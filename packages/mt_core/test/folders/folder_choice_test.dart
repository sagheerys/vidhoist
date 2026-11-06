import 'package:mt_core/mt_core.dart';
import 'package:test/test.dart';

void main() {
  group('FolderChoice', () {
    test('the top is no folder; the channel is named once resolved', () {
      expect(FolderChoice.top.isTop, isTrue);
      expect(FolderChoice.channel.isTop, isFalse);
      expect(const FolderChoice('Ai').isTop, isFalse);
    });
  });

  group('pickableFolders', () {
    test("the library's folders, parents first, tree order", () {
      expect(pickableFolders(['Tech Ai 1', 'Ai/Old', 'Games', 'Ai/Lessons']), [
        'Ai',
        'Ai/Lessons',
        'Ai/Old',
        'Games',
        'Tech Ai 1',
      ]);
      expect(pickableFolders(const []), isEmpty);
    });
  });

  group('channelFolderName', () {
    test('one folder, whatever the name holds', () {
      expect(channelFolderName('AC/DC'), 'AC-DC');
      expect(channelFolderName(r'Back\Slash'), 'Back-Slash');
      expect(channelFolderName('  ..  '), '');
      expect(channelFolderName('قناة'), 'قناة');
    });
  });
}
