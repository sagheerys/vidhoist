import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_core/vh_core.dart';

import '../../di.dart';
import 'pc_outbox.dart';
import 'pc_pairing_store.dart';
import 'pc_view_cache.dart';

/// The link to the paired computer, or null when there is none.
final pcClientProvider = Provider<PcLinkApi?>((ref) {
  // Only what the connection needs: the routes the computer reports change
  // without a new client, a route the user picks makes one.
  final link = ref.watch(
    pcPairingProvider.select(
      (p) => p == null ? null : (p.host, p.port, p.fingerprint, p.secret),
    ),
  );
  final pairing = ref.read(pcPairingProvider);
  if (link == null || pairing == null) return null;
  final client = PcLinkClient(pairing);
  ref.onDispose(client.close);
  return client;
});

/// Pairs with a computer; replaced in tests.
typedef PcPairer = Future<PcPairing> Function({
  required String host,
  required int port,
  required String code,
  required String phoneName,
  required void Function(String check) onCheck,
});

final pcPairerProvider = Provider<PcPairer>((ref) => PcLinkClient.pair);

/// Asks the home network where the paired computer is now; replaced in
/// tests, where nothing answers a broadcast.
final pcFinderProvider = Provider<Future<PcFound?> Function(PcPairing)>(
  (ref) => pcFindPaired,
);

/// The computers showing a pairing code on this network; replaced in tests.
final pcPairableFinderProvider = Provider<Future<List<PcFound>> Function()>(
  (ref) => pcFindPairable,
);

/// The phone's name for the computer's list; replaced in tests, where no
/// channel answers.
final pcPhoneNameProvider = Provider<Future<String> Function()>(
  (ref) => phoneName,
);

/// What the "Computer" page shows.
class PcView {
  const PcView({
    this.status,
    this.tasks = const [],
    this.items = const [],
    this.total = 0,
    this.lastContact,
    this.failure,
  });

  final PcStatus? status;
  final List<PcTask> tasks;
  final List<PcItem> items;
  final int total;
  final DateTime? lastContact;

  /// Why the last call failed; null after a call that worked.
  final PcLinkFailure? failure;

  /// It answered the last time it was asked.
  bool get online => status != null && failure == null;

  List<PcTask> get live => [
    for (final task in tasks)
      if (!task.isFinished) task,
  ];

  PcView copyWith({
    PcStatus? status,
    List<PcTask>? tasks,
    List<PcItem>? items,
    int? total,
    DateTime? lastContact,
    PcLinkFailure? failure,
    bool clearFailure = false,
  }) => PcView(
    status: status ?? this.status,
    tasks: tasks ?? this.tasks,
    items: items ?? this.items,
    total: total ?? this.total,
    lastContact: lastContact ?? this.lastContact,
    failure: clearFailure ? null : failure ?? this.failure,
  );
}

/// Whether the app is in front; the shell keeps it. Nothing is asked of
/// the computer from behind other apps.
final pcForegroundProvider = StateProvider<bool>((ref) => true);

final pcViewProvider = NotifierProvider<PcViewNotifier, PcView>(
  PcViewNotifier.new,
);

/// Keeps [PcView] current while the page is open: every two seconds while
/// something downloads there, every ten otherwise, and the library again
/// when a download finishes. With the page closed, **it follows only
/// downloads it knows are running**, every five seconds while the app is
/// in front, for the count on the tab and the word when one is done.
class PcViewNotifier extends Notifier<PcView> {
  Timer? _timer;
  var _watching = 0;
  DateTime? _lastFind;
  final _done = StreamController<PcTask>.broadcast();

  /// Each download the computer finished while it was being followed.
  Stream<PcTask> get done => _done.stream;

  PcLinkApi? get _client => ref.read(pcClientProvider);

  @override
  PcView build() {
    // Listened to, not watched: a new link (a route picked, an address
    // found) keeps what the page shows, and a call under way can retry on
    // the new link without this rebuilding beneath it.
    ref.listen(pcClientProvider, (_, client) {
      if (client == null) {
        _timer?.cancel();
        state = const PcView();
      } else if (_watching > 0) {
        // A route changed while the page is open: ask again at once.
        unawaited(refresh());
      }
    });
    ref.listen(pcForegroundProvider, (_, front) {
      if (front) {
        unawaited(glance());
      } else if (_watching == 0) {
        _timer?.cancel();
      }
    });
    ref.onDispose(() {
      _timer?.cancel();
      unawaited(_done.close());
    });
    unawaited(_loadCache());
    return const PcView();
  }

  /// Keeps the computer's addresses for the user's choice of route.
  void _learn(PcStatus status) {
    final pairing = ref.read(pcPairingProvider);
    if (pairing == null || status.addresses.isEmpty) return;
    final known = pairing.routes;
    final same =
        known.length == status.addresses.length &&
        [for (var i = 0; i < known.length; i++) known[i] == status.addresses[i]]
            .every((s) => s);
    if (!same) {
      unawaited(
        ref.read(pcPairingProvider.notifier).learnRoutes(status.addresses),
      );
    }
  }

  /// The page opened; [stopWatching] when it closes.
  void watch() {
    _watching++;
    if (_watching == 1) unawaited(refresh());
  }

  void stopWatching() {
    _watching = (_watching - 1).clamp(0, 1 << 20);
    if (_watching == 0) _timer?.cancel();
  }

  /// One look with the page closed, at a start or a return to the app: a
  /// download running there is then followed.
  Future<void> glance() async {
    if (_watching == 0) await refresh(library: false);
  }

