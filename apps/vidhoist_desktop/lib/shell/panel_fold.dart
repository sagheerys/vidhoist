import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:vh_media/vh_media.dart';

import 'shell_layout.dart';

/// Whether the side panel stands beside the content: the user's saved
/// choice, but folded while the player holds nothing, unless it was opened
/// by hand since. Idle, it only said "Nothing playing" across a quarter of
/// the window, settings included.
///
/// Told only when the answer may change, so the shell does not rebuild its
/// frame on every tick of the clock to learn it.
class PanelFold extends ChangeNotifier {
  PanelFold(VhPlayer player) : _loaded = player.state.current != null {
    _states = player.states.listen((s) {
      final loaded = s.current != null;
      if (loaded == _loaded) return;
      _loaded = loaded;
      notifyListeners();
    });
  }

  late final StreamSubscription<VhPlayerState> _states;
  bool _loaded;

  /// Opened by hand while nothing plays. Not saved: the folding is the
  /// shell's, not the user's choice.
  bool _opened = false;

  /// [clipPage] keeps it: a clip's page is about to play, and folding there
  /// widened its picture until the actions under it left the window, then
  /// jumped back when the clip started.
  bool shown(ShellLayout layout, {bool clipPage = false}) =>
      !layout.panelHidden && (_loaded || _opened || clipPage);

  /// The panel was asked for, as by its tab from the player bar.
  void open() => _opened = true;

  /// The button in the title bar. With a clip loaded it changes the saved
  /// choice, as it always did; idle, only this session's.
  void toggle(
    ShellLayout layout,
    void Function(bool hidden) setHidden, {
    bool clipPage = false,
  }) {
    final wasShown = shown(layout, clipPage: clipPage);
    if (_loaded || clipPage) return setHidden(wasShown);
    _opened = !wasShown;
    if (!wasShown) setHidden(false);
    notifyListeners();
  }

  @override
  void dispose() {
    unawaited(_states.cancel());
    super.dispose();
  }
}
