import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';

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
