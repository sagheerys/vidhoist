import 'package:flutter/widgets.dart';
import 'package:vh_media/library.dart';
import 'package:super_drag_and_drop/super_drag_and_drop.dart';

import '../data/clip_handover.dart';

/// Carried by every drag that starts in this window, so the window's own
/// drop target lets it pass instead of offering to add it as a link.
const desktopDragMark = 'vidhoist-clip';

/// A clip dragged to Explorer or the desktop becomes its file; one whose
/// file is gone does not start a drag.
class ClipDragSource extends StatelessWidget {
  const ClipDragSource({
    super.key,
    required this.item,
    required this.handover,
    required this.child,
  });

  final LibraryItem item;
  final ClipHandover handover;
  final Widget child;

  Future<DragItem?> _provide(DragItemRequest _) async {
    final path = handover.localFile(item);
    if (path == null) return null;
    final name = path.substring(path.lastIndexOf(r'\') + 1);
    return DragItem(suggestedName: name, localData: desktopDragMark)
      ..add(Formats.fileUri(Uri.file(path, windows: true)));
  }

  @override
  Widget build(BuildContext context) => DragItemWidget(
    allowedOperations: () => const [DropOperation.copy],
    dragItemProvider: _provide,
    child: DraggableWidget(child: child),
  );
}
