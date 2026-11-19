# Download on the computer: design and security

The phone can send links to VidHoist on a Windows computer and show that
computer's downloads and library. It works on the same home network, or
from outside it through Tailscale when both devices run Tailscale.

The feature is **entirely optional**. Someone without a computer sees
almost nothing of it, and a computer that has not turned it on opens no
port.

## Where the code is

| Part | Path |
|---|---|
| Protocol, certificate, server, pinned client, discovery, stream proxy (pure Dart) | `packages/vh_core/lib/src/pc_link/` |
| The computer's side: settings, the host that answers the server, firewall, keep-awake | `apps/vidhoist_desktop/lib/data/pc_link_*.dart`, `firewall_data.dart`, `keep_awake_data.dart` |
| The computer's Settings › Phone page | `apps/vidhoist_desktop/lib/features/settings/phone_*.dart` |
| The phone's side: pairing, the Computer tab, sending, streaming, copying | `apps/vidhoist_mobile/lib/features/pc/` |

## Who sees what

| Situation | What changes |
|---|---|
| Phone only | One row in Settings, "Computer", that explains the feature. No tab, and no choice in the add sheet |
| Windows, not turned on | No port is open. "Receive from the phone" (Settings › Phone) is off by default |
| Turned on, not paired | Windows listens; the phone is unchanged |
| Paired | A "Computer" tab appears before Settings. The add sheet and the batch screen get a "Save to" row (computer or "This phone"), shown even while the computer is away. The last choice also decides where a quick download goes |
| Unpaired | Both go away and the phone is as it was |

## Pairing

1. On Windows, "Pair a phone" shows a 6-digit code. It is valid for two
   minutes, for five attempts, and for one pairing. Leaving the page
   closes it.
2. On the phone, in Settings › Computer, the user types the address the
   computer shows (for example `192.168.1.24`) and the code. The port has
   its own field; empty means 47321. The phone's number pad has a dot but
   no colon, so `host:port` cannot be typed in one field.
3. The phone connects over TLS, reads the fingerprint of the certificate
   it actually reached, and computes **four digits** from
   SHA-256(`fingerprint:code:nonce`), where the nonce is random and made by
   the phone. The computer computes the same four digits from its own
   certificate. (The digits are the first four bytes of the hash, read as
   an unsigned integer, modulo 10,000.)
4. Windows shows "*name* asks to pair" with its four digits, and the phone
   shows its own. **The person at the computer allows the phone only if the
   digits match.** The request waits up to 90 seconds for an answer.
5. When allowed, the phone stores the fingerprint (the pin), a device id,
   and a random 32-byte secret. The computer stores **the SHA-256 of the
   secret**, never the secret itself.

### With the QR code

Next to the code, Windows shows a QR code that carries every address of
the computer (home network first, then Tailscale, then the rest, at most
six), the port, the code, and **the certificate's fingerprint**:

`vidhoist://pair?v=1&h=192.168.1.24,100.101.102.103&p=47321&c=123456&f=<64 hex>`

1. On the phone, "Scan the QR code" opens the scanner
   (zxing-android-embedded, Apache 2.0, no Google services). The camera
   permission is asked for only at that moment.
2. The phone tries all the addresses at once with a TLS handshake only,
   and takes the first one, in the code's order, that presents the same
   certificate. Nothing is sent in this step.
3. It pairs on that address **with the fingerprint pinned from the first
   byte**. Any other certificate is refused before the code leaves the
   phone (`PcLinkFailure.wrongCertificate`).
4. The person at the computer presses "Allow", as with a typed code. The
   four digits still appear and match, but here the pin is the protection.

