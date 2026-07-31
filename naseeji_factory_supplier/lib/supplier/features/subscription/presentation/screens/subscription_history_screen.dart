import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naseeji_factory/core/theme/app_colors.dart';
import '../controllers/subscription_controllers.dart';

class SubscriptionHistoryScreen extends ConsumerWidget {
  const SubscriptionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(subscriptionHistoryControllerProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          elevation: 0.5,
          title: Text(
            'سجل عمليات الاشتراكات',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Theme.of(context).colorScheme.onSurface),
          ),
          centerTitle: true,
        ),
        body: Material(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: historyAsync.when(
            loading: () => Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('خطأ: $e')),
            data: (history) {
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: history.length,
                itemBuilder: (context, index) {
                  final item = history[index];
                  final startStr = '${item.startDate.year}/${item.startDate.month.toString().padLeft(2, '0')}/${item.startDate.day.toString().padLeft(2, '0')}';
                  final endStr = '${item.endDate.year}/${item.endDate.month.toString().padLeft(2, '0')}/${item.endDate.day.toString().padLeft(2, '0')}';

                  final bool isActive = item.status == 'نشط';

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: isActive
                                    ? const Color(0xFF006B5F).withValues(alpha: 0.1)
                                    : AppColors.outline.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                item.status,
                                style: TextStyle(
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                  color: isActive ? const Color(0xFF006B5F) : AppColors.outline,
                                ),
                              ),
                            ),
                            Text(
                              item.planName,
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        const Divider(color: AppColors.outlineVariant),
                        SizedBox(height: 8),

                        _buildInfoRow(context, 'مدة الباقة', '${item.billingCycle} | $startStr - $endStr'),
                        _buildInfoRow(context, 'تكلفة الاشتراك المدفوعة', '${item.price.toStringAsFixed(0)} جنيه'),
                        _buildInfoRow(context, 'حالة سداد الدفعة', item.paymentStatus),
                        _buildInfoRow(context, 'رقم الفاتورة المرجعي', item.invoiceNumber),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            value,
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF111827)),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 11, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280)),
          ),
        ],
      ),
    );
  }
}


