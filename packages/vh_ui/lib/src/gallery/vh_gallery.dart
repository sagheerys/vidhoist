import 'package:flutter/material.dart';

import '../icons/vh_icon.dart';
import '../icons/vh_icons.dart';
import '../theme/vh_theme.dart';
import '../tokens/tokens.dart';
import '../kit/vh_badge.dart';
import '../kit/vh_boxed_settings.dart';
import '../kit/vh_confirm_dialog.dart';
import '../kit/vh_shortcut_tooltip.dart';
import '../kit/vh_switch.dart';
import 'vh_gallery_motion.dart';

/// An internal sheet of the app's components, for reviewing them by eye in
/// both themes and both directions. **Not a product screen**: its strings
/// are fixed samples on purpose, outside the arb rule, like
/// `VhGalleryScreen`.
class VhGallery extends StatefulWidget {
  const VhGallery({super.key, this.arabic = true});

  final bool arabic;

  @override
  State<VhGallery> createState() => _VhGalleryState();
}

class _VhGalleryState extends State<VhGallery> {
  bool _wifi = true;
  bool _notify = false;
  bool _check = true;
  int _radio = 1;

  String t(String ar, String en) => widget.arabic ? ar : en;

  @override
  Widget build(BuildContext context) {
    final p = VhThemeX.of(context).palette;
    final text = Theme.of(context).textTheme;
    Widget label(String s) => Padding(
      padding: const EdgeInsets.only(top: VhSpace.xl, bottom: VhSpace.xs),
      child: Text(s, style: text.titleMedium!.copyWith(color: p.ink3)),
    );
    return Directionality(
      textDirection: widget.arabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        body: ListView(
          padding: const EdgeInsets.all(VhSpace.xxl),
          children: [
            Text(
              t('مكوّنات VidHoist', 'VidHoist components'),
              style: text.headlineLarge,
            ),
            label(t('المفتاح', 'Switch')),
            Wrap(
              spacing: VhSpace.xl,
              children: [
                VhSwitch(value: true, onChanged: (_) {}),
                VhSwitch(value: false, onChanged: (_) {}),
                const VhSwitch(value: true, onChanged: null),
              ],
            ),
            label(t('الاختيار والشارة', 'Choice and badge')),
            Wrap(
              spacing: VhSpace.lg,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Checkbox(
                  value: _check,
                  onChanged: (v) => setState(() => _check = v!),
                ),
                Checkbox(value: false, onChanged: (_) {}),
                RadioGroup<int>(
                  groupValue: _radio,
                  onChanged: (v) => setState(() => _radio = v!),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [Radio<int>(value: 1), Radio<int>(value: 2)],
                  ),
                ),
                const VhBadge(count: 3),
                const VhBadge(count: 120),
                VhShortcutTooltip(
                  message: t('نزّل إلى الجهاز', 'Download to this computer'),
                  shortcut: 'Ctrl+D',
                  child: const VhIcon(VhIcons.download),
                ),
              ],
            ),
            label(t('صفوف الإعدادات', 'Settings rows')),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: VhBoxedGroup(
                title: t('التشغيل والتنزيل', 'Playback and download'),
                rows: [
                  VhBoxedRow(
                    icon: VhIcons.appearance,
                    title: t('المظهر', 'Appearance'),
                    subtitle: t('يتبع النظام', 'Follows the system'),
                    value: t('النظام', 'System'),
                    onTap: () {},
                  ),
                  VhBoxedRow(
                    icon: VhIcons.download,
                    title: t('Wi‑Fi فقط', 'Wi‑Fi only'),
                    subtitle: t(
                      'لا تنزيل على البيانات',
                      'No downloads on data',
                    ),
                    trailing: VhSwitch(
                      value: _wifi,
                      onChanged: (v) => setState(() => _wifi = v),
                    ),
                  ),
                  VhBoxedRow(
                    icon: VhIcons.subscriptions,
                    title: t('إشعار الاكتمال', 'Notify when done'),
                    trailing: VhSwitch(
                      value: _notify,
                      onChanged: (v) => setState(() => _notify = v),
                    ),
                  ),
                ],
              ),
            ),
            VhGalleryMotion(arabic: widget.arabic),
            label(t('الحوار', 'Dialog')),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: VhConfirmDialog(
                title: t('حذف المقطع؟', 'Delete the clip?'),
                message: t(
                  'سيُحذف الملف من السيرفر نهائياً، ولا يمكن التراجع.',
                  'The file is removed from the server for good.',
                ),
                confirmLabel: t('احذف', 'Delete'),
                cancelLabel: t('إلغاء', 'Cancel'),
                destructive: true,
                preview: VhDialogClip(
                  title: t(
                    'رحلة إلى وادي رم · 12:40',
                    'Trip to Wadi Rum · 12:40',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
