import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_factory/supplier/core/theme/app_colors.dart';
import 'package:naseeji_factory/supplier/core/theme/app_theme.dart';
import 'package:naseeji_factory/supplier/core/widgets/general_widgets.dart';
import 'package:naseeji_factory/supplier/features/auth/domain/entities/supplier_registration_data.dart';
import 'package:naseeji_factory/supplier/features/auth/presentation/controllers/registration_controller.dart';


class RegisterReviewScreen extends ConsumerWidget {
  const RegisterReviewScreen({super.key});

  Future<void> _confirmAndSubmit(BuildContext context, WidgetRef ref) async {
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
          final theme = Theme.of(context);
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
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1E1E2E), // Solid dark color
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: theme.colorScheme.outlineVariant.withValues(alpha: 0.2),
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.3),
                                    blurRadius: 15,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  _buildSectionHeader(theme, 'بيانات الحساب الأساسية'),
                                  const SizedBox(height: 12),
                                  _buildReviewRow(theme, Icons.badge_outlined, 'نوع الحساب', getAccountTypeLabel(data.supplierType)),
                                  _buildDivider(theme),
                                  _buildReviewRow(theme, Icons.person_outline, 'اسم المسؤول', data.fullName),
                                  _buildDivider(theme),
                                  _buildReviewRow(theme, Icons.phone_outlined, 'رقم الهاتف', data.phone),
                                  _buildDivider(theme),
                                  _buildReviewRow(theme, Icons.email_outlined, 'البريد الإلكتروني', data.email),
                                  _buildDivider(theme),
                                  _buildReviewRow(theme, Icons.map_outlined, 'المحافظة', data.governorate),
                                  _buildDivider(theme),
                                  _buildReviewRow(theme, Icons.location_city_outlined, 'المدينة', data.city),
                                  
                                  const SizedBox(height: 24),
                                  _buildSectionHeader(theme, 'بيانات المنشأة والتجارة'),
                                  const SizedBox(height: 12),
                                  _buildReviewRow(theme, Icons.business_outlined, 'اسم الشركة', data.companyName),
                                  _buildDivider(theme),
                                  
                                  if (data.supplierType == SupplierType.factoryUnit) ...[
                                    _buildReviewRow(theme, Icons.factory_outlined, 'نوع المصنع', data.factoryType),
                                    _buildDivider(theme),
                                    _buildReviewRow(theme, Icons.people_outline, 'عدد العمال', data.employeeCount),
                                    _buildDivider(theme),
                                    _buildReviewRow(theme, Icons.bolt_outlined, 'الطاقة الإنتاجية', data.productionCapacity),
                                    _buildDivider(theme),
                                    _buildReviewRow(theme, Icons.category_outlined, 'أنواع المنتجات', data.productTypes),
                                  ] else ...[
                                    _buildReviewRow(theme, Icons.category_outlined, 'التخصصات', data.categories.join('، ')),
                                  ],
                                  _buildDivider(theme),
                                  _buildReviewRow(theme, Icons.description_outlined, 'نبذة الشركة', data.companyBio),
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

  Widget _buildSectionHeader(ThemeData theme, String title) {
    return Row(
      children: [
        Expanded(child: Divider(color: theme.colorScheme.primary.withValues(alpha: 0.3), thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Expanded(child: Divider(color: theme.colorScheme.primary.withValues(alpha: 0.3), thickness: 1)),
      ],
    );
  }

  Widget _buildDivider(ThemeData theme) {
    return Divider(
      height: 24,
      color: theme.colorScheme.outlineVariant.withValues(alpha: 0.1),
    );
  }

  Widget _buildReviewRow(ThemeData theme, IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Value on the Left
        Expanded(
          flex: 2,
          child: Text(
            value.isEmpty ? '—' : value,
            textAlign: TextAlign.left,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 16),
        // Label on the Right
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                fontSize: 13,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              icon,
              size: 16,
              color: theme.colorScheme.primary.withValues(alpha: 0.8),
            ),
          ],
        ),
      ],
    );
  }
}

