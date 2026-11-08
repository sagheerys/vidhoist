import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mt_core/mt_core.dart';
import 'package:mt_ui/mt_ui.dart';

import '../../di.dart';
import '../home/quick_download.dart';
import '../player/caption_style.dart';
import '../shared/error_text.dart';
import 'channels_state.dart';

/// Follows a channel, or with [editing] changes how often it is read and
/// its title filter; its quality is chosen once, when following.
Future<void> showFollowSheet(
  BuildContext context, {
  ChannelSubscription? editing,
}) => showMTSheet<void>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  showDragHandle: true,
  builder: (_) => _FollowSheet(editing: editing),
);

const _qualities = [
  Quality.best,
  Quality.q1080,
  Quality.q720,
  Quality.q480,
  Quality.q360,
  Quality.audio,
];

class _FollowSheet extends ConsumerStatefulWidget {
  const _FollowSheet({this.editing});

  final ChannelSubscription? editing;

  @override
  ConsumerState<_FollowSheet> createState() => _FollowSheetState();
}

class _FollowSheetState extends ConsumerState<_FollowSheet> {
  final _url = TextEditingController();
  late final _filter = TextEditingController(
    text: widget.editing?.titleRegex ?? '',
  );
  late int _interval = _nearest(widget.editing?.checkIntervalMinutes ?? 60);
  late Quality _quality = ref.read(settingsProvider).quality;
  bool _busy = false;
  String? _failure;

  bool get _isEdit => widget.editing != null;

  static int _nearest(int minutes) => channelIntervals.reduce(
    (a, b) => (a - minutes).abs() <= (b - minutes).abs() ? a : b,
  );

  @override
  void dispose() {
    _url.dispose();
    _filter.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = context.mtl;
    final controller = ref.read(channelsControllerProvider);
    setState(() {
      _busy = true;
      _failure = null;
    });
    try {
      final String message;
      if (widget.editing case final sub?) {
        await controller.edit(
          sub,
          checkIntervalMinutes: _interval,
          titleRegex: _filter.text,
        );
        message = l10n.done;
      } else {
        final url = _url.text.trim();
        final filter = _filter.text.trim();
        final name = await controller.follow(
          url,
          quality: _quality,
          checkIntervalMinutes: _interval,
          titleRegex: filter.isEmpty ? null : filter,
        );
        // The name yt-dlp resolved shows the right channel was followed.
        message = l10n.subscriptionAdded(mtName(name ?? url));
      }
      if (!mounted) return;
      Navigator.of(context).pop();
      showMTNotice(context, message: message, kind: MTNoticeKind.done);
    } on Object catch (e) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _failure = e is AlreadyFollowedException
            ? l10n.alreadySubscribed
            : errorText(l10n, e);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.mtl;
    final p = MTThemeX.of(context).palette;
    final text = Theme.of(context).textTheme;
    final canSubmit = !_busy && (_isEdit || _url.text.trim().isNotEmpty);
    Widget label(String s) => Padding(
      padding: const EdgeInsets.only(top: MTSpace.lg, bottom: MTSpace.xs),
      child: Text(s, style: text.labelLarge?.copyWith(color: p.ink2)),
    );
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          MTSpace.pagePad,
          0,
          MTSpace.pagePad,
          MTSpace.xl,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.editing?.name ?? l10n.followChannel,
              style: text.titleLarge,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (!_isEdit) ...[
              const SizedBox(height: MTSpace.lg),
              TextField(
                controller: _url,
                enabled: !_busy,
                keyboardType: TextInputType.url,
                textDirection: TextDirection.ltr,
                decoration: InputDecoration(
                  labelText: l10n.channelUrl,
                  hintText: l10n.channelUrlHint,
                ),
                onChanged: (_) => setState(() {}),
              ),
            ],
            label(l10n.checkEvery),
            CaptionChoiceChips(
              labels: [
                for (final m in channelIntervals)
                  m < 60 ? l10n.every30Minutes : l10n.everyHours(m ~/ 60),
              ],
              chosen: channelIntervals.indexOf(_interval),
              onChosen: (i) => setState(() => _interval = channelIntervals[i]),
            ),
            if (!_isEdit) ...[
              label(l10n.subscriptionQuality),
              CaptionChoiceChips(
                labels: [for (final q in _qualities) qualityLabel(l10n, q)],
                chosen: _qualities.indexOf(_quality),
                onChosen: (i) => setState(() => _quality = _qualities[i]),
              ),
              const SizedBox(height: MTSpace.xs),
              Text(
                l10n.subscriptionQualityNote,
                style: text.bodySmall?.copyWith(color: p.ink3),
              ),
            ],
            const SizedBox(height: MTSpace.lg),
            TextField(
              controller: _filter,
              enabled: !_busy,
              decoration: InputDecoration(
                labelText: l10n.titleFilter,
                hintText: l10n.titleFilterHint,
                helperText: l10n.titleFilterHelper,
                helperMaxLines: 3,
              ),
            ),
            if (!_isEdit) ...[
              const SizedBox(height: MTSpace.md),
              Text(
                l10n.onlyNewVideos,
                style: text.bodySmall?.copyWith(color: p.ink3),
              ),
            ],
            if (_failure case final failure?) ...[
              const SizedBox(height: MTSpace.md),
              Text(failure, style: text.bodyMedium?.copyWith(color: p.err)),
            ],
            const SizedBox(height: MTSpace.lg),
            FilledButton(
              onPressed: canSubmit ? _submit : null,
              child: _busy
                  ? const MTSpinner(size: 18)
                  : Text(_isEdit ? l10n.saveSettings : l10n.follow),
            ),
          ],
        ),
      ),
    );
  }
}
