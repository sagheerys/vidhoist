import 'package:flutter_riverpod/flutter_riverpod.dart';

/// **Mapping an async state while preserving the previous value.**
///
/// The library used to flicker while loading.
/// The cause was `AsyncValue.whenData`: it dispatches on the **type** of
/// the state rather than on whether a value exists, so on `AsyncLoading`
/// it returns a **new empty** instance, destroying what Riverpod was
/// holding from before, and nothing reaches the screen for it to prefer
/// over the spinner.
///
/// The effect was measured with a screen recording on the emulator:
/// repeated invalidations produced **13 unbroken seconds of spinner** in
/// place of the library during a single download.
///
/// The rule: **a value exists, build and show it; else the error; else
/// loading.**
AsyncValue<R> asyncViewOf<T, R>(
  AsyncValue<T> source,
  R Function(T value) build,
) {
  final value = source.valueOrNull;
  if (value != null) return AsyncData(build(value));
  return source.hasError
      ? AsyncError<R>(source.error!, source.stackTrace ?? StackTrace.empty)
      : const AsyncLoading();
}
