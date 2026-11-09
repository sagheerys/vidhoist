import 'dart:convert';
import 'dart:typed_data';

/// The few DER shapes a self-signed certificate needs, written by hand so
/// that the link to the computer adds no dependency: a certificate is a
/// tree of tag-length-value triples and nothing more.
abstract final class Der {
  static Uint8List _tlv(int tag, List<int> value) {
    final n = value.length;
    final length = n < 0x80
        ? [n]
        : n < 0x100
        ? [0x81, n]
        : n < 0x10000
        ? [0x82, n >> 8, n & 0xff]
        : [0x83, n >> 16, (n >> 8) & 0xff, n & 0xff];
    return Uint8List.fromList([tag, ...length, ...value]);
  }

  static Uint8List sequence(List<List<int>> items) =>
      _tlv(0x30, [for (final item in items) ...item]);

  static Uint8List set(List<List<int>> items) =>
      _tlv(0x31, [for (final item in items) ...item]);

  /// A non-negative integer, with the leading zero DER wants when the top
  /// bit is set, so that it never reads as negative.
  static Uint8List integer(BigInt value) {
    var bytes = _unsigned(value);
    if (bytes.isEmpty) bytes = [0];
    if (bytes.first & 0x80 != 0) bytes = [0, ...bytes];
    return _tlv(0x02, bytes);
  }

  static Uint8List smallInt(int value) => integer(BigInt.from(value));

  static Uint8List octets(List<int> value) => _tlv(0x04, value);

  /// A bit string with no unused bits, as keys and signatures are.
  static Uint8List bits(List<int> value) => _tlv(0x03, [0, ...value]);

  static Uint8List utf8String(String value) => _tlv(0x0c, utf8.encode(value));

  /// UTCTime, `YYMMDDHHMMSSZ`, good for dates up to 2049.
  static Uint8List utcTime(DateTime when) {
    final t = when.toUtc();
    String two(int v) => v.toString().padLeft(2, '0');
    final text =
        '${two(t.year % 100)}${two(t.month)}${two(t.day)}'
        '${two(t.hour)}${two(t.minute)}${two(t.second)}Z';
    return _tlv(0x17, ascii.encode(text));
  }

  static Uint8List oid(List<int> arcs) {
    final out = <int>[40 * arcs[0] + arcs[1]];
    for (final arc in arcs.skip(2)) {
      final chunk = <int>[arc & 0x7f];
      var rest = arc >> 7;
      while (rest > 0) {
        chunk.insert(0, (rest & 0x7f) | 0x80);
        rest >>= 7;
      }
      out.addAll(chunk);
    }
    return _tlv(0x06, out);
  }

  /// `[n] EXPLICIT`, a context tag wrapping one element.
  static Uint8List explicit(int n, List<int> inner) => _tlv(0xa0 | n, inner);

  /// [value] as exactly [length] big-endian bytes.
  static Uint8List fixed(BigInt value, int length) {
    final bytes = _unsigned(value);
    return Uint8List(length)..setRange(length - bytes.length, length, bytes);
  }

  static List<int> _unsigned(BigInt value) {
    final out = <int>[];
    var rest = value;
    while (rest > BigInt.zero) {
      out.insert(0, (rest & BigInt.from(0xff)).toInt());
      rest >>= 8;
    }
    return out;
  }

  /// [der] wrapped as PEM under [label].
  static String pem(String label, List<int> der) {
    final body = base64.encode(der);
    final lines = [
      for (var i = 0; i < body.length; i += 64)
        body.substring(i, i + 64 > body.length ? body.length : i + 64),
    ];
    return '-----BEGIN $label-----\n${lines.join('\n')}\n-----END $label-----\n';
  }
}
