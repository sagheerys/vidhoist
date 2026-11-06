import 'package:mt_ytdlp/mt_ytdlp.dart';
import 'package:test/test.dart';

void main() {
  test('what yt-dlp --version prints', () {
    final v = EngineVersion.tryParse('2026.10.26\n')!;
    expect(v.toString(), '2026.10.26');
    expect(v.date, DateTime.utc(2026, 10, 26));
    expect(v.build, 0);
  });

  test('a nightly build and a single-digit month', () {
    final v = EngineVersion.tryParse('stable@2025.1.5.232 from yt-dlp')!;
    expect(v.toString(), '2025.01.05.232');
    expect(v.build, 232);
  });

  test('nothing that looks like a version', () {
    expect(EngineVersion.tryParse(null), isNull);
    expect(EngineVersion.tryParse(''), isNull);
    expect(EngineVersion.tryParse('yt-dlp: not found'), isNull);
    expect(EngineVersion.tryParse('2026.13.01'), isNull);
    expect(EngineVersion.tryParse('2026.12.00'), isNull);
  });

  test('ordered by date, then build', () {
    final a = EngineVersion.tryParse('2025.11.12')!;
    final b = EngineVersion.tryParse('2026.10.26')!;
    final c = EngineVersion.tryParse('2026.10.26.1')!;
    expect(a < b, isTrue);
    expect(b < c, isTrue);
    expect(c.compareTo(b), greaterThan(0));
    expect([c, a, b]..sort(), [a, b, c]);
    expect(b, EngineVersion.tryParse('2026.10.26'));
    expect(b.hashCode, EngineVersion.tryParse('2026.10.26').hashCode);
    expect(b == c, isFalse);
  });

  test("the Android library's own build was a year old", () {
    final bundled = EngineVersion.tryParse('2025.11.12')!;
    final now = DateTime.utc(2026, 11, 6);
    expect(bundled.ageInDays(now), 359);
    expect(bundled.isStale(now), isTrue);
    expect(EngineVersion.tryParse('2026.10.26')!.isStale(now), isFalse);
    expect(EngineVersion.tryParse('2026.10.26')!.isStale(now, days: 5), isTrue);
  });

  test('the helpers print their version first', () {
    expect(
      toolVersion('ffmpeg version 7.1.1 Copyright (c) 2000-2025'),
      '7.1.1',
    );
    expect(
      toolVersion('deno 2.9.8 (stable, release, x86_64-pc-windows-msvc)'),
      '2.9.8',
    );
    expect(toolVersion('QuickJS version 2025-04-26'), isNull);
    expect(toolVersion(null), isNull);
  });
}
