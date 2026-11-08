import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vh_ui/vh_ui.dart';

import 'icon_finder.dart';

// The phones' chrome in the ink (log §4, 2026-10-31): the accent is kept for
// the one action and for the data, and nothing sits in a tinted square.

const _variant = VhVariant.desktop;
final _p = VhPalette.of(_variant, Brightness.light);

Widget _host(Widget child, {bool desktop = false}) {
  final app = MaterialApp(
    theme: vhTheme(_variant, Brightness.light),
    localizationsDelegates: VhLocalizations.localizationsDelegates,
    supportedLocales: VhLocalizations.supportedLocales,
    home: Scaffold(body: Center(child: child)),
  );
  return desktop ? VhDesktopApp(child: app) : app;
}

/// Every box decoration painted under [root], with its colour and shadow.
Iterable<BoxDecoration> _boxes(WidgetTester tester, Finder root) => tester
    .widgetList<Container>(
      find.descendant(of: root, matching: find.byType(Container)),
    )
    .map((c) => c.decoration)
    .whereType<BoxDecoration>();

void main() {
  testWidgets('**the guard**: a settings row has a bare icon in the ink and '
      'is chosen with the ink\'s veil', (tester) async {
    await tester.pumpWidget(
      _host(
        VhSettingsRow(
          icon: VhIcons.sort,
          title: 'Playback',
          value: 'Best compatibility',
          selected: true,
          onTap: () {},
        ),
      ),
    );
    final row = find.byType(VhSettingsRow);
    expect(_boxes(tester, row).where((d) => d.color == _p.accentSoft), isEmpty);
    final icon = tester.widget<VhIcon>(byVhIcon(VhIcons.sort));
    expect(icon.color, _p.ink);
    final tile = tester.widget<ListTile>(find.byType(ListTile));
    expect(tile.selectedTileColor, vhSelectedFill(_p));
  });

  testWidgets('**the guard**: an empty state has no emblem, and its action '
      'is in the ink', (tester) async {
    await tester.pumpWidget(
      _host(
        VhEmptyState(
          title: 'Nothing here',
          message: 'Share a link to fill it.',
          actionLabel: 'Paste a link',
          onAction: () {},
        ),
      ),
    );
    final state = find.byType(VhEmptyState);
    expect(
      find.descendant(of: state, matching: find.byType(VhIcon)),
      findsNothing,
    );
    expect(
      _boxes(tester, state).where((d) => d.shape == BoxShape.circle),
      isEmpty,
    );
    expect(find.byType(FilledButton), findsNothing);
    expect(find.widgetWithText(TextButton, 'Paste a link'), findsOneWidget);
  });

  testWidgets('**the guard**: a download card is neutral; only its bar is in '
      'the accent', (tester) async {
    await tester.pumpWidget(
      _host(
        const VhDownloadProgressCard(
          title: 'Sourdough, week one',
          statusText: 'On the server',
          progress: 0.4,
        ),
      ),
    );
    final card = find.byType(VhDownloadProgressCard);
    final ground = _boxes(tester, card).first;
    expect(ground.color, _p.card);
    expect((ground.border! as Border).top.color, _p.line);
    final bar = tester.widget<LinearProgressIndicator>(
      find.byType(LinearProgressIndicator),
    );
    expect(
      (bar.valueColor! as AlwaysStoppedAnimation<Color?>).value,
      _p.accent,
    );
  });

  testWidgets('**the guard**: a failed download is marked by its sentence '
      'alone', (tester) async {
    await tester.pumpWidget(
      _host(
        const VhDownloadProgressCard(
          title: 'Slow coffee',
          statusText: 'Failed: the post is private',
          isError: true,
        ),
      ),
    );
    final card = find.byType(VhDownloadProgressCard);
    expect(_boxes(tester, card).first.color, _p.card);
    final status = tester.widget<Text>(
      find.text('Failed: the post is private'),
    );
    expect(status.style!.color, _p.err);
  });

  testWidgets('**the guard**: the add button casts a neutral shadow, not a '
      'glow, and its glyph stands alone', (tester) async {
    await tester.pumpWidget(_host(VhFab(label: 'Add link', onPressed: () {})));
    final fab = find.byType(VhFab);
    final boxes = _boxes(tester, fab).toList();
    expect(boxes.first.boxShadow, VhShadow.float);
    // The button's own ground is the only box: no tinted square inside it.
    expect(boxes.where((d) => d.color != null), hasLength(1));
  });

  for (final desktop in [false, true]) {
    testWidgets('**the guard**: a selected card is the ink\'s veil on the '
        'phone and keeps the accent\'s tint in Ember (desktop: $desktop)', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(
          const VhHighlightSurface(
            selected: true,
            highlighted: false,
            child: SizedBox(width: 10, height: 10),
          ),
          desktop: desktop,
        ),
      );
      final ground = tester.widget<Material>(
        find
            .descendant(
              of: find.byType(VhHighlightSurface),
              matching: find.byType(Material),
            )
            .first,
      );
      expect(ground.color, desktop ? _p.accentSoft : vhSelectedFill(_p));
    });
  }
}
