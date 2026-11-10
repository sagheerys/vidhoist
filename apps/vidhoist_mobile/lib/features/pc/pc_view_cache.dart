import 'dart:convert';

import 'package:vh_core/vh_core.dart';

import 'pc_pairing_store.dart';

/// The computer's library as last seen, with when: shown at once on the
/// next start, before the computer answers, or while it is away.
typedef PcViewCache = ({PcLibraryPage page, DateTime? seen});

Future<PcViewCache?> loadPcViewCache(KeyValueStore store) async {
  try {
    final raw = await store.getString(pcCacheKey);
    if (raw == null) return null;
    final json = jsonDecode(raw);
    if (json is! Map) return null;
    final seen = json['seen'];
    return (
      page: PcLibraryPage.fromJson(json['library']),
      seen: seen is int ? DateTime.fromMillisecondsSinceEpoch(seen) : null,
    );
  } on Object {
    // A cache is a convenience.
    return null;
  }
}

/// Keeps the first 60 clips: enough for the page to open full.
Future<void> savePcViewCache(
  KeyValueStore store,
  PrefsMutex mutex, {
  required List<PcItem> items,
  required int total,
  DateTime? seen,
}) async {
  try {
    final page = PcLibraryPage(items: items.take(60).toList(), total: total);
    await mutex.run(
      () => store.setString(
        pcCacheKey,
        jsonEncode({
          'library': page.toJson(),
          'seen': seen?.millisecondsSinceEpoch,
        }),
      ),
    );
  } on Object {
    // A cache is a convenience.
  }
}
