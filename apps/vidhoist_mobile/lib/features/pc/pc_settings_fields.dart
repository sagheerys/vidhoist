import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';

import 'pc_errors.dart';
import 'pc_link_state.dart';
import 'pc_pairing_store.dart';
import 'pc_scan.dart';

/// **Settings › Computer**: pair with VidHoist on a Windows computer, or
/// see the pairing and undo it. Until a pairing exists, this page is the
/// whole feature: nothing else in the app changes.
class PcSettingsFields extends ConsumerWidget {
  const PcSettingsFields({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pairing = ref.watch(pcPairingProvider);
    return pairing == null ? const _PairForm() : _Paired(pairing: pairing);
  }
}

class _Paired extends ConsumerWidget {
  const _Paired({required this.pairing});

  final PcPairing pairing;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.vhl;
    final p = VhThemeX.of(context).palette;
    final text = Theme.of(context).textTheme;
    final fp = pairing.fingerprint.toUpperCase();
    final groups = [for (var i = 0; i < 16; i += 4) fp.substring(i, i + 4)];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(pairing.name, style: text.titleMedium?.copyWith(color: p.ink)),
        const SizedBox(height: VhSpace.xxs),
        Text(
          '${pairing.host}:${pairing.port}',
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.start,
          style: text.bodyMedium?.copyWith(color: p.ink2),
        ),
        const SizedBox(height: VhSpace.md),
        Text(
          l10n.pcCertificate,
          style: text.bodySmall?.copyWith(color: p.ink2),
        ),
        Text(
          groups.join(' '),
          textDirection: TextDirection.ltr,
          style: text.bodyMedium?.copyWith(
            color: p.ink,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
        const SizedBox(height: VhSpace.lg),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: TextButton.icon(
            style: TextButton.styleFrom(foregroundColor: p.err),
            onPressed: () =>
                unawaited(ref.read(pcPairingProvider.notifier).forget()),
            icon: const VhIcon(VhIcons.linkOff),
            label: Text(l10n.pcLinkRevoke),
          ),
        ),
      ],
    );
  }
}

class _PairForm extends ConsumerStatefulWidget {
  const _PairForm();

  @override
  ConsumerState<_PairForm> createState() => _PairFormState();
}

class _PairFormState extends ConsumerState<_PairForm> {
  final _address = TextEditingController();
  final _port = TextEditingController();
  final _code = TextEditingController();
  var _busy = false;
  String? _check;
  String? _error;

  @override
  void dispose() {
    _address.dispose();
    _port.dispose();
    _code.dispose();
    super.dispose();
  }

  Future<void> _pair() async {
    final l10n = context.vhl;
    final port = _port.text.trim();
    final address = parsePcAddress(
      port.isEmpty ? _address.text : '${_address.text.trim()}:$port',
    );
    final code = _code.text.trim();
    if (address == null) {
      setState(() => _error = l10n.pcBadAddress);
      return;
    }
    if (code.length != PcLink.codeLength) {
      setState(() => _error = l10n.pcErrWrongCode);
      return;
    }
    final pair = ref.read(pcPairerProvider);
    await _run(
      (phoneName, onCheck) => pair(
        host: address.$1,
        port: address.$2,
        code: code,
        phoneName: phoneName,
        onCheck: onCheck,
      ),
    );
  }

  /// The computer's QR code: its addresses, code and certificate in one
  /// look, nothing typed (owner's request, 2026-11-10).
  Future<void> _scan() async {
    final l10n = context.vhl;
    final String? read;
    try {
      read = await ref.read(pcScannerProvider)(l10n.pcScanPrompt);
    } on PlatformException {
      if (mounted) setState(() => _error = l10n.pcScanFailed);
      return;
    }
    if (read == null || !mounted) return;
    final offer = PcPairOffer.parse(read);
    if (offer == null) {
      setState(() => _error = l10n.pcBadQr);
      return;
    }
    final pair = ref.read(pcOfferPairerProvider);
    await _run(
      (phoneName, onCheck) =>
          pair(offer: offer, phoneName: phoneName, onCheck: onCheck),
    );
  }

