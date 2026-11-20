import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vh_ui/shots.dart';
import 'package:vh_ui/vh_ui.dart';
import 'package:vidhoist_mobile/features/downloads_library/local_item.dart';

/// What the phone's screenshot tests share: where things are, the device,
/// waiting for the covers, saving, and the sample library. Run only with
/// `VH_SHOTS=1`; see `phone_shots_test.dart`.
final shotsEnabled = Platform.environment['VH_SHOTS'] != null;
final shotRoot = Directory.current.parent.parent.path;
final shotCovers = '$shotRoot/tool/screenshots/covers';
final shotOut = '$shotRoot/docs/screenshots';

/// The app's fonts and its relative times, as main sets them.
Future<void> loadShotFonts() async {
  if (!shotsEnabled) return;
  await loadVhFonts('$shotRoot/packages/vh_ui/assets/fonts');
  initVhL10n();
}

/// A device of [size] points saved at twice that, with a status bar and a
/// gesture bar, which the frame draws over, and real shadows: tests draw
/// each as a black outline unless told otherwise.
void useShotDevice(WidgetTester tester, {Size size = const Size(360, 800)}) {
  debugDisableShadows = false;
  tester.view.physicalSize = size * 2;
  tester.view.devicePixelRatio = 2;
  tester.view.padding = const FakeViewPadding(top: 56, bottom: 36);
  tester.view.viewPadding = const FakeViewPadding(top: 56, bottom: 36);
  addTearDown(tester.view.reset);
}

/// Covers are files: read and decoded outside the test's clock. [still]
/// waits for the screen to settle; a player's clock never lets it.
Future<void> settleShot(WidgetTester tester, {bool still = true}) async {
  for (var i = 0; i < 12; i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 250)),
    );
    await tester.pump(const Duration(milliseconds: 100));
  }
  // Every picture on screen decoded outside the test's clock: one made
  // from bytes in memory, as the computer's covers are, otherwise stayed
  // blank however long the loop above ran.
  await tester.runAsync(() async {
    for (final element in find.byType(Image).evaluate()) {
      final image = (element.widget as Image).image;
      await precacheImage(image, element, onError: (_, _) {});
    }
  });
  await tester.pump(const Duration(milliseconds: 100));
  if (still) await tester.pumpAndSettle();
}

const shotKey = ValueKey('shot');

/// Saves what is inside the [shotKey] boundary as `docs/screenshots/[name]`,
/// then ends the screen, so no timer outlives the test.
Future<void> saveShot(WidgetTester tester, String name) async {
  final boundary = tester.renderObject<RenderRepaintBoundary>(
    find.byKey(shotKey),
  );
  await tester.runAsync(() => saveVhShot(boundary, '$shotOut/$name.png'));
  debugDisableShadows = true;
  await tester.pumpWidget(const SizedBox());
  await tester.pump(const Duration(seconds: 2));
}

ThemeData shotTheme(Locale locale, Brightness brightness) =>
    vhTheme(VhVariant.phone, brightness, language: locale.languageCode);

/// The sample library: titles, covers, minutes, and whether it is sound.
const shotArabicClips = [
  ('رحلة إلى جبال السروات في موسم الضباب', 'mountains', 14, false),
  ('إبحار هادئ على ساحل البحر الأحمر', 'sea', 9, false),
  ('المدينة في الليل: جولة بين الأبراج', 'city', 22, false),
  ('طبق الخضار المشوي في عشر دقائق', 'kitchen', 6, false),
  ('ألحان المساء', 'music', 4, true),
  ('كثبان الربع الخالي عند الغروب', 'desert', 18, false),
  ('غابات الشمال: نزهة طويلة', 'forest', 31, false),
  ('ألوان الشفق القطبي', 'aurora', 3, false),
];

const shotEnglishClips = [
  ('Into the misty mountains at dawn', 'mountains', 14, false),
  ('A quiet sail along the coast', 'sea', 9, false),
  ('The city at night: a walk between towers', 'city', 22, false),
  ('Roasted vegetables in ten minutes', 'kitchen', 6, false),
  ('Evening tunes', 'music', 4, true),
  ('Dunes of the Empty Quarter at sunset', 'desert', 18, false),
  ('Northern forests: a long hike', 'forest', 31, false),
  ('Colours of the aurora', 'aurora', 3, false),
];

const shotArabicChannels = ['عدسة الجنوب', 'مطبخ البيت', 'رحّالة'];
const shotEnglishChannels = ['Southern Lens', 'Home Kitchen', 'The Wanderer'];

List<LocalItem> shotLibrary(bool arabic) => [
  for (final (i, (title, cover, minutes, audio))
      in (arabic ? shotArabicClips : shotEnglishClips).indexed)
    LocalItem(
      key: 'https://vimeo.com/90000$i',
      canonicalUrl: 'https://vimeo.com/90000$i',
      path:
          '/storage/emulated/0/Download/VidHoist/clip$i.'
          '${audio ? 'm4a' : 'mp4'}',
      title: title,
      sizeBytes: (minutes * 9.5 * 1000000).round(),
      modified: DateTime.now().subtract(Duration(hours: 3 + i * 9)),
      thumbnail: '$shotCovers/$cover.jpg',
      duration: Duration(minutes: minutes, seconds: 7 + i * 6),
    ),
];
