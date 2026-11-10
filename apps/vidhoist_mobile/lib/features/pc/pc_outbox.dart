import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_core/vh_core.dart';

import '../../di.dart';
import 'pc_pairing_store.dart';

/// A link sent to the computer while it was away, waiting to go.
class PcQueued {
  const PcQueued({
    required this.url,
    required this.quality,
    required this.at,
    this.refused = false,
  });

  final String url;
  final String quality;
  final DateTime at;

  /// The computer answered and would not take it: kept to be seen and
  /// removed, never sent again.
  final bool refused;

  PcQueued asRefused() =>
      PcQueued(url: url, quality: quality, at: at, refused: true);

  Map<String, Object?> toJson() => {
    'url': url,
    'quality': quality,
    'at': at.millisecondsSinceEpoch,
    if (refused) 'refused': true,
  };

  static PcQueued? fromJson(Object? json) {
    if (json is! Map) return null;
    final url = json['url'];
    final quality = json['quality'];
    final at = json['at'];
    if (url is! String || quality is! String || at is! int) return null;
    return PcQueued(
      url: url,
      quality: quality,
      at: DateTime.fromMillisecondsSinceEpoch(at),
      refused: json['refused'] == true,
    );
  }
}

/// **Links waiting for the computer**, in the order they were sent, kept
/// across restarts on this phone only. Empty while unpaired: unpairing
/// drops them with the pairing.
final pcOutboxProvider = NotifierProvider<PcOutbox, List<PcQueued>>(
  PcOutbox.new,
);

class PcOutbox extends Notifier<List<PcQueued>> {
  var _sending = false;

  @override
  List<PcQueued> build() {
    final paired = ref.watch(pcPairingProvider.select((p) => p != null));
    if (!paired) return const [];
    unawaited(_load());
    return const [];
  }

  /// Those still to send, not the refused.
  List<PcQueued> get waiting => [
    for (final q in state)
      if (!q.refused) q,
  ];

  Future<void> add(String url, String quality) => addAll([url], quality);

  /// A batch's links in one save, in their order.
  Future<void> addAll(List<String> urls, String quality) async {
    final at = DateTime.now();
    state = [
      ...state,
      for (final url in urls) PcQueued(url: url, quality: quality, at: at),
    ];
    await _save();
  }

  Future<void> remove(PcQueued queued) async {
    state = [
      for (final q in state)
        if (!identical(q, queued)) q,
    ];
    await _save();
  }

  /// Sends what waits, oldest first, now that [client] answered: the tasks
  /// the computer made of them. Stops at the first that does not reach it
  /// and keeps the rest; one it refuses is marked and the next goes on.
  Future<List<PcTask>> send(PcLinkApi client) async {
    if (_sending || waiting.isEmpty) return const [];
    _sending = true;
    final made = <PcTask>[];
    try {
      for (final queued in waiting) {
        try {
          made.add(await client.submit(queued.url, queued.quality));
          state = [
            for (final q in state)
              if (!identical(q, queued)) q,
          ];
        } on PcLinkException catch (e) {
          if (e.failure != PcLinkFailure.refused) break;
          state = [
            for (final q in state) identical(q, queued) ? q.asRefused() : q,
          ];
        }
      }
      await _save();
    } finally {
      _sending = false;
    }
    return made;
  }

  Future<void> _load() async {
    try {
      final raw = await ref.read(keyValueStoreProvider).getString(pcOutboxKey);
      if (raw == null || raw.isEmpty) return;
      final list = jsonDecode(raw);
      final saved = [
        if (list is List)
          for (final entry in list) ?PcQueued.fromJson(entry),
      ];
      // A link added before the saved list arrived goes after it.
      state = [...saved, ...state];
    } on Object {
      // A list that cannot be read is no list.
    }
  }

  Future<void> _save() => ref
      .read(prefsMutexProvider)
      .run(
        () => ref
            .read(keyValueStoreProvider)
            .setString(
              pcOutboxKey,
              jsonEncode([for (final q in state) q.toJson()]),
            ),
      );
}