  Future<void> _run(
    Future<PcPairing> Function(
      String phoneName,
      void Function(String check) onCheck,
    )
    attempt,
  ) async {
    final l10n = context.vhl;
    final messenger = ScaffoldMessenger.of(context);
    setState(() {
      _busy = true;
      _error = null;
      _check = null;
    });
    try {
      final pairing = await attempt(await ref.read(pcPhoneNameProvider)(), (
        check,
      ) {
        if (mounted) setState(() => _check = check);
      });
      await ref.read(pcPairingProvider.notifier).save(pairing);
      showVhSnackOn(
        messenger,
        l10n.pcPaired(pairing.name),
        type: VhSnackType.success,
      );
    } on PcLinkException catch (e) {
      if (mounted) setState(() => _error = pcFailureText(l10n, e.failure));
    } finally {
      if (mounted) {
        setState(() {
          _busy = false;
          _check = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.vhl;
    final p = VhThemeX.of(context).palette;
    final text = Theme.of(context).textTheme;
    final check = _check;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.pcPairIntro, style: text.bodySmall?.copyWith(color: p.ink2)),
        const SizedBox(height: VhSpace.lg),
        FilledButton.icon(
          onPressed: _busy ? null : () => unawaited(_scan()),
          icon: const VhIcon(VhIcons.qrScan),
          label: Text(l10n.pcScanButton),
        ),
        const SizedBox(height: VhSpace.lg),
        Text(l10n.pcOrType, style: text.bodySmall?.copyWith(color: p.ink2)),
        // The port has its own field: the phone's number pad has a dot but
        // no colon (owner's report, 2026-11-09), and it is rarely needed.
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: TextField(
                controller: _address,
                enabled: !_busy,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                textDirection: TextDirection.ltr,
                autocorrect: false,
                decoration: InputDecoration(
                  labelText: l10n.pcAddressLabel,
                  hintText: '192.168.1.24',
                  hintTextDirection: TextDirection.ltr,
                ),
              ),
            ),
            const SizedBox(width: VhSpace.md),
            Expanded(
              child: TextField(
                controller: _port,
                enabled: !_busy,
                keyboardType: TextInputType.number,
                textDirection: TextDirection.ltr,
                maxLength: 5,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  labelText: l10n.pcPortLabel,
                  hintText: '${PcLink.defaultPort}',
                  hintTextDirection: TextDirection.ltr,
                  counterText: '',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: VhSpace.md),
        TextField(
          controller: _code,
          enabled: !_busy,
          keyboardType: TextInputType.number,
          textDirection: TextDirection.ltr,
          maxLength: PcLink.codeLength,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            labelText: l10n.pcCodeLabel,
            counterText: '',
          ),
          onSubmitted: (_) => unawaited(_pair()),
        ),
        const SizedBox(height: VhSpace.md),
        if (check != null) ...[
          Text(
            check.split('').join(' '),
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.center,
            style: text.headlineMedium?.copyWith(
              color: p.accentInk,
              fontFeatures: const [FontFeature.tabularFigures()],
              letterSpacing: 4,
            ),
          ),
          const SizedBox(height: VhSpace.xs),
          Text(
            l10n.pcPairCheck(check),
            textAlign: TextAlign.center,
            style: text.bodyMedium?.copyWith(color: p.ink),
          ),
          const SizedBox(height: VhSpace.md),
        ],
        if (_error case final error?) ...[
          Text(error, style: text.bodySmall?.copyWith(color: p.err)),
          const SizedBox(height: VhSpace.md),
        ],
        OutlinedButton(
          onPressed: _busy ? null : () => unawaited(_pair()),
          child: _busy ? const VhSpinner(size: 18) : Text(l10n.pcPairButton),
        ),
      ],
    );
  }
}
