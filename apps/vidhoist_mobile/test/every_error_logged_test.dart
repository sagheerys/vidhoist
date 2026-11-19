import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vidhoist_mobile/features/shared/error_report.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';

/// The log held in memory, so the test needs no disk.
class _Lines extends VhLogger {
  _Lines() : super(filePath: '');

  final lines = <String>[];

  @override
  Future<void> log(
    String message, {
    LogLevel level = LogLevel.info,
    String? tag,
  }) async => lines.add(message);
}

/// Every error that shows, and every error
/// nobody caught, is in the diagnostic log.
void main() {
  testWidgets('error snack bars and framework errors reach the log', (
    tester,
  ) async {
    final testHandler = FlutterError.onError;
    // Kept from the test framework, which would fail the test on the
    // error raised on purpose below.
    FlutterError.onError = (_) {};
    final logger = _Lines();
    logEveryError(logger);
    addTearDown(() {
      FlutterError.onError = testHandler;
      vhErrorSnackLog = null;
    });

    late BuildContext context;
    await tester.pumpWidget(
      MaterialApp(
        theme: vhTheme(VhVariant.desktop, Brightness.light),
        home: Scaffold(
          body: Builder(
            builder: (c) {
              context = c;
              return const SizedBox();
            },
          ),
        ),
      ),
    );
    showVhSnack(context, 'could not delete', type: VhSnackType.error);
    FlutterError.reportError(
      FlutterErrorDetails(exception: StateError('broken layout')),
    );
    await tester.pump();

    expect(logger.lines, contains('shown: could not delete'));
    expect(logger.lines.any((l) => l.contains('broken layout')), isTrue);
  });
}
