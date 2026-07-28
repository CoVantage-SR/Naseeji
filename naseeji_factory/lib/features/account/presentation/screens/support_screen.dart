import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/extensions/context_extensions.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;

    return Scaffold(
      appBar: AppBar(
        title: const Text('الدعم الفني والاتصال'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            decoration: BoxDecoration(
              color: surface,
              borderRadius: AppRadius.rLG,
              border: Border.all(color: border),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.phone_outlined, color: AppColors.primary),
                  title: Text('الاتصال المباشر', style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 14)),
                  subtitle: const Text('+20 10 1234 5678'),
                  trailing: const Icon(Icons.chevron_left_rounded),
                  onTap: () {},
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.chat_bubble_outline_rounded, color: AppColors.primary),
                  title: Text('محادثة واتساب الفنية', style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 14)),
                  subtitle: const Text('دعم فوري على مدار 24 ساعة'),
                  trailing: const Icon(Icons.chevron_left_rounded),
                  onTap: () {},
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.email_outlined, color: AppColors.primary),
                  title: Text('البريد الإلكتروني', style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 14)),
                  subtitle: const Text('support@naseeji.com'),
                  trailing: const Icon(Icons.chevron_left_rounded),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
