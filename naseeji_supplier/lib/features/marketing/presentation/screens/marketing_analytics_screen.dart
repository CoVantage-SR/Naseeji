import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../controllers/marketing_controllers.dart';
import '../widgets/marketing_chart_widget.dart';

class MarketingAnalyticsScreen extends ConsumerStatefulWidget {
  const MarketingAnalyticsScreen({super.key});

  @override
  ConsumerState<MarketingAnalyticsScreen> createState() => _MarketingAnalyticsScreenState();
}

class _MarketingAnalyticsScreenState extends ConsumerState<MarketingAnalyticsScreen> {
  String _selectedReportType = 'المبيعات والأرباح';

  final List<String> _reportTypes = [
    'المبيعات والأرباح',
    'الوصول والتفاعل',
    'معدلات التحويل والـ ROAS'
  ];

  @override
  Widget build(BuildContext context) {
    final analyticsAsync = ref.watch(marketingAnalyticsControllerProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          title: const Text(
            'تحليلات وتقارير التسويق',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.onSurface),
          ),
          centerTitle: true,
        ),
        body: Material(
          color: const Color(0xFFF8F9FF),
          child: analyticsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('خطأ: $e')),
            data: (data) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Report Type Selector
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedReportType,
                          items: _reportTypes.map((type) {
                            return DropdownMenuItem<String>(
                              value: type,
                              child: Text(type, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold), textAlign: TextAlign.right),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => _selectedReportType = val);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Selected Charts
                    if (_selectedReportType == 'المبيعات والأرباح') ...[
                      MarketingChartWidget(
                        title: 'الإيرادات الشهرية الناتجة من الإعلانات (ر.س)',
                        values: data.monthlyRevenue,
                        labels: const ['مارس', 'أبريل', 'مايو', 'يونيو', 'يوليو'],
                        chartType: 'bar',
                      ),
                      const SizedBox(height: 16),
                      MarketingChartWidget(
                        title: 'حجم الطلبات المولدة إعلانياً',
                        values: data.monthlyOrders,
                        labels: const ['مارس', 'أبريل', 'مايو', 'يونيو', 'يوليو'],
                        chartType: 'bar',
                      ),
                    ] else if (_selectedReportType == 'الوصول والتفاعل') ...[
                      MarketingChartWidget(
                        title: 'معدلات الوصول الكلية للمصانع والزيارات',
                        values: data.monthlyReach,
                        secondaryValues: data.monthlyClicks,
                        labels: const ['مارس', 'أبريل', 'مايو', 'يونيو', 'يوليو'],
                        chartType: 'double_bar',
                      ),
                      const SizedBox(height: 16),
                      MarketingChartWidget(
                        title: 'معدل النقر CTR الإجمالي (%)',
                        values: data.monthlyCtr,
                        labels: const ['مارس', 'أبريل', 'مايو', 'يونيو', 'يوليو'],
                        chartType: 'bar',
                      ),
                    ] else if (_selectedReportType == 'معدلات التحويل والـ ROAS') ...[
                      MarketingChartWidget(
                        title: 'العائد على الإنفاق ROAS',
                        values: data.monthlyRoas,
                        labels: const ['مارس', 'أبريل', 'مايو', 'يونيو', 'يوليو'],
                        chartType: 'bar',
                      ),
                      const SizedBox(height: 16),
                      MarketingChartWidget(
                        title: 'نسب التفاعل بحسب الحملة التسويقية',
                        values: data.bestCampaigns.map((c) => c['revenue'] as double).toList(),
                        labels: data.bestCampaigns.map((c) => c['name'] as String).toList(),
                        chartType: 'donut',
                      ),
                    ],
                    const SizedBox(height: 24),

                    // Top Campaigns table B2B
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            'الحملات الأكثر فاعلية وأرباحاً',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.onSurface),
                          ),
                          const SizedBox(height: 12),
                          const Divider(color: AppColors.outlineVariant),
                          ...data.bestCampaigns.map((c) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('${(c['roas'] as double).toStringAsFixed(1)}x ROAS', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF006B5F))),
                                  Text('${(c['revenue'] as double).toStringAsFixed(0)} ر.س', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
                                  Expanded(
                                    child: Text(
                                      c['name'] as String,
                                      style: const TextStyle(fontSize: 11, color: AppColors.onSurface),
                                      textAlign: TextAlign.right,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // CRM integration table: best factory customers
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            'أكثر المصانع استجابة وشراءً (CRM Integration)',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.onSurface),
                          ),
                          const SizedBox(height: 12),
                          const Divider(color: AppColors.outlineVariant),
                          ...data.bestCustomers.map((cust) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('${cust['orders']} طلبية', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0040E0))),
                                  Text('${(cust['revenue'] as double).toStringAsFixed(0)} ر.س', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          cust['factoryName'] as String,
                                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.onSurface),
                                          textAlign: TextAlign.right,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          'قطاع: ${cust['industry']}',
                                          style: const TextStyle(fontSize: 9, color: AppColors.onSurfaceVariant),
                                          textAlign: TextAlign.right,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
