import 'package:flutter/material.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';

import '../../shell/shell_metrics.dart';
import '../../shell/desktop_dialog.dart';

/// The name of a new folder, nested when typed with a slash. It is made on
/// the server by the first download saved into it.
Future<String?> askNewFolder(BuildContext context, String parent) async {
  final typed = await showEmberDialog<String>(
    context: context,
    builder: (_) => _NewFolderDialog(parent: parent),
  );
  final clean = ServerPath.cleanFolder(typed ?? '');
  return clean.isEmpty ? null : clean;
}

/// The dialog owns its controller, so it is disposed only once the route
/// is gone, not while the closing animation still builds the field.
class _NewFolderDialog extends StatefulWidget {
  const _NewFolderDialog({required this.parent});

  final String parent;

  @override
  State<_NewFolderDialog> createState() => _NewFolderDialogState();
}

class _NewFolderDialogState extends State<_NewFolderDialog> {
  late final _controller = TextEditingController(
    text: widget.parent.isEmpty ? '' : '${widget.parent}/',
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.vhl;
    return AlertDialog(
      title: Text(l.newFolder),
      content: SizedBox(
        width: DesktopShellSize.smallDialog,
        child: TextField(
          controller: _controller,
          autofocus: true,
          decoration: InputDecoration(hintText: l.newFolderHint),
          onSubmitted: (value) => Navigator.of(context).pop(value),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l.cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(_controller.text),
          child: Text(l.create),
        ),
      ],
    );
  }
}

/// A help text in its own dialog.
Future<void> showFolderHelp(BuildContext context, String title, String body) =>
    showEmberDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SizedBox(
          width: DesktopShellSize.formDialog,
          child: SingleChildScrollView(child: Text(body)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(context.vhl.done),
          ),
        ],
      ),
    );

/// The (?) that opens a help text: **still and grey**, found by whoever
/// wants it. It used to pulse three times in a circle of the accent as the
/// picker opened, a light that asked for attention nobody had asked for.
class FolderHelp extends StatelessWidget {
  const FolderHelp({super.key, required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = VhThemeX.of(context).palette;
    final text = Theme.of(context).textTheme;
    final mark = Directionality.of(context) == TextDirection.rtl ? '؟' : '?';
    return VhShortcutTooltip(
      message: label,
      child: Material(
        shape: CircleBorder(
          side: BorderSide(
            color: p.line2,
            width: VhThemeX.of(context).hairline,
          ),
        ),
        color: Colors.transparent,
        // A button by its name, not by the question mark it shows: the
        // tooltip says nothing to a screen reader.
        child: Semantics(
          button: true,
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onTap,
            child: SizedBox.square(
              dimension: VhSpace.xl,
              child: Center(
                child: Text(
                  mark,
                  semanticsLabel: label,
                  style: text.labelMedium?.copyWith(color: p.ink2),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
