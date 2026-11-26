import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_media/vh_media.dart' show vhFormatDuration;
import 'package:vh_ui/vh_ui.dart';

import '../downloads_library/library_providers.dart';
import '../shared/error_text.dart';
import 'pc_copy.dart';
import 'pc_errors.dart';
import 'pc_link_state.dart';
import 'pc_lists.dart';
import 'pc_pairing_store.dart';
import 'pc_stream.dart';

/// The links of the computer's clips that are copied to this phone.
final pcOnPhoneProvider = Provider<Set<String>>(
  (ref) => {
    for (final local in ref.watch(localMediaProvider).valueOrNull ?? const [])
      ?local.canonicalUrl,
  },
);

/// A clip in the computer's library. A tap plays it from the computer, as
/// a clip of the phone's own plays; its menu copies it to the phone, or,
/// where the user allowed it, puts it in the computer's Recycle Bin.
class PcItemRow extends ConsumerWidget {
  const PcItemRow({super.key, required this.item, required this.items});

  final PcItem item;

  /// The list it is shown in, the queue a tap plays.
  final List<PcItem> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.vhl;
    final copy = ref.watch(pcCopiesProvider)[item.id];
    final onPhone = ref.watch(pcOnPhoneProvider).contains(item.url);
    return VhMediaCard(
      title: item.title,
      subtitle: switch (copy) {
        PcCopy(:final progress?) => l10n.pcCopying((progress * 100).round()),
        PcCopy() => l10n.pcCopyStarting,
        null => vhMetaLine([
          if (onPhone) l10n.pcOnPhone,
          if (item.added case final at?) vhTimeAgo(context, at),
          if (item.sizeBytes case final size?) vhFormatSize(size),
        ]),
      },
      duration: item.duration == null ? null : vhFormatDuration(item.duration!),
      audio: item.isAudio,
      thumbnail: PcThumb(
        url: item.thumbnail,
        coverId: item.hasCover ? item.id : null,
      ),
      onTap: () => unawaited(_play(context, ref)),
      onMore: () => unawaited(_actions(context, ref, onPhone: onPhone)),
    );
  }

  Future<void> _play(BuildContext context, WidgetRef ref) async {
    try {
      await playFromPc(context, ref, items, item);
    } on Object catch (e) {
      if (context.mounted) showVhSnack(context, errorText(context.vhl, e));
    }
  }

  Future<void> _actions(
    BuildContext context,
    WidgetRef ref, {
    required bool onPhone,
  }) async {
    final l10n = context.vhl;
    final copying = ref.read(pcCopiesProvider).containsKey(item.id);
    // Offered only where the user allowed it on the computer, which asks
    // again before it deletes.
    final canDelete = ref.read(pcViewProvider).status?.canDelete ?? false;
    final danger = VhThemeX.of(context).palette.err;
    final chosen = await showVhSheet<_Action>(
      context: context,
      useSafeArea: true,
      showDragHandle: true,
      builder: (sheet) {
        Widget tile(_Action action, VhIconData icon, String label) => ListTile(
          leading: VhIcon(icon),
          title: Text(label),
          enabled: !(action == _Action.copy && onPhone),
          onTap: () => Navigator.of(sheet).pop(action),
        );
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(
                item.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(sheet).textTheme.titleSmall,
              ),
            ),
            tile(
              _Action.play,
              VhIcons.play,
              item.isAudio ? l10n.pcListen : l10n.pcWatch,
            ),
            if (copying)
              tile(_Action.stop, VhIcons.close, l10n.pcCopyStop)
            else
              tile(
                _Action.copy,
                onPhone ? VhIcons.check : VhIcons.download,
                onPhone ? l10n.pcOnPhone : l10n.pcCopyToPhone,
              ),
            if (canDelete)
              ListTile(
                leading: VhIcon(VhIcons.trash, color: danger),
                title: Text(l10n.pcDelete, style: TextStyle(color: danger)),
                onTap: () => Navigator.of(sheet).pop(_Action.delete),
              ),
            SizedBox(height: vhSheetBottomPad(sheet, VhSpace.md)),
          ],
        );
      },
    );
    if (chosen == null || !context.mounted) return;
    switch (chosen) {
      case _Action.play:
        await _play(context, ref);
      case _Action.stop:
        ref.read(pcCopiesProvider.notifier).stop(item.id);
      case _Action.copy:
        final end = await ref.read(pcCopiesProvider.notifier).copy(item);
        if (!context.mounted) return;
        switch (end) {
          case PcCopyEnd.copied:
            showVhSnack(context, l10n.pcCopied);
          case PcCopyEnd.failed:
            showVhSnack(context, l10n.pcCopyFailed);
          case PcCopyEnd.stopped:
            break;
        }
      case _Action.delete:
        await _delete(context, ref);
    }
  }

  /// Asks first, naming the computer and saying where the clip goes, then
  /// says what became of it.
  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final l10n = context.vhl;
    final name =
        ref.read(pcViewProvider).status?.name ??
        ref.read(pcPairingProvider)?.name ??
        l10n.pcTab;
    final sure = await showVhConfirm(
      context,
      title: l10n.pcDeleteTitle(name),
      message: l10n.pcDeleteBody(item.title),
      confirmLabel: l10n.delete,
      cancelLabel: l10n.cancel,
      destructive: true,
      preview: VhDialogClip(
        title: item.title,
        thumbnail: PcThumb(
          url: item.thumbnail,
          coverId: item.hasCover ? item.id : null,
        ),
      ),
    );
    if (!sure || !context.mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    final outcome = await ref.read(pcViewProvider.notifier).delete(item.id);
    if (!context.mounted) return;
    if (outcome == PcDeleteOutcome.deleted) forgetPcLists(ref);
    showVhSnackOn(
      messenger,
      switch (outcome) {
        PcDeleteOutcome.deleted => l10n.pcDeleted(item.title),
        PcDeleteOutcome.notAllowed => l10n.pcDeleteNotAllowed,
        PcDeleteOutcome.missing => l10n.pcDeleteMissing,
        PcDeleteOutcome.noRecycleBin => l10n.pcDeleteNoBin,
        PcDeleteOutcome.failed => l10n.pcDeleteFailed,
        null => pcFailureText(
          l10n,
          ref.read(pcViewProvider).failure ?? PcLinkFailure.unreachable,
        ),
      },
      type: outcome == PcDeleteOutcome.deleted
          ? VhSnackType.success
          : VhSnackType.error,
    );
  }
}

enum _Action { play, copy, stop, delete }

/// A web thumbnail, or a cover the computer keeps, fetched through the link
/// and held for this run.
class PcThumb extends ConsumerWidget {
  const PcThumb({super.key, this.url, this.coverId});

  final String? url;
  final String? coverId;

  static final _covers = <String, Future<Uint8List?>>{};

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = VhThemeX.of(context).palette;
    final blank = ColoredBox(color: p.cardAlt);
    if (url case final url?) {
      return Image.network(
        url,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => blank,
      );
    }
    final client = ref.watch(pcClientProvider);
    if (coverId == null || client == null) return blank;
    final bytes = _covers.putIfAbsent(
      coverId!,
      () => client.cover(coverId!).catchError((Object _) => null),
    );
    return FutureBuilder(
      future: bytes,
      builder: (context, snap) => switch (snap.data) {
        final data? => Image.memory(
          data,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => blank,
        ),
        null => blank,
      },
    );
  }
}
