import 'dart:async';
import 'dart:ui' show PlatformDispatcher;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_transcripts/vh_transcripts.dart';

import 'appearance_data.dart';

/// The transcripts on this computer, in `%APPDATA%\Vidhoist\transcripts\`
/// and in the phone's format, so an exported bundle reads the same here.
/// Overridden in main; null (tests) means none.
final transcriptStoreProvider = Provider<TranscriptStore?>((ref) => null);

/// Every transcript on this computer, searchable by what was said. Built
/// from the files the first time a search asks for it, then kept current
/// by [keepTranscript], so a search never reads the whole folder twice.
final transcriptIndexProvider = FutureProvider<TranscriptIndex>((ref) async {
  final index = TranscriptIndex();
  final store = ref.watch(transcriptStoreProvider);
  if (store == null) return index;
  await for (final transcript in store.readAll()) {
    index.add(transcript);
  }
  return index;
});

/// Writes [transcript] and adds it to the search index. [fetched] says
/// this computer fetched it itself, rather than reading it from a file.
Future<void> keepTranscript(
  Ref ref,
  TranscriptStore store,
  Transcript transcript, {
  bool fetched = false,
}) async {
  await store.write(transcript);
  noteTranscript(ref, transcript);
}

/// Adds a transcript already on disk to the search index when the index is
/// built. One still being built is started again, since it may have read
/// the folder before this file was in it.
void noteTranscript(Ref ref, Transcript transcript) {
  if (!ref.exists(transcriptIndexProvider)) return;
  final index = ref.read(transcriptIndexProvider);
  if (index.valueOrNull case final built?) {
    built.add(transcript);
  } else {
    ref.invalidate(transcriptIndexProvider);
  }
}

/// The transcript of one clip, by its link, in the reader's language when
/// there is a choice; the subtitles came with the download itself.
final transcriptForProvider = FutureProvider.family<Transcript?, String>((
  ref,
  canonicalUrl,
) async {
  final store = ref.watch(transcriptStoreProvider);
  if (store == null) return null;
  final languages = readerLanguages(ref.watch(appearanceProvider).locale);
  return _pick(await store.readFor(canonicalUrl), languages);
});

/// Every language this computer keeps for one clip, for the reading
/// room's choice between them.
final transcriptLanguagesProvider =
    FutureProvider.family<List<Transcript>, String>((ref, canonicalUrl) async {
      final store = ref.watch(transcriptStoreProvider);
      if (store == null) return const [];
      return store.readFor(canonicalUrl);
    });

/// The language the reader chose for a clip's transcript; null takes the
/// reader's own, then English.
final readingLanguageProvider = StateProvider.family<String?, String>(
  (ref, canonicalUrl) => null,
);

/// The reader's language first, then English, which most clips have. The
/// reader's is **the one chosen in Appearance**, else Windows': with
/// Windows in English and the app in Arabic, the Arabic transcript came
/// second.
List<String> readerLanguages(String? chosen) {
  final own = chosen ?? PlatformDispatcher.instance.locale.languageCode;
  return {own, 'en'}.toList();
}

/// The transcript in the first of [languages] there is one for. Null when
/// only other languages are kept: one is never put in front of the reader
/// unasked, and the reading room still offers the rest.
Transcript? _pick(List<Transcript> all, List<String> languages) {
  for (final language in languages) {
    for (final t in all) {
      if (Transcript.baseLanguage(t.language) == language) return t;
    }
  }
  return null;
}
