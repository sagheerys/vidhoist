import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:vidhoist_desktop/data/clip_handover.dart';
import 'package:mt_media/library.dart';

void main() {
  late Directory root;
  const handover = ClipHandover();

  setUp(() => root = Directory.systemTemp.createTempSync('ember_handover_'));
  tearDown(() => root.deleteSync(recursive: true));

  LibraryItem clip({String? localPath}) => LibraryItem(
    canonicalUrl: 'https://youtu.be/aaaaaaaaaaa',
    title: 'Night Drive',
    localPath: localPath,
  );

  test('**the guard**: a file on this computer is handed over as it is', () {
    final kept = File('${root.path}\\Night Drive.mp4')..writeAsBytesSync([1]);
    expect(handover.localFile(clip(localPath: kept.path)), kept.path);
  });

  test('a file deleted in Explorer is not trusted: nothing is handed over', () {
    expect(
      handover.localFile(clip(localPath: '${root.path}\\gone.mp4')),
      isNull,
    );
    expect(handover.localFile(clip()), isNull);
  });
}
