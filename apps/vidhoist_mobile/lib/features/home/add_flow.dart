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

import 'package:vh_media/vh_media.dart' show ClipFields;

import 'clip_length.dart';
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
/// single link goes straight to the engine.
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

  /// Only a stretch ([ClipFields]); its times show what is wrong only
  /// once a download was asked for.
  var _clipOn = false;
  var _clipErrors = false;
  final _clipFrom = TextEditingController();
  final _clipTo = TextEditingController();

  /// The link whose length is read: the one in the field once it has
  /// stopped changing, so typing a link letter by letter starts no probe
  /// per letter.
  late var _settled = UrlKit.extractUrl(_url);
  Timer? _settle;

  /// Start was pressed while the length was still read.
  var _waiting = false;

  @override
  void initState() {
    super.initState();
    if (UrlKit.needsResolution(_url)) unawaited(_follow(_url));
    if (ref.read(pcPairingProvider) == null) return;
    unawaited(_lookForPc());
  }

  /// A shared short link opens the sheet at once and is followed here,
  /// so the preview and the download see where it leads; a link the user
  /// changed meanwhile is theirs.
  Future<void> _follow(String asked) async {
    final url = await ref
        .read(shortLinkResolverProvider)
        .resolveForRouting(asked);
    if (!mounted || url == asked || _controller.text != asked) return;
    _controller.text = url;
    setState(() => _url = _settled = url);
  }

  void _changed(String value) {
    setState(() => _url = value);
    _settle?.cancel();
    _settle = Timer(
      settleTime,
      () => setState(() => _settled = UrlKit.extractUrl(value)),
    );
  }

  Future<void> _lookForPc() async {
    final reachable = await ref.read(pcViewProvider.notifier).probe();
    if (!mounted) return;
    setState(() => _pcReachable = reachable);
  }

  @override
  void dispose() {
    _settle?.cancel();
    _controller.dispose();
    _clipFrom.dispose();
    _clipTo.dispose();
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
    final link = UrlKit.extractUrl(_url);
    // A stretch wanted is read at once: the link is no longer being typed.
    final length =
        !toPc && (link == _settled || _clipOn) && readsLength(link, _clipOn)
        ? ref.watch(clipLengthProvider(link))
        : null;

    return VhUrlInputSheet(
      title: l10n.addUrl,
      urlHint: l10n.pasteUrlHint,
      controller: _controller,
      onUrlChanged: _changed,
      preview: linkPreviewFor(ref, _url),
      platform: platformKindOf(platform),
      platformLabel: platform == MediaPlatform.other ? null : platform.label,
      qualities: qualities,
      selectedQuality: _quality,
      onQualitySelected: (value) => setState(() => _quality = value),
      extra: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (showPc)
            PcDestination(
              pcName: pc.name,
              toPc: _toPc,
              away: _pcReachable == false,
              onChanged: (value) {
                setState(() => _toPc = value);
                unawaited(ref.read(sendToPcProvider.notifier).set(value));
              },
            ),
          // The computer is told a link and a quality, nothing more: a
          // stretch sent there would come back whole.
          if (!toPc)
            ClipFields(
              on: _clipOn,
              onChanged: (on) => setState(() => _clipOn = on),
              from: _clipFrom,
              to: _clipTo,
              showErrors: _clipErrors,
              length: length?.valueOrNull,
              readingLength: length?.isLoading ?? false,
              lengthUnknown:
                  length is AsyncData<Duration?> && length.value == null,
            ),
        ],
      ),
      startLabel: toPc ? l10n.pcSendToPc : l10n.startDownload,
      onStart: () => unawaited(_submit(toPc: toPc)),
    );
  }

  /// The stretch typed, checked against the length: Start pressed while
  /// it is still read waits for it, a probe the download then starts from.
  /// Past [lengthWait] the times go unchecked, and the download cuts the
  /// end itself ([DownloadTask.withProbe]).
  Future<ClipRange?> _readClip(String url) async {
    _settle?.cancel();
    setState(() {
      _settled = url;
      _waiting = true;
    });
    // The engine, not the provider: it hands back the reading the sheet
    // already started rather than a second one.
    final engine = ref.read(downloadEngineProvider);
    final length = await engine
        ?.lengthOf(url)
        .timeout(lengthWait, onTimeout: () => null);
    if (mounted) setState(() => _waiting = false);
    return ClipFields.read(_clipFrom, _clipTo, length: length);
  }

  Future<void> _submit({bool toPc = false}) async {
    final l10n = widget.l10n;
    final input = UrlKit.extractUrl(_controller.text);
    if (_waiting) return;
    if (!input.startsWith('http')) {
      showVhSnack(context, l10n.invalidUrl, type: VhSnackType.error);
      return;
    }
    final clip = _clipOn && !toPc ? await _readClip(input) : null;
    if (!mounted) return;
    if (_clipOn && !toPc && clip == null) {
      setState(() => _clipErrors = true);
      return;
    }
    Navigator.pop(context, true);

    // **The decision is made on the final URL, not the entered one**:
    // `on.soundcloud.com/…` is an album with no
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
    engine.submit(url, Quality.fromWire(_quality), clip: clip);
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
