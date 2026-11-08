import '../models/channel_subscription.dart';
import '../models/quality.dart';

/// Where followed channels are kept and checked: on this device
/// ([LocalChannelSource]), since there is no server to do it.
abstract interface class ChannelSource {
  Future<List<ChannelSubscription>> list();

  /// Returns the channel as resolved, so its own title can be shown.
  /// Throws [AlreadyFollowedException] for a channel followed already.
  Future<ChannelSubscription?> follow(
    String url,
    Quality quality, {
    required int checkIntervalMinutes,
    String? titleRegex,
    String? folder,
  });

  /// Null leaves a field as it is; [clearTitleRegex] empties the filter.
  Future<void> update(
    String id, {
    String? name,
    bool? enabled,
    int? checkIntervalMinutes,
    String? titleRegex,
    bool clearTitleRegex = false,
    String? folder,
  });

  Future<void> unfollow(List<String> ids);

  /// Looks for new clips now; null [ids] checks them all.
  Future<void> check({List<String>? ids});
}

/// A channel followed twice: the dialog names it rather than failing.
class AlreadyFollowedException implements Exception {
  const AlreadyFollowedException();
}
