import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
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
                          _buildDetailRow('تاريخ بداية الاشتراك', startStr),
                          _buildDetailRow('تاريخ الانتهاء والتجديد', expiryStr),
                          _buildDetailRow('تجديد آلي للمحاسبة', sub.autoRenew ? 'مفعل نشط' : 'غير مفعل موقوف'),
                          _buildDetailRow('بطاقة الدفع المحددة', sub.paymentMethod),
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
                          _buildBenefitRow('إضافة حتى 50 منتجاً في كتالوج التوريد للمصانع'),
                          _buildBenefitRow('نشر 5 إعلانات ممولة جارية ومستهدفة للطلبات'),
                          _buildBenefitRow('رعاية 3 منتجات خامات مميزة للظهور في الصفحة الأولى'),
                          _buildBenefitRow('توفير مساحة تخزين 5 جيجابايت لتصاميم وشهادات الجودة'),
                          _buildBenefitRow('صلاحية إضافة 5 موظفين للمخازن والمبيعات'),
                          _buildBenefitRow('تفعيل فرعين تجاريين منفصلين لحساب المؤسسة'),
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

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
          Text(label, style: TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant)),
        ],
      ),
    );
  }

  Widget _buildBenefitRow(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Text(text, style: TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant), textAlign: TextAlign.right),
          ),
          SizedBox(width: 8),
          const Icon(Icons.check, color: Color(0xFF006B5F), size: 16),
        ],
      ),
    );
  }
}