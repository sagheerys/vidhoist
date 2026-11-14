import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_media/library.dart';
import 'package:vh_media/vh_media.dart' show ClipFields;
import 'package:vh_ui/vh_ui.dart';

import '../../data/choices_data.dart';
import '../../data/downloads_data.dart';
import '../../data/library_data.dart';
import '../../shell/shell_metrics.dart';
import '../library/platform_label.dart';
import 'add_options.dart';
import 'batch_dialog.dart';
import 'link_lines.dart';
import 'link_preview_card.dart';
import 'links_view.dart';
import '../../shell/desktop_dialog.dart';

/// Opens the add dialog with [text] in its field: a link, or a text that
/// holds several, from the clipboard, a drop or the button.
Future<void> openAddDialog(BuildContext context, {String text = ''}) =>
    showDesktopDialog<void>(context: context, builder: (_) => _AddDialog(text));

class _AddDialog extends ConsumerStatefulWidget {
  const _AddDialog(this.text);

  final String text;

  @override
  ConsumerState<_AddDialog> createState() => _AddDialogState();
}

class _AddDialogState extends ConsumerState<_AddDialog> {
  late final _field = TextEditingController(text: widget.text.trim());
  late AddChoice _choice = AddChoice.startingWith(
    ref.read(defaultQualityProvider),
  );
  final _removed = <String>{};

  /// Only a stretch ([ClipFields]), for one video; its times show what
  /// is wrong only once a download was asked for.
  var _clipOn = false;
  var _clipErrors = false;
  final _clipFrom = TextEditingController();
  final _clipTo = TextEditingController();

  /// The links sent, each with its task, so its line follows it.
  Map<String, String> _tasks = const {};

  bool get _sent => _tasks.isNotEmpty;

  @override
  void dispose() {
    _field.dispose();
    _clipFrom.dispose();
    _clipTo.dispose();
    super.dispose();
  }

  ReadLinks _read() {
    final library = [
      for (final item
          in ref.read(libraryItemsProvider).valueOrNull ?? <LibraryItem>[])
        item.canonicalUrl,
    ];
    final read = readLinks(_field.text, library);
    return ReadLinks([
      for (final line in read.lines)
        if (!_removed.contains(line.url)) line,
    ], dropped: read.dropped);
  }

  void _notice(String message, {VhNoticeKind kind = VhNoticeKind.info}) {
    if (mounted) showVhNotice(context, message: message, kind: kind);
  }

  /// Several links, sent together with the one choice for all.
  Future<void> _submitMany(ReadLinks read) async {
    final engine = ref.read(downloadEngineProvider);
    if (engine == null) return _notice(context.vhl.engineErrMissing);
    setState(() => _tasks = LinksView.submit(engine, read, _choice));
  }

  /// One link: a playlist goes to its own dialog, anything else is added.
  Future<void> _submitOne(String url) async {
    final l = context.vhl;
    final engine = ref.read(downloadEngineProvider);
    if (engine == null) return _notice(l.engineErrMissing);
    final clip = _clipOn ? ClipFields.read(_clipFrom, _clipTo) : null;
    // Times that do not read keep the dialog open, saying why.
    if (_clipOn && clip == null) return setState(() => _clipErrors = true);
    final navigator = Navigator.of(context);
    final resolved = await ShortLinkResolver().resolveForRouting(url);
    if (!mounted) return;
    if (PlaylistDetector.isPlaylist(resolved)) {
      navigator.pop();
      return showBatchDialog(navigator.context, resolved);
    }
    engine.submit(
      url,
      _choice.qualityFor(resolved),
      folder: _choice.folderPath,
      clip: clip,
    );
    navigator.pop();
    _notice(l.downloadStarted, kind: VhNoticeKind.done);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.vhl;
    final read = _read();
    final lines = read.lines;
    final many = lines.length > 1 || read.dropped > 0;
    final single = lines.length == 1 ? lines.single : null;
    final url = single?.url;
    final heights =
        lines.isNotEmpty && lines.every((line) => !line.platform.isAudioOnly);
    final canSubmit = many ? read.ready.isNotEmpty && !_sent : url != null;

    return AlertDialog(
      title: Text(l.addUrl),
      content: SizedBox(
        width: many ? DesktopShellSize.wideDialog : DesktopShellSize.addDialog,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Named for a screen reader even once filled, when its hint
              // is gone and only the link would be read.
              Semantics(
                label: l.addUrl,
                child: TextField(
                  controller: _field,
                  autofocus: true,
                  minLines: 1,
                  maxLines: many ? 4 : 2,
                  keyboardType: TextInputType.url,
                  textDirection: TextDirection.ltr,
                  onChanged: (_) => setState(() => _tasks = const {}),
                  decoration: InputDecoration(
                    hintText: l.pasteUrlHint,
                    hintTextDirection: TextDirection.ltr,
                    // A widget, not suffixText: the link reads left to right
                    // inside a right-to-left dialog, and the plain suffix sat
                    // flush against its first letter ("YouTubehttps://…").
                    suffix: url == null
                        ? null
                        : Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: VhSpace.sm,
                            ),
                            child: Text(
                              platformLabel(l, MediaPlatform.detect(url)),
                              key: const ValueKey('addLinkSite'),
                              style: Theme.of(context)
                                  .inputDecorationTheme
                                  .hintStyle,
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: VhSpace.md),
              if (many)
                LinksView(
                  read: read,
                  choice: _choice,
                  tasks: _tasks,
                  onRemove: (line) => setState(() => _removed.add(line.url)),
                  onRetry: (url, id) =>
                      setState(() => _tasks = {..._tasks, url: id}),
                )
              else if (single case final line?)
                switch (line.state) {
                  LinkState.playlist => LinkStateLine(line: line),
                  _ => LinkPreviewCard(url: line.url),
                },
              const SizedBox(height: VhSpace.md),
              if (single?.state != LinkState.playlist)
                AddOptions(
                  choice: _choice,
                  heights: heights,
                  offerTranscript:
                      !many &&
                      url != null &&
                      UrlKit.youtubeVideoId(url) != null,
                  onChanged: (choice) => setState(() => _choice = choice),
                ),
              // One video alone: a stretch means nothing across several
              // links or a playlist.
              if (single?.state case final state?
                  when state != LinkState.playlist)
                ClipFields(
                  on: _clipOn,
                  onChanged: (on) => setState(() => _clipOn = on),
                  from: _clipFrom,
                  to: _clipTo,
                  showErrors: _clipErrors,
                  checkbox: true,
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(_sent ? l.done : l.cancel),
        ),
        FilledButton(
          onPressed: !canSubmit
              ? null
              : () {
                  if (many) {
                    unawaited(_submitMany(read));
                  } else {
                    unawaited(_submitOne(url!));
                  }
                },
          child: Text(
            many
                ? l.desktopAddLinks(read.ready.length)
                : single?.state == LinkState.playlist
                ? l.batchTitle
                : l.startDownload,
          ),
        ),
      ],
    );
  }
}
