import 'package:vh_ytdlp/vh_ytdlp.dart';
import 'package:test/test.dart';

import 'fixtures.dart';

List<ProgressLine> progressOf(String run) =>
    fixture('$run.stdout.txt')
        .split('\n')
        .map(YtDlpLine.parse)
        .whereType<ProgressLine>()
        .toList();

ProgressLine line(String status, int downloaded, int? total) =>
    ProgressLine(status: status, downloaded: downloaded, total: total);

void main() {
  test('a merged 1080p download, picture then sound, never goes back', () {
    final lines = progressOf('yt-1080-js');
    final tracker = ProgressTracker();
    final seen = [for (final l in lines) tracker.add(l)];
    for (var i = 1; i < seen.length; i++) {
      expect(seen[i].fraction, greaterThanOrEqualTo(seen[i - 1].fraction));
    }
    expect(seen.last.fraction, 1);
    expect(seen.last.part, 2);
    expect(seen.last.downloadedBytes, 124386876 + 30767611);
  });

  test('announced parts weight the bar by bytes', () {
    final tracker = ProgressTracker()..expectParts(const PartsLine([900, 100]));
    expect(tracker.add(line('downloading', 450, 900)).fraction, 0.45);
    expect(tracker.add(line('finished', 900, 900)).fraction, 0.9);
    final sound = tracker.add(line('downloading', 50, 100));
    expect(sound.fraction, closeTo(0.95, 1e-9));
    expect(sound.part, 2);
    expect(sound.totalBytes, 1000);
    expect(tracker.add(line('finished', 100, 100)).fraction, 1);
  });

  test('an exact size replaces the announced estimate for its part', () {
    final tracker = ProgressTracker()
      ..expectParts(const PartsLine([1000, 100]));
    final p = tracker.add(line('downloading', 400, 800));
    expect(p.totalBytes, 900);
    expect(p.fraction, closeTo(400 / 900, 1e-9));
  });

  test('while a size is unknown each part counts the same', () {
    final tracker = ProgressTracker(partSizes: [null, null]);
    expect(
      tracker
          .add(const ProgressLine(status: 'downloading', downloaded: 5))
          .fraction,
      0,
    );
    expect(tracker.add(line('downloading', 5, 10)).fraction, 0.25);
    expect(tracker.add(line('finished', 10, 10)).fraction, 0.5);
    // Both sizes known now: bytes decide, (10 + 3) of 16.
    expect(tracker.add(line('downloading', 3, 6)).fraction, 13 / 16);
  });

  test('an unexpected part widens the count but the bar holds', () {
    final tracker = ProgressTracker();
    expect(tracker.add(line('downloading', 50, 100)).fraction, 0.5);
    expect(tracker.add(line('finished', 100, 100)).fraction, 1);
    final next = tracker.add(line('downloading', 10, 100));
    expect(next.part, 2);
    expect(next.fraction, 1);
  });

  test('counting from zero without a finished line is a new part', () {
    final tracker = ProgressTracker(partSizes: [100, 100]);
    tracker.add(line('downloading', 80, 100));
    final next = tracker.add(line('downloading', 10, 100));
    expect(next.part, 2);
    expect(next.downloadedBytes, 90);
    expect(next.fraction, closeTo(0.45, 1e-9));
  });

  test('speed and time left come from the current part', () {
    final p = ProgressTracker().add(
      const ProgressLine(
        status: 'downloading',
        downloaded: 1,
        total: 2,
        speed: 3.5,
        eta: 7,
      ),
    );
    expect(p.speed, 3.5);
    expect(p.eta, 7);
  });

  test('a stream already on disk prints finished alone', () {
    final tracker = ProgressTracker(partSizes: [100, 50]);
    expect(
      tracker.add(line('finished', 100, 100)).fraction,
      closeTo(100 / 150, 1e-9),
    );
    expect(tracker.add(line('finished', 50, 50)).fraction, 1);
  });
}
