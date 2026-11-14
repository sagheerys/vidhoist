/// yt-dlp as the apps use it, without running it.
///
/// What goes in (the command line) and what comes out (progress, the
/// finished file, the info JSON, the error) are plain text, so this package
/// is plain Dart and is tested on what yt-dlp really printed
/// (`test/fixtures/`). Starting the process is each app's own business:
/// `Process` on Windows, the youtubedl-android library on Android.
library;

export 'src/channel_feed.dart';
export 'src/clip_range.dart';
export 'src/command_builder.dart';
export 'src/engine_version.dart';
export 'src/error_classifier.dart';
export 'src/format_selector.dart';
export 'src/info_json.dart';
export 'src/progress_parser.dart';
export 'src/progress_tracker.dart';
export 'src/subtitle_languages.dart';
