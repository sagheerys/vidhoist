import 'package:vh_media/vh_media.dart' show vhFormatDuration;
import 'package:vh_transcripts/vh_transcripts.dart';
import 'package:vh_ui/vh_ui.dart';

/// The quote as it is copied: the words, where they come from and when,
/// and a link to the moment they begin.
String quoteText(
  VhLocalizations l, {
  required Quote quote,
  required List<TranscriptSegment> segments,
  required String title,
  required String canonicalUrl,
}) {
  final from = segments[quote.first].start;
  final to = segments[quote.last].end;
  return l.desktopQuote(
    quote.text,
    title,
    '${vhFormatDuration(from)}–${vhFormatDuration(to)}',
    timedLink(canonicalUrl, from),
  );
}
