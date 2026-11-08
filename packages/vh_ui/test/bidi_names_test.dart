import 'package:flutter_test/flutter_test.dart';
import 'package:vh_ui/vh_ui.dart';

/// **A name the app did not write, inside a sentence it did**: an Arabic
/// channel name before "· 5 minutes ago" came apart, and so did the
/// "Unfollow …?" dialog.
///
/// The interface has one direction and the name has its own. Where the two
/// meet, the characters between them — the separator, the question mark,
/// the brackets — belong to neither until something says so. `vhName` says
/// so, by isolating the name and taking its direction from its own first
/// strong character.
void main() {
  const arabicChannel = 'قناة جديدة';
  const latinChannel = 'Veritasium';

  group('vhName', () {
    test('it wraps a name in a first-strong isolate, whatever its '
        'language', () {
      for (final name in [arabicChannel, latinChannel, '日本語', '#وسم']) {
        final wrapped = vhName(name);
        expect(wrapped.startsWith(vhFirstStrongIsolate), isTrue, reason: name);
        expect(wrapped.endsWith(vhPopIsolate), isTrue, reason: name);
        expect(
          wrapped.substring(1, wrapped.length - 1),
          name,
          reason: 'ولا يغيّر الاسم نفسه بحرف',
        );
      }
    });

    test('an empty or missing name stays empty: an isolate around nothing '
        'is two invisible characters that break an isEmpty check further '
        'down', () {
      expect(vhName(null), '');
      expect(vhName(''), '');
    });

    test('it is not the LTR run, which is for clocks and fractions: that '
        'one would force an Arabic channel to read left to right', () {
      expect(vhName(arabicChannel).startsWith(vhLtrIsolate), isFalse);
      expect(vhLtrRun('2 / 40').startsWith(vhLtrIsolate), isTrue);
    });
  });

  group('vhMetaLine', () {
    test('every part is isolated, and the separator belongs to the '
        'sentence', () {
      final line = vhMetaLine([arabicChannel, '5 minutes ago']);
      expect(line, '${vhName(arabicChannel)} · ${vhName("5 minutes ago")}');
      // The separator itself is outside both isolates, which is what lets
      // the interface's direction place it.
      expect(line.contains('$vhPopIsolate · $vhFirstStrongIsolate'), isTrue);
    });

    test('and the reverse pairing, which is the same defect seen from the '
        'Arabic interface', () {
      final line = vhMetaLine([latinChannel, 'منذ ٥ دقائق']);
      expect(line.contains('$vhPopIsolate · $vhFirstStrongIsolate'), isTrue);
    });

    test('a missing part is dropped rather than leaving a stray '
        'separator', () {
      expect(vhMetaLine([arabicChannel, null]), vhName(arabicChannel));
      expect(vhMetaLine([null, '']), '');
      expect(
        vhMetaLine([null, latinChannel, '', 'x']),
        '${vhName(latinChannel)} · ${vhName("x")}',
      );
    });

    test('one part alone carries no separator at all', () {
      expect(vhMetaLine([latinChannel]).contains('·'), isFalse);
    });
  });
}
