import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_ui/vh_ui.dart';

import '../../di.dart';
import '../downloads_library/local_item.dart';
import 'phone_volumes.dart';

/// The folder's place inside a volume, shown under each choice so the
/// person knows where to look in a file manager: on the phone as the disk
/// spells it (an old `Vidhoist` may stay), on a card as the app makes it.
String _folder(String? volumeId) => volumeId == null
    ? 'Download/${phoneMediaDir.split('/').last}'
    : 'Download/$mediaFolderName';

/// **Where new downloads go**: the phone's storage, or a memory card while
/// one is in (plan item R4). In the downloads settings.
///
/// A phone with no card still shows the row, saying so: someone looking
/// for the card setting learns why there is nothing to pick.
class StorageLocationTile extends ConsumerStatefulWidget {
  const StorageLocationTile({super.key});

  @override
  ConsumerState<StorageLocationTile> createState() =>
      _StorageLocationTileState();
}

class _StorageLocationTileState extends ConsumerState<StorageLocationTile> {
  @override
  void initState() {
    super.initState();
    // A card put in since the app started shows up on opening the page.
    unawaited(ref.read(phoneVolumesProvider.notifier).refresh());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.vhl;
    final chosen = ref.watch(settingsProvider).downloadVolume;
    final volumes = ref.watch(phoneVolumesProvider);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(l10n.storageLocation),
      subtitle: Text(
        storageSummary(l10n, chosen, volumes),
        style: Theme.of(context).textTheme.bodySmall,
      ),
      trailing: const VhIcon(VhIcons.chevronDown),
      onTap: () => showVhSheet<void>(
        context: context,
        showDragHandle: true,
        builder: (_) => const StorageLocationSheet(),
      ),
    );
  }
}

/// The line under "Save to": the place and the folder in it, or why the
/// chosen card is not used right now.
String storageSummary(
  VhLocalizations l10n,
  String? chosen,
  List<PhoneVolume> volumes,
) {
  if (chosen == null) {
    return '${l10n.storagePhone} · ${vhLtrRun(_folder(null))}';
  }
  for (final volume in volumes) {
    if (volume.id == chosen) {
      return '${volume.label} · ${vhLtrRun(_folder(chosen))}';
    }
  }
  return l10n.storageCardMissing;
}

/// The choices: the phone, then each mounted card.
class StorageLocationSheet extends ConsumerWidget {
  const StorageLocationSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.vhl;
    final p = VhThemeX.of(context).palette;
    final text = Theme.of(context).textTheme;
    final chosen = ref.watch(settingsProvider).downloadVolume;
    final volumes = ref.watch(phoneVolumesProvider);
    final notifier = ref.read(settingsProvider.notifier);

    Widget choice(String title, String? id) => ListTile(
      title: Text(title),
      subtitle: Text(vhLtrRun(_folder(id)), style: text.bodySmall),
      trailing: chosen == id ? VhIcon(VhIcons.check, color: p.ink) : null,
      onTap: () {
        unawaited(notifier.setDownloadVolume(id));
        Navigator.pop(context);
      },
    );

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: VhSpace.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: VhSpace.lg),
              child: Text(l10n.storageLocation, style: text.titleMedium),
            ),
            choice(l10n.storagePhone, null),
            for (final volume in volumes) choice(volume.label, volume.id),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: VhSpace.lg),
              child: Text(
                volumes.isEmpty
                    ? '${l10n.storageNoCard}. ${l10n.storageLocationHelp}'
                    : l10n.storageLocationHelp,
                style: text.bodySmall?.copyWith(color: p.ink2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