  Future<void> refresh({bool library = true}) async {
    final client = _client;
    if (client == null) return;
    _timer?.cancel();
    final hadLive = state.live.map((t) => t.id).toSet();
    try {
      final status = await client.status();
      _learn(status);
      await _sendWaiting(client);
      final tasks = await client.tasks();
      final stillLive = {
        for (final t in tasks)
          if (!t.isFinished) t.id,
      };
      // A download that finished since the last look is in the library now.
      final finished = hadLive.difference(stillLive).isNotEmpty;
      var next = state.copyWith(
        status: status,
        tasks: tasks,
        lastContact: DateTime.now(),
        clearFailure: true,
      );
      if (library || finished || state.items.isEmpty) {
        final page = await client.library(limit: 200);
        next = next.copyWith(items: page.items, total: page.total);
        unawaited(_saveCache(next));
      }
      state = next;
      for (final t in tasks) {
        if (hadLive.contains(t.id) && t.phase == 'completed') _done.add(t);
      }
    } on PcLinkException catch (e) {
      state = state.copyWith(failure: e.failure);
      // Found elsewhere: the new link asks again by itself while watched.
      if (await _findAgain(e)) return;
    }
    _schedule();
  }

  /// A quick look, for the add sheet: is the computer there right now?
  Future<bool> probe() async {
    final client = _client;
    if (client == null) return false;
    try {
      final status = await client.status();
      _learn(status);
      state = state.copyWith(
        status: status,
        lastContact: DateTime.now(),
        clearFailure: true,
      );
      await _sendWaiting(client);
      return true;
    } on PcLinkException catch (e) {
      state = state.copyWith(failure: e.failure);
      if (await _findAgain(e)) return probe();
      return false;
    }
  }

  /// The links sent while it was away go now that it answers.
  Future<void> _sendWaiting(PcLinkApi client) async {
    final made = await ref.read(pcOutboxProvider.notifier).send(client);
    if (made.isNotEmpty) {
      state = state.copyWith(tasks: [...made, ...state.tasks]);
      _schedule();
    }
  }

  /// **The computer did not answer where it was.** On the home network the
  /// router may have given it a new address: the network is asked, and an
  /// answer with the computer's proof moves the link there. The route stays
  /// the user's (the home network, never switched to Tailscale), only its
  /// address follows; the certificate pin still decides who is reached.
  /// True when it moved.
  Future<bool> _findAgain(PcLinkException e) async {
    final pairing = ref.read(pcPairingProvider);
    if (e.failure != PcLinkFailure.unreachable || pairing == null) {
      return false;
    }
    if (pcAddressKind('', pairing.host) != PcAddressKind.home) return false;
    // At most twice a minute: a computer that is off stays silent.
    final now = DateTime.now();
    if (_lastFind case final last?
        when now.difference(last) < const Duration(seconds: 30)) {
      return false;
    }
    _lastFind = now;
    final found = await ref.read(pcFinderProvider)(pairing);
    if (found == null ||
        pcAddressKind('', found.host) != PcAddressKind.home ||
        (found.host == pairing.host && found.port == pairing.port)) {
      return false;
    }
    await ref.read(pcPairingProvider.notifier).moved(found.host, found.port);
    return true;
  }

  /// Sends [url] to be downloaded on the computer.
  Future<PcTask> submit(String url, String quality) async {
    final client = _client;
    if (client == null) {
      throw const PcLinkException(PcLinkFailure.unauthorized);
    }
    final task = await client.submit(url, quality);
    state = state.copyWith(tasks: [task, ...state.tasks], clearFailure: true);
    _schedule();
    return task;
  }

  Future<void> cancel(String id) async {
    final client = _client;
    if (client == null) return;
    try {
      await client.cancel(id);
    } on PcLinkException catch (e) {
      state = state.copyWith(failure: e.failure);
    }
    await refresh(library: false);
  }

  /// Asks the computer to put clip [id] in its Recycle Bin; the library is
  /// read again when it did. Null when the computer did not answer.
  Future<PcDeleteOutcome?> delete(String id) async {
    final client = _client;
    if (client == null) return null;
    try {
      final outcome = await client.delete(id);
      if (outcome == PcDeleteOutcome.deleted ||
          outcome == PcDeleteOutcome.missing) {
        state = state.copyWith(
          items: [
            for (final item in state.items)
              if (item.id != id) item,
          ],
          total: (state.total - 1).clamp(0, 1 << 30),
        );
        unawaited(refresh());
      }
      return outcome;
    } on PcLinkException catch (e) {
      state = state.copyWith(failure: e.failure);
      return null;
    }
  }

  void _schedule() {
    _timer?.cancel();
    final busy = state.live.isNotEmpty;
    final Duration every;
    if (_watching > 0) {
      every = Duration(seconds: busy ? 2 : 10);
    } else if (busy &&
        state.failure == null &&
        ref.read(pcForegroundProvider)) {
      every = const Duration(seconds: 5);
    } else {
      return;
    }
    _timer = Timer(every, () => unawaited(refresh(library: false)));
  }

  Future<void> _loadCache() async {
    final cache = await loadPcViewCache(ref.read(keyValueStoreProvider));
    if (cache == null || state.items.isNotEmpty) return;
    state = state.copyWith(
      items: cache.page.items,
      total: cache.page.total,
      lastContact: cache.seen,
    );
  }

  Future<void> _saveCache(PcView view) => savePcViewCache(
    ref.read(keyValueStoreProvider),
    ref.read(prefsMutexProvider),
    items: view.items,
    total: view.total,
    seen: view.lastContact,
  );
}
