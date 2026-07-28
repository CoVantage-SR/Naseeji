import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/extensions/context_extensions.dart';

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
        title: const Text('عن نسيجي'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.factory_rounded, color: Colors.white, size: 50),
              ),
              const SizedBox(height: 16),
              Text('منصة نسيجي للمصانع', style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 20)),
              const SizedBox(height: 4),
              Text('نسخة التطبيق 1.2.0 (Build 120)', style: TextStyle(color: textSecondary, fontSize: 12)),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: surface,
                  borderRadius: AppRadius.rLG,
                  border: Border.all(color: border),
                ),
                child: Text(
                  'منصة نسيجي هي البيئة الرقمية المتكاملة لربط المصانع المصرية والموردين لإدارة عروض الأسعار والطلبات والصفقات والعمليات اللوجستية بكفاءة عالية.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: textSecondary, fontSize: 13, height: 1.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
