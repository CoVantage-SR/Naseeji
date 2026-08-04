import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../widgets/register_header.dart';
import '../widgets/register_logo.dart';

class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  String _currentLanguage = 'العربية';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? colorScheme.surface : const Color(0xFFFAFCFF),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                children: [
                  // Top Header (Language switcher)
                  RegisterHeader(
                    showBackButton: false,
                    currentLanguage: _currentLanguage,
                    onLanguageChanged: (lang) {
                      setState(() {
                        _currentLanguage = lang;
                      });
                    },
                  ),
                  const Spacer(),

                  // Central Logo & Hero Section
                  const RegisterLogo(),
                  AppSpacing.hLG,

                  Text(
                    'مرحباً بك في منصة نسيجي',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDark ? colorScheme.onSurface : const Color(0xFF1E293B),
                      fontSize: 26,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'المنصة الصناعية المتكاملة لربط المصانع والموردين في قطاع النسيج والتصنيع',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isDark ? colorScheme.onSurfaceVariant : const Color(0xFF64748B),
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),

                  const Spacer(),

                  // Action Buttons Group
                  // 1. Login Button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () => context.push('/auth/login'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        textStyle: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      child: const Text('تسجيل الدخول'),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // 2. Create Account Button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton(
                      onPressed: () => context.push('/auth/register'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.primary, width: 1.5),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        textStyle: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      child: const Text('إنشاء حساب جديد'),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // 3. Continue as Guest Button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: TextButton.icon(
                      onPressed: () => context.push('/auth/account-type', extra: {'isGuest': true}),
                      icon: Icon(
                        Icons.person_outline_rounded,
                        color: isDark ? colorScheme.onSurfaceVariant : const Color(0xFF475569),
                        size: 20,
                      ),
                      label: Text(
                        'المتابعة كزائر',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isDark ? colorScheme.onSurfaceVariant : const Color(0xFF475569),
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
