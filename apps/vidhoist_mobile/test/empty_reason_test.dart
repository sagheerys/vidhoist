import 'package:flutter_test/flutter_test.dart';
import 'package:vidhoist_mobile/features/downloads_library/library_providers.dart';
import 'package:vidhoist_mobile/features/downloads_library/local_item.dart';
import 'package:vh_core/vh_core.dart';

/// **An empty list says why it is empty**: the library screen
/// tells "nothing matches these filters" from "no downloads yet" by
/// [LibraryViewOptions.narrowed].
void main() {
  test('**the guard**: no filter is not narrowed; a search alone is not', () {
    expect(const LibraryViewOptions().narrowed, isFalse);
    expect(const LibraryViewOptions(query: 'coffee').narrowed, isFalse);
  });

  test(
    '**the guard**: favourites, a type or a platform narrow the library',
    () {
      expect(
        const LibraryViewOptions(scope: LocalScope.favorites).narrowed,
        isTrue,
      );
      expect(
        const LibraryViewOptions(type: MediaTypeFilter.audio).narrowed,
        isTrue,
      );
      expect(
        const LibraryViewOptions(platform: MediaPlatform.youtube).narrowed,
        isTrue,
      );
    },
  );
}
