import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
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
              const SectionHeader(title: 'اختر ثيم التطبيق'),
              AppSpacing.hSM,

              // Theme Cards Row
              Row(
                children: AppThemeMode.values.map((mode) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: ThemeCard(
                        mode: mode,
                        isSelected: currentMode == mode,
                        onTap: () => notifier.setThemeMode(mode),
                      ),
                    ),
                  );
                }).toList(),
              ),
              AppSpacing.hLG,

              // Preview
              const SectionHeader(title: 'معاينة'),
              AppSpacing.hSM,
              _PreviewWidget(mode: currentMode),
              AppSpacing.hLG,

              // Apply Button
              PrimaryButton(
                label: 'تطبيق الثيم',
                icon: Icons.check_rounded,
                onPressed: () {
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
}

class _PreviewWidget extends StatelessWidget {
  final AppThemeMode mode;
  const _PreviewWidget({required this.mode});

  @override
  Widget build(BuildContext context) {
    final isDark = mode == AppThemeMode.dark ||
        (mode == AppThemeMode.system && Theme.of(context).brightness == Brightness.dark);
    final bg = isDark ? const Color(0xFF0B0F19) : const Color(0xFFF8FAFC);
    final surface = isDark ? const Color(0xFF151B2C) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final border = isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppRadius.rMD,
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('معاينة: ${mode.label}', style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: surface, borderRadius: AppRadius.rSM, border: Border.all(color: border)),
            child: Row(
              children: [
                Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.15), borderRadius: AppRadius.rSM),
                  child: const Icon(Icons.factory_rounded, color: AppColors.primary, size: 20),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('مصنع نسيجي', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: textColor)),
                    Text('المحلة الكبرى، مصر', style: const TextStyle(fontSize: 10, color: Colors.grey)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _previewChip('نشط', AppColors.success, surface, border),
              const SizedBox(width: 8),
              _previewChip('PRO', const Color(0xFF7C3AED), surface, border),
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
