import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vidhoist_mobile/di.dart';
import 'package:vidhoist_mobile/features/downloads_library/artwork_view.dart';
import 'package:vidhoist_mobile/features/downloads_library/library_providers.dart';
import 'package:vidhoist_mobile/features/downloads_library/local_item.dart';
import 'package:vh_core/vh_core.dart';

/// The guard for the fourth view mode (requested 2026-09-08).
void main() {
  late MemoryKeyValueStore store;

  setUp(() => store = MemoryKeyValueStore());

  Future<LibraryViewOptions> restored() async {
    final c = ProviderContainer(
      overrides: [
        keyValueStoreProvider.overrideWithValue(store),
        prefsMutexProvider.overrideWithValue(PrefsMutex()),
      ],
    );
    addTearDown(c.dispose);
    c.read(libraryViewProvider);
    await pumpEventQueue();
    return c.read(libraryViewProvider);
  }

  test('nothing saved means the list', () async {
    expect((await restored()).mode, LibraryViewMode.list);
  });

  /// **The guard**: someone updating the app while on grid must find it as
  /// they left it.
  test('migrating from the two old keys', () async {
    await store.setBool('library_grid_view', true);
    expect((await restored()).mode, LibraryViewMode.grid);
  });

  test('the new key beats both old ones', () async {
    await store.setBool('library_grid_view', true);
    await store.setString('library_view_mode', 'cards');
    final options = await restored();
    expect(options.cards, isTrue);
    expect(options.grid, isFalse);
  });

  testWidgets('the decode width rises with the height when cover demands it', (
    tester,
  ) async {
    late BuildContext ctx;
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(devicePixelRatio: 2),
        child: Builder(
          builder: (c) {
            ctx = c;
            return const SizedBox();
          },
        ),
      ),
    );
    expect(vhDecodeWidth(ctx, 98, 62), (62 * 16 / 9 * 2).ceil());
    expect(vhDecodeWidth(ctx, 210), 420);
  });
}
