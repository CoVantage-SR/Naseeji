import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../providers/account_provider.dart';

class LanguageScreen extends ConsumerWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsNotifierProvider);
    final notifier = ref.read(settingsNotifierProvider.notifier);
    final currentLang = settings.language;

    return Scaffold(
      appBar: AppBar(
        title: const Text('اللغة - Language'),
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
              Text('اختر لغة الواجهة التطبيق:', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              AppSpacing.hMD,
              _langTile(
                context,
                title: 'العربية (Arabic)',
                subtitle: 'اللغة الرسمية للمنظومة (RTL)',
                isSelected: currentLang == 'العربية',
                onTap: () {
                  notifier.setLanguage('العربية');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تم ضبط لغة التطبيق إلى العربية.')),
                  );
                },
              ),
              const SizedBox(height: 10),
              _langTile(
                context,
                title: 'English (الإنجليزية)',
                subtitle: 'International Interface (LTR)',
                isSelected: currentLang == 'English',
                onTap: () {
                  notifier.setLanguage('English');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('App language set to English.')),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _langTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;

    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.rMD,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : surface,
          borderRadius: AppRadius.rMD,
          border: Border.all(color: isSelected ? AppColors.primary : border, width: isSelected ? 1.5 : 1),
        ),
        child: Row(
          children: [
            const Icon(Icons.language_rounded, color: AppColors.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                ],
              ),
            ),
            if (isSelected) const Icon(Icons.check_circle_rounded, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}

