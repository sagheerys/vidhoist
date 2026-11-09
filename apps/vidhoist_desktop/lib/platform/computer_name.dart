import 'dart:io';

/// This computer's name, as a paired phone shows it.
String computerName() {
  try {
    return Platform.localHostname;
  } on Object {
    return 'PC';
  }
}
