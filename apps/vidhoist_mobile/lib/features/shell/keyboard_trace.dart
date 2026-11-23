import 'package:flutter/widgets.dart';

/// Notes, each time the keyboard comes up, where the app was and whether a
/// text field was holding the focus.
///
/// **Why:** a keyboard once rose on its own after a download, and nothing
/// afterwards could say what raised it. A keyboard with a field behind it
/// was asked for by that screen; one with no field was raised by the
/// system, which brings it back when the app returns to the front. The
/// line names the screen only: never what was typed.
class KeyboardTrace {
  KeyboardTrace(this.log);

  final void Function(String line) log;
  bool _up = false;

  /// Called on every change of the window's insets; [where] is the path of
  /// the screen in front.
  void metricsChanged(BuildContext context, String where) {
    final up = View.of(context).viewInsets.bottom > 0;
    if (up == _up) return;
    _up = up;
    if (!up) return;
    final focused = FocusManager.instance.primaryFocus?.context;
    final field =
        focused?.findAncestorWidgetOfExactType<EditableText>() != null ||
        focused?.widget is EditableText;
    log(
      'keyboard up at $where, '
      '${field ? 'a text field has the focus' : 'no text field has the focus'}',
    );
  }
}
