import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:vidhoist_mobile/features/channels/channel_art.dart';

/// **A channel's pictures kept on the phone**: they showed only while
/// online, so they stay on the device, go on unfollow, and come back on a
/// new follow.
void main() {
  late Directory root;
  late List<Uri> fetched;
  late bool offline;

  setUp(() async {
    root = await Directory.systemTemp.createTemp('vh_art');
    fetched = [];
    offline = false;
  });
  tearDown(() => root.delete(recursive: true));

  ChannelArt art() => ChannelArt(
    root: () async => root.path,
    fetch: (uri) async {
      if (offline) throw const SocketException('no network');
      fetched.add(uri);
      return uri.toString().codeUnits;
    },
  );

  const a1 = 'https://img.test/avatar-1';
  const a2 = 'https://img.test/avatar-2';

  test('fetched once, then read from the phone, offline too', () async {
    final first = await art().file('UC_x', ChannelArtKind.avatar, a1);
    expect(await first!.readAsString(), a1);
    offline = true;
    final again = await art().file('UC_x', ChannelArtKind.avatar, a1);
    expect(await again!.readAsString(), a1);
    expect(fetched, hasLength(1), reason: 'not fetched at every visit');
  });

  test('a new picture replaces the old; failing, the old one stays', () async {
    final old = await art().file('UC_x', ChannelArtKind.avatar, a1);
    offline = true;
    final kept = await art().file('UC_x', ChannelArtKind.avatar, a2);
    expect(await kept!.readAsString(), a1, reason: 'offline: the one kept');
    offline = false;
    final fresh = await art().file('UC_x', ChannelArtKind.avatar, a2);
    expect(await fresh!.readAsString(), a2);
    expect(await old!.exists(), isFalse, reason: 'one picture each');
  });

  test('never fetched and offline: none, and no error', () async {
    offline = true;
    expect(await art().file('UC_x', ChannelArtKind.banner, a1), isNull);
    expect(await art().file('UC_x', ChannelArtKind.banner, null), isNull);
  });

  test('the avatar and the banner are kept apart', () async {
    await art().file('UC_x', ChannelArtKind.avatar, a1);
    expect(await art().file('UC_x', ChannelArtKind.banner, null), isNull);
  });

  test('unfollowing forgets them; following again fetches anew', () async {
    await art().file('UC_x', ChannelArtKind.avatar, a1);
    await art().forget('UC_x');
    expect(Directory('${root.path}/channel_art/UC_x').existsSync(), isFalse);
    await art().file('UC_x', ChannelArtKind.avatar, a1);
    expect(fetched, hasLength(2));
  });

  test('a channel id with a slash stays inside its folder', () async {
    final file = await art().file('a/../b', ChannelArtKind.avatar, a1);
    expect(file!.path, startsWith('${root.path}/channel_art/'));
    expect(file.parent.parent.path, '${root.path}/channel_art');
  });
}
