import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';

import '../../data/pc_link_data.dart';
import '../../shell/folded_text.dart';
import 'phone_pane_cards.dart';
import 'simple_panes.dart';

/// **Settings › Phone**: "download on the computer" from this end. Off
/// until turned on, and then a phone pairs once: a code shown here, typed
/// there, and the owner allowing it here after comparing four digits.
class PhonePane extends ConsumerWidget {
  const PhonePane({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.vhl;
    final p = VhThemeX.of(context).palette;
    final text = Theme.of(context).textTheme;
    final enabled = ref.watch(pcLinkEnabledProvider);
    final session = ref.watch(pcLinkProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FoldedText(
          l.pcLinkIntro,
          style: text.bodyMedium?.copyWith(color: p.ink2),
        ),
        const SizedBox(height: VhSpace.sm),
        SwitchLine(
          title: l.pcLinkReceive,
          hint: l.pcLinkReceiveHint,
          value: enabled,
          onChanged: (on) =>
              unawaited(ref.read(pcLinkEnabledProvider.notifier).set(on)),
        ),
        if (enabled)
          switch (session) {
            AsyncData(value: final s?) => _Session(session: s),
            AsyncError(:final error) => Padding(
              padding: const EdgeInsets.symmetric(vertical: VhSpace.md),
              child: Text(
                l.pcLinkFailed('$error'),
                style: text.bodySmall?.copyWith(color: p.err),
              ),
            ),
            _ => Padding(
              padding: const EdgeInsets.symmetric(vertical: VhSpace.md),
              child: Text(l.pcLinkStarting, style: text.bodySmall),
            ),
          },
        const SizedBox(height: VhSpace.lg),
        FoldedText(
          l.pcLinkSecurity,
          style: text.labelSmall?.copyWith(color: p.ink3),
        ),
      ],
    );
  }
}

class _Session extends ConsumerStatefulWidget {
  const _Session({required this.session});

  final PcLinkSession session;

  @override
  ConsumerState<_Session> createState() => _SessionState();
}

class _SessionState extends ConsumerState<_Session> {
  StreamSubscription<void>? _changes;
  StreamSubscription<PcPairingRequest>? _requests;
  Timer? _tick;
  PcPairingRequest? _request;

  PcPairingWindow get _pairing => widget.session.pairing;

  @override
  void initState() {
    super.initState();
    _listen();
  }

  @override
  void didUpdateWidget(_Session old) {
    super.didUpdateWidget(old);
    if (old.session != widget.session) {
      unawaited(_changes?.cancel());
      unawaited(_requests?.cancel());
      _listen();
    }
  }

  void _listen() {
    _changes = _pairing.changes.listen((_) {
      if (mounted) setState(_retick);
    });
    _requests = _pairing.requests.listen((request) {
      if (!mounted) return;
      setState(() => _request = request);
      unawaited(
        request.answer.whenComplete(() {
          if (mounted && _request == request) setState(() => _request = null);
        }),
      );
    });
  }

  /// A second's tick only while a code is on screen, for its countdown.
  void _retick() {
    _tick?.cancel();
    if (!_pairing.isOpen) return;
    _tick = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {});
      if (!_pairing.isOpen) _tick?.cancel();
    });
  }

  @override
  void dispose() {
    unawaited(_changes?.cancel());
    unawaited(_requests?.cancel());
    _tick?.cancel();
    // Leaving the page takes the code off the screen: it shuts.
    _pairing.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.vhl;
    final p = VhThemeX.of(context).palette;
    final text = Theme.of(context).textTheme;
    final addresses =
        ref.watch(pcLinkAddressesProvider).valueOrNull ?? const [];
    final port = widget.session.port;
    final code = _pairing.code;
    final request = _request;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SettingLine(
          title: l.pcLinkAddress,
          value: addresses.isEmpty
              ? '—'
              : addresses.map((a) => '$a:$port').join('  ·  '),
        ),
        if (request != null && request.isOpen)
          PhoneRequestCard(request: request)
        else if (code != null)
          PhoneCodeCard(
            code: code,
            secondsLeft: _pairing.expires!.difference(DateTime.now()).inSeconds,
            onCancel: _pairing.close,
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(vertical: VhSpace.md),
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: FilledButton.icon(
                onPressed: () => setState(() {
                  _pairing.open();
                  _retick();
                }),
                icon: const VhIcon(VhIcons.phone),
                label: Text(l.pcLinkPairPhone),
              ),
            ),
          ),
        const SizedBox(height: VhSpace.sm),
        Text(l.pcLinkDevices, style: text.titleSmall?.copyWith(color: p.ink)),
        if (_pairing.devices.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: VhSpace.sm),
            child: Text(
              l.pcLinkNoDevices,
              style: text.bodySmall?.copyWith(color: p.ink2),
            ),
          ),
        for (final device in _pairing.devices)
          SettingLine(
            title: device.name,
            hint: device.lastSeen != null
                ? l.pcLinkLastSeen(vhTimeAgo(context, device.lastSeen!))
                : l.pcLinkPairedAt(vhTimeAgo(context, device.pairedAt)),
            trailing: VhLinkButton(
              label: l.pcLinkRevoke,
              icon: VhIcons.trash,
              danger: true,
              onPressed: () => unawaited(_pairing.revoke(device.id)),
            ),
          ),
      ],
    );
  }
}
