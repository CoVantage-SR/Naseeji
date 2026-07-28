import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/extensions/context_extensions.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String _selectedLang = 'ar';

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;

    return Scaffold(
      appBar: AppBar(
        title: const Text('اللغة / Language'),
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
                RadioListTile<String>(
                  title: Text('العربية (Arabic)', style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold)),
                  value: 'ar',
                  groupValue: _selectedLang,
                  activeColor: AppColors.primary,
                  onChanged: (val) => setState(() => _selectedLang = val!),
                ),
                const Divider(height: 1),
                RadioListTile<String>(
                  title: Text('English (الإنجليزي)', style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold)),
                  value: 'en',
                  groupValue: _selectedLang,
                  activeColor: AppColors.primary,
                  onChanged: (val) => setState(() => _selectedLang = val!),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
