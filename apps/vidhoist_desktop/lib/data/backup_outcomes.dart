import 'package:vh_core/vh_core.dart';

/// What a dropped or chosen file did.
sealed class ImportOutcome {
  const ImportOutcome();
}

/// A phone backup, merged as a union: nothing here is dropped.
class MergedBackup extends ImportOutcome {
  const MergedBackup(this.result);
  final MergeResult result;
}

/// A transcripts file: those this computer lacked, or had older.
class MergedTranscripts extends ImportOutcome {
  const MergedTranscripts(this.added);
  final int added;
}

/// **A computer's own full backup** (its library, followed channels and
/// settings, not only what a phone shares), chosen or dropped: it is
/// restored, after the person says so, rather than merged. Merged, it
/// brought back the playlists alone, pointing at clips the library no
/// longer listed (owner's report 2026-11-12).
class ComputerBackup extends ImportOutcome {
  const ComputerBackup(this.contents);
  final String contents;
}

/// Neither: a file this app cannot read.
class NotABackup extends ImportOutcome {
  const NotABackup();
}

/// What looking for clips already in the download folder did.
class LibraryRecoveryResult {
  const LibraryRecoveryResult({required this.added, required this.unknown});

  /// Clips put back in the library.
  final int added;

  /// Media files left out, their link unknown.
  final int unknown;
}
