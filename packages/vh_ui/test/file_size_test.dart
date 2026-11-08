import 'package:flutter_test/flutter_test.dart';
import 'package:vh_ui/vh_ui.dart';

/// **A file size as people read it** (field report 2026-09-26: a 3 GB
/// video read "3000 MB"). The sizes are real files.
void main() {
  const mb = 1024 * 1024;
  const gb = 1024 * mb;

  String plain(int bytes) => String.fromCharCodes(
    vhFormatSize(bytes).runes.where((r) => r < 0x2066 || r > 0x2069),
  );

  test('a 3 GB video reads in gigabytes, not as 3000 MB', () {
    expect(plain(3 * gb), '3.0 GB');
    expect(plain(797000000), '760.1 MB');
  });

  test('from a thousand megabytes it is gigabytes: never "1023.9 MB"', () {
    expect(plain(999 * mb), '999.0 MB');
    expect(plain(1000 * mb), '1.0 GB');
    expect(plain(1023 * mb), '1.0 GB');
  });

  test('small files keep megabytes with one decimal', () {
    expect(plain(13900000), '13.3 MB');
    expect(plain(200000), '0.2 MB');
  });

  test('direction-isolated, so an Arabic line cannot reorder it', () {
    expect(vhFormatSize(3 * gb), vhLtrRun('3.0 GB'));
  });
}
