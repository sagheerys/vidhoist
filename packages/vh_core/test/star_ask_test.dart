import 'package:test/test.dart';
import 'package:vh_core/vh_core.dart';

/// The star question: after the third finished download, at most twice,
/// and never after a star or "Don't show this again".
void main() {
  late StarAsk ask;
  late DateTime today;

  setUp(() {
    today = DateTime(2027, 1, 1);
    ask = StarAsk(MemoryKeyValueStore(), now: () => today);
  });

  Future<void> finish(int n) async {
    for (var i = 0; i < n; i++) {
      await ask.countFinished();
    }
  }

  test('**the guard**: not before the third finished download', () async {
    await finish(2);
    expect(await ask.isDue(), isFalse);
    await finish(1);
    expect(await ask.isDue(), isTrue);
  });

  test('**the guard**: "Maybe later" asks once more, twenty downloads and '
      'thirty days on, then never', () async {
    await finish(3);
    await ask.shown();
    expect(await ask.isDue(), isFalse);
    today = today.add(const Duration(days: 30));
    await finish(19);
    expect(await ask.isDue(), isFalse);
    await finish(1);
    expect(await ask.isDue(), isTrue);
    await ask.shown();
    await finish(100);
    expect(await ask.isDue(), isFalse);
  });

  test('**the guard**: twenty downloads in a day do not bring it back '
      'before thirty days', () async {
    await finish(3);
    await ask.shown();
    await finish(40);
    today = today.add(const Duration(days: 29));
    expect(await ask.isDue(), isFalse);
    today = today.add(const Duration(days: 1));
    expect(await ask.isDue(), isTrue);
  });

  test('a star or "Don\'t show this again" ends it', () async {
    await finish(3);
    await ask.end();
    expect(await ask.isDue(), isFalse);
  });

  test('the pages are the repository\'s', () {
    expect(StarAsk.repoUrl, 'https://github.com/sagheerys/vidhoist');
    expect(StarAsk.ideasUrl, startsWith(StarAsk.repoUrl));
  });
}
