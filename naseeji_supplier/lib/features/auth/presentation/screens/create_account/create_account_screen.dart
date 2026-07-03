import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import 'package:naseeji_supplier/core/widgets/general_widgets.dart';
import 'package:naseeji_supplier/features/auth/presentation/controllers/registration_controller.dart';
import 'widgets/create_account_form.dart';

class CreateAccountScreen extends ConsumerWidget {
  const CreateAccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(registrationControllerProvider);

    return Scaffold(
      body: Stack(
        children: [
          // Background Decorative circles
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.04),
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondary.withValues(alpha: 0.04),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: AppColors.outlineVariant.withValues(alpha: 0.3),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Branding Side (Left 2/5 on wide screen)
                          Expanded(
                            flex: 2,
                            child: Container(
                              color: AppColors.surfaceContainerLow,
                              padding: const EdgeInsets.all(32),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Naseeji',
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'الرابط الذكي بين الموردين ومصانع النسيج المستقبلية.',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.onSurfaceVariant,
                                      height: 1.5,
                                    ),
                                  ),
                                  const Spacer(),
                                  // Context features list
                                  const Row(
                                    children: [
                                      Icon(
                                        Icons.verified,
                                        color: AppColors.secondary,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'موردين معتمدين',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  const Row(
                                    children: [
                                      Icon(
                                        Icons.bolt,
                                        color: AppColors.secondary,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'توريد ذكي وسريع',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  // Mini visual
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      'https://lh3.googleusercontent.com/aida-public/AB6AXuAhy7sCMnbCQ2UtMymxhfWcdWZxRQs-PujSbPqZRvfzmagdlY_FgLz10xvJWYGJ0t7PLiFfsGF5Mdu0MF6jkzqONk2giNjB6GYsSSNtcChbdgbHLWYOjrr0bWj1SBEE6uDxAgj0xfeiwRdkQOl2gqm1mJ7zb7keDCnImQU1pj02iq9tH3UbZrYhVSBhWJcuX0xP-issEaiS6t4P9DQVYycnDCKd4rTLT7v1P-m6pDMx5dPjN1iYCP9TBPphMl1HATfIi81gdy0ftm4',
                                      fit: BoxFit.cover,
                                      height: 100,
                                      width: double.infinity,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Container(
                                                height: 100,
                                                color: AppColors
                                                    .primaryContainer
                                                    .withValues(alpha: 0.1),
                                                child: const Icon(
                                                  Icons.factory,
                                                  color: AppColors.primary,
                                                ),
                                              ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Form Side (Right 3/5)
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.all(32.0),
                              child: LoadingOverlay(
                                isLoading: state.isLoading,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    const Text(
                                      'إنشاء حساب',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      'أدخل بيانات الشركة للبدء في رحلة التوريد الذكي',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: AppColors.onSurfaceVariant,
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    const CreateAccountForm(),
                                    const SizedBox(height: 24),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          'لديك حساب بالفعل؟',
                                          style: TextStyle(
                                            color: AppColors.onSurfaceVariant,
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            context.go('/login');
                                          },
                                          child: const Text(
                                            'تسجيل الدخول',
                                            style: TextStyle(
                                              color: AppColors.primary,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ).maxW(750),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Add a helper wrapper since BoxConstraints/max width is used
extension ContainerExtensions on Widget {
  Widget maxW(double width) => Center(
    child: ConstrainedBox(
      constraints: BoxConstraints(maxWidth: width),
      child: this,
    ),
  );
}
