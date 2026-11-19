import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_core/vh_core.dart';

import 'pc_link_state.dart';

/// The computer's library as the Computer page lists it: what was searched,
/// in what order and of what kind, and the clips loaded so far.
class PcBrowse {
  const PcBrowse({
    this.query = '',
    this.sort = PcLibrarySort.newest,
    this.kind = PcLibraryKind.all,
    this.items = const [],
    this.total = 0,
    this.loading = false,
    this.loadingMore = false,
    this.failed = false,
  });

  final String query;
  final PcLibrarySort sort;
  final PcLibraryKind kind;
  final List<PcItem> items;
  final int total;

  /// A new search or order is on its way; the clips shown are the last
  /// answer's until it arrives, so the list never empties and refills.
  final bool loading;
  final bool loadingMore;

  /// The computer did not answer the last search.
  final bool failed;

  /// The library as it opens: newest first, everything, nothing searched.
  /// Its first page is the one the page already keeps and caches.
  bool get isDefault =>
      query.trim().isEmpty &&
      sort == PcLibrarySort.newest &&
      kind == PcLibraryKind.all;

  bool get hasMore => items.length < total;

  PcBrowse copyWith({
    String? query,
    PcLibrarySort? sort,
    PcLibraryKind? kind,
    List<PcItem>? items,
    int? total,
    bool? loading,
    bool? loadingMore,
    bool? failed,
  }) => PcBrowse(
    query: query ?? this.query,
    sort: sort ?? this.sort,
    kind: kind ?? this.kind,
    items: items ?? this.items,
    total: total ?? this.total,
    loading: loading ?? this.loading,
    loadingMore: loadingMore ?? this.loadingMore,
    failed: failed ?? this.failed,
  );
}

final pcBrowseProvider = NotifierProvider<PcBrowseNotifier, PcBrowse>(
  PcBrowseNotifier.new,
);

/// Asks the computer for its library a page at a time. Before this the
/// phone read the newest 200 clips once, and a larger library's other
/// clips could not be reached from the phone at all.
class PcBrowseNotifier extends Notifier<PcBrowse> {
  /// How many clips one request asks for.
  static const page = 100;

  /// How long typing must pause before the computer is asked: one request
  /// for a word, not one for every letter of it.
  static const pause = Duration(milliseconds: 350);

  Timer? _typing;

  /// Counts the requests, so an answer that arrives after a newer request
  /// was made is dropped rather than shown over it.
  var _asked = 0;

  /// The pages loaded past the first in the default listing, whose first
  /// page follows the page's own refreshes.
  var _more = const <PcItem>[];

  @override
  PcBrowse build() {
    ref.onDispose(() => _typing?.cancel());
    ref.listen(pcViewProvider, (_, view) {
      if (state.isDefault) state = _withFirstPage(state, view);
    });
    return _withFirstPage(const PcBrowse(), ref.read(pcViewProvider));
  }

  PcBrowse _withFirstPage(PcBrowse browse, PcView view) {
    final first = {for (final item in view.items) item.id};
    return browse.copyWith(
      // A clip downloaded since moves the rest down a place: a page loaded
      // before may then repeat one, which is dropped here.
      items: [...view.items, ..._more.where((i) => !first.contains(i.id))],
      total: view.total,
      loading: false,
      failed: false,
    );
  }

  /// What is typed; the computer is asked once typing pauses.
  void search(String query) {
    state = state.copyWith(query: query);
    _typing?.cancel();
    _typing = Timer(pause, () => unawaited(_reload()));
  }

  void order({PcLibrarySort? sort, PcLibraryKind? kind}) {
    state = state.copyWith(sort: sort, kind: kind);
    _typing?.cancel();
    unawaited(_reload());
  }

  Future<void> _reload() async {
    final asked = ++_asked;
    _more = const [];
    if (state.isDefault) {
      state = _withFirstPage(state, ref.read(pcViewProvider));
      return;
    }
    state = state.copyWith(loading: true, failed: false);
    final page = await _fetch(0);
    if (asked != _asked) return;
    state = page == null
        ? state.copyWith(loading: false, failed: true)
        : state.copyWith(items: page.items, total: page.total, loading: false);
  }

  /// The next page, when the list is scrolled near its end.
  Future<void> loadMore() async {
    if (state.loading || state.loadingMore || !state.hasMore) return;
    final asked = _asked;
    state = state.copyWith(loadingMore: true);
    final page = await _fetch(state.items.length);
    if (asked != _asked) return;
    if (page == null) {
      state = state.copyWith(loadingMore: false);
      return;
    }
    final known = {for (final item in state.items) item.id};
    final fresh = page.items.where((i) => !known.contains(i.id)).toList();
    if (state.isDefault) _more = [..._more, ...fresh];
    final items = [...state.items, ...fresh];
    state = state.copyWith(
      items: items,
      // A page that brings nothing new ends the list, whatever total the
      // computer claims, or every scroll would ask again.
      total: fresh.isEmpty ? items.length : page.total,
      loadingMore: false,
    );
  }

  Future<PcLibraryPage?> _fetch(int offset) async {
    final client = ref.read(pcClientProvider);
    if (client == null) return null;
    try {
      return await client.library(
        offset: offset,
        limit: page,
        query: state.query.trim(),
        sort: state.sort,
        kind: state.kind,
      );
    } on PcLinkException {
      return null;
    }
  }
}
