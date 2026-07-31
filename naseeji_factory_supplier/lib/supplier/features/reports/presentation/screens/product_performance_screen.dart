import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../../../dashboard/presentation/controllers/analytics_report_controller.dart';
import '../widgets/report_filter_bar.dart';
import '../widgets/report_section_header.dart';
import '../widgets/report_stat_row.dart';

class ProductPerformanceScreen extends ConsumerWidget {
  const ProductPerformanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataAsync = ref.watch(analyticsReportDataProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0.5,
        title: Text('أداء المنتجات التفصيلي',
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 16)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.onSurfaceVariant, size: 20),
          onPressed: () => context.canPop() ? context.pop() : context.go('/reports/products'),
        ),
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
                ReportSectionHeader(
                  title: 'تفاصيل أداء كل منتج',
                  subtitle: 'المشاهدات والزوار وطلبات الأسعار',
                  icon: Icons.analytics_outlined,
                  iconColor: const Color(0xFFD97706),
                ),
                const SizedBox(height: 12),
                ...data.productPerformance.map((p) => _buildProductCard(context, p)),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, Map<String, dynamic> product) {
    final convRate = product['rfqs'] != null && product['views'] != null && (product['views'] as int) > 0
        ? ((product['rfqs'] as int) / (product['views'] as int) * 100).toStringAsFixed(1)
        : '0.0';

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Product header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  product['sku'] as String? ?? '',
                  style: const TextStyle(fontSize: 10, color: AppColors.primary, fontWeight: FontWeight.bold),
                ),
              ),
              const Spacer(),
              Text(
                product['name'] as String? ?? '',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                textAlign: TextAlign.right,
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),

          // Stats
          ReportStatRow(label: 'المشاهدات', value: (product['views'] as int? ?? 0).toString(), icon: Icons.visibility_outlined, iconColor: const Color(0xFF0040E0)),
          const ReportStatDivider(),
          ReportStatRow(label: 'زوار فريدون', value: (product['visitors'] as int? ?? 0).toString(), icon: Icons.people_outline, iconColor: const Color(0xFF7C3AED)),
          const ReportStatDivider(),
          ReportStatRow(label: 'طلبات أسعار (RFQs)', value: (product['rfqs'] as int? ?? 0).toString(), icon: Icons.request_quote_outlined, iconColor: const Color(0xFFD97706)),
          const ReportStatDivider(),
          ReportStatRow(label: 'مفاوضات', value: (product['negotiations'] as int? ?? 0).toString(), icon: Icons.handshake_outlined, iconColor: const Color(0xFF0891B2)),
          const ReportStatDivider(),
          ReportStatRow(label: 'طلبات مكتملة', value: (product['orders'] as int? ?? 0).toString(), icon: Icons.check_circle_outline, iconColor: const Color(0xFF00875A)),
          const ReportStatDivider(),
          ReportStatRow(
            label: 'الإيرادات',
            value: '${((product['revenue'] as num?) ?? 0).toStringAsFixed(0)} ج',
            icon: Icons.monetization_on_outlined,
            iconColor: const Color(0xFF00875A),
          ),
          const ReportStatDivider(),
          ReportStatRow(label: 'معدل التحويل', value: '$convRate%', icon: Icons.swap_horiz_outlined, iconColor: const Color(0xFFEC4899)),
          const ReportStatDivider(),
          ReportStatRow(
            label: 'تقييم العملاء',
            value: '${((product['rating'] as num?) ?? 0).toStringAsFixed(1)} ⭐',
            icon: Icons.star_outline,
            iconColor: const Color(0xFFF59E0B),
          ),
        ],
      ),
    );
  }
}
