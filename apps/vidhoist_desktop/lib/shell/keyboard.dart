import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_media/vh_media.dart';
import 'package:vh_ui/vh_ui.dart';

import '../data/hints_data.dart';
import '../data/subtitles_data.dart';
import '../data/volume.dart';
import '../di.dart';
import '../features/listening/listening_room.dart';
import '../features/shortcuts/shortcuts_sheet.dart';
import 'key_gate.dart';
import 'player_bar.dart';
import 'shell_state.dart';

/// The window's keys, each with what it does.
enum DesktopKey {
  playPause,
  back,
  forward,
  up,
  down,
  repeat,
  captions,
  search,
  fullScreen,
  leaveFullScreen,
  shortcuts,
  mini;

  /// Plain keys, which a text field types and a focused button presses;
  /// they are left to those.
  bool get plain => this != search && this != fullScreen && this != mini;

  /// What the small card answers: play, seeking, and the way back (Esc
  /// too). The rest wants the full window.
  bool get inMini =>
      this == playPause ||
      this == back ||
      this == forward ||
      this == mini ||
      this == leaveFullScreen;

  /// Held down, only seeking and the volume go on.
  bool get repeats => arrow;

  bool get arrow =>
      this == back || this == forward || this == up || this == down;
}

/// Which of the window's keys [event] is, if any. Letters go by the key's
/// place on the keyboard, so R and F work with an Arabic layout too.
DesktopKey? desktopKeyFor(
  KeyEvent event, {
  required bool control,
  required bool shift,
}) {
  final logical = event.logicalKey;
  final physical = event.physicalKey;
  if (control) {
    if (shift) return null;
    return switch (physical) {
      PhysicalKeyboardKey.keyF => DesktopKey.search,
      PhysicalKeyboardKey.keyM => DesktopKey.mini,
      _ => null,
    };
  }
  if (shift) {
    // "?" is Shift and the slash key; an Arabic layout types its own
    // question mark there, so the key is read, not the character.
    return physical == PhysicalKeyboardKey.slash ? DesktopKey.shortcuts : null;
  }
  return switch (logical) {
    LogicalKeyboardKey.space => DesktopKey.playPause,
    LogicalKeyboardKey.arrowLeft => DesktopKey.back,
    LogicalKeyboardKey.arrowRight => DesktopKey.forward,
    LogicalKeyboardKey.arrowUp => DesktopKey.up,
    LogicalKeyboardKey.arrowDown => DesktopKey.down,
    LogicalKeyboardKey.f11 => DesktopKey.fullScreen,
    LogicalKeyboardKey.escape => DesktopKey.leaveFullScreen,
    _ => switch (physical) {
      PhysicalKeyboardKey.keyR => DesktopKey.repeat,
      PhysicalKeyboardKey.keyC => DesktopKey.captions,
      _ => null,
    },
  };
}

/// How far ← and → move.
const seekStep = Duration(seconds: 10);

/// **The keyboard over the whole window.** It reads each key before the
/// focus system does, so a key works wherever focus happens to be, and a
/// key it uses goes no further: a handler on [HardwareKeyboard] runs
/// beside the focus system, not ahead of it, so ↑ used to raise the volume
/// and move the focus at once. It stands aside for a dialog, for typing,
/// for Space on a focused button, and for the arrows while a control holds
/// focus (the keyboard is walking the window). Seeking, the volume and
/// play/pause wait for a clip: with none, the keys go on as usual.
class DesktopKeyboard extends ConsumerStatefulWidget {
  const DesktopKeyboard({
    super.key,
    required this.onSearch,
    required this.onMini,
    required this.inShortsLane,
    required this.child,
  });

  final VoidCallback onSearch;

  /// Turns the window into the small card, or back.
  final VoidCallback onMini;

  /// Whether a short is open in its lane, where ↑ and ↓ move between
  /// shorts rather than the volume.
  final bool Function() inShortsLane;
  final Widget child;

  @override
  ConsumerState<DesktopKeyboard> createState() => _DesktopKeyboardState();
}

