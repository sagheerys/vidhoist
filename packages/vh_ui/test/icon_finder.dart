import 'package:flutter_test/flutter_test.dart';
import 'package:vh_ui/vh_ui.dart';

/// Finds a VidHoist icon on screen, as `find.byIcon` finds a Material one.
Finder byVhIcon(VhIconData icon) => find.byWidgetPredicate(
  (w) => w is VhIcon && w.icon == icon,
  description: 'Vidhoist icon "${icon.name}"',
);
