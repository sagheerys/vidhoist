/// A file that is not a Vidhoist backup, or a damaged one.
final class BackupFormatException implements Exception {
  const BackupFormatException([this.detail]);
  final String? detail;
  @override
  String toString() => 'BackupFormatException(${detail ?? ''})';
}

/// The name a backup carries in its `app` field: Vidhoist's own today,
/// and `MTF`, which backups from version 1.0.0 carry; both are the same
/// plain format.
const backupAppName = 'Vidhoist';
const backupAppNames = {backupAppName, 'MTF'};
