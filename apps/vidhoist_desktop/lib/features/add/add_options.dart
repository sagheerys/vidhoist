import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vh_core/vh_core.dart';
import 'package:vh_ui/vh_ui.dart';

import '../../data/downloads_data.dart';
import '../../shell/pill.dart';
import '../folders/folder_picker.dart';

/// What an add sends with every link: video or sound, the quality, and
/// the folder below the download folder. **The folder is never
/// remembered**, as on the phone:
/// a folder chosen once and silently kept files the next clip where the
/// user did not look.
class AddChoice {
  const AddChoice({
    this.audio = false,
    this.quality = Quality.best,
    this.folder = FolderChoice.top,
  });

  /// An add as Downloads' default quality starts it: on sound when that is
  /// audio.
  factory AddChoice.startingWith(Quality quality) => quality == Quality.audio
      ? const AddChoice(audio: true)
      : AddChoice(quality: quality);

  final bool audio;

  /// The video quality; numbers are YouTube's alone.
  final Quality quality;
  final FolderChoice folder;

  /// What is sent for [url]: sound, or the video quality after the rule
  /// that an audio-only platform has no heights.
  Quality qualityFor(String url) =>
      audio ? Quality.audio : quality.applyRule(url);

  String? get folderPath => folder.isTop ? null : folder.path;

  AddChoice copyWith({bool? audio, Quality? quality, FolderChoice? folder}) =>
      AddChoice(
        audio: audio ?? this.audio,
        quality: quality ?? this.quality,
        folder: folder ?? this.folder,
      );
}

/// The choices under the link(s): video or audio, the video's quality
/// (the numbers for YouTube only), the folder, and for one YouTube clip
/// "fetch its transcript first".
class AddOptions extends ConsumerWidget {
  const AddOptions({
    super.key,
    required this.choice,
    required this.onChanged,
    required this.heights,
    this.offerTranscript = false,
    this.audioOnly = false,
  });

  final AddChoice choice;
  final ValueChanged<AddChoice> onChanged;

  /// Whether the heights apply: no link is sound alone (SoundCloud).
  final bool heights;
  final bool offerTranscript;

  /// A SoundCloud set: sound is the only choice.
  final bool audioOnly;

  Future<void> _pickFolder(BuildContext context) async {
    final picked = await showFolderPicker(context, current: choice.folder);
    if (picked != null) onChanged(choice.copyWith(folder: picked));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.vhl;
    final p = VhThemeX.of(context).palette;
    final text = Theme.of(context).textTheme;
    final audio = choice.audio || audioOnly;
    final qualities = [
      (Quality.best, l.qualityBest),
      if (heights) ...[
        (Quality.q1080, l.quality1080),
        (Quality.q720, l.quality720),
        (Quality.q480, l.quality480),
      ],
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: VhSpace.xs,
          runSpacing: VhSpace.xs,
          children: [
            if (!audioOnly)
              DesktopPill(
                label: l.filterVideo,
                icon: VhIcons.library,
                selected: !audio,
                onTap: () => onChanged(choice.copyWith(audio: false)),
              ),
            DesktopPill(
              label: l.filterAudio,
              icon: VhIcons.headphones,
              selected: audio,
              onTap: () => onChanged(choice.copyWith(audio: true)),
            ),
          ],
        ),
        if (!audio) ...[
          const SizedBox(height: VhSpace.sm),
          Wrap(
            spacing: VhSpace.xs,
            runSpacing: VhSpace.xs,
            children: [
              for (final (quality, label) in qualities)
                DesktopPill(
                  label: label,
                  selected:
                      choice.quality == quality ||
                      (!heights && quality == Quality.best),
                  onTap: () => onChanged(choice.copyWith(quality: quality)),
                ),
            ],
          ),
        ],
        const SizedBox(height: VhSpace.md),
        FolderLine(
          value: folderLabel(l, choice.folder),
          onPick: () => unawaited(_pickFolder(context)),
        ),
        if (offerTranscript)
          Padding(
            padding: const EdgeInsets.only(top: VhSpace.xs),
            child: CheckboxListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              value: ref.watch(transcriptsFirstProvider),
              onChanged: (on) => unawaited(
                ref.read(transcriptsFirstProvider.notifier).set(on ?? false),
              ),
              title: Text(
                l.desktopTranscriptFirst,
                style: text.bodySmall?.copyWith(color: p.ink),
              ),
              subtitle: Text(
                l.transcriptsSearchHelp,
                style: text.labelSmall?.copyWith(color: p.ink3),
              ),
            ),
          ),
      ],
    );
  }
}
