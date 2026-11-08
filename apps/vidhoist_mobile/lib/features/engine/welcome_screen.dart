import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vh_ui/vh_ui.dart';

import '../../di.dart';
import 'engine_preparer.dart';

/// Where a first run goes, and where nobody goes once it is done: the
/// welcome screen readies the engine before anything can be downloaded.
String? welcomeRedirect({required bool welcomed, required String location}) {
  final onWelcome = location == '/welcome';
  if (!welcomed) return onWelcome ? null : '/welcome';
  return onWelcome ? '/' : null;
}

/// The welcome screen was completed in this run: the app is freshly
/// installed, the one moment to offer restoring an earlier backup.
final welcomedThisRunProvider = StateProvider<bool>((ref) => false);

/// The first run, in place of the server setup: the engine is unpacked
/// and yt-dlp updated in the background, each step shown, then the person
/// goes in (`docs/ENGINE.md` findings 11 and 12). A failed update does not
/// keep them out; the engine tries again before the first download.
class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key, this.onEntered});

  /// Instead of going to the library, for a test.
  final VoidCallback? onEntered;

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _prepare());
  }

  /// A failure shows on the screen through the status; nothing to catch
  /// beyond that.
  void _prepare() => unawaited(
    ref.read(enginePreparerProvider).ensure().catchError((Object _) {}),
  );

  Future<void> _enter() async {
    await ref.read(settingsProvider.notifier).setWelcomed();
    if (!mounted) return;
    ref.read(welcomedThisRunProvider.notifier).state = true;
    if (widget.onEntered case final entered?) {
      entered();
    } else {
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.vhl;
    final p = VhThemeX.of(context).palette;
    final text = Theme.of(context).textTheme;
    final status =
        ref.watch(engineStatusProvider).valueOrNull ??
        ref.read(enginePreparerProvider).status;
    final stage = status.stage;
    final failed = stage == EngineStage.failed;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(VhSpace.xl),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(VhRadius.card),
                      child: Image.asset(
                        'assets/icons/icon.png',
                        width: 72,
                        height: 72,
                        cacheWidth: 216,
                      ),
                    ),
                  ),
                  const SizedBox(height: VhSpace.lg),
                  Text(
                    l10n.mobileWelcomeTitle,
                    textAlign: TextAlign.center,
                    style: text.headlineSmall,
                  ),
                  const SizedBox(height: VhSpace.sm),
                  Text(
                    l10n.mobileWelcomeBody,
                    textAlign: TextAlign.center,
                    style: text.bodyMedium!.copyWith(color: p.ink2),
                  ),
                  const SizedBox(height: VhSpace.xxl),
                  _Step(
                    label: l10n.mobileWelcomeUnpacking,
                    state: switch (stage) {
                      EngineStage.idle || EngineStage.unpacking => _Mark.busy,
                      EngineStage.failed => _Mark.failed,
                      _ => _Mark.done,
                    },
                  ),
                  _Step(
                    label: l10n.mobileWelcomeUpdating,
                    state: switch (stage) {
                      EngineStage.updating => _Mark.busy,
                      EngineStage.ready when status.updateFailed => _Mark.warn,
                      EngineStage.ready => _Mark.done,
                      _ => _Mark.waiting,
                    },
                    note: stage == EngineStage.ready && status.updateFailed
                        ? l10n.mobileWelcomeUpdateFailed
                        : null,
                  ),
                  if (failed) ...[
                    const SizedBox(height: VhSpace.md),
                    Text(
                      l10n.mobileWelcomeFailed,
                      style: text.bodyMedium!.copyWith(color: p.err),
                    ),
                    const SizedBox(height: VhSpace.md),
                    OutlinedButton(
                      onPressed: _prepare,
                      child: Text(l10n.retry),
                    ),
                  ],
                  const SizedBox(height: VhSpace.xl),
                  FilledButton(
                    onPressed: stage == EngineStage.ready ? _enter : null,
                    child: Text(l10n.mobileWelcomeStart),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum _Mark { waiting, busy, done, warn, failed }

/// One step of the readying: what it is, and how far it got.
class _Step extends StatelessWidget {
  const _Step({required this.label, required this.state, this.note});

  final String label;
  final _Mark state;
  final String? note;

  @override
  Widget build(BuildContext context) {
    final p = VhThemeX.of(context).palette;
    final text = Theme.of(context).textTheme;
    final mark = switch (state) {
      _Mark.waiting => Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(color: p.line2, shape: BoxShape.circle),
      ),
      _Mark.busy => const VhSpinner(size: 18),
      _Mark.done => VhDrawnCheck(color: p.ok, size: 20),
      _Mark.warn => VhIcon(VhIcons.alert, size: 20, color: p.ink3),
      _Mark.failed => VhIcon(VhIcons.alert, size: 20, color: p.err),
    };
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: VhSpace.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox.square(dimension: 24, child: Center(child: mark)),
          const SizedBox(width: VhSpace.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: text.bodyMedium!.copyWith(
                    color: state == _Mark.waiting ? p.ink3 : p.ink,
                  ),
                ),
                if (note case final n?)
                  Text(n, style: text.bodySmall!.copyWith(color: p.ink3)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
