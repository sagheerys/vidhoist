import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vh_ui/vh_ui.dart';

import '../../shell/search_lens.dart';

/// The reading room's find bar (Ctrl+F): the words, how many places hold
/// them and which one is chosen, and the way between them. Enter and ↓
/// go to the next, Shift+Enter and ↑ to the one before, Esc closes.
class ReadingFindBar extends StatelessWidget {
  const ReadingFindBar({
    super.key,
    required this.query,
    required this.focus,
    required this.found,
    required this.chosen,
    required this.onChanged,
    required this.onStep,
    required this.onClose,
  });

  final TextEditingController query;
  final FocusNode focus;

  /// How many places hold the words, and which of them is chosen.
  final int found;
  final int chosen;
  final ValueChanged<String> onChanged;

  /// Moves the choice by one, forward or back.
  final ValueChanged<int> onStep;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final l = context.vhl;
    final p = VhThemeX.of(context).palette;
    final text = Theme.of(context).textTheme;
    final typed = query.text.trim().isNotEmpty;
    Widget button(
      VhIconData icon,
      String label,
      VoidCallback? onTap, {
      bool up = false,
    }) => VhShortcutTooltip(
      message: label,
      child: IconButton(
        onPressed: onTap,
        icon: RotatedBox(
          quarterTurns: up ? 2 : 0,
          child: VhIcon(
            icon,
            size: VhDensity.desktop.icon,
            semanticLabel: label,
          ),
        ),
      ),
    );
    return DecoratedBox(
      decoration: BoxDecoration(
        color: p.card,
        border: Border(
          bottom: BorderSide(
            color: p.line,
            width: VhThemeX.of(context).hairline,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: VhSpace.xl,
          vertical: VhSpace.sm,
        ),
        child: Row(
          children: [
            Expanded(
              child: CallbackShortcuts(
                bindings: {
                  const SingleActivator(LogicalKeyboardKey.enter): () =>
                      onStep(1),
                  const SingleActivator(LogicalKeyboardKey.arrowDown): () =>
                      onStep(1),
                  const SingleActivator(
                    LogicalKeyboardKey.enter,
                    shift: true,
                  ): () =>
                      onStep(-1),
                  const SingleActivator(LogicalKeyboardKey.arrowUp): () =>
                      onStep(-1),
                  const SingleActivator(LogicalKeyboardKey.escape): onClose,
                },
                child: TextField(
                  controller: query,
                  focusNode: focus,
                  onChanged: onChanged,
                  decoration: InputDecoration(
                    hintText: l.desktopReadingFind,
                    prefixIcon: searchLens(p),
                  ),
                ),
              ),
            ),
            const SizedBox(width: VhSpace.md),
            // Read out as it changes, so a screen reader hears the count.
            Semantics(
              liveRegion: true,
              child: Text(
                !typed
                    ? ''
                    : found == 0
                    ? l.noResults
                    : l.desktopReadingFound(chosen + 1, found),
                style: text.labelMedium?.tabular.copyWith(color: p.ink3),
              ),
            ),
            button(
              VhIcons.chevronDown,
              l.desktopReadingPreviousMatch,
              found > 1 ? () => onStep(-1) : null,
              up: true,
            ),
            button(
              VhIcons.chevronDown,
              l.desktopReadingNextMatch,
              found > 1 ? () => onStep(1) : null,
            ),
            button(VhIcons.close, l.desktopReadingCloseFind, onClose),
          ],
        ),
      ),
    );
  }
}
