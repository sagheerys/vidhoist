import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vidhoist_mobile/features/home/clip_time_field.dart';

/// The clip's times are typed as digits alone (Samsung's number pad has
/// no colon); the colon is put in as they arrive.
void main() {
  const formatter = ClipTimeFormatter();

  String typed(String old, String now) => formatter
      .formatEditUpdate(
        TextEditingValue(text: old),
        TextEditingValue(text: now),
      )
      .text;

  test('the digits fill from the right, seconds first', () {
    expect(ClipTimeFormatter.format(''), '');
    expect(ClipTimeFormatter.format('1'), '0:01');
    expect(ClipTimeFormatter.format('13'), '0:13');
    expect(ClipTimeFormatter.format('130'), '1:30');
    expect(ClipTimeFormatter.format('1305'), '13:05');
    expect(ClipTimeFormatter.format('10305'), '1:03:05');
  });

  test('typing and deleting walk the digits in and out', () {
    expect(typed('', '1'), '0:01');
    expect(typed('0:01', '0:013'), '0:13');
    expect(typed('0:13', '0:130'), '1:30');
    expect(typed('1:30', '1:3'), '0:13');
    expect(typed('0:01', '0:0'), '');
  });

  test('Arabic-Indic digits, a pasted colon and stray letters', () {
    expect(typed('', '١٣٠'), '1:30');
    expect(typed('', '1:30'), '1:30');
    expect(typed('', 'soon'), '');
  });

  test('past six digits the last good time stays', () {
    expect(typed('99:59:59', '99:59:590'), '99:59:59');
  });

  test('the cursor stays at the end, where the next digit goes', () {
    final value = formatter.formatEditUpdate(
      TextEditingValue.empty,
      const TextEditingValue(text: '130'),
    );
    expect(value.selection, const TextSelection.collapsed(offset: 4));
  });
}