class _DesktopKeyboardState extends ConsumerState<DesktopKeyboard> {
  @override
  void initState() {
    super.initState();
    HardwareKeyboard.instance.addHandler(_onKey);
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_onKey);
    super.dispose();
  }

  bool _onKey(KeyEvent event) {
    final used = _use(event);
    // The focus system hears the same key next; [KeyGate] stops it there.
    if (used) KeyGate.used(event);
    return used;
  }

  bool _use(KeyEvent event) {
    if (event is KeyUpEvent || !mounted) return false;
    if (ModalRoute.of(context)?.isCurrent == false) return false;
    final keyboard = HardwareKeyboard.instance;
    if (keyboard.isAltPressed || keyboard.isMetaPressed) return false;
    final key = desktopKeyFor(
      event,
      control: keyboard.isControlPressed,
      shift: keyboard.isShiftPressed,
    );
    if (key == null) return false;
    if (event is KeyRepeatEvent && !key.repeats) return false;
    final focused = FocusManager.instance.primaryFocus?.context;
    if (key.plain && _typing(focused)) return false;
    if (key == DesktopKey.playPause && _pressable(focused)) return false;
    if (key.arrow && _onControl()) return false;
    return _run(key);
  }

  /// A real control holds focus, not the window or a page as a whole: the
  /// arrows are the keyboard's way around, as the focus ring shows.
  static bool _onControl() {
    final node = FocusManager.instance.primaryFocus;
    return node != null && node is! FocusScopeNode && node.context != null;
  }

  /// A text field has the keys.
  static bool _typing(BuildContext? focused) =>
      focused != null &&
      (focused.widget is EditableText ||
          focused.findAncestorWidgetOfExactType<EditableText>() != null);

  /// A focused button takes Space for itself.
  static bool _pressable(BuildContext? focused) =>
      focused != null &&
      (Actions.maybeFind<ActivateIntent>(focused)
              ?.isEnabled(const ActivateIntent()) ??
          false);

  bool _run(DesktopKey pressed) {
    var key = pressed;
    final player = ref.read(playerProvider);
    final state = player.state;
    final loaded = state.current != null;
    final controls = ref.read(windowControlsProvider);
    if (controls.mini.value) {
      if (!key.inMini) return false;
      if (key == DesktopKey.leaveFullScreen) key = DesktopKey.mini;
    }
    switch (key) {
      case DesktopKey.playPause when loaded:
        unawaited(state.playing ? player.pause() : player.play());
      case DesktopKey.back when loaded:
        final to = player.position - seekStep;
        unawaited(player.seek(to.isNegative ? Duration.zero : to));
      case DesktopKey.forward when loaded:
        unawaited(player.seek(player.position + seekStep));
      case DesktopKey.up || DesktopKey.down when widget.inShortsLane():
        unawaited(
          key == DesktopKey.down
              ? player.skipToNext()
              : player.skipToPrevious(),
        );
      case DesktopKey.up || DesktopKey.down when loaded:
        unawaited(_nudgeVolume(key == DesktopKey.up ? 1 : -1));
      case DesktopKey.repeat:
        final mode = nextPlayMode(state.mode);
        unawaited(player.setPlayMode(mode));
        showVhNotice(context, message: _modeName(context.vhl, mode));
      case DesktopKey.captions when loaded:
        ref.read(desktopSubtitlesProvider).toggle();
      case DesktopKey.search:
        widget.onSearch();
      case DesktopKey.fullScreen:
        controls.setFullScreen(!controls.fullScreen.value);
      case DesktopKey.leaveFullScreen when controls.fullScreen.value:
        controls.setFullScreen(false);
      // Out of full screen first, then out of the room.
      case DesktopKey.leaveFullScreen when ref.read(listeningProvider):
        ref.read(listeningProvider.notifier).state = false;
      case DesktopKey.shortcuts:
        unawaited(showShortcutsSheet(context));
      case DesktopKey.mini:
        widget.onMini();
      default:
        return false;
    }
    // Someone using the keys needs no tip about them.
    unawaited(ref.read(hintsProvider.notifier).learned(DesktopHint.shortcuts));
    return true;
  }

  Future<void> _nudgeVolume(int direction) async {
    await ref.read(volumeProvider.notifier).nudge(direction);
    if (!mounted) return;
    showVhNotice(
      context,
      message: context.vhl.desktopVolumeLevel(ref.read(volumeProvider).round()),
      duration: const Duration(seconds: 1),
    );
  }

  static String _modeName(VhLocalizations l, PlayMode mode) => switch (mode) {
    PlayMode.autoNext => l.modeAutoNext,
    PlayMode.repeatAll => l.modeRepeatAll,
    PlayMode.repeatOne => l.modeRepeatOne,
    PlayMode.stopAtEnd => l.modeStopAtEnd,
  };

  @override
  Widget build(BuildContext context) => widget.child;
}
