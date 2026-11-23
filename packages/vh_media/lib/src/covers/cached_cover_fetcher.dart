import 'dart:io' show HttpStatus;

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:vh_core/vh_core.dart';

/// Fetches an online cover through the cards' own cache: a picture the
/// cache still holds is used as it is, however old (it may be the last
/// copy left); otherwise it is downloaded, with whatever headers
/// [headersFor] gives that address.
CoverFetcher cachedCoverFetcher(
  BaseCacheManager cache,
  Map<String, String> Function(String url) headersFor,
) => (url) async {
  if (await cache.getFileFromCache(url) case final held?) {
    return FetchedCover.found(await held.file.readAsBytes());
  }
  try {
    final got = await cache.downloadFile(url, authHeaders: headersFor(url));
    return FetchedCover.found(await got.file.readAsBytes());
  } on HttpExceptionWithStatus catch (e) {
    return _goneStatuses.contains(e.statusCode)
        ? const FetchedCover.gone()
        : const FetchedCover.failed();
  } on Object {
    return const FetchedCover.failed();
  }
};

/// The answers that mean the address will never give the picture again.
///
/// **A refusal is one of them.** Facebook, Instagram and TikTok sign their
/// cover addresses for a few days and answer 403 once the signature has
/// run out. Read as "try again later", such a cover was asked for at every
/// launch and never replaced by a frame of the clip's own file; and a run
/// of them looked like the network being down, which ended the round
/// before it reached the covers that could still be kept.
const _goneStatuses = {
  HttpStatus.notFound,
  HttpStatus.gone,
  HttpStatus.unauthorized,
  HttpStatus.forbidden,
};

/// [cachedCoverFetcher] over the cache the cards use when they name none
/// (the phone app's), so a cover they showed is not fetched twice.
CoverFetcher defaultCoverFetcher(
  Map<String, String> Function(String url) headersFor,
) => cachedCoverFetcher(DefaultCacheManager(), headersFor);
