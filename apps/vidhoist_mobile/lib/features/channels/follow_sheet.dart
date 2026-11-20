import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';

import '../../di.dart';
import '../background/background_tile.dart';
import '../home/quick_download.dart';
import '../shared/choice_chip_row.dart';
import '../shared/error_text.dart';
import 'channel_card.dart';
import 'channels_state.dart';

/// Follows a channel, or with [editing] changes how often it is read, the
/// quality of what it downloads from now on, and its title filter.
/// A new follow, once the sheet has closed, may offer the check while the
/// app is closed.
Future<void> showFollowSheet(
  BuildContext context, {
  ChannelSubscription? editing,
}) async {
  final followed = await showVhSheet<bool>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (_) => _FollowSheet(editing: editing),
  );
  if (followed == true && context.mounted) {
    await offerBackgroundChecks(context);
  }
}

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
  late Quality _quality = switch (widget.editing?.quality) {
    final wire? => Quality.fromWire(wire),
    null => ref.read(settingsProvider).quality,
  };
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
    final l10n = context.vhl;
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
          quality: _quality,
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
        message = l10n.subscriptionAdded(vhName(name ?? url));
      }
      if (!mounted) return;
      Navigator.of(context).pop(!_isEdit);
      showVhNotice(context, message: message, kind: VhNoticeKind.done);
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
    final l10n = context.vhl;
    final p = VhThemeX.of(context).palette;
    final text = Theme.of(context).textTheme;
    final canSubmit = !_busy && (_isEdit || _url.text.trim().isNotEmpty);
    Widget label(String s) => Padding(
      padding: const EdgeInsets.only(top: VhSpace.lg, bottom: VhSpace.xs),
      child: Text(s, style: text.labelLarge?.copyWith(color: p.ink2)),
    );
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          VhSpace.pagePad,
          0,
          VhSpace.pagePad,
          VhSpace.xl,
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
              const SizedBox(height: VhSpace.lg),
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
            ChoiceChipRow(
              labels: [
                for (final m in channelIntervals) channelIntervalLabel(l10n, m),
              ],
              chosen: channelIntervals.indexOf(_interval),
              onChosen: (i) => setState(() => _interval = channelIntervals[i]),
            ),
            label(l10n.subscriptionQuality),
            ChoiceChipRow(
              labels: [for (final q in _qualities) qualityLabel(l10n, q)],
              chosen: _qualities.indexOf(_quality),
              onChosen: (i) => setState(() => _quality = _qualities[i]),
            ),
            const SizedBox(height: VhSpace.xs),
            Text(
              l10n.subscriptionQualityNote,
              style: text.bodySmall?.copyWith(color: p.ink3),
            ),
            const SizedBox(height: VhSpace.lg),
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
              const SizedBox(height: VhSpace.md),
              Text(
                l10n.onlyNewVideos,
                style: text.bodySmall?.copyWith(color: p.ink3),
              ),
            ],
            if (_failure case final failure?) ...[
              const SizedBox(height: VhSpace.md),
              Text(failure, style: text.bodyMedium?.copyWith(color: p.err)),
            ],
            const SizedBox(height: VhSpace.lg),
            FilledButton(
              onPressed: canSubmit ? _submit : null,
              child: _busy
                  ? const VhSpinner(size: 18)
                  : Text(_isEdit ? l10n.saveSettings : l10n.follow),
            ),
          ],
        ),
      ),
    );
  }
}
