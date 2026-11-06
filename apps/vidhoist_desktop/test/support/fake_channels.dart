import 'package:mt_core/mt_core.dart';
import 'package:vidhoist_desktop/data/channels_data.dart';

/// Followed channels kept in memory, recording what was asked of them as
/// the server's client once did, so the hidden Channels page keeps its
/// tests until the scheduler on this computer comes.
class FakeChannels implements ChannelSource {
  FakeChannels([List<ChannelSubscription> subscriptions = const []])
    : subscriptions = [...subscriptions];

  List<ChannelSubscription> subscriptions;

  /// What was asked of the channels, in order.
  final List<String> calls = [];

  /// Set to make the next follow fail with it.
  Object? followFailure;

  @override
  Future<List<ChannelSubscription>> list() async => [...subscriptions];

  @override
  Future<ChannelSubscription?> follow(
    String url,
    Quality quality, {
    required int checkIntervalMinutes,
    String? titleRegex,
    String? folder,
  }) async {
    calls.add(
      'follow $url ${quality.wire} $checkIntervalMinutes '
      '${titleRegex ?? '-'} folder=${folder ?? '-'}',
    );
    if (followFailure case final failure?) throw failure;
    final made = ChannelSubscription(
      id: 'new',
      name: 'Field Notes - Videos',
      url: url,
      enabled: true,
      checkIntervalMinutes: checkIntervalMinutes,
      quality: quality.wire,
      titleRegex: titleRegex,
    );
    subscriptions = [...subscriptions, made];
    return made;
  }

  @override
  Future<void> update(
    String id, {
    String? name,
    bool? enabled,
    int? checkIntervalMinutes,
    String? titleRegex,
    bool clearTitleRegex = false,
    String? folder,
  }) async {
    calls.add(
      'update $id name=${name ?? '-'} enabled=${enabled ?? '-'} '
      'every=${checkIntervalMinutes ?? '-'} filter=${titleRegex ?? '-'} '
      'clear=$clearTitleRegex folder=${folder ?? '-'}',
    );
    subscriptions = [
      for (final s in subscriptions)
        s.id == id ? s.copyWith(name: name, enabled: enabled) : s,
    ];
  }

  @override
  Future<void> unfollow(List<String> ids) async {
    calls.add('delete ${ids.join(',')}');
    subscriptions = [
      for (final s in subscriptions)
        if (!ids.contains(s.id)) s,
    ];
  }

  @override
  Future<void> check({List<String>? ids}) async =>
      calls.add('check ${ids?.join(',') ?? 'all'}');
}
