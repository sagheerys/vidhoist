import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vh_ui/vh_ui.dart';

/// One choice of several as chips in a single row that slides sideways,
/// for a list too long to sit in one line: wrapped, six chips stood in
/// three uneven rows and pushed the rest of the sheet down.
///
/// The chosen chip is brought into view when the row first appears, so a
/// choice near the end (every 24 hours, audio only) is seen, not hidden
/// past the edge.
class ChoiceChipRow extends StatefulWidget {
  const ChoiceChipRow({
    super.key,
    required this.labels,
    required this.chosen,
    required this.onChosen,
  });

  final List<String> labels;
  final int chosen;
  final ValueChanged<int> onChosen;

  @override
  State<ChoiceChipRow> createState() => _ChoiceChipRowState();
}

class _ChoiceChipRowState extends State<ChoiceChipRow> {
  late final _chips = [for (final _ in widget.labels) GlobalKey()];
  final _row = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.chosen < 0 || widget.chosen >= _chips.length) return;
      final chip = _chips[widget.chosen].currentContext?.findRenderObject();
      // The row's own position only: the sheet around it stays put.
      if (chip == null || !_row.hasClients) return;
      unawaited(_row.position.ensureVisible(chip, alignment: 0.5));
    });
  }

  @override
  void dispose() {
    _row.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = VhThemeX.of(context).palette;
    final style = Theme.of(context).textTheme.labelMedium!;
    return SingleChildScrollView(
      controller: _row,
      scrollDirection: Axis.horizontal,
      child: Row(
        spacing: VhSpace.xs,
        children: [
          for (final (i, label) in widget.labels.indexed)
            ChoiceChip(
              key: _chips[i],
              label: Text(label),
              selected: widget.chosen == i,
              showCheckmark: false,
              labelStyle: style.copyWith(
                color: widget.chosen == i ? p.bg : p.ink2,
              ),
              onSelected: (_) => widget.onChosen(i),
            ),
        ],
      ),
    );
  }
}
