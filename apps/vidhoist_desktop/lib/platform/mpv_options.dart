/// What mpv is told before its first clip.
///
/// - **Its own reconnection for a dropped stream**: off by default in
///   ffmpeg, so a connection the network or a tunnel cut ended the clip
///   where it was.
/// - **No subtitle file of its own**: yt-dlp writes `.ar.vtt` and
///   `.en.vtt` beside every video, mpv loaded one by itself and drew it
///   under the app's captions, over the seek bar (owner, 2026-11-07).
///   The app draws the subtitles.
const mpvEngineOptions = {
  'stream-lavf-o':
      'reconnect=1,reconnect_streamed=1,reconnect_on_network_error=1,'
      'reconnect_delay_max=5',
  'sub-auto': 'no',
};
