import 'package:flutter/material.dart';

import '../icons/vh_icon_data.dart';
import '../theme/vh_theme.dart';
import '../tokens/tokens.dart';
import 'vh_link_button.dart';

/// The Wahaj empty screen: a plain title that names what is empty, one
/// sentence that says **how to begin**, and the way out as a link, not a
/// filled button.
///
/// **No drawing above it.** The same picture over every empty place (it was
/// a film frame with the ember in it) is one of the marks of a generated
/// screen; the words, and the action where the content will appear, are
/// what an empty place owes the reader.
class VhEmptyFrame extends StatelessWidget {
  const VhEmptyFrame({
    super.key,
    required this.title,
    required this.message,
    this.actionLabel,
    this.actionIcon,
    this.onAction,
  });

  final String title;
  final String message;
  final String? actionLabel;
  final VhIconData? actionIcon;
  final VoidCallback? onAction;

  /// Wide enough for the longer messages to keep to three lines.
  static const _textWidth = 360.0;

  @override
  Widget build(BuildContext context) {
    final p = VhThemeX.of(context).palette;
    final text = Theme.of(context).textTheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title, style: text.titleMedium, textAlign: TextAlign.center),
        const SizedBox(height: VhSpace.xxs),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: _textWidth),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: text.bodyMedium!.copyWith(color: p.ink3),
          ),
        ),
        if (actionLabel != null) ...[
          const SizedBox(height: VhSpace.xs),
          VhLinkButton(
            label: actionLabel!,
            icon: actionIcon,
            onPressed: onAction,
          ),
        ],
      ],
    );
  }
}
