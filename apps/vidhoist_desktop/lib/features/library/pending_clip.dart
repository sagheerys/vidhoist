import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_media/library.dart';
import 'package:vh_ui/vh_ui.dart';

import '../../data/downloads_data.dart';
import '../../data/library_data.dart';
import '../add/links_view.dart';
import '../downloads/downloads_panel.dart';
import 'artwork.dart';

/// Clips on their way into the library: every download not cancelled and
/// not arrived, in the engine's order, so the one being fetched leads.
///
/// A finished one leaves as the library reloads, which the engine asks
/// for the moment it finishes; one the library already holds is not shown
/// twice.
final pendingClipsProvider = Provider<List<DownloadTask>>((ref) {
  final tasks = ref.watch(engineTasksProvider).valueOrNull ?? const [];
  final held = {
    for (final item
        in ref.watch(libraryItemsProvider).valueOrNull ?? const <LibraryItem>[])
      item.canonicalUrl,
  };
  return [
    for (final task in tasks)
      if (task.phase != TaskPhase.cancelled &&
          task.phase != TaskPhase.completed &&
          !held.contains(task.canonicalUrl))
        task,
  ];
});

/// What a clip on its way is called: its title once the site has given
/// it, and before that its site ("YouTube", or the address's host) rather
/// than a whole link set in bold where a title belongs.
String pendingName(DownloadTask task) {
  if (task.title case final title? when title.trim().isNotEmpty) return title;
  final url = task.effectiveUrl;
  final platform = MediaPlatform.detect(url);
  if (platform != MediaPlatform.other) return platform.label;
  final host = Uri.tryParse(url)?.host ?? '';
  return host.isEmpty ? url : host.replaceFirst(RegExp(r'^www\.'), '');
}

/// **A clip being downloaded stands in the library at once**, where it
/// will stay: its cover held back, a line of its progress under it, and
/// what is happening to it in place of its channel and age. Before, it was
/// only in the downloads list behind a button, and the library said
/// nothing until the file was whole.
///
/// It is drawn by the library's own cards, so it takes the same room in
/// every layout. A click opens the downloads, where it can be paused,
/// retried or cancelled; it has nothing to play yet.
class PendingClipView extends ConsumerWidget {
  const PendingClipView({
    super.key,
    required this.task,
    required this.mode,
    required this.columns,
  });

  final DownloadTask task;
  final LibraryViewMode mode;

  /// Set for a row of the table.
  final VhMediaColumns? columns;

  static const double _gridCell = 210;
  static const double _compactWidth = 64;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.vhl;
    final title = vhName(pendingName(task));
    final status = taskLine(l, task);
    // The amount, where the clip's length will be once it has arrived.
    final amount = task.phase == TaskPhase.downloading && task.hasKnownProgress
        ? vhLtrRun('${(task.progress * 100).floor()}%')
        : null;
    void open() => unawaited(showDownloadsPanel(context));
    Widget cover(double width, double height) =>
        _HeldCover(task: task, width: width, height: height);

    if (columns case final columns?) {
      return VhMediaRow(
        columns: columns,
        title: title,
        subtitle: status,
        thumbnail: cover(VhMediaColumns.thumbWidth, VhMediaColumns.thumbHeight),
        duration: amount,
        onTap: open,
      );
    }
    if (mode == LibraryViewMode.grid) {
      return VhMediaGridCard(
        title: title,
        subtitle: status,
        thumbnail: cover(_gridCell, _gridCell * 9 / 16),
        duration: amount,
        onTap: open,
      );
    }
    return VhMediaCard(
      compact: true,
      title: title,
      subtitle: status,
      thumbnail: cover(_compactWidth, _compactWidth * 10 / 16),
      duration: amount,
      onTap: open,
    );
  }
}

/// The cover the preview found, faded while the file is not whole, with
/// the progress along its foot: a filled line while the amount is known,
/// the sliding strip while it is not, nothing while it waits or failed.
class _HeldCover extends ConsumerWidget {
  const _HeldCover({
    required this.task,
    required this.width,
    required this.height,
  });

  final DownloadTask task;
  final double width;
  final double height;

  static const double _line = 3;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = VhThemeX.of(context).palette;
    final art = artworkFor(
      ref,
      context,
      task.thumbnail,
      width: width,
      height: height,
    );
    final moving = switch (task.phase) {
      TaskPhase.downloading || TaskPhase.paused => true,
      TaskPhase.preparing || TaskPhase.postprocessing => true,
      _ => false,
    };
    return Stack(
      fit: StackFit.expand,
      children: [
        ColoredBox(color: p.cardAlt),
        if (art != null) Opacity(opacity: 0.4, child: art),
        if (moving)
          PositionedDirectional(
            start: 0,
            end: 0,
            bottom: 0,
            child: task.hasKnownProgress
                ? Container(
                    height: _line,
                    color: p.line2,
                    alignment: AlignmentDirectional.centerStart,
                    child: FractionallySizedBox(
                      widthFactor: task.progress.clamp(0, 1),
                      child: ColoredBox(color: p.accent),
                    ),
                  )
                : const VhFilmStrip(),
          ),
      ],
    );
  }
}
