import 'dart:io';

/// `%USERPROFILE%\Downloads\<name>`: where a download goes in the moment
/// before the chosen folder has been read.
String fallbackDownloadFolder(String name) =>
    '${Platform.environment['USERPROFILE'] ?? '.'}\\Downloads\\$name';
