import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_factory/core/theme/app_theme.dart';
import 'package:naseeji_factory/core/widgets/general_widgets.dart';
import 'package:naseeji_factory/authentication/domain/entities/supplier_registration_data.dart';
import 'package:naseeji_factory/authentication/presentation/controllers/registration_controller.dart';
import 'widgets/supplier_type_card.dart';

class ChooseSupplierTypeScreen extends ConsumerWidget {
  const ChooseSupplierTypeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registrationState = ref.watch(registrationControllerProvider);
    final selectedType = registrationState.data.supplierType;

    return Theme(
      data: AppTheme.darkTheme,
      child: Builder(
        builder: (context) {
          final theme = Theme.of(context);
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'نوع الحساب',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              centerTitle: true,
              actions: [
                TextButton(
                  onPressed: () => context.go('/login'),
                  child: Text(
                    'تسجيل الدخول',
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Step Progress Indicator
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox.shrink(),
                        Text(
                          'الخطوة 2 من 5',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: TweenAnimationBuilder<double>(
                        tween: Tween<double>(begin: 0.0, end: 0.4),
                        duration: const Duration(milliseconds: 800),
                        curve: Curves.easeInOut,
                        builder: (ctx, value, child) => LinearProgressIndicator(
                          value: value,
                          minHeight: 6,
                          backgroundColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                          valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Headings
                    Text(
                      'اختر نوع حسابك كمورد',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'حدد طبيعة نشاطك علشان نجهزلك الأدوات والخدمات المناسبة.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Selection Cards list with slide-fade entry animation
                    Expanded(
                      child: TweenAnimationBuilder<double>(
                        tween: Tween<double>(begin: 0.0, end: 1.0),
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeOutCubic,
                        builder: (ctx, animValue, child) => Transform.translate(
                          offset: Offset(0, 30 * (1.0 - animValue)),
                          child: Opacity(
                            opacity: animValue,
                            child: child,
                          ),
                        ),
                        child: ListView(
                          physics: const BouncingScrollPhysics(),
                          children: [
                            SupplierTypeCard(
                              type: SupplierType.factoryUnit,
                              title: 'مصنع أو ورشة إنتاج',
                              description: 'تصنيع الملابس والمنسوجات وتنفيذ طلبات الإنتاج.',
                              emoji: '🏭',
                              isSelected: selectedType == SupplierType.factoryUnit,
                              onTap: () {
                                ref.read(registrationControllerProvider.notifier).updateSupplierType(SupplierType.factoryUnit);
                              },
                            ),
                            const SizedBox(height: 16),
                            SupplierTypeCard(
                              type: SupplierType.supplier,
                              title: 'مورد خامات ومستلزمات',
                              description: 'توريد الأقمشة والخيوط والإكسسوارات والتغليف وماكينات الإنتاج.',
                              emoji: '🧵',
                              isSelected: selectedType == SupplierType.supplier,
                              onTap: () {
                                ref.read(registrationControllerProvider.notifier).updateSupplierType(SupplierType.supplier);
                              },
                            ),
                            const SizedBox(height: 16),
                            SupplierTypeCard(
                              type: SupplierType.customizer,
                              title: 'مقدم خدمات',
                              description: 'الطباعة، التطريز، التصميم، الصباغة، القص، التغليف وغيرها.',
                              emoji: '🎨',
                              isSelected: selectedType == SupplierType.customizer,
                              onTap: () {
                                ref.read(registrationControllerProvider.notifier).updateSupplierType(SupplierType.customizer);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Continue button with validation snackbar and opacity signal
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 250),
                      opacity: selectedType != null ? 1.0 : 0.6,
                      child: PrimaryButton(
                        text: 'متابعة التسجيل',
                        onPressed: () {
                          if (selectedType == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'من فضلك اختار نوع الحساب.',
                                      style: TextStyle(
                                        color: theme.colorScheme.onErrorContainer,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Icon(Icons.error_outline, color: theme.colorScheme.onErrorContainer),
                                  ],
                                ),
                                backgroundColor: theme.colorScheme.errorContainer,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                            );
                          } else {
                            context.push('/register');
                          }
                        },
                        suffixIcon: Icons.arrow_forward_rounded,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}


