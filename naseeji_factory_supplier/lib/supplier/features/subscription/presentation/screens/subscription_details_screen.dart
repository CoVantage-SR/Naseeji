import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_factory/supplier/core/theme/app_colors.dart';
import '../controllers/subscription_controllers.dart';

class SubscriptionDetailsScreen extends ConsumerWidget {
  const SubscriptionDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subAsync = ref.watch(activeSubscriptionControllerProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          elevation: 0.5,
          title: Text(
            'تفاصيل اشتراك الباقة',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Theme.of(context).colorScheme.onSurface),
          ),
          centerTitle: true,
        ),
        body: Material(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: subAsync.when(
            loading: () => Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('خطأ: $e')),
            data: (sub) {
              final startStr = '${sub.startDate.year}/${sub.startDate.month.toString().padLeft(2, '0')}/${sub.startDate.day.toString().padLeft(2, '0')}';
              final expiryStr = '${sub.expiryDate.year}/${sub.expiryDate.month.toString().padLeft(2, '0')}/${sub.expiryDate.day.toString().padLeft(2, '0')}';

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Plan Info Header
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            sub.planName,
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'تكلفة الباقة الحالية: ${sub.price.toStringAsFixed(0)} جنيه / شهرياً',
                            style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant),
                          ),
                          const Divider(height: 24, color: AppColors.outlineVariant),
                          _buildDetailRow(context, 'تاريخ بداية الاشتراك', startStr),
                          _buildDetailRow(context, 'تاريخ الانتهاء والتجديد', expiryStr),
                          _buildDetailRow(context, 'تجديد آلي للمحاسبة', sub.autoRenew ? 'مفعل نشط' : 'غير مفعل موقوف'),
                          _buildDetailRow(context, 'بطاقة الدفع المحددة', sub.paymentMethod),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),

                    // Current benefits B2B list
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'المزايا والامتيازات الحالية للحساب',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                          ),
                          const Divider(height: 20, color: AppColors.outlineVariant),
                          _buildBenefitRow(context, 'إضافة حتى 50 منتجاً في كتالوج التوريد للمصانع'),
                          _buildBenefitRow(context, 'نشر 5 إعلانات ممولة جارية ومستهدفة للطلبات'),
                          _buildBenefitRow(context, 'رعاية 3 منتجات خامات مميزة للظهور في الصفحة الأولى'),
                          _buildBenefitRow(context, 'توفير مساحة تخزين 5 جيجابايت لتصاميم وشهادات الجودة'),
                          _buildBenefitRow(context, 'صلاحية إضافة 5 موظفين للمخازن والمبيعات'),
                          _buildBenefitRow(context, 'تفعيل فرعين تجاريين منفصلين لحساب المؤسسة'),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),

                    // Actions
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => context.push('/subscription/history'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Theme.of(context).colorScheme.onSurface,
                              side: BorderSide(color: AppColors.outlineVariant),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: Text('سجل العمليات السابقة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => context.push('/subscription/plans'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0040E0),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: Text('تغيير أو ترقية الباقة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF111827))),
          Text(label, style: TextStyle(fontSize: 12, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280))),
        ],
      ),
    );
  }

  Widget _buildBenefitRow(BuildContext context, String text) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Text(text, style: TextStyle(fontSize: 11, color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF4B5563)), textAlign: TextAlign.right),
          ),
          SizedBox(width: 8),
          Icon(Icons.check, color: isDark ? const Color(0xFF2DD4BF) : const Color(0xFF006B5F), size: 16),
        ],
      ),
    );
  }
}
