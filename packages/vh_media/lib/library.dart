/// The unified library of the Windows app: the merged item, its filters
/// and views, and how it is built.
///
/// **A separate entry, not part of `vh_media.dart`**: the phone app keeps
/// its own library of local files with enums of the same names (`LibrarySort`,
/// `LibraryViewMode`, `MediaTypeFilter`), and exporting these through the
/// main entry would make every one of them ambiguous there.
library;

export 'src/library/arrival_origin.dart';
export 'src/library/channel_match.dart';
export 'src/library/library_merge.dart';
export 'src/library/library_models.dart';
export 'src/library/library_stats.dart';
export 'src/library/library_view_options.dart';
export 'src/library/platform_kind.dart';
export 'src/library/subscription_checks.dart';
