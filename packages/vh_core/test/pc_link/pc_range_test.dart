import 'package:test/test.dart';
import 'package:vh_core/vh_core.dart';

void main() {
  PcByteRange? part(String? header, [int length = 1000]) =>
      switch (pcRangeOf(header, length)) {
        PcPartOfFile(:final range) => range,
        _ => null,
      };

  test('the three forms a player sends', () {
    expect(part('bytes=0-499'), const PcByteRange(0, 499));
    expect(part('bytes=500-'), const PcByteRange(500, 999));
    expect(part('bytes=-200'), const PcByteRange(800, 999));
  });

  test('an end past the file stops at its last byte', () {
    expect(part('bytes=900-5000'), const PcByteRange(900, 999));
    expect(part('bytes=-5000'), const PcByteRange(0, 999));
  });

  test('a start past the end cannot be answered', () {
    expect(pcRangeOf('bytes=1000-', 1000), isA<PcRangeUnsatisfiable>());
    expect(pcRangeOf('bytes=-0', 1000), isA<PcRangeUnsatisfiable>());
    expect(pcRangeOf('bytes=0-', 0), isA<PcRangeUnsatisfiable>());
  });

  test('anything else is the whole file', () {
    for (final header in [
      null,
      '',
      'bytes=-',
      'bytes=0-10,20-30',
      'items=0-10',
      'bytes=500-400',
    ]) {
      expect(pcRangeOf(header, 1000), isA<PcWholeFile>(), reason: header);
    }
  });

  test('the content range names the file size', () {
    expect(const PcByteRange(10, 19).contentRange(100), 'bytes 10-19/100');
    expect(const PcByteRange(10, 19).length, 10);
  });

  test('a player is told the media type by extension', () {
    expect(pcMediaType('MP4'), 'video/mp4');
    expect(pcMediaType('m4a'), 'audio/mp4');
    expect(pcMediaType('webm'), 'video/webm');
    expect(pcMediaType('exe'), 'application/octet-stream');
  });
}
