import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_core/vh_core.dart';

import '../../di.dart';
import 'pc_pairing_store.dart';

/// The link to the paired computer, or null when there is none.
final pcClientProvider = Provider<PcLinkApi?>((ref) {
  final pairing = ref.watch(pcPairingProvider);
  if (pairing == null) return null;
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

final pcViewProvider = NotifierProvider<PcViewNotifier, PcView>(
  PcViewNotifier.new,
);

/// Keeps [PcView] current while the page is open: every two seconds while
/// something downloads there, every ten otherwise, and the library again
/// when a download finishes. Asks nothing while the page is closed.
class PcViewNotifier extends Notifier<PcView> {
  Timer? _timer;
  var _watching = 0;

  PcLinkApi? get _client => ref.read(pcClientProvider);

  @override
  PcView build() {
    ref.watch(pcClientProvider);
    ref.onDispose(() => _timer?.cancel());
    unawaited(_loadCache());
    return const PcView();
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

  Future<void> refresh({bool library = true}) async {
    final client = _client;
    if (client == null) return;
    _timer?.cancel();
    final hadLive = state.live.map((t) => t.id).toSet();
    try {
      final status = await client.status();
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
    } on PcLinkException catch (e) {
      state = state.copyWith(failure: e.failure);
    }
    _schedule();
  }

  /// A quick look, for the add sheet: is the computer there right now?
  Future<bool> probe() async {
    final client = _client;
    if (client == null) return false;
    try {
      final status = await client.status();
      state = state.copyWith(
        status: status,
        lastContact: DateTime.now(),
        clearFailure: true,
      );
      return true;
    } on PcLinkException catch (e) {
      state = state.copyWith(failure: e.failure);
      return false;
    }
  }

  /// Sends [url] to be downloaded on the computer.
  Future<PcTask> submit(String url, String quality) async {
    final client = _client;
    if (client == null) {
      throw const PcLinkException(PcLinkFailure.unauthorized);
    }
    final task = await client.submit(url, quality);
    state = state.copyWith(tasks: [task, ...state.tasks]);
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

  void _schedule() {
    _timer?.cancel();
    if (_watching == 0) return;
    final busy = state.live.isNotEmpty;
    _timer = Timer(
      Duration(seconds: busy ? 2 : 10),
      () => unawaited(refresh(library: false)),
    );
  }

  Future<void> _loadCache() async {
    try {
      final raw = await ref.read(keyValueStoreProvider).getString(pcCacheKey);
      if (raw == null || state.items.isNotEmpty) return;
      final json = jsonDecode(raw);
      if (json is! Map) return;
      final page = PcLibraryPage.fromJson(json['library']);
      final seen = json['seen'];
      state = state.copyWith(
        items: page.items,
        total: page.total,
        lastContact: seen is int
            ? DateTime.fromMillisecondsSinceEpoch(seen)
            : null,
      );
    } on Object {
      // A cache is a convenience.
    }
  }

  Future<void> _saveCache(PcView view) async {
    try {
      final page = PcLibraryPage(
        items: view.items.take(60).toList(),
        total: view.total,
      );
      await ref
          .read(prefsMutexProvider)
          .run(
            () => ref
                .read(keyValueStoreProvider)
                .setString(
                  pcCacheKey,
                  jsonEncode({
                    'library': page.toJson(),
                    'seen': view.lastContact?.millisecondsSinceEpoch,
                  }),
                ),
          );
    } on Object {
      // A cache is a convenience.
    }
  }
}
