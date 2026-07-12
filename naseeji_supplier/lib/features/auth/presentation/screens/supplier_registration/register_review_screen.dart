import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import 'package:naseeji_supplier/core/theme/app_theme.dart';
import 'package:naseeji_supplier/core/widgets/general_widgets.dart';
import 'package:naseeji_supplier/features/auth/domain/entities/supplier_registration_data.dart';
import 'package:naseeji_supplier/features/auth/presentation/controllers/registration_controller.dart';

class RegisterReviewScreen extends ConsumerWidget {
  const RegisterReviewScreen({super.key});

  Future<void> _confirmAndSubmit(BuildContext context, WidgetRef ref) async {
    // Submit registration details and send OTP
    final success = await ref.read(registrationControllerProvider.notifier).sendOtp();
    if (context.mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم تأكيد البيانات وإرسال رمز التحقق بنجاح.'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
        context.push('/verify-otp');
      } else {
        final errorMsg = ref.read(registrationControllerProvider).errorMessage ?? 'حدث خطأ غير متوقع';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMsg),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(registrationControllerProvider);
    final data = state.data;
    final theme = Theme.of(context);

    String getAccountTypeLabel(SupplierType? type) {
      if (type == SupplierType.supplier) return 'مورد خامات ومستلزمات';
      if (type == SupplierType.factoryUnit) return 'مصنع أو ورشة إنتاج';
      if (type == SupplierType.customizer) return 'مقدم خدمات';
      return 'غير محدد';
    }

    return Theme(
      data: AppTheme.darkTheme,
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'مراجعة البيانات',
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
              child: LoadingOverlay(
                isLoading: state.isLoading,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Step Progress Indicator (Step 5 of 5)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const SizedBox.shrink(),
                                Text(
                                  'الخطوة 5 من 5',
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
                                tween: Tween<double>(begin: 0.0, end: 1.0),
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

                            Text(
                              'راجع بياناتك',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'تأكد من صحة البيانات قبل إرسال طلب إنشاء الحساب.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Data review card
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surfaceContainer,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
                                ),
                              ),
                              child: Column(
                                children: [
                                  _buildReviewRow('نوع الحساب', getAccountTypeLabel(data.supplierType)),
                                  const Divider(height: 20),
                                  _buildReviewRow('اسم الشركة', data.companyName),
                                  const Divider(height: 20),
                                  _buildReviewRow('اسم المسؤول', data.fullName),
                                  const Divider(height: 20),
                                  _buildReviewRow('رقم الهاتف', data.phone),
                                  const Divider(height: 20),
                                  _buildReviewRow('البريد الإلكتروني', data.email),
                                  const Divider(height: 20),
                                  _buildReviewRow('المحافظة', data.governorate),
                                  const Divider(height: 20),
                                  _buildReviewRow('المدينة', data.city),
                                  const Divider(height: 20),
                                  if (data.supplierType == SupplierType.factoryUnit) ...[
                                    _buildReviewRow('نوع المصنع', data.factoryType),
                                    const Divider(height: 20),
                                    _buildReviewRow('عدد العمال', data.employeeCount),
                                    const Divider(height: 20),
                                    _buildReviewRow('طاقة الإنتاجية', data.productionCapacity),
                                    const Divider(height: 20),
                                    _buildReviewRow('أنواع المنتجات', data.productTypes),
                                  ] else ...[
                                    _buildReviewRow('التخصصات', data.categories.join('، ')),
                                  ],
                                  const Divider(height: 20),
                                  _buildReviewRow('نبذة الشركة', data.companyBio),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => context.pop(),
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size.fromHeight(56),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text('تعديل', style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            flex: 2,
                            child: PrimaryButton(
                              text: 'تأكيد وإنشاء الحساب',
                              onPressed: () => _confirmAndSubmit(context, ref),
                              suffixIcon: Icons.check_circle_outline,
                            ),
                          ),
                        ],
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

  Widget _buildReviewRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            value.isEmpty ? '—' : value,
            textAlign: TextAlign.left,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            label,
            textAlign: TextAlign.right,
            style: const TextStyle(color: AppColors.outline, fontSize: 13),
          ),
        ),
      ],
    );
  }
}
