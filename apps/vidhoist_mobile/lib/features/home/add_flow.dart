import '../pc/pc_destination.dart';
import '../pc/pc_link_state.dart';
import '../pc/pc_outbox.dart';
import '../pc/pc_pairing_store.dart';
import '../pc/pc_send.dart';

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';

import '../../di.dart';
import '../shared/error_text.dart';
import 'link_preview_view.dart';

/// Converts the core's platform into its presentation type, since vh_ui
/// does not know vh_core.
VhPlatformKind platformKindOf(MediaPlatform platform) => switch (platform) {
  MediaPlatform.youtube => VhPlatformKind.youtube,
  MediaPlatform.tiktok => VhPlatformKind.tiktok,
  MediaPlatform.instagram => VhPlatformKind.instagram,
  MediaPlatform.soundcloud => VhPlatformKind.soundcloud,
  MediaPlatform.x => VhPlatformKind.x,
  MediaPlatform.facebook => VhPlatformKind.facebook,
  MediaPlatform.vimeo => VhPlatformKind.vimeo,
  MediaPlatform.twitch => VhPlatformKind.twitch,
  MediaPlatform.reddit => VhPlatformKind.reddit,
  MediaPlatform.dailymotion => VhPlatformKind.dailymotion,
  MediaPlatform.other => VhPlatformKind.other,
};

/// The add dialog plus automatic routing: a playlist goes to `/batch`, a
/// single link goes straight to the engine (rule 2).
Future<void> openAddSheet(
  BuildContext context,
  WidgetRef ref, {
  String? initialUrl,
}) async {
  final l10n = context.vhl;
  final logger = ref.read(loggerProvider);
  final opened = DateTime.now();
  unawaited(logger.log('add sheet shown', tag: 'share'));
  final submitted = await showVhSheet<bool>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    // The router and the messenger are captured **before** the sheet opens:
    // using them through the sheet's context after `Navigator.pop` queries
    // a deactivated element.
    builder: (sheetContext) => _AddSheet(
      initialUrl: initialUrl,
      l10n: l10n,
      router: GoRouter.of(context),
      messenger: ScaffoldMessenger.of(context),
    ),
  );
  // How it closed, and when: a sheet gone within a second that nobody
  // touched was closed by something else.
  final open = DateTime.now().difference(opened).inMilliseconds;
  unawaited(
    logger.log(
      'add sheet ${submitted ?? false ? 'submitted' : 'dismissed'} '
      'after ${open}ms',
      tag: 'share',
    ),
  );
}

class _AddSheet extends ConsumerStatefulWidget {
  const _AddSheet({
    required this.initialUrl,
    required this.l10n,
    required this.router,
    required this.messenger,
  });

  final String? initialUrl;
  final VhLocalizations l10n;

  /// Captured from the hosting screen's context, so they stay valid after
  /// the sheet closes.
  final GoRouter router;
  final ScaffoldMessengerState messenger;

  @override
  ConsumerState<_AddSheet> createState() => _AddSheetState();
}

class _AddSheetState extends ConsumerState<_AddSheet> {
  /// **The sheet owns its controller and disposes it itself.** Disposing it
  /// in `openAddSheet` after `await showModalBottomSheet` happened **during
  /// the closing animation** while the field was still being rebuilt,
  /// giving "TextEditingController used after being disposed" and then a
  /// red screen (`_dependents.isEmpty`). `dispose` here only runs once the
  /// route is genuinely gone.
  late final TextEditingController _controller = TextEditingController(
    text: UrlKit.extractUrl(widget.initialUrl ?? ''),
  );
  late String _quality = ref.read(settingsProvider).quality.wire;
  late String _url = _controller.text;

  /// The paired computer was asked (null until it answers or fails), and
  /// whether it answered: offered either way, away it takes the link later.
  bool? _pcReachable;
  late var _toPc = ref.read(sendToPcProvider);

  @override
  void initState() {
    super.initState();
    if (ref.read(pcPairingProvider) == null) return;
    unawaited(_lookForPc());
  }