An invalid QR code (a poster's link, a newer format, a malformed address)
gives the phone nothing to connect to (`PcPairOffer.parse` returns null).
Someone who photographs the screen during the two minutes still needs the
person at the computer to allow them.

## Security: what someone scanning the network sees

| Layer | What it does |
|---|---|
| Off by default | No port until the user turns "Receive from the phone" on |
| Nothing without a key | A request without the `x-vh-device` header gets an empty 404 on every path. A request that names a device but fails the secret check gets 401, so a phone that was unpaired learns it must pair again. `/v1/pair` exists only while a code is showing |
| A certificate with no name | Self-signed (P-256), with the name `localhost`. It says nothing about the app |
| Certificate pinning | The phone trusts no certificate authority (`SecurityContext(withTrustedRoots: false)`) and refuses any certificate other than the one it saw when pairing, before it sends a byte |
| Machine in the middle while pairing | With the QR code, the fingerprint is pinned before connecting, so the code never reaches the impostor. With a typed code, the impostor must present its own certificate **before** it sees the code or the phone's nonce, so its four digits differ and the person at the computer refuses it. A chance match is 1 in 10,000, and each try still needs that person's approval |
| Guessing the code | 5 tries out of a million is 1 in 200,000; then the code closes |
| Narrow permissions | A paired phone can read the downloads, the library and the saved lists; add a web link (`http`/`https` only, no playlists); cancel a download; fetch a saved cover; and read a library clip's file and transcripts by its id. It can send one library clip to the Recycle Bin **only** if the user allowed it on Windows (see deleting below). No settings, no files outside the library, no commands |
| Files by id | A clip's id is the first 20 hex digits of the SHA-256 of its canonical URL. No path is ever requested |
| Silent discovery | On UDP 47321 the computer answers only a paired phone that proves itself (HMAC-SHA256 over a nonce, keyed with the secret's hash that the computer stores), and its answer is proved the same way. Anyone else hears nothing, except while a code is showing, when it hears only the name and the port. At most 20 answers a second. The answer only says where to connect; the pin and the secret decide everything after it |
| Unpairing | "Unpair" on Windows voids the secret at once, and the phone learns it must pair again (401) |
| Outside backups | The pairing keys on both devices never enter a backup. The phone's secret is in Android's encrypted store; the certificate and its key are in Windows' encrypted store (DPAPI). The paired-phones list, the on/off switch and the delete permission are device-only settings |

The server also sends `Cache-Control: no-store` and
`X-Content-Type-Options: nosniff`, no `Server` header, and accepts JSON
bodies up to 64 KiB.

**What stays exposed:** whoever holds the unlocked phone holds the secret,
as with any signed-in app. Malware on the computer itself can read the
library from the disk without going through the server. Windows Firewall
asks once on first run; if that was not allowed, or a rule blocks the app,
the Phone page on Windows shows an "Allow" button that adds a rule for
private networks only (see the firewall below).

### Tests

End-to-end tests over real TLS are in
`packages/vh_core/test/pc_link/pc_link_test.dart`: pairing, five wrong
codes, refusal by the person at the computer, an impostor certificate, a
made-up secret, an unpaired device, and every path probed without a key.
The pinning and attempt-limit tests were checked by breaking the code on
purpose and watching them fail. The same folder tests discovery, the QR
offer, addresses, ranges and the stream proxy.

## Watching and copying from the computer

Android's players (ExoPlayer under video_player and just_audio) open
their own connections and do not know the computer's fingerprint.
Trusting any certificate there would undo the pin. So the phone runs an
**internal proxy** (`PcStreamProxy` in vh_core):

- It listens on `127.0.0.1` only, on a free port, so nothing outside the
  phone reaches it.
- Every path starts with a token of 32 random bytes, made for each run:
  `http://127.0.0.1:<port>/<token>/<id>`. Another app on the phone that
  finds the port does not find what it asks for (a guard test covers it).
- Every request, with its `Range`, goes through the pinned link to the
  computer, so seeking works as in a local file. The route is read on
  each request, so changing "Connect through" while watching takes effect
  at the next seek.
- The bytes are unencrypted only inside the phone.
  `network_security_config.xml` allows plain HTTP to `127.0.0.1` alone;
  every other address keeps Android's default.

On the phone (`apps/vidhoist_mobile/lib/features/pc/`):

- **Tapping a clip** plays it like the phone's own clips: audio in the
  background, video in the player, and the play queue is the computer's
  list as shown. The key is the clip's URL, so there is one resume
  position for both copies, and if the phone has its own copy, that copy
  plays.
- **Transcripts:** the player asks the computer once per clip, so
  subtitles and the transcript page appear. An absent computer gives no
  subtitles and no error.
- **Covers:** a cover the computer keeps as a file reaches the player
  through the same proxy, `http://127.0.0.1:<port>/<token>/cover/<id>`, so
  it shows in the "Up next" list, the mini player and the playback
  notification. The address changes with every run, so an audio queue
  restored after a restart shows without covers until it is played from
  the computer again.
- **"Copy to the phone"** in the clip's menu (⋮): the file goes to
  `Download/VidHoist` under the download's own name. It is written to a
  temporary `.part` file and renamed when complete; a partial file (the
  link dropped) or a stopped copy is deleted. Transcripts go beside it as
  `<name>.<language>.vtt`, as a download writes them, so the player reads
  them. Then the indexes are updated as for a download (URL, title,
  cover), and the phone's gallery. A language that is not a language code
  (for example `../`) names no file.

## When the computer is away or its address changes

- **A new address:** if the computer does not answer on the home network,
  the phone asks the whole network (a UDP broadcast), at most once every
  30 seconds. A proved answer from a home address moves the link there and
  is saved, with no new pairing. The route stays the same (home network):
  the phone never switches to or from Tailscale on its own, because the
  user chose the route. The computer re-reads its addresses every minute,
  so the phone learns them from its first answer.
- **"Find on the network"** in the typed pairing form fills in the address
  of the computer that is showing a code right now, so only the code needs
  typing. The four digits work as before.
- **A link while the computer is away:** the add sheet shows the computer
  even when it is away ("Away: sent when it is back"). The link waits on
  the phone (`pc_link_outbox`, outside backups, deleted on unpairing) and
  shows at the top of the Computer page under "Waiting to send", with a
  button to remove it. While the app runs, the phone asks the computer
  every minute, and the first answer sends the links in order. A link the
  computer refused stays marked and is not retried. A closed app sends
  nothing.
- **Keeping awake:** Windows does not go to sleep while a download runs
  (`SetThreadExecutionState`; the screen still turns off as usual). It is
  on by default and can be turned off in Settings › Downloads ("Keep the
  computer awake while downloading").

If the computer's home address changes and the broadcast does not get
through (a router that blocks it), the phone learns the new address from
the computer's first answer over Tailscale, if that route is known, or
the user types it in Settings.

### Windows Firewall

The installer runs without administrator rights (per user), so it adds
no rule. The Phone page reads the firewall each time receiving starts,
with PowerShell commands rather than `netsh`, because netsh's output is
translated into the system language:

| State | What shows |
|---|---|
| A rule allows the app on the network type in use (private or public) | Nothing |
| No rule | "Windows Firewall" with "Allow" |
| A rule blocks it (usually "Cancel" on Windows' own prompt) | The same; a block wins over an allow |
| The network is "Public" and has no rule | Also: make it "Private" if it is the home network |

"Allow" asks Windows for administrator permission once, then removes
blocks on **this app** for private networks only, and adds
`VidHoist phone link` (inbound, this program, private networks). It
touches nothing else. The uninstaller deletes this rule if it exists
(with administrator permission). If the user accepted Windows' own
first-run prompt, Windows may already have added rules for both private
and public networks; then nothing shows, even on a Public network.

## Every way a link reaches the computer, and following it

- **The last "Save to" choice decides** (`sendToPcProvider`, read before
  the first frame, so it also holds for a shared link while the app was
  closed): the add sheet, the batch screen and the quick download.
- **The batch screen:** the selected clips are sent one by one in list
  order, because the computer does not accept a playlist from the phone.
  The first one that does not arrive waits, with everything after it,
  under "Waiting to send". Grouping them into a saved list stays a
  phone-download feature.
- **Quick download:** if the last choice was the computer, the link goes
  there at the default quality, and "Undo" cancels it on the computer and
  opens the add sheet with the same link. A playlist opens the batch
  screen as before. Sharing several links at once stays on the phone.
- **Following:** the Computer tab shows a count of the downloads running
  there, and the count goes away if the computer stops answering. When a
  download finishes, "Done on the computer: *title*" appears, with a play
  button if the clip is in its library. With the Computer page closed,
  the phone asks every 5 seconds **only** while the app is in the
  foreground and a download it knows of is running (one it sent, or one
  it saw when opening or returning to the app). While the Computer page is
  open, it asks every 2 seconds when something is running and every 10
  seconds otherwise. Nothing runs in the background.
- **No Android notification:** the phone only knows what happens if it
  asks, and asking while the app is closed needs a service that always
  runs in the background, which Android usually stops. A notification that
  arrives only sometimes is worse than none, and the computer announces a
  finished download itself.

## The Computer tab: downloads, lists and deleting

- **Downloads are grouped like the phone's:** one download shows as its
  own card. Two or more, together with links waiting to be sent, show as
  one line, "*n* downloads for the computer · View all", with the average
  progress. Tapping it opens the "Downloads on the computer" sheet with
  "On the computer now", "Queued" and "Waiting to send", each item with a
  cancel button. The sheet closes when nothing is left.
- **The computer's lists live in the Computer tab, not among the phone's
  lists.** The phone's lists are files on the phone: they work offline,
  enter the backup, and can be edited. The computer's lists disappear when
  the computer does. One line, "Lists on the computer", with their count,
  opens their page; a list opens with its clips that are files on the
  computer, in order, with "Play all" and "Shuffle". They are read-only
  from the phone, so a list never has two sources. A list with no file on
  the computer does not show.
- **Deleting from the phone has three safeguards:**
  1. A switch, "Let the phone delete clips", in Windows Settings › Phone.
     It is **off** until the user turns it on, and is kept out of backups
     so that a restore cannot carry it to another computer. The computer
     checks the switch on every request and does not trust the phone. The
     phone shows "Delete from the computer" only if the computer says it
     is allowed (`canDelete` in `/v1/status`).
  2. **To the Recycle Bin** (`SHFileOperation` with `FOF_ALLOWUNDO`), so it
     can be restored from there. A drive with no Recycle Bin (a network
     folder, some removable drives) is checked first
     (`SHQueryRecycleBin`): from the phone, **nothing is deleted** and the
     phone says so, because Windows would otherwise delete it permanently
     without a word.
  3. A confirmation on the phone that names the computer and shows the
     clip, one clip at a time.
- **Deleting on Windows itself also goes to the Recycle Bin.** On a drive
  with no Recycle Bin, the user at the computer can still delete
  permanently, after confirming.

## Protocol (v1)

HTTPS on port 47321 by default. If that port is taken, any free port is
used, and the Phone page on Windows shows it. Every request except pairing
carries `Authorization: Bearer <secret>` and `x-vh-device: <deviceId>`.

| Request | Authentication | Response |
|---|---|---|
| `POST /v1/pair` `{code, nonce, name}` | The code, while it is showing | `{deviceId, secret, name}` once allowed on the computer; 403 `{error: closed\|wrongCode\|denied}`; 400 for a malformed body (the nonce must be at least 16 characters); an empty 404 when no code is showing |
| `GET /v1/status` | Bearer secret + `x-vh-device` | `{name, version, active, addresses?, canDelete?}` |
| `GET /v1/downloads` | Same | `{tasks: [...]}`: running ones, then the last 20 finished |
| `POST /v1/downloads` `{url, quality}` | Same | The task; 400 for anything but an `http`/`https` URL; 422 if the app refuses it. `quality` defaults to `best` |
| `POST /v1/downloads/<id>/cancel` | Same | 204 or 404 |
| `GET /v1/library?offset&limit&q` | Same | `{items, total}`: files on the computer only, newest first. `limit` defaults to 100, at most 500 |
| `GET /v1/library/<id>/cover` | Same | The saved cover image (JPEG, PNG or WebP), or 404 |
| `GET`/`HEAD /v1/library/<id>/file` | Same | The clip's file: 200 whole, 206 for the requested range (`Range: bytes=…`), 416 for a range past the end, or 404 |
| `GET /v1/library/<id>/transcripts` | Same | `{transcripts: [...]}` in the phone's format (`Transcript.toJson`) |
| `DELETE /v1/library/<id>` | Same | 204 once in the Recycle Bin; 404; 403 `{error: notAllowed}`; or 409 `{error: noRecycleBin\|failed}` |
| `GET /v1/lists` | Same | `{lists: [{id, name, count, thumbnail?, cover?}]}`. An older computer answers 404, and the phone shows no lists |
| `GET /v1/lists/<id>` | Same | The list with its `items` in order, or 404 |

Without a valid key, every path above answers as described in the
security table: an empty 404, or 401 when the request names a device.

Discovery runs on UDP 47321: one JSON datagram of at most 512 bytes each
way. The phone listens for answers for 2 seconds.

| Question | Answer |
|---|---|
| `{vh: find, id, n, m}`, where `m` = HMAC(secret hash, `find:id:n`) | `{vh: here, n, port, m}`, where `m` = HMAC(secret hash, `here:id:n:port`); or silence |
| `{vh: find-pair}` | `{vh: pairable, port, name}`, only while a code is showing; otherwise silence |

`id` is the device id, `n` a fresh nonce, and the HMAC is HMAC-SHA256
keyed with the hex SHA-256 of the device's secret.

## Addresses

Windows gives every network adapter an address, and programs add their
own adapters. The Phone page on Windows sorts them
(`packages/vh_core/lib/src/pc_link/pc_addresses.dart`):

| Kind | How it is recognised | Shown |
|---|---|---|
| Home | A private address (10/8, 172.16/12, 192.168/16) on a real adapter | First, with the adapter's name (Wi-Fi, Ethernet) |
| Tailscale | The range 100.64/10, or an adapter named Tailscale | Under "Through Tailscale, from outside home" |
| Other | Adapters added by VirtualBox, VMware, WSL, Hyper-V, Docker, VPNs and similar; VirtualBox's 192.168.56.x network; any public address | Folded under "Other addresses" |

The server listens on every adapter, so a Tailscale address works like any
other, with the same security: encryption, certificate pinning and the
device secret do not depend on the route.

### Choosing the route on the phone

The route is chosen by hand, never automatically, so the user always
knows which network the phone is using.

- The computer sends its sorted addresses with every `/v1/status`
  (`addresses`), and the phone saves them with the pairing (`routes`).
  Existing pairings need no new pairing: the first answer is enough.
- Settings › Computer › "Connect through": "Home network" and "Tailscale"
  (other adapters stay hidden unless one is the route in use). The user
  chooses, and **the phone never switches on its own**.
- The Computer page says which route is in use ("Through …"). When the
  computer does not answer and a Tailscale route is known but not in use,
  the page suggests choosing it.
- Learning addresses opens no new connection; choosing a route does.
