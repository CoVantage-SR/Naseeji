import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../controllers/subscription_controller.dart';

class SubscriptionProfileTabView extends ConsumerWidget {
  const SubscriptionProfileTabView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sub = ref.watch(currentSubscriptionProvider);
    final state = ref.watch(subscriptionControllerProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (sub == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final startDateStr =
        '${sub.startDate.year}/${sub.startDate.month.toString().padLeft(2, '0')}/${sub.startDate.day.toString().padLeft(2, '0')}';
    final endDateStr =
        '${sub.endDate.year}/${sub.endDate.month.toString().padLeft(2, '0')}/${sub.endDate.day.toString().padLeft(2, '0')}';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Subscription Status Header Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.workspace_premium_rounded,
                            color: AppColors.primary, size: 22),
                        const SizedBox(width: 8),
                        Text(
                          sub.planName,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: sub.isExpired
                            ? Colors.red.shade50
                            : Colors.green.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: sub.isExpired
                                ? Colors.red.shade300
                                : Colors.green.shade300),
                      ),
                      child: Text(
                        sub.isExpired ? 'منتهي' : 'نشط 🟢',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: sub.isExpired
                              ? Colors.red.shade900
                              : Colors.green.shade900,
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24),

                // Key Info Grid
                _buildInfoRow('تاريخ البداية', startDateStr),
                _buildInfoRow('تاريخ الانتهاء', endDateStr),
                _buildInfoRow('الأيام المتبقية', '${sub.remainingDays} يوم'),
                _buildInfoRow('المنتجات المستخدمة',
                    '${sub.productsUsed} من أصل ${sub.productsLimit}'),
                _buildInfoRow(
                    'المنتجات المتبقية', '${sub.remainingProducts} منتج'),
                _buildInfoRow('حد الصور لكل منتج', '${sub.imagesPerProduct} صور'),
                _buildInfoRow('حد الفيديو لكل منتج', '${sub.videosPerProduct} فيديو'),
                _buildInfoRow('حد PDF لكل منتج', '${sub.pdfPerProduct} ملفات'),
                _buildInfoRow('عدد الموظفين المسموح', '${sub.employeeLimit} موظفين'),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 2. Action Buttons (Upgrade & Renew)
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => context.push('/subscription/plans'),
                  icon: const Icon(Icons.arrow_upward_rounded, size: 16),
                  label: const Text('ترقية الباقة (Upgrade)'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(0, 42),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () async {
                    await ref
                        .read(subscriptionControllerProvider.notifier)
                        .renewSubscription();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('تم تجديد الاشتراك بنجاح 🔄'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.autorenew_rounded, size: 16),
                  label: const Text('تجديد الاشتراك (Renew)'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 42),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 3. Subscription Features Checklist
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'المميزات والخصائص المفعلة',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
                ),
                const SizedBox(height: 10),
                _buildFeatureCheck('إمكانية نشر المنتجات', sub.canPublishProducts),
                _buildFeatureCheck('إمكانية تعديل المنتجات', sub.canEditProducts),
                _buildFeatureCheck('إعادة النشر والتسويق', sub.canRepublishProducts),
                _buildFeatureCheck('التحليلات والمؤشرات المتقدمة', sub.analyticsEnabled),
                _buildFeatureCheck('الدعم الفني ذو الأولوية 24/7', sub.prioritySupport),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 4. Invoices Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'الفواتير والمطالبات المالية',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
                ),
                const SizedBox(height: 10),
                if (state.invoices.isEmpty)
                  const Text('لا توجد فواتير حتي الآن',
                      style: TextStyle(fontSize: 11, color: Colors.grey))
                else
                  ...state.invoices.map(
                    (inv) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.receipt_long_rounded,
                          color: AppColors.primary),
                      title: Text(inv.planName,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12)),
                      subtitle: Text(
                          'رقم الفاتورة: ${inv.invoiceId} • ${inv.paymentMethod}',
                          style: const TextStyle(fontSize: 10)),
                      trailing: Text(
                        '${inv.amount} ${inv.currency}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.green),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 5. Renewal History Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'سجل التجديد والترقيات',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
                ),
                const SizedBox(height: 10),
                if (state.history.isEmpty)
                  const Text('لا يوجد سجل عمليات سابق',
                      style: TextStyle(fontSize: 11, color: Colors.grey))
                else
                  ...state.history.map(
                    (h) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.history_rounded,
                          color: Colors.orange),
                      title: Text(h.action,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12)),
                      subtitle: Text(h.notes,
                          style: const TextStyle(fontSize: 10)),
                      trailing: Text(
                        '${h.timestamp.year}/${h.timestamp.month}/${h.timestamp.day}',
                        style: const TextStyle(
                            fontSize: 10, color: Colors.grey),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: TextStyle(fontSize: 11.5, color: Colors.grey.shade700)),
          Text(value,
              style:
                  const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildFeatureCheck(String title, bool isEnabled) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        children: [
          Icon(
            isEnabled ? Icons.check_circle_rounded : Icons.cancel_rounded,
            size: 16,
            color: isEnabled ? Colors.green : Colors.grey.shade400,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 11.5,
              color: isEnabled ? Colors.black87 : Colors.grey.shade600,
              decoration: isEnabled ? null : TextDecoration.lineThrough,
            ),
          ),
        ],
      ),
    );
  }
}


