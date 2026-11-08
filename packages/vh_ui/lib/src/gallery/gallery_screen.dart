import 'package:flutter/material.dart';

import '../theme/vh_theme.dart';
import '../tokens/tokens.dart';
import '../widgets/vh_download_progress_card.dart';
import '../widgets/vh_empty_state.dart';
import '../widgets/vh_fab.dart';
import '../widgets/vh_media_card.dart';
import '../widgets/vh_platform_chip.dart';
import '../widgets/vh_search_field.dart';
import '../widgets/vh_section_header.dart';
import '../widgets/vh_snackbar.dart';
import '../widgets/vh_url_input_sheet.dart';
import '../widgets/vh_route_motion.dart';

import '../icons/vh_icon.dart';
import '../icons/vh_icons.dart';

/// An internal gallery for reviewing every component in both themes and
/// both text directions. **Not a product screen**: its strings are fixed
/// samples on purpose, outside the arb rule.
class VhGalleryScreen extends StatelessWidget {
  const VhGalleryScreen({
    super.key,
    this.onToggleTheme,
    this.onToggleDirection,
    this.onToggleVariant,
  });

  final VoidCallback? onToggleTheme;
  final VoidCallback? onToggleDirection;
  final VoidCallback? onToggleVariant;

  @override
  Widget build(BuildContext context) {
    final x = VhThemeX.of(context);
    final p = x.palette;
    final text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'معرض Vidhoist — ${x.variant == VhVariant.phone ? 'phone' : 'desktop'}',
        ),
        actions: [
          IconButton(
            onPressed: onToggleVariant,
            tooltip: 'phone/desktop',
            icon: const VhIcon(VhIcons.swap),
          ),
          IconButton(
            onPressed: onToggleDirection,
            tooltip: 'RTL/LTR',
            icon: const VhIcon(VhIcons.swap),
          ),
          IconButton(
            onPressed: onToggleTheme,
            tooltip: 'ليل/نهار',
            icon: const VhIcon(VhIcons.appearance),
          ),
        ],
      ),
      floatingActionButton: VhFab(
        label: 'إضافة رابط',
        onPressed: () => _openUrlSheet(context),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          VhSpace.pagePad,
          0,
          VhSpace.pagePad,
          120,
        ),
        children: [
          const VhSectionHeader(title: 'الطباعة', trailing: 'كوفي + Tajawal'),
          const SizedBox(height: VhSpace.md),
          Text('عنوان رئيسي بالكوفي', style: text.headlineLarge),
          Text('عنوان ورقة', style: text.titleLarge),
          Text(
            'نص أساسي بخط Tajawal يجري مجرى السطور بارتياح — 13.5',
            style: text.bodyMedium,
          ),
          Text('نص ثانوي خافت 11.5', style: text.bodySmall),
          const SizedBox(height: VhSpace.xl),

          const VhSectionHeader(title: 'اللوحة', trailing: 'Vidhoist'),
          const SizedBox(height: VhSpace.md),
          Wrap(
            spacing: VhSpace.xs,
            runSpacing: VhSpace.xs,
            children: [
              _Swatch('فعل', p.accent),
              _Swatch('soft', p.accentSoft, ink: p.accentInk),
              _Swatch('زيتوني', p.offlineSoft, ink: p.offlineInk),
              _Swatch('مفضلة', p.favoriteSoft, ink: p.favorite),
              _Swatch('نجاح', p.ok),
              _Swatch('خطأ', p.err),
            ],
          ),
          const SizedBox(height: VhSpace.xl),

          const VhSectionHeader(title: 'البحث والرقاقات'),
          const SizedBox(height: VhSpace.md),
          const VhSearchField(hint: 'ابحث في المكتبة…'),
          const SizedBox(height: VhSpace.md),
          Wrap(
            spacing: VhSpace.xs,
            children: [
              ChoiceChip(
                label: const Text('الكل'),
                selected: true,
                showCheckmark: false,
                labelStyle: text.labelMedium!.copyWith(color: p.bg),
                onSelected: (_) {},
              ),
              ChoiceChip(
                label: const Text('♥ المفضلة'),
                selected: false,
                onSelected: (_) {},
              ),
              ChoiceChip(
                label: const Text('فيديو'),
                selected: false,
                onSelected: (_) {},
              ),
              ChoiceChip(
                label: const Text('صوت'),
                selected: false,
                onSelected: (_) {},
              ),
            ],
          ),
          const SizedBox(height: VhSpace.xl),

          const VhSectionHeader(title: 'تحميل جارٍ', trailing: 'بطاقة حية'),
          const SizedBox(height: VhSpace.md),
          VhDownloadProgressCard(
            title: 'أنشودة الفجر — نسخة المسجد الكبير',
            statusText: 'يسحب من السيرفر · 64٪',
            progress: 0.64,
            onCancel: () {},
          ),
          const SizedBox(height: VhSpace.xs),
          VhDownloadProgressCard(
            title: 'مقطع محظور المنصة',
            statusText: 'المنصة تطلب تسجيل الدخول — حدّث الكوكيز',
            isError: true,
            onCancel: () {},
          ),
          const SizedBox(height: VhSpace.xl),

          const VhSectionHeader(title: 'بطاقات الوسائط', trailing: '٥ حالات'),
          VhMediaCard(
            title: 'خطبة الجمعة — أهمية الوقت في حياة المسلم',
            duration: '42:18',
            platform: VhPlatformKind.youtube,
            subtitle: 'قناة المنبر · قبل ٣ أيام',
            favorite: true,
            onFavoriteToggle: () {},
            onMore: () {},
            onTap: () {},
          ),
          VhMediaCard(
            title: 'أنشودة يا طيبة — مؤثرات',
            duration: '04:05',
            platform: VhPlatformKind.soundcloud,
            subtitle: 'أناشيد الفجر',
            playing: true,
            onTap: () {},
          ),
          VhMediaCard(
            title: 'عنصر محدد (وضع التحديد المتعدد)',
            platform: VhPlatformKind.tiktok,
            subtitle: '2.1MB · أمس',
            selected: true,
            onTap: () {},
          ),
          VhMediaCard(
            title: 'بطاقة مضغوطة بسطر واحد فقط للعرض الكثيف',
            duration: '1:03',
            platform: VhPlatformKind.instagram,
            subtitle: '12MB',
            compact: true,
            onMore: () {},
            onTap: () {},
          ),
          const SizedBox(height: VhSpace.xl),

          const VhSectionHeader(title: 'أزرار وتنبيهات'),
          const SizedBox(height: VhSpace.md),
          Row(
            children: [
              FilledButton(onPressed: () {}, child: const Text('فعل أساسي')),
              const SizedBox(width: VhSpace.sm),
              OutlinedButton(onPressed: () {}, child: const Text('ثانوي')),
            ],
          ),
          const SizedBox(height: VhSpace.md),
          Wrap(
            spacing: VhSpace.xs,
            children: [
              ActionChip(
                label: const Text('نجاح'),
                onPressed: () => showVhSnack(
                  context,
                  'تم الحفظ بنجاح',
                  type: VhSnackType.success,
                ),
              ),
              ActionChip(
                label: const Text('خطأ'),
                onPressed: () => showVhSnack(
                  context,
                  'تعذر الوصول للسيرفر',
                  type: VhSnackType.error,
                ),
              ),
              ActionChip(
                label: const Text('تراجع'),
                onPressed: () => showVhSnack(
                  context,
                  'حُذف العنصر',
                  actionLabel: 'تراجع',
                  onAction: () {},
                ),
              ),
            ],
          ),
          const SizedBox(height: VhSpace.xl),

          const VhSectionHeader(title: 'حالة فارغة'),
          VhEmptyState(
            title: 'لا سيرفر بعد',
            message: 'أدخل رابط سيرفر Vidhoist من الإعدادات لبدء التحميل',
            actionLabel: 'فتح الإعدادات',
            onAction: () {},
          ),
        ],
      ),
    );
  }

  void _openUrlSheet(BuildContext context) {
    final controller = TextEditingController(
      text: 'https://youtu.be/dQw4w9WgXcQ',
    );
    showVhSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      builder: (sheetContext) => VhUrlInputSheet(
        title: 'إضافة رابط',
        urlHint: 'الصق الرابط هنا…',
        controller: controller,
        platform: VhPlatformKind.youtube,
        platformLabel: 'YouTube',
        qualities: const [
          VhQualityOption(value: 'best', label: 'الأفضل'),
          VhQualityOption(value: '1080', label: '1080p'),
          VhQualityOption(value: '720', label: '720p'),
          VhQualityOption(value: '480', label: '480p'),
          VhQualityOption(value: 'audio', label: 'صوت فقط'),
        ],
        selectedQuality: 'best',
        onQualitySelected: (_) {},
        startLabel: 'ابدأ التحميل',
        onStart: () => Navigator.pop(sheetContext),
      ),
      // A development gallery, but a leak is still a leak: the controller
      // is disposed once the sheet has actually left the tree, not the
      // moment its future completes.
    ).whenComplete(() {
      WidgetsBinding.instance.addPostFrameCallback((_) => controller.dispose());
    });
  }
}

class _Swatch extends StatelessWidget {
  const _Swatch(this.label, this.color, {this.ink});

  final String label;
  final Color color;
  final Color? ink;

  @override
  Widget build(BuildContext context) {
    final p = VhThemeX.of(context).palette;
    final on = ink ?? (color.computeLuminance() > 0.5 ? p.ink : p.bg);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: VhSpace.md,
        vertical: VhSpace.xs,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(VhRadius.chip),
        border: Border.all(color: p.line),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium!.copyWith(color: on),
      ),
    );
  }
}