  Future<void> _lookForPc() async {
    final reachable = await ref.read(pcViewProvider.notifier).probe();
    if (!mounted) return;
    setState(() => _pcReachable = reachable);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = widget.l10n;
    final platform = MediaPlatform.detect(_url);
    // The quality rule: heights for every platform but an audio-only one;
    // outside YouTube the engine falls back to best if the site has none.
    final qualities = [
      VhQualityOption(value: 'best', label: l10n.qualityBest),
      if (!platform.isAudioOnly) ...[
        VhQualityOption(value: '1080', label: l10n.quality1080),
        VhQualityOption(value: '720', label: l10n.quality720),
        VhQualityOption(value: '480', label: l10n.quality480),
        // Phone only: a phone keeps what it downloads, so small files count.
        VhQualityOption(value: '360', label: l10n.quality360),
      ],
      VhQualityOption(value: 'audio', label: l10n.audioOnly),
    ];
    if (!qualities.any((q) => q.value == _quality)) _quality = 'best';
    final pc = ref.watch(pcPairingProvider);
    final showPc = pc != null && _pcReachable != null && offerPc(ref, _url);
    final toPc = showPc && _toPc;

    return VhUrlInputSheet(
      title: l10n.addUrl,
      urlHint: l10n.pasteUrlHint,
      controller: _controller,
      onUrlChanged: (value) => setState(() => _url = value),
      preview: linkPreviewFor(ref, _url),
      platform: platformKindOf(platform),
      platformLabel: platform == MediaPlatform.other ? null : platform.label,
      qualities: qualities,
      selectedQuality: _quality,
      onQualitySelected: (value) => setState(() => _quality = value),
      extra: showPc
          ? PcDestination(
              pcName: pc.name,
              toPc: _toPc,
              away: _pcReachable == false,
              onChanged: (value) {
                setState(() => _toPc = value);
                unawaited(ref.read(sendToPcProvider.notifier).set(value));
              },
            )
          : null,
      startLabel: toPc ? l10n.pcSendToPc : l10n.startDownload,
      onStart: () => unawaited(_submit(toPc: toPc)),
    );
  }

  Future<void> _submit({bool toPc = false}) async {
    final l10n = widget.l10n;
    final input = UrlKit.extractUrl(_controller.text);
    if (!input.startsWith('http')) {
      showVhSnack(context, l10n.invalidUrl, type: VhSnackType.error);
      return;
    }
    Navigator.pop(context, true);

    // **The decision is made on the final URL, not the entered one** (field
    // report 2026-09-08): `on.soundcloud.com/…` is an album with no
    // `/sets/`, so it counted as a single clip and all twenty downloaded
    // with no selection screen. For links that are not short,
    // `needsResolution` returns false immediately, so there is no delay at
    // all.
    final url = await ref
        .read(shortLinkResolverProvider)
        .resolveForRouting(input);
    if (!mounted) return;

    // A playlist URL opens the batch screen.
    if (PlaylistDetector.isPlaylist(url)) {
      widget.router.push('/batch', extra: url);
      return;
    }
    if (toPc) {
      await _sendToPc(url);
      return;
    }
    final engine = ref.read(downloadEngineProvider);
    if (engine == null) {
      showVhSnackOn(
        widget.messenger,
        l10n.noServerTitle,
        type: VhSnackType.error,
      );
      return;
    }
    engine.submit(url, Quality.fromWire(_quality));
    showVhSnackOn(
      widget.messenger,
      l10n.downloadStarted,
      type: VhSnackType.success,
    );
  }
}

extension on _AddSheetState {
  /// Queues [url] on the paired computer rather than on this phone; away,
  /// it waits here for it.
  Future<void> _sendToPc(String url) async {
    final result = await sendLinksToPc(
      view: ref.read(pcViewProvider.notifier),
      outbox: ref.read(pcOutboxProvider.notifier),
      urls: [url],
      quality: _quality,
      away: _pcReachable != true,
    );
    showPcSendResult(
      widget.messenger,
      widget.l10n,
      result,
      ref.read(pcPairingProvider)?.name ?? '',
    );
  }
}

/// The error text for a failed task, used by the cards and the sheets.
String taskErrorText(VhLocalizations l10n, DownloadTask task) =>
    task.error == null ? l10n.failed : errorText(l10n, task.error!);
