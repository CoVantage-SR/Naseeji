import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_factory/supplier/core/theme/app_theme.dart';
import 'package:naseeji_factory/supplier/core/widgets/general_widgets.dart';
import 'package:naseeji_factory/supplier/features/auth/presentation/controllers/registration_controller.dart';
import 'widgets/create_account_form.dart';

class CreateAccountScreen extends ConsumerWidget {
  const CreateAccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Theme(
      data: AppTheme.darkTheme,
      child: Builder(
        builder: (context) {
          final state = ref.watch(registrationControllerProvider);
          final screenWidth = MediaQuery.of(context).size.width;
          final showBranding = screenWidth >= 650;

          Widget formContent() {
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: LoadingOverlay(
                isLoading: state.isLoading,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Step Progress Indicator
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox.shrink(),
                        Text(
                          'الخطوة 3 من 5',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: TweenAnimationBuilder<double>(
                        tween: Tween<double>(begin: 0.0, end: 0.6),
                        duration: const Duration(milliseconds: 800),
                        curve: Curves.easeInOut,
                        builder: (ctx, value, child) => LinearProgressIndicator(
                          value: value,
                          minHeight: 6,
                          backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                          valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'بيانات الشركة',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'اكتب بيانات شركتك علشان نكمل إنشاء حسابك.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const CreateAccountForm(),
                    SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'لديك حساب بالفعل؟',
                          style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                        ),
                        TextButton(
                          onPressed: () {
                            context.go('/login');
                          },
                          child: Text(
                            'تسجيل الدخول',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }

          Widget brandingContent() {
            return Container(
              color: Theme.of(context).colorScheme.surfaceContainerLow,
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Naseeji',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'الرابط الذكي بين الموردين ومصانع النسيج المستقبلية.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      height: 1.5,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Icon(Icons.verified, color: Theme.of(context).colorScheme.secondary, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'موردين معتمدين',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.bolt, color: Theme.of(context).colorScheme.secondary, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'توريد ذكي وسريع',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const Spacer(),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuAhy7sCMnbCQ2UtMymxhfWcdWZxRQs-PujSbPqZRvfzmagdlY_FgLz10xvJWYGJ0t7PLiFfsGF5Mdu0MF6jkzqONk2giNjB6GYsSSNtcChbdgbHLWYOjrr0bWj1SBEE6uDxAgj0xfeiwRdkQOl2gqm1mJ7zb7keDCnImQU1pj02iq9tH3UbZrYhVSBhWJcuX0xP-issEaiS6t4P9DQVYycnDCKd4rTLT7v1P-m6pDMx5dPjN1iYCP9TBPphMl1HATfIi81gdy0ftm4',
                      fit: BoxFit.cover,
                      height: 100,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 100,
                        color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.1),
                        child: Icon(Icons.factory, color: Theme.of(context).colorScheme.primary),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

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
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.04),
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
                      color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.04),
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
                          color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.3),
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
                          child: showBranding
                              ? IntrinsicHeight(
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: brandingContent(),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: formContent(),
                                      ),
                                    ],
                                  ),
                                )
                              : formContent(),
                        ),
                      ).maxW(showBranding ? 750 : 450),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
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
