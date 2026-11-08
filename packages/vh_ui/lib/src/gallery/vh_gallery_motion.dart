import 'package:flutter/material.dart';

import '../icons/vh_icon.dart';
import '../icons/vh_icons.dart';
import '../theme/vh_theme.dart';
import '../tokens/tokens.dart';
import '../kit/vh_empty_frame.dart';
import '../kit/vh_link_button.dart';
import '../kit/vh_notice.dart';
import '../kit/vh_progress.dart';

/// The second half of [VhGallery]: the components that move (progress,
/// touch, notices) and the empty screen. Fixed sample strings, outside the
/// arb rule, like the rest of the gallery.
class VhGalleryMotion extends StatelessWidget {
  const VhGalleryMotion({super.key, required this.arabic});

  final bool arabic;

  String t(String ar, String en) => arabic ? ar : en;

  @override
  Widget build(BuildContext context) {
    final p = VhThemeX.of(context).palette;
    final text = Theme.of(context).textTheme;
    Widget label(String s) => Padding(
      padding: const EdgeInsets.only(top: VhSpace.xl, bottom: VhSpace.xs),
      child: Text(s, style: text.titleMedium!.copyWith(color: p.ink3)),
    );
    Widget notice(VhNoticeKind kind, String msg, {String? action}) => Padding(
      padding: const EdgeInsets.only(bottom: VhSpace.xs),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: p.miniBg,
          borderRadius: BorderRadius.circular(VhCorners.desktop.card),
        ),
        child: VhNotice(
          message: msg,
          kind: kind,
          actionLabel: action,
          onAction: () {},
          icon: kind == VhNoticeKind.info ? VhIcons.copy : null,
          duration: const Duration(hours: 1),
        ),
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        label(t('الانتظار والتقدم', 'Waiting and progress')),
        Row(
          children: [
            const VhSpinner(),
            const SizedBox(width: VhSpace.xl),
            const Expanded(child: VhFilmStrip()),
            const SizedBox(width: VhSpace.xl),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(t('يحمّل… 62٪', 'Loading… 62%'), style: text.bodySmall),
                  const VhProgressBar(value: 0.62),
                ],
              ),
            ),
          ],
        ),
        label(t('الأزرار واللمس', 'Buttons and touch')),
        Wrap(
          spacing: VhSpace.lg,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            IconButton(onPressed: () {}, icon: const VhIcon(VhIcons.list)),
            IconButton(onPressed: () {}, icon: const VhIcon(VhIcons.queue)),
            VhLinkButton(label: t('عرض الكل', 'See all'), onPressed: () {}),
          ],
        ),
        label(t('الإشعار السفلي', 'Notices')),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            children: [
              notice(
                VhNoticeKind.done,
                t('بدأ التنزيل', 'Download started'),
                action: t('تراجع', 'Undo'),
              ),
              notice(
                VhNoticeKind.failed,
                t('تعذّر الوصول إلى السيرفر', 'Could not reach the server'),
              ),
              notice(VhNoticeKind.info, t('نُسخ الرابط', 'Link copied')),
            ],
          ),
        ),
        label(t('الشاشة الفارغة', 'Empty screen')),
        VhEmptyFrame(
          title: t('المكتبة فارغة', 'The library is empty'),
          message: t(
            'شارك رابطاً من أي تطبيق، أو الصقه هنا.',
            'Share a link from any app, or paste it here.',
          ),
          actionLabel: t('الصق رابطاً', 'Paste a link'),
          actionIcon: VhIcons.addlink,
          onAction: () {},
        ),
      ],
    );
  }
}
