/// **The project's screenshots, made inside widget tests**: the app's own
/// fonts, which tests otherwise draw as blocks, and a screen saved as a
/// PNG. Imported by the apps' screenshot tests only, never by the apps.
library;

import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

/// The faces `pubspec.yaml` declares, each with the weights it ships.
const _families = {
  'Tajawal': ['Regular', 'Medium', 'Bold'],
  'NotoKufiArabic': ['Medium', 'Bold'],
  'NotoSans': ['Regular', 'Medium', 'Bold'],
  'NotoNaskhArabic': ['Regular', 'Medium', 'Bold'],
  'NotoSansDevanagari': ['Regular', 'Medium', 'Bold'],
};

/// Loads the app's fonts from [fontsDir] (`packages/vh_ui/assets/fonts`,
/// relative to the test's folder) under the names the theme asks for.
Future<void> loadVhFonts(String fontsDir) async {
  for (final MapEntry(key: family, value: weights) in _families.entries) {
    final loader = FontLoader('packages/vh_ui/$family');
    for (final weight in weights) {
      final bytes = File('$fontsDir/$family-$weight.ttf').readAsBytesSync();
      loader.addFont(Future.value(ByteData.sublistView(bytes)));
    }
    await loader.load();
  }
}

/// Saves what [boundary] holds as a PNG at [path], [pixelRatio] times its
/// logical size.
Future<void> saveVhShot(
  RenderRepaintBoundary boundary,
  String path, {
  double pixelRatio = 2,
}) async {
  final image = await boundary.toImage(pixelRatio: pixelRatio);
  final png = await image.toByteData(format: ui.ImageByteFormat.png);
  image.dispose();
  File(path)
    ..parent.createSync(recursive: true)
    ..writeAsBytesSync(png!.buffer.asUint8List());
}
