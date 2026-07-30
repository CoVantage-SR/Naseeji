import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/widgets/reusable_widgets.dart';

/// 1. StatisticsHeaderWidget
class StatisticsHeaderWidget extends StatelessWidget {
  final String monthlyPurchases;
  final String averageCost;

  const StatisticsHeaderWidget({
    super.key,
    required this.monthlyPurchases,
    required this.averageCost,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.primary.withValues(alpha: 0.05),
        borderRadius: AppRadius.rLG,
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.primary.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'نظرة عامة على المشتريات والإنتاج',
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          AppSpacing.hLG,
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'مشتريات الشهر',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      monthlyPurchases,
                      style: context.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 1.5,
                height: 40,
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'متوسط تكلفة الطلب',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      averageCost,
                      style: context.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// 2. OrdersChartWidget - Custom bar chart using standard Flutter widgets
class OrdersChartWidget extends StatelessWidget {
  final List<Map<String, dynamic>> chartData;

  const OrdersChartWidget({super.key, required this.chartData});

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    final int maxValue = chartData.map((e) => (e['value'] as int)).reduce((a, b) => a > b ? a : b);

    return PrimaryCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'حجم الطلبات الشهري',
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          AppSpacing.hLG,
          SizedBox(
            height: 180,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: chartData.map((item) {
                final String month = item['month'] ?? '';
                final int value = item['value'] ?? 0;
                final double barPercent = value / (maxValue == 0 ? 1 : maxValue);
                final double barHeight = 120 * barPercent;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      value.toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                    ),
                    const SizedBox(height: 4),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      width: 24,
                      height: barHeight,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      month,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        fontSize: 10,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

/// 3. PurchaseChartWidget - Custom category progress bars (donut representation)
class PurchaseChartWidget extends StatelessWidget {
  final List<Map<String, dynamic>> distribution;

  const PurchaseChartWidget({super.key, required this.distribution});

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;

    return PrimaryCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'توزيع المشتريات حسب الفئة',
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          AppSpacing.hLG,
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: distribution.length,
            separatorBuilder: (context, index) => AppSpacing.hMD,
            itemBuilder: (context, index) {
              final item = distribution[index];
              final String category = item['category'] ?? '';
              final double percent = item['percent'] ?? 0.0;
              final double fraction = percent / 100.0;

              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        category,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        '${percent.toInt()}%',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: AppRadius.rRound,
                    child: LinearProgressIndicator(
                      value: fraction,
                      color: AppColors.primary,
                      backgroundColor: isDark ? AppColors.borderDark : AppColors.borderLight,
                      minHeight: 8,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

/// 4. TopSuppliersWidget
class TopSuppliersWidget extends StatelessWidget {
  const TopSuppliersWidget({super.key});

  final List<Map<String, dynamic>> _topSuppliers = const [
    {
      'name': 'الشركة الدولية للخيوط',
      'share': '٤٥% من الطلبات',
      'logo_url': '',
    },
    {
      'name': 'مصنع النيل للأقمشة',
      'share': '٣٠% من الطلبات',
      'logo_url': '',
    },
    {
      'name': 'الفتح لمستلزمات المصانع',
      'share': '١٥% من الطلبات',
      'logo_url': '',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;

    return PrimaryCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'أكثر الموردين تعاملاً',
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          AppSpacing.hLG,
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _topSuppliers.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final sup = _topSuppliers[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    SupplierAvatar(name: sup['name']!, size: 40),
                    AppSpacing.wMD,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            sup['name']!,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            sup['share']!,
                            style: context.textTheme.bodySmall?.copyWith(
                              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_back_ios_new_rounded, size: 14, color: Colors.grey),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
