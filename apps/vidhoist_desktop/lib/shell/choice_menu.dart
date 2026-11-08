import 'package:flutter/material.dart';
import 'package:vh_ui/vh_ui.dart';

/// A closed list to pick from, with the Wahaj chevron rather than
/// Material's arrow.
class DesktopChoice<T> extends StatelessWidget {
  const DesktopChoice({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    required this.choices,
    this.helper,
  });

  final String label;
  final String? helper;
  final T value;
  final ValueChanged<T> onChanged;
  final Map<T, String> choices;

  @override
  Widget build(BuildContext context) {
    final p = VhThemeX.of(context).palette;
    final chevron = VhIcon(
      VhIcons.chevronDown,
      size: VhSpace.lg,
      color: p.ink2,
    );
    return DropdownMenu<T>(
      initialSelection: value,
      label: Text(label),
      helperText: helper,
      expandedInsets: EdgeInsets.zero,
      trailingIcon: chevron,
      selectedTrailingIcon: chevron,
      onSelected: (picked) {
        if (picked != null) onChanged(picked);
      },
      dropdownMenuEntries: [
        for (final MapEntry(:key, :value) in choices.entries)
          DropdownMenuEntry(value: key, label: value),
      ],
    );
  }
}
