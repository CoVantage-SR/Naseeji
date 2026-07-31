import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naseeji_factory/core/theme/app_colors.dart';
import '../controllers/subscription_controllers.dart';
import '../widgets/subscription_chart.dart';

class SubscriptionAnalyticsScreen extends ConsumerWidget {
  const SubscriptionAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsAsync = ref.watch(subscriptionAnalyticsControllerProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          elevation: 0.5,
          title: Text(
            'تحليلات وإحصائيات الاشتراك',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Theme.of(context).colorScheme.onSurface),
          ),
          centerTitle: true,
        ),
        body: Material(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: analyticsAsync.when(
            loading: () => Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('خطأ: $e')),
            data: (data) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Summary KPIs
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
                            'الملخص المالي والوفورات B2B',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                          ),
                          const Divider(height: 20, color: AppColors.outlineVariant),
                          _buildKpiRow('تكلفة الاشتراك الشهري', '${data.subscriptionCost.toStringAsFixed(0)} جنيه'),
                          _buildKpiRow('إجمالي الإنفاق على الملحقات', '${data.addonSpending.toStringAsFixed(0)} جنيه'),
                          _buildKpiRow('العائد المالي المقدر للاستثمار (ROI)', '${data.roi}x'),
                          _buildKpiRow('إجمالي الوفورات المالية المقدرة بالباقة', '${data.subscriptionSavings.toStringAsFixed(0)} جنيه'),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),

                    // Spending Chart
                    SubscriptionChart(
                      title: 'الإنفاق الشهري للاشتراكات والخدمات (جنيه)',
                      values: data.monthlySpending,
                      labels: const ['مارس', 'أبريل', 'مايو', 'يونيو', 'يوليو'],
                      chartType: 'bar',
                    ),
                    SizedBox(height: 16),

                    // Feature Distribution Chart
                    SubscriptionChart(
                      title: 'توزيع استخدام وتفاعل موارد الباقة الحالية',
                      values: data.featureUsagePercent.values.toList(),
                      labels: data.featureUsagePercent.keys.toList(),
                      chartType: 'donut',
                    ),
                    SizedBox(height: 16),

                    // Storage Growth Chart
                    SubscriptionChart(
                      title: 'نمو مساحة التخزين المستخدمة (جيجابايت)',
                      values: data.storageGrowthGb,
                      labels: const ['مارس', 'أبريل', 'مايو', 'يونيو', 'يوليو'],
                      chartType: 'line',
                    ),
                    SizedBox(height: 24),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildKpiRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            value,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.onSurface),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

