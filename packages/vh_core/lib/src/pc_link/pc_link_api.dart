import 'dart:io';
import 'dart:typed_data';

import 'pc_link_models.dart';

/// Why a call to the computer failed, in the terms the phone shows.
enum PcLinkFailure {
  /// Off, asleep, on another network, or a firewall in the way.
  unreachable,

  /// Something answered with another certificate: not our computer, or a
  /// machine in the middle. Nothing was sent.
  wrongCertificate,

  /// The computer forgot this phone; pair again.
  unauthorized,

  /// No pairing window on the computer (no code shown, or it expired).
  pairingClosed,
  wrongCode,

  /// The person at the computer refused, or did not answer in time.
  pairingDenied,

  /// The computer would not take the link.
  refused,
  badResponse,
}

class PcLinkException implements Exception {
  const PcLinkException(this.failure, [this.detail]);

  final PcLinkFailure failure;
  final String? detail;

  @override
  String toString() =>
      'PcLinkException(${failure.name}${detail == null ? '' : ': $detail'})';
}

/// What the phone asks of the computer once paired; [PcLinkClient] over the
/// network, a fake in tests.
abstract interface class PcLinkApi {
  Future<PcStatus> status();
  Future<List<PcTask>> tasks();
  Future<PcTask> submit(String url, String quality);
  Future<bool> cancel(String id);
  Future<PcLibraryPage> library({
    int offset = 0,
    int limit = 100,
    String? query,
  });
  Future<Uint8List?> cover(String id);

  /// A library clip's file, from [range] on when given (a `Range` header's
  /// value, passed on as the player sent it). The caller reads or cancels
  /// [PcFileResponse.body]; cancelling ends the transfer.
  Future<PcFileResponse> file(String id, {String? range});

  /// Every transcript the computer keeps for [id], as JSON.
  Future<List<Object?>> transcripts(String id);

  /// The computer's saved lists; none from a computer older than them.
  Future<List<PcList>> lists();

  /// One list with its clips; null when the computer has no such list.
  Future<PcList?> list(String id);

  /// Asks the computer to put clip [id] in its Recycle Bin.
  Future<PcDeleteOutcome> delete(String id);
  void close();
}

/// The computer's answer for a clip's file: its status (200 whole, 206 a
/// range, 404, 416), the headers a player needs, and the bytes as they come.
class PcFileResponse {
  const PcFileResponse({
    required this.statusCode,
    required this.headers,
    required this.body,
  });

  final int statusCode;

  /// `content-type`, `content-length`, `content-range` and `accept-ranges`,
  /// where the computer sent them; nothing else is passed on.
  final Map<String, String> headers;
  final Stream<List<int>> body;

  static const passed = [
    HttpHeaders.contentTypeHeader,
    HttpHeaders.contentLengthHeader,
    HttpHeaders.contentRangeHeader,
    HttpHeaders.acceptRangesHeader,
  ];

  int? get length =>
      int.tryParse(headers[HttpHeaders.contentLengthHeader] ?? '');
}
