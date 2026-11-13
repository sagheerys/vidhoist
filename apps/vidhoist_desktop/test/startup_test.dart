import 'package:flutter_test/flutter_test.dart';
import 'package:vidhoist_desktop/platform/startup.dart';

/// The start-up list runs a command line, not a file name: a path with a
/// space in it, left bare, starts the part before the space instead.
void main() {
  test('**the guard**: the start-up entry names the program in quotes', () {
    const exe = 'C:\\Users\\Sam Lee\\AppData\\Local\\VidHoist\\vidhoist.exe';
    final program = WindowsStartup.program(exe);
    expect(program, '"$exe"');
    // The whole command the list keeps: the quoted program, then its flag.
    expect('$program ${WindowsStartup.arg}', '"$exe" --startup');
  });
}
