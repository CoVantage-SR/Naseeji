import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/services/theme_service.dart';
import '../providers/account_provider.dart';
import '../widgets/account_reusable_widgets.dart';

class AppearanceScreen extends ConsumerWidget {
  const AppearanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsNotifierProvider);
    final notifier = ref.read(settingsNotifierProvider.notifier);
    final currentMode = settings.themeMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('المظهر والثيم'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const SectionHeader(title: 'اختر وضع المظهر المناسب لك'),
              AppSpacing.hSM,

              // Theme Cards Grid
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: AppThemeMode.values.map((mode) {
                  final isSelected = currentMode == mode;
                  return InkWell(
                    onTap: () {
                      notifier.setThemeMode(mode);
                      final themeMode = switch (mode) {
                        AppThemeMode.light => ThemeMode.light,
                        AppThemeMode.dark => ThemeMode.dark,
                        AppThemeMode.system => ThemeMode.system,
                        AppThemeMode.amoled => ThemeMode.dark,
                      };
                      ref.read(themeServiceProvider.notifier).setThemeMode(themeMode);
                    },
                    borderRadius: AppRadius.rMD,
                    child: Container(
                      width: (MediaQuery.of(context).size.width - 40) / 2,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : Colors.transparent,
                        borderRadius: AppRadius.rMD,
                        border: Border.all(
                          color: isSelected ? AppColors.primary : AppColors.borderLight,
                          width: isSelected ? 1.5 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _modeIcon(mode),
                            color: isSelected ? AppColors.primary : Colors.grey,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              mode.label,
                              style: TextStyle(
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                color: isSelected ? AppColors.primary : null,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          if (isSelected) const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 18),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              AppSpacing.hLG,

              // Preview
              const SectionHeader(title: 'معاينة النمط المختار'),
              AppSpacing.hSM,
              _PreviewWidget(mode: currentMode),
              AppSpacing.hLG,

              const Spacer(),

              // Apply Button
              PrimaryButton(
                label: 'تأكيد وحفظ الثيم',
                icon: Icons.check_rounded,
                onPressed: () {
                  final themeMode = switch (currentMode) {
                    AppThemeMode.light => ThemeMode.light,
                    AppThemeMode.dark => ThemeMode.dark,
                    AppThemeMode.system => ThemeMode.system,
                    AppThemeMode.amoled => ThemeMode.dark,
                  };
                  ref.read(themeServiceProvider.notifier).setThemeMode(themeMode);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('تم تطبيق ثيم: ${currentMode.label}')),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _modeIcon(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return Icons.wb_sunny_outlined;
      case AppThemeMode.dark:
        return Icons.nightlight_round_outlined;
      case AppThemeMode.system:
        return Icons.brightness_auto_rounded;
      case AppThemeMode.amoled:
        return Icons.contrast_rounded;
    }
  }
}

class _PreviewWidget extends StatelessWidget {
  final AppThemeMode mode;
  const _PreviewWidget({required this.mode});

  @override
  Widget build(BuildContext context) {
    final isDark = mode == AppThemeMode.dark ||
        mode == AppThemeMode.amoled ||
        (mode == AppThemeMode.system && Theme.of(context).brightness == Brightness.dark);
    final bg = mode == AppThemeMode.amoled
        ? Colors.black
        : (isDark ? const Color(0xFF0B0F19) : const Color(0xFFF8FAFC));
    final surface = mode == AppThemeMode.amoled
        ? const Color(0xFF121212)
        : (isDark ? const Color(0xFF151B2C) : Colors.white);
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final border = isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppRadius.rMD,
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('معاينة: ${mode.label}', style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: surface, borderRadius: AppRadius.rSM, border: Border.all(color: border)),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.15), borderRadius: AppRadius.rSM),
                  child: const Icon(Icons.factory_rounded, color: AppColors.primary, size: 20),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('مصنع النسيج الحديث', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: textColor)),
                    const Text('المحلة الكبرى، مصر', style: TextStyle(fontSize: 10, color: Colors.grey)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _previewChip('حساب موثق', AppColors.success, surface, border),
              const SizedBox(width: 8),
              _previewChip('خطة بريميوم', const Color(0xFF7C3AED), surface, border),
            ],
          ),
        ],
      ),
    );
  }

  Widget _previewChip(String label, Color color, Color surface, Color border) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: AppRadius.rRound, border: Border.all(color: color.withValues(alpha: 0.3))),
      child: Text(label, style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.bold)),
    );
  }
}
