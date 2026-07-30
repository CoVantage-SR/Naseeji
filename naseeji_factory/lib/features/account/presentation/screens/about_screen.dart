import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/extensions/context_extensions.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSecondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    return Scaffold(
      appBar: AppBar(
        title: const Text('عن منصة نسيجي'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          physics: const BouncingScrollPhysics(),
          children: [
            const SizedBox(height: 12),
            // Logo & App info
            Center(
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: AppRadius.rLG,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.factory_rounded, color: Colors.white, size: 44),
                  ),
                  const SizedBox(height: 12),
                  Text('مصنع نسيجي NASEEJI Factory', style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 4),
                  Text('المنصة الرقمية المتكاملة لقطاع الغزل والنسيج في الشرق الأوسط', style: TextStyle(color: textSecondary, fontSize: 11)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: AppRadius.rRound),
                    child: const Text('الإصدار v1.2.0 • Build 14', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 11)),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Links List
            Text('الروائح القانونية والتراخيص', style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 8),
            Material(
              color: surface,
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: AppRadius.rLG,
                side: BorderSide(color: border),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.gavel_rounded, color: AppColors.primary),
                    title: const Text('الشروط والأحكام الاستخدام'),
                    subtitle: const Text('حقوق وواجبات أصحاب المصانع والموردين', style: TextStyle(fontSize: 11)),
                    trailing: const Icon(Icons.chevron_left_rounded),
                    onTap: () => context.push('/account/terms'),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.privacy_tip_rounded, color: AppColors.primary),
                    title: const Text('سياسة الخصوصية وحماية البيانات'),
                    subtitle: const Text('طريقة التعامل مع المستندات والبيانات البنكية', style: TextStyle(fontSize: 11)),
                    trailing: const Icon(Icons.chevron_left_rounded),
                    onTap: () => context.push('/account/privacy'),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.copyright_rounded, color: AppColors.primary),
                    title: const Text('حقوق الملكية الفكرية والتراخيص'),
                    subtitle: const Text('جميع الحقوق محفوظة © 2026 نسيجي', style: TextStyle(fontSize: 11)),
                    trailing: const Icon(Icons.chevron_left_rounded),
                    onTap: () {
                      showLicensePage(
                        context: context,
                        applicationName: 'مصنع نسيجي',
                        applicationVersion: '1.2.0',
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.code_rounded, color: AppColors.primary),
                    title: const Text('المكتبات البرمجية المفتوحة المصدر Open Source Libraries'),
                    subtitle: const Text('عرض تراخيص الحزم المستعملة (Flutter, Riverpod, GoRouter)', style: TextStyle(fontSize: 11)),
                    trailing: const Icon(Icons.chevron_left_rounded),
                    onTap: () {
                      _showLibrariesModal(context);
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            Center(
              child: Text(
                'صُنع بكل فخر لخدمة الصناعة العربية 🇪🇬 🇸🇦 🇦🇪',
                style: TextStyle(color: textSecondary, fontSize: 11),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLibrariesModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('المكتبات مفتوحة المصدر المستعملة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            SizedBox(height: 12),
            ListTile(
              title: Text('Flutter Framework'),
              subtitle: Text('BSD 3-Clause License'),
            ),
            Divider(height: 1),
            ListTile(
              title: Text('Flutter Riverpod 2.x'),
              subtitle: Text('MIT License'),
            ),
            Divider(height: 1),
            ListTile(
              title: Text('GoRouter Navigation System'),
              subtitle: Text('BSD 3-Clause License'),
            ),
          ],
        ),
      ),
    );
  }
}
