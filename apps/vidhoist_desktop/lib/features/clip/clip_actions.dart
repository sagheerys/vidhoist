import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_media/library.dart';

import '../../shell/open_web_link.dart';

import '../../data/clip_delete.dart';
import '../../data/library_data.dart';

/// What can be done to one clip, as the phone's item actions do it, with
/// this computer's indexes.
class ClipActions {
  ClipActions(this._ref);

  final Ref _ref;

  Future<void> toggleFavorite(String canonicalUrl) async {
    await _ref
        .read(tagsIndexProvider)
        .toggleTag(canonicalUrl, VhConstants.favoritesSystemTag);
    _ref.invalidate(libraryItemsProvider);
  }

  /// The clip on its own site, in the browser.
  Future<void> openOriginal(String canonicalUrl) => openWebLink(canonicalUrl);

  /// Deletes [item]'s file to the Recycle Bin, and what was kept about it;
  /// see [deleteClipFile]. A refusal throws for the caller to say.
  Future<void> deleteFile(LibraryItem item) => deleteClipFile(_ref, item);
}

final clipActionsProvider = Provider((ref) => ClipActions(ref));
