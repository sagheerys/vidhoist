import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';

import '../../data/folders_data.dart';
import '../../di.dart';
import '../../shell/search_lens.dart';

/// The diagnostic log: searched, cleared, and given away as a file or
/// copied. **What leaves the app is always the sanitised text**: no links,
/// addresses, sign-in headers or paths, whichever way it goes.
class LogsPane extends ConsumerStatefulWidget {
  const LogsPane({super.key});

  /// The newest lines kept on screen; the file itself holds more, and the
  /// saved copy holds all of it.
  static const shown = 400;

  @override
  ConsumerState<LogsPane> createState() => _LogsPaneState();
}

class _LogsPaneState extends ConsumerState<LogsPane> {
  List<String> _lines = const [];
  String _query = '';
  StreamSubscription<void>? _changes;

  VhLogger get _logger => ref.read(loggerProvider);

  @override
  void initState() {
    super.initState();
    unawaited(_load());
    _changes = _logger.changes.listen((_) => unawaited(_load()));
  }

  @override
  void dispose() {
    unawaited(_changes?.cancel());
    super.dispose();
  }

  Future<void> _load() async {
    final text = await _logger.readAll();
    if (!mounted) return;
    setState(
      () => _lines = [
        for (final line in text.split('\n'))
          if (line.trim().isNotEmpty) line,
      ],
    );
  }

  Future<void> _save() async {
    final day = DateTime.now().toIso8601String().substring(0, 10);
    final path = await ref
        .read(desktopFoldersProvider)
        .saveText(
          name: 'vidhoist_logs_$day.txt',
          text: await _logger.readForShare(),
        );
    if (path != null && mounted) {
      showVhNotice(context, message: context.vhl.desktopSavedIn(path));
    }
  }

  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: await _logger.readForShare()));
    if (mounted) showVhNotice(context, message: context.vhl.desktopLogsCopied);
  }

  Future<void> _clear() async {
    final l = context.vhl;
    final sure = await showVhConfirm(
      context,
      title: l.clearLogs,
      message: l.clearLogsConfirm,
      confirmLabel: l.clear,
      cancelLabel: l.cancel,
      destructive: true,
    );
    if (sure) await _logger.clear();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.vhl;
    final p = VhThemeX.of(context).palette;
    final text = Theme.of(context).textTheme;
    final query = _query.trim().toLowerCase();
    final matching = [
      for (final line in _lines)
        if (query.isEmpty || line.toLowerCase().contains(query)) line,
    ];
    final visible = matching.length > LogsPane.shown
        ? matching.sublist(matching.length - LogsPane.shown)
        : matching;
    final some = _lines.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: VhSpace.md,
          runSpacing: VhSpace.xs,
          children: [
            VhLinkButton(
              label: l.desktopLogsSave,
              icon: VhIcons.saveTo,
              onPressed: some ? () => unawaited(_save()) : null,
            ),
            VhLinkButton(
              label: l.desktopLogsCopy,
              icon: VhIcons.copy,
              onPressed: some ? () => unawaited(_copy()) : null,
            ),
            VhLinkButton(
              label: l.clearLogs,
              danger: true,
              icon: VhIcons.trash,
              onPressed: some ? () => unawaited(_clear()) : null,
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: VhSpace.xs),
          child: Text(
            l.logsSanitizedNote,
            style: text.labelSmall?.copyWith(color: p.ink3),
          ),
        ),
        TextField(
          onChanged: (value) => setState(() => _query = value),
          decoration: InputDecoration(
            hintText: l.searchLogs,
            prefixIcon: searchLens(p),
          ),
        ),
        const SizedBox(height: VhSpace.md),
        if (visible.isEmpty)
          Text(
            some ? l.noResults : l.logsEmpty,
            style: text.bodyMedium?.copyWith(color: p.ink3),
          )
        else
          // One block of text rather than a widget per line: hundreds of
          // lines lay out once, and a selection can span several of them.
          SelectableText(
            visible.join('\n'),
            textDirection: TextDirection.ltr,
            style: text.labelSmall?.copyWith(
              color: p.ink2,
              fontFamily: 'monospace',
              height: 1.5,
            ),
          ),
      ],
    );
  }
}
