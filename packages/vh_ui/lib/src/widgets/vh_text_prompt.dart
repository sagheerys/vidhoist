import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../l10n/l10n.dart';
import 'vh_route_motion.dart';

/// A single-text input dialog: a playlist name, a tag name, an endpoint
/// URL.
///
/// **Why a stateful widget rather than a function** (full review
/// 2026-09-02): every call site created a `TextEditingController` inside
/// the dialog's builder and never disposed it, five leaks across the two
/// apps. Disposing after `await showDialog` **is not a fix**: the future
/// completes at the pop while the closing animation is still rebuilding
/// the field, which is exactly what produced the red screen in phase 8.
/// The only correct owner of the controller is the widget that holds it,
/// disposing it in `dispose` once it has actually left the tree.
Future<String?> promptVhText(
  BuildContext context, {
  required String title,
  required String confirmLabel,
  String? initialValue,
  String? labelText,
  String? hintText,
  TextDirection? fieldDirection,
  int? maxLength,
}) => showVhDialog<String>(
  context: context,
  builder: (_) => _VhTextPrompt(
    title: title,
    confirmLabel: confirmLabel,
    initialValue: initialValue,
    labelText: labelText,
    hintText: hintText,
    fieldDirection: fieldDirection,
    maxLength: maxLength,
  ),
);

class _VhTextPrompt extends StatefulWidget {
  const _VhTextPrompt({
    required this.title,
    required this.confirmLabel,
    this.initialValue,
    this.labelText,
    this.hintText,
    this.fieldDirection,
    this.maxLength,
  });

  final String title;
  final String confirmLabel;
  final String? initialValue;
  final String? labelText;
  final String? hintText;

  /// URLs are typed left to right even when the interface is Arabic.
  final TextDirection? fieldDirection;

  /// Characters the answer may hold; typing stops there.
  final int? maxLength;

  @override
  State<_VhTextPrompt> createState() => _VhTextPromptState();
}

class _VhTextPromptState extends State<_VhTextPrompt> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.initialValue,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() => Navigator.of(context).pop(_controller.text.trim());

  @override
  Widget build(BuildContext context) {
    final l10n = context.vhl;
    return AlertDialog(
      title: Text(widget.title),
      content: TextField(
        inputFormatters: [
          if (widget.maxLength case final max?)
            LengthLimitingTextInputFormatter(max),
        ],
        controller: _controller,
        autofocus: true,
        textDirection: widget.fieldDirection,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          labelText: widget.labelText,
          hintText: widget.hintText,
        ),
        onSubmitted: (_) => _submit(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FilledButton(onPressed: _submit, child: Text(widget.confirmLabel)),
      ],
    );
  }
}
