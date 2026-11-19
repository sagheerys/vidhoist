import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vh_media/library.dart';
import 'package:vh_ui/vh_ui.dart';

import '../../shell/error_text.dart';
import '../../shell/player_controls.dart';
import '../clip/clip_actions.dart';
import '../clip/clip_state.dart';
import '../clip/tags_dialog.dart';
import '../lists/list_dialogs.dart';
import 'clip_keys.dart';
import 'selection.dart';

/// A list of clips that can be chosen from: the list, and while any is
/// chosen a bar of what can be done to them all at its foot. Esc lets
/// go of the choice and Ctrl+A takes every clip shown.
class SelectionFrame extends ConsumerStatefulWidget {
  const SelectionFrame({super.key, required this.items, required this.child});

  /// The clips as shown, in order.
  final List<LibraryItem> items;
  final Widget child;

  @override
  ConsumerState<SelectionFrame> createState() => _SelectionFrameState();
}

class _SelectionFrameState extends ConsumerState<SelectionFrame> {
  late final LibrarySelectionNotifier _selection;

  /// The bar, measured so a notice can rise above it.
  final _bar = GlobalKey();

  @override
  void initState() {
    super.initState();
    _selection = ref.read(librarySelectionProvider.notifier);
    HardwareKeyboard.instance.addHandler(_key);
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_key);
    // A choice belongs to the list it was made in.
    Future.microtask(_selection.clear);
    super.dispose();
  }

  bool _key(KeyEvent event) {
    if (event is! KeyDownEvent) return false;
    final focused = FocusManager.instance.primaryFocus?.context;
    // A text field keeps its own Esc and Ctrl+A.
    if (focused?.findAncestorWidgetOfExactType<EditableText>() != null ||
        focused?.widget is EditableText) {
      return false;
    }
    if (clipCopyOf(event) case final copy?) return _copy(copy, focused);
    if (event.logicalKey == LogicalKeyboardKey.escape &&
        ref.read(librarySelectionProvider).urls.isNotEmpty) {
      _selection.clear();
      return true;
    }
    if (event.logicalKey == LogicalKeyboardKey.keyA &&
        HardwareKeyboard.instance.isControlPressed &&
        ModalRoute.of(context)?.isCurrent != false) {
      _selection.selectAll([for (final i in widget.items) i.canonicalUrl]);
      return true;
    }
    return false;
  }

  /// The copy keys with no clip in focus, since with the mouse they used to
  /// do nothing. They take the one clip chosen, else the one under the
  /// mouse; never several at once, which says so instead of copying the lot.
  bool _copy(ClipCopy copy, BuildContext? focused) {
    // A clip with focus answers its own keys.
    if (focused?.findAncestorWidgetOfExactType<ClipKeyArea>() != null) {
      return false;
    }
    if (ModalRoute.of(context)?.isCurrent == false) return false;
    final chosen = ref.read(librarySelectionProvider).urls;
    if (chosen.length > 1) {
      // Over the bar it would hide the bar's last buttons while it shows.
      final bar = _bar.currentContext?.size?.height ?? 0;
      showVhNotice(
        context,
        message: context.vhl.desktopCopyOneClip,
        raise: bar + VhSpace.lg,
      );
      return true;
    }
    final item = chosen.isEmpty
        ? ClipKeyArea.pointed
        : widget.items
              .where((i) => i.canonicalUrl == chosen.single)
              .firstOrNull;
    if (item == null) return false;
    unawaited(runClipCopy(context, copy, item));
    return true;
  }

  /// The choice the bar shows, kept while it leaves.
  List<LibraryItem> _shown = const [];

  @override
  Widget build(BuildContext context) {
    final chosen = ref.watch(librarySelectionProvider).urls;
    final items = [
      for (final i in widget.items)
        if (chosen.contains(i.canonicalUrl)) i,
    ];
    // The bar rises a few points as it fades in and drops back quicker as
    // it leaves, holding the last choice while it goes.
    if (items.isNotEmpty) _shown = items;
    final shown = items.isNotEmpty;
    return Stack(
      children: [
        widget.child,
        if (_shown.isNotEmpty)
          PositionedDirectional(
            start: VhSpace.xl,
            end: VhSpace.xl,
            bottom: VhSpace.lg,
            child: IgnorePointer(
              ignoring: !shown,
              child: AnimatedSlide(
                offset: shown ? Offset.zero : const Offset(0, 0.25),
                duration: vhMotionDuration(
                  context,
                  shown ? VhMotion.page : VhMotion.fast,
                ),
                curve: shown ? VhMotion.entrance : VhMotion.exit,
                child: AnimatedOpacity(
                  opacity: shown ? 1 : 0,
                  duration: vhMotionDuration(
                    context,
                    shown ? VhMotion.page : VhMotion.fast,
                  ),
                  curve: shown ? VhMotion.entrance : VhMotion.exit,
                  onEnd: () {
                    if (!shown && mounted) setState(() => _shown = const []);
                  },
                  child: Center(
                    child: _Bar(key: _bar, items: _shown),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// What can be done to every chosen clip at once.
class _Bar extends ConsumerWidget {
  const _Bar({super.key, required this.items});

  final List<LibraryItem> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = VhThemeX.of(context).palette;
    final l = context.vhl;
    final text = Theme.of(context).textTheme;
    final selection = ref.read(librarySelectionProvider.notifier);
    final withFile = items.where((i) => i.isOffline).toList();
    return Material(
      color: p.card,
      elevation: 6,
      shadowColor: p.ink.withValues(alpha: 0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(VhCorners.desktop.card),
        side: BorderSide(color: p.line2, width: VhThemeX.of(context).hairline),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: VhSpace.md,
          vertical: VhSpace.xs,
        ),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: VhSpace.xs,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.only(end: VhSpace.sm),
              child: Text(
                l.desktopSelectedCount(items.length),
                style: text.labelLarge?.copyWith(color: p.ink),
              ),
            ),
            DesktopPlayerControl(
              icon: VhIcons.play,
              label: l.play,
              onTap: () => unawaited(
                openFromList(ref, GoRouter.of(context), [
                  for (final i in items) toPlaylistItem(i),
                ], 0),
              ),
            ),
            DesktopPlayerControl(
              icon: VhIcons.queue,
              label: l.addToPlaylist,
              onTap: () => unawaited(
                showAddAllToPlaylistDialog(context, [
                  for (final i in items) toPlaylistItem(i),
                ]),
              ),
            ),
            DesktopPlayerControl(
              icon: VhIcons.tags,
              label: l.tags,
              onTap: () => unawaited(
                showTagsDialogFor(context, [
                  for (final i in items) i.canonicalUrl,
                ]),
              ),
            ),
            if (withFile.isNotEmpty)
              DesktopPlayerControl(
                icon: VhIcons.trash,
                label: l.delete,
                onTap: () => unawaited(_delete(context, ref, withFile)),
              ),
            DesktopPlayerControl(
              icon: VhIcons.close,
              label: l.desktopClearSelection,
              shortcut: 'Esc',
              onTap: selection.clear,
            ),
          ],
        ),
      ),
    );
  }

  /// Their files on this computer, after asking once.
  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    List<LibraryItem> withFile,
  ) async {
    final l = context.vhl;
    final sure = await showVhConfirm(
      context,
      title: l.delete,
      message: l.desktopDeleteSelectedConfirm(withFile.length),
      confirmLabel: l.delete,
      cancelLabel: l.cancel,
      destructive: true,
    );
    if (!sure) return;
    final actions = ref.read(clipActionsProvider);
    try {
      for (final item in withFile) {
        await actions.deleteFile(item);
      }
    } on Object catch (e) {
      // Those deleted before the failure are gone; the rest stay chosen.
      if (context.mounted) {
        showVhNotice(
          context,
          message: errorText(l, e),
          kind: VhNoticeKind.failed,
        );
      }
      return;
    }
    ref.read(librarySelectionProvider.notifier).clear();
    if (context.mounted) {
      showVhNotice(context, message: l.deletedCount(withFile.length));
    }
  }
}
