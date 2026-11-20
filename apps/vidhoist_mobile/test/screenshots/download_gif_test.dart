@Tags(['shots'])
library;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_media/vh_media.dart' show vhFormatDuration;
import 'package:vh_ui/shots.dart';
import 'package:vh_ui/vh_ui.dart';
import 'package:vidhoist_mobile/di.dart';
import 'package:vidhoist_mobile/features/downloads_library/library_providers.dart';
import 'package:vidhoist_mobile/features/downloads_library/library_screen.dart';
import 'package:vidhoist_mobile/features/downloads_library/local_item.dart';
import 'package:vidhoist_mobile/features/downloads_library/media_access.dart';
import 'package:vidhoist_mobile/features/settings/settings_state.dart';
import 'package:vidhoist_mobile/features/shell/shell_tabs.dart';

import 'shot_kit.dart';

/// **The frames of the download, for the project's pages**: a link pasted,
/// a quality picked, the card filling, and the clip arriving in the
/// library. Each frame is saved with how long it shows, and
/// `tool/screenshots/make_gif.py` puts them in a phone and makes the
/// animation. As the other shots, run only with `VH_SHOTS=1`.
void main() {
  setUpAll(loadShotFonts);

  for (final lang in ['ar', 'en']) {
    final arabic = lang == 'ar';
    testWidgets('download gif $lang', skip: !shotsEnabled, (tester) async {
      useShotDevice(tester);
      final dir = Directory('$shotRoot/build/gif/$lang')
        ..createSync(recursive: true);
      for (final old in dir.listSync()) {
        old.deleteSync();
      }
      final frames = <Map<String, Object>>[];
      Future<void> frame(int ms) async {
        await precacheAll(tester);
        final boundary = tester.renderObject<RenderRepaintBoundary>(
          find.byKey(shotKey),
        );
        final name = 'f${frames.length.toString().padLeft(3, '0')}.png';
        await tester.runAsync(() => saveVhShot(boundary, '${dir.path}/$name'));
        frames.add({'file': name, 'ms': ms});
        // ignore: avoid_print
        print('frame $name');
      }

      // The clip that arrives: the first of the sample library, new.
      final all = shotLibrary(arabic);
      final arriving = all.first;
      var shown = all.skip(1).toList();
      final tasks = StreamController<List<DownloadTask>>.broadcast();
      addTearDown(tasks.close);
      final store = MemoryKeyValueStore();
      await store.setString('library_view_mode', LibraryViewMode.grid.name);
      final c = ProviderContainer(
        overrides: [
          keyValueStoreProvider.overrideWithValue(store),
          secretStoreProvider.overrideWithValue(MemorySecretStore()),
          prefsMutexProvider.overrideWithValue(PrefsMutex()),
          initialSettingsProvider.overrideWithValue(const PhoneSettings()),
          mediaAccessGateProvider.overrideWithValue(
            MediaAccessGate(
              probe: () async => true,
              isGranted: (_) async => true,
              ask: (_) async => true,
            ),
          ),
          localMediaProvider.overrideWith((ref) async => shown),
          engineTasksProvider.overrideWith((ref) => tasks.stream),
          downloadEngineProvider.overrideWithValue(null),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: c,
          child: RepaintBoundary(
            key: shotKey,
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              locale: Locale(lang),
              localizationsDelegates: VhLocalizations.localizationsDelegates,
              supportedLocales: VhLocalizations.supportedLocales,
              theme: shotTheme(Locale(lang), Brightness.light),
              home: Builder(
                builder: (context) => VhAdaptiveScaffold(
                  items: shellNavItems(context.vhl, shellTabs(paired: false)),
                  selectedIndex: 0,
                  onSelected: (_) {},
                  body: const LibraryScreen(),
                  floatingActionButton: VhFab(
                    label: context.vhl.addLinkFab,
                    onPressed: () {},
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      tasks.add(const []);
      await settleShot(tester);
      await frame(1400);

      // The sheet rises, empty, then takes the pasted link. The field's
      // cursor blinks for ever, so each wait is a fixed one.
      final context = tester.element(find.byType(LibraryScreen));
      final l10n = context.vhl;
      final link = TextEditingController();
      addTearDown(link.dispose);
      final state = ValueNotifier<(bool, String)>((false, 'best'));
      addTearDown(state.dispose);
      final cover = File(arriving.thumbnail!).readAsBytesSync();
      final channel = (arabic ? shotArabicChannels : shotEnglishChannels)[0];
      unawaited(
        showVhSheet<void>(
          context: context,
          isScrollControlled: true,
          builder: (_) => ValueListenableBuilder(
            valueListenable: state,
            builder: (_, value, _) => VhUrlInputSheet(
              title: l10n.addUrl,
              urlHint: l10n.pasteUrlHint,
              controller: link,
              preview: value.$1
                  ? VhLinkPreview(
                      // Read at once: a file the test's clock holds back
                      // never decoded in the sheet.
                      thumbnail: Image.memory(cover, fit: BoxFit.cover),
                      title: arriving.title,
                      subtitle: vhMetaLine([
                        channel,
                        vhFormatDuration(arriving.duration!),
                      ]),
                    )
                  : null,
              platform: value.$1 ? VhPlatformKind.vimeo : null,
              platformLabel: value.$1 ? 'Vimeo' : null,
              qualities: [
                VhQualityOption(value: 'best', label: l10n.qualityBest),
                VhQualityOption(value: '1080', label: l10n.quality1080),
                VhQualityOption(value: '720', label: l10n.quality720),
                VhQualityOption(value: '480', label: l10n.quality480),
                VhQualityOption(value: 'audio', label: l10n.audioOnly),
              ],
              selectedQuality: value.$2,
              onQualitySelected: (_) {},
              startLabel: l10n.startDownload,
              onStart: () {},
            ),
          ),
        ),
      );
      for (var i = 0; i < 6; i++) {
        await tester.pump(const Duration(milliseconds: 50));
        await frame(60);
      }
      await wait(tester, 600);
      await frame(700);
      link.text = arriving.canonicalUrl!;
      state.value = (true, 'best');
      await wait(tester, 600);
      await frame(1300);
      state.value = (true, '1080');
      await wait(tester, 600);
      await frame(1000);

      // Start: the sheet goes down and the card takes its place.
      Navigator.of(tester.element(find.byType(VhUrlInputSheet))).pop();
      var task = DownloadTask(
        inputUrl: arriving.canonicalUrl!,
        canonicalUrl: arriving.canonicalUrl,
        title: arriving.title,
        thumbnail: arriving.thumbnail,
        quality: Quality.q1080,
        phase: TaskPhase.preparing,
      );
      tasks.add([task]);
      showVhSnack(context, l10n.downloadStarted, type: VhSnackType.success);
      for (var i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 50));
        await frame(60);
      }
      await wait(tester, 400);
      await frame(900);
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      final size = arriving.sizeBytes.toDouble();
      for (final p in [0.07, 0.21, 0.38, 0.56, 0.74, 0.9, 1.0]) {
        task = task.copyWith(
          phase: TaskPhase.downloading,
          progress: p,
          speed: () => 7.6e6 + p * 1.1e6,
          eta: () => ((1 - p) * size / 8e6).round(),
        );
        tasks.add([task]);
        await wait(tester, 350);
        await frame(380);
      }
      task = task.copyWith(phase: TaskPhase.postprocessing, progress: 1);
      tasks.add([task]);
      await wait(tester, 350);
      await frame(800);

      // Done: the card goes and the clip leads the library.
      shown = [arriving.copyWith(modified: DateTime.now()), ...shown];
      c.invalidate(localMediaProvider);
      tasks.add([task.copyWith(phase: TaskPhase.completed)]);
      await settleShot(tester, still: false);
      await frame(2600);

      File('${dir.path}/frames.json').writeAsStringSync(jsonEncode(frames));
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 5));
      c.dispose();
      debugDisableShadows = true;
    });
  }
}

/// [ms] of the clock in small steps: an animation starts in the frame
/// that asks for it, so one long pump left a chip half chosen.
Future<void> wait(WidgetTester tester, int ms) async {
  for (var t = 0; t < ms; t += 50) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

/// Every picture on screen decoded outside the test's clock, or a cover
/// that appeared since the last frame stays blank in this one.
Future<void> precacheAll(WidgetTester tester) async {
  await tester.runAsync(() async {
    for (final element in find.byType(Image).evaluate()) {
      final image = (element.widget as Image).image;
      await precacheImage(
        image,
        element,
        onError: (_, _) {},
      ).timeout(const Duration(seconds: 5), onTimeout: () {});
    }
  });
  await tester.pump();
}

extension on LocalItem {
  LocalItem copyWith({DateTime? modified}) => LocalItem(
    key: key,
    canonicalUrl: canonicalUrl,
    path: path,
    title: title,
    sizeBytes: sizeBytes,
    modified: modified ?? this.modified,
    thumbnail: thumbnail,
    duration: duration,
  );
}
