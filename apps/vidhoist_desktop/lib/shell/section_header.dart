import 'package:flutter/material.dart';
import 'package:vh_ui/vh_ui.dart';

/// The section header as the phone app draws it (a Kufi title, a quiet
/// line at the end, a hairline beneath), except that **the end line gives
/// way**: in a window at a large font it shortens instead of pushing the
/// row past its edge. The phone app's header keeps its own rules.
class DesktopSectionHeader extends StatelessWidget {
  const DesktopSectionHeader({
    super.key,
    required this.title,
    this.trailing,
    this.action,
  });

  final String title;
  final String? trailing;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final p = VhThemeX.of(context).palette;
    final text = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(
        VhSpace.xxs,
        VhSpace.xxs,
        VhSpace.xxs,
        VhSpace.sm,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: p.line,
            width: VhThemeX.of(context).hairline,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: text.titleMedium,
            ),
          ),
          if (trailing case final line?)
            Flexible(
              // Filling its share, so the line sits at the row's end.
              child: Align(
                alignment: AlignmentDirectional.centerEnd,
                child: Text(
                  line,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: text.bodySmall?.copyWith(color: p.ink3),
                ),
              ),
            ),
          // A button keeps its size; the two texts are what give way.
          ?action,
        ],
      ),
    );
  }
}
