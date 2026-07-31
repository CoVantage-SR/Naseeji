import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../../../dashboard/presentation/controllers/analytics_report_controller.dart';
import '../../../financial/presentation/widgets/financial_summary_card.dart';
import '../widgets/report_filter_bar.dart';
import '../widgets/report_section_header.dart';
import '../widgets/report_stat_row.dart';

class ProductsReportScreen extends ConsumerWidget {
  const ProductsReportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataAsync = ref.watch(analyticsReportDataProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0.5,
        title: Text('تقرير المنتجات',
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 16)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.onSurfaceVariant, size: 20),
          onPressed: () => context.canPop() ? context.pop() : context.go('/reports'),
        ),
        actions: [
          TextButton.icon(
            onPressed: () => context.go('/reports/products/performance'),
            icon: const Icon(Icons.analytics_outlined, size: 16, color: AppColors.primary),
            label: const Text('أداء تفصيلي', style: TextStyle(fontSize: 12, color: AppColors.primary)),
          ),
        ],
      ),
      body: dataAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (e, _) => Center(child: Text('خطأ: $e')),
        data: (data) {
          final published = (data.totalProducts * 0.7).round();
          final hidden = (data.totalProducts * 0.1).round();
          final paused = (data.totalProducts * 0.1).round();
          final outOfStock = (data.totalProducts * 0.1).round();

          return RefreshIndicator(
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

                  // Summary Cards
                  ReportSectionHeader(title: 'ملخص المنتجات', icon: Icons.category_outlined, iconColor: const Color(0xFFD97706)),
                  const SizedBox(height: 12),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.35,
                    children: [
                      FinancialSummaryCard(title: 'إجمالي المنتجات', value: data.totalProducts.toDouble(), currency: 'منتج', icon: Icons.category_outlined, iconColor: const Color(0xFFD97706)),
                      FinancialSummaryCard(title: 'منتجات منشورة', value: published.toDouble(), currency: 'منتج', icon: Icons.visibility_outlined, iconColor: const Color(0xFF00875A)),
                      FinancialSummaryCard(title: 'منتجات مخفية', value: hidden.toDouble(), currency: 'منتج', icon: Icons.visibility_off_outlined, iconColor: const Color(0xFF6366F1)),
                      FinancialSummaryCard(title: 'نفدت الكمية', value: outOfStock.toDouble(), currency: 'منتج', icon: Icons.remove_shopping_cart_outlined, iconColor: const Color(0xFFDE350B)),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Status details
                  ReportSectionHeader(title: 'تفصيل حالات المنتجات', icon: Icons.list_alt_outlined),
                  const SizedBox(height: 12),
                  _buildStatCard(context, [
                    _Stat('منشورة ونشطة', published.toString(), Icons.check_circle_outline, const Color(0xFF00875A)),
                    _Stat('مخفية مؤقتاً', hidden.toString(), Icons.visibility_off_outlined, const Color(0xFF6366F1)),
                    _Stat('موقوفة', paused.toString(), Icons.pause_circle_outline, const Color(0xFFB45309)),
                    _Stat('نفدت الكمية', outOfStock.toString(), Icons.remove_shopping_cart_outlined, const Color(0xFFDE350B)),
                  ]),
                  const SizedBox(height: 20),

                  // Top Performers
                  ReportSectionHeader(title: 'أفضل المنتجات أداءً', icon: Icons.workspace_premium_outlined, iconColor: const Color(0xFFD97706)),
                  const SizedBox(height: 12),
                  ...data.productPerformance.asMap().entries.map((entry) {
                    final i = entry.key;
                    final p = entry.value;
                    return _buildProductRankCard(context, i + 1, p);
                  }),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductRankCard(BuildContext context, int rank, Map<String, dynamic> product) {
    final colors = [const Color(0xFFD97706), const Color(0xFF6366F1), const Color(0xFF0891B2)];
    final color = rank <= colors.length ? colors[rank - 1] : AppColors.outline;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: Text('$rank', style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 14)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(product['name'] as String? ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13), textAlign: TextAlign.right),
                Text('${product['orders'] ?? 0} طلب  •  ${product['views'] ?? 0} مشاهدة', style: const TextStyle(fontSize: 11, color: AppColors.outline), textAlign: TextAlign.right),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${((product['revenue'] as num?) ?? 0).toStringAsFixed(0)} ج', style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 13)),
              const Text('الإيرادات', style: TextStyle(fontSize: 10, color: AppColors.outline)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, List<_Stat> stats) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: stats.expand((s) => [
          ReportStatRow(label: s.label, value: s.value, icon: s.icon, iconColor: s.color),
          if (s != stats.last) const ReportStatDivider(),
        ]).toList(),
      ),
    );
  }
}

class _Stat {
  final String label, value;
  final IconData icon;
  final Color color;
  const _Stat(this.label, this.value, this.icon, this.color);
}
