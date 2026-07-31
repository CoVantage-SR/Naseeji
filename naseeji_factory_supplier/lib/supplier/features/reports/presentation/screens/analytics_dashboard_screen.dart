import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_factory/supplier/core/theme/app_colors.dart';
import '../../../dashboard/presentation/controllers/analytics_report_controller.dart';
import '../../../financial/presentation/widgets/financial_chart_widget.dart';
import '../../../financial/presentation/widgets/financial_summary_card.dart';
import '../widgets/report_filter_bar.dart';
import '../widgets/report_nav_card.dart';
import '../widgets/report_section_header.dart';

class AnalyticsDashboardScreen extends ConsumerWidget {
  const AnalyticsDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataAsync = ref.watch(analyticsReportDataProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0.5,
        title: Text(
          'لوحة التقارير والتحليلات',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.onSurfaceVariant, size: 20),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/home');
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.auto_awesome_outlined, color: AppColors.primary, size: 22),
            tooltip: 'رؤى الذكاء الاصطناعي',
            onPressed: () => context.go('/reports/ai-insights'),
          ),
        ],
      ),
      body: dataAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (e, _) => Center(child: Text('خطأ: $e')),
        data: (data) => RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () => ref.refresh(analyticsReportDataProvider.future),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const ReportFilterBar(),
                const SizedBox(height: 20),

                // KPI Cards
                ReportSectionHeader(
                  title: 'مؤشرات الأداء الرئيسية (KPIs)',
                  subtitle: 'نظرة شاملة على أداء شغلك',
                  icon: Icons.dashboard_outlined,
                ),
                const SizedBox(height: 12),
                _buildKpiGrid(context, data),
                const SizedBox(height: 24),

                // Sales Chart
                ReportSectionHeader(title: 'اتجاه المبيعات', icon: Icons.show_chart),
                const SizedBox(height: 12),
                FinancialChartWidget(
                  title: 'المبيعات خلال الفترة',
                  data: data.salesTrend
                      .map((e) => {'month': e['label'] ?? '', 'value': e['value'] ?? 0.0})
                      .toList(),
                  type: 'bar',
                ),
                const SizedBox(height: 16),

                // Revenue vs Expenses
                FinancialChartWidget(
                  title: 'الإيرادات مقابل المصروفات',
                  data: data.revenueExpensesTrend
                      .map((e) => {
                            'label': e['label'] ?? '',
                            'inflow': e['revenue'] ?? 0.0,
                            'outflow': e['expenses'] ?? 0.0,
                          })
                      .toList(),
                  type: 'double_bar',
                ),
                const SizedBox(height: 16),

                // Orders Status Distribution
                FinancialChartWidget(
                  title: 'توزيع حالات الطلبات',
                  data: data.orderStatusDistribution
                      .map((e) => {
                            'label': e['status'] ?? '',
                            'value': (e['count'] as int? ?? 0).toDouble(),
                            'color': (e['color'] as Color?)?.value ?? 0xFF0040E0,
                          })
                      .toList(),
                  type: 'donut',
                ),
                const SizedBox(height: 24),

                // Navigation Cards Grid
                ReportSectionHeader(
                  title: 'التقارير التفصيلية',
                  subtitle: 'اضغط لعرض تقرير كامل',
                  icon: Icons.list_alt_outlined,
                ),
                const SizedBox(height: 12),
                _buildNavGrid(context, data),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildKpiGrid(BuildContext context, ReportData data) {
    final kpis = [
      _KpiItem('إجمالي المبيعات', _formatCurrency(data.totalSales), Icons.monetization_on_outlined, const Color(0xFF0040E0)),
      _KpiItem('صافي الأرباح', _formatCurrency(data.netProfit), Icons.trending_up, const Color(0xFF00875A)),
      _KpiItem('إجمالي الطلبات', '${data.totalOrders} طلب', Icons.inventory_2_outlined, const Color(0xFF6366F1)),
      _KpiItem('طلبات معلقة', '${data.pendingOrders} طلب', Icons.hourglass_empty_outlined, const Color(0xFFB45309)),
      _KpiItem('طلبات مكتملة', '${data.completedOrders} طلب', Icons.check_circle_outline, const Color(0xFF00875A)),
      _KpiItem('طلبات ملغاة', '${data.cancelledOrders} طلب', Icons.cancel_outlined, const Color(0xFFDE350B)),
      _KpiItem('عملاء جدد', '${data.newCustomers} عميل', Icons.person_add_outlined, const Color(0xFF0891B2)),
      _KpiItem('عملاء عائدون', '${data.returningCustomers} عميل', Icons.people_outline, const Color(0xFF7C3AED)),
      _KpiItem('إجمالي المنتجات', '${data.totalProducts} منتج', Icons.category_outlined, const Color(0xFFD97706)),
      _KpiItem('إعلانات نشطة', '${data.activeAds} إعلان', Icons.campaign_outlined, const Color(0xFFEC4899)),
      _KpiItem('الاشتراك الحالي', data.currentSubscriptionPlan, Icons.workspace_premium_outlined, const Color(0xFF059669)),
      _KpiItem('رصيد المحفظة', _formatCurrency(data.walletBalance), Icons.account_balance_wallet_outlined, const Color(0xFF0284C7)),
      _KpiItem('تقييم العملاء', '${data.averageRating.toStringAsFixed(1)} ⭐', Icons.star_outline, const Color(0xFFF59E0B)),
      _KpiItem('نمو الإيرادات', '+${data.revenueGrowth.toStringAsFixed(1)}%', Icons.area_chart_outlined, const Color(0xFF16A34A)),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.4,
      ),
      itemCount: kpis.length,
      itemBuilder: (context, i) {
        final kpi = kpis[i];
        // Use value=0 and put the formatted text in currency to display text-only KPI
        return FinancialSummaryCard(
          title: kpi.title,
          value: 0,
          currency: kpi.value,
          icon: kpi.icon,
          iconColor: kpi.color,
        );
      },
    );
  }

  Widget _buildNavGrid(BuildContext context, ReportData data) {
    final items = [
      _NavItem('المبيعات', 'اتجاه المبيعات والإيرادات', Icons.show_chart, const Color(0xFF0040E0), _formatCurrency(data.totalSales), '/reports/sales'),
      _NavItem('الطلبات', 'حالات وأداء الطلبات', Icons.inventory_2_outlined, const Color(0xFF6366F1), data.totalOrders.toString(), '/reports/orders'),
      _NavItem('المنتجات', 'أداء وتفاصيل المنتجات', Icons.category_outlined, const Color(0xFFD97706), data.totalProducts.toString(), '/reports/products'),
      _NavItem('العملاء', 'قاعدة العملاء ونموهم', Icons.people_outline, const Color(0xFF0891B2), '${data.newCustomers + data.returningCustomers}', '/reports/customers'),
      _NavItem('عروض الأسعار', 'معدل الفوز والمفاوضات', Icons.request_quote_outlined, const Color(0xFF7C3AED), '${data.winRate.toStringAsFixed(0)}%', '/reports/quotations'),
      _NavItem('المالية', 'الإيرادات والمصروفات', Icons.account_balance_outlined, const Color(0xFF00875A), _formatCurrency(data.netProfit), '/reports/financial'),
      _NavItem('الشحن', 'أداء الشحن والتوصيل', Icons.local_shipping_outlined, const Color(0xFF0284C7), '${data.avgShippingDays.toStringAsFixed(1)} يوم', '/reports/shipping'),
      _NavItem('الاشتراك', 'استخدام الخطة والحدود', Icons.workspace_premium_outlined, const Color(0xFF059669), data.currentSubscriptionPlan, '/reports/subscription'),
      _NavItem('الإعلانات', 'أداء وعائد الإعلانات', Icons.campaign_outlined, const Color(0xFFEC4899), data.activeAds.toString(), '/reports/advertisements'),
      _NavItem('الأداء العام', 'معدلات الاستجابة والقبول', Icons.speed_outlined, const Color(0xFFB45309), '${data.averageRating.toStringAsFixed(1)}★', '/reports/performance'),
      _NavItem('رؤى الذكاء الاصطناعي', 'توصيات ذكية مخصصة', Icons.auto_awesome_outlined, const Color(0xFF6366F1), 'جديد', '/reports/ai-insights'),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.25,
      ),
      itemCount: items.length,
      itemBuilder: (context, i) {
        final item = items[i];
        return ReportNavCard(
          title: item.title,
          subtitle: item.subtitle,
          icon: item.icon,
          iconColor: item.color,
          value: item.value,
          onTap: () => context.go(item.route),
        );
      },
    );
  }

  String _formatCurrency(double v) {
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}م ج';
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(1)}ك ج';
    return '${v.toStringAsFixed(0)} ج';
  }
}

class _KpiItem {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  const _KpiItem(this.title, this.value, this.icon, this.color);
}

class _NavItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String value;
  final String route;
  const _NavItem(this.title, this.subtitle, this.icon, this.color, this.value, this.route);
}

