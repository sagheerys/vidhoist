import 'package:flutter/material.dart';
import 'package:vh_ui/vh_ui.dart';

/// The swaying bars that mark the clip playing in a list, at the line's
/// end after its title, where the phone's card puts them. Still while
/// paused.
class NowPlayingBars extends StatelessWidget {
  const NowPlayingBars({super.key, required this.playing});

  final bool playing;

  @override
  Widget build(BuildContext context) =>
      ExcludeSemantics(child: VhEqualizer(animate: playing));
}
