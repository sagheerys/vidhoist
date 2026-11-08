import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_ui/vh_ui.dart';

import 'di.dart';
import 'router.dart';

/// The Vidhoist Lite root: the Wahaj theme with the petrol bay accent, plus
/// localisation and the router. The identity is one and the difference is
/// functional only.
class PhoneApp extends ConsumerWidget {
  const PhoneApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(settingsProvider.select((s) => s.themeMode));
    final localeCode = ref.watch(settingsProvider.select((s) => s.localeCode));

    return MaterialApp.router(
      title: 'Vidhoist',
      debugShowCheckedModeBanner: false,
      theme: vhTheme(VhVariant.phone, Brightness.light),
      darkTheme: vhTheme(VhVariant.phone, Brightness.dark),
      themeMode: themeMode,
      locale: localeCode == null ? null : Locale(localeCode),
      localizationsDelegates: VhLocalizations.localizationsDelegates,
      supportedLocales: VhLocalizations.supportedLocales,
      localeListResolutionCallback: vhLocaleResolution,
      routerConfig: router,
      // **The system bars follow the theme**, without the contrast scrim
      // Android imposes behind the three navigation buttons, which cuts
      // across
      // the colour of the bottom bar.
      builder: (context, child) =>
          VhSystemBars(child: child ?? const SizedBox.shrink()),
    );
  }
}
