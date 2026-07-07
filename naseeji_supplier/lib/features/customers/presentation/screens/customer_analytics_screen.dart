import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../controllers/customers_controller.dart';
import '../../domain/entities/customer_model.dart';
import '../widgets/customer_statistics_card.dart';

class CustomerAnalyticsScreen extends ConsumerWidget {
  final String customerId;

  const CustomerAnalyticsScreen({super.key, required this.customerId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateAsync = ref.watch(customersControllerProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FF),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          centerTitle: true,
          title: const Text('تحليلات العميل', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 16)),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: AppColors.onSurfaceVariant),
            onPressed: () => context.pop(),
          ),
        ),
        body: stateAsync.when(
          loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
          error: (e, _) => Center(child: Text('خطأ: $e')),
          data: (customers) {
            final idx = customers.indexWhere((c) => c.id == customerId);
            if (idx == -1) return const Center(child: Text('العميل غير موجود'));
            final c = customers[idx];
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildKpiGrid(c),
                const SizedBox(height: 16),
                _buildRevenueChart(c),
                const SizedBox(height: 16),
                _buildTopProducts(c),
                const SizedBox(height: 16),
                _buildPaymentHealth(c),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildKpiGrid(CustomerModel c) {
    final acceptanceRate = c.totalQuotations > 0
        ? (c.acceptedQuotations / c.totalQuotations * 100)
        : 0.0;
    final repeatRate = c.totalOrders > 1 ? 85.0 : 0.0;

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 1.3,
      children: [
        CustomerStatisticsCard(
          label: 'إجمالي الإيرادات',
          value: '${(c.totalRevenue / 1000).toStringAsFixed(1)}ك ر.س',
          icon: Icons.monetization_on_outlined,
          color: AppColors.primary,
        ),
        CustomerStatisticsCard(
          label: 'متوسط الطلب',
          value: '${(c.averageOrderValue / 1000).toStringAsFixed(1)}ك ر.س',
          icon: Icons.analytics_outlined,
          color: AppColors.secondary,
        ),
        CustomerStatisticsCard(
          label: 'إجمالي الطلبات',
          value: c.totalOrders.toString(),
          icon: Icons.shopping_bag_outlined,
          color: AppColors.tertiary,
        ),
        CustomerStatisticsCard(
          label: 'قبول العروض',
          value: '${acceptanceRate.toStringAsFixed(0)}٪',
          icon: Icons.check_circle_outline,
          color: Colors.green,
        ),
        CustomerStatisticsCard(
          label: 'نجاح التفاوض',
          value: '${c.negotiationSuccessRate.toStringAsFixed(0)}٪',
          icon: Icons.gavel,
          color: AppColors.secondary,
        ),
        CustomerStatisticsCard(
          label: 'موثوقية الدفع',
          value: c.averagePaymentTime <= 7 ? 'ممتازة' : c.averagePaymentTime <= 14 ? 'جيدة' : 'ضعيفة',
          icon: Icons.payments_outlined,
          color: c.averagePaymentTime <= 7 ? Colors.green : c.averagePaymentTime <= 14 ? const Color(0xFFFFB800) : AppColors.error,
        ),
        CustomerStatisticsCard(
          label: 'متوسط وقت الدفع',
          value: '${c.averagePaymentTime.toStringAsFixed(0)} يوم',
          icon: Icons.timer_outlined,
          color: AppColors.outline,
        ),
        CustomerStatisticsCard(
          label: 'تكرار الشراء',
          value: '${repeatRate.toStringAsFixed(0)}٪',
          icon: Icons.repeat,
          color: const Color(0xFF993100),
        ),
      ],
    );
  }

  Widget _buildRevenueChart(CustomerModel c) {
    if (c.monthlyRevenue.isEmpty) return const SizedBox.shrink();
    final maxAmount = c.monthlyRevenue.map((m) => m.amount).reduce((a, b) => a > b ? a : b);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E1EF), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('الإيرادات الشهرية (ر.س)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary)),
          const SizedBox(height: 16),
          SizedBox(
            height: 140,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: c.monthlyRevenue.map((m) {
                final ratio = maxAmount > 0 ? m.amount / maxAmount : 0.0;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '${(m.amount / 1000).toStringAsFixed(0)}ك',
                          style: const TextStyle(fontSize: 7, color: AppColors.outline),
                        ),
                        const SizedBox(height: 3),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 600),
                          height: 100 * ratio,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.6)],
                            ),
                            borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4)),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          m.month.substring(0, m.month.length < 3 ? m.month.length : 3),
                          style: const TextStyle(fontSize: 7, color: AppColors.outline),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopProducts(CustomerModel c) {
    if (c.topProducts.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E1EF), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('أكثر المنتجات طلباً', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary)),
          const SizedBox(height: 12),
          ...c.topProducts.asMap().entries.map((entry) {
            final colors = [AppColors.primary, AppColors.secondary, AppColors.tertiary];
            final color = colors[entry.key % colors.length];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(children: [
                Container(
                  width: 24, height: 24,
                  decoration: BoxDecoration(color: color.withValues(alpha: 0.15), shape: BoxShape.circle),
                  child: Center(child: Text('${entry.key + 1}', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color))),
                ),
                const SizedBox(width: 10),
                Expanded(child: Text(entry.value, style: const TextStyle(fontSize: 12, color: AppColors.onSurface))),
                Icon(Icons.trending_up, size: 16, color: color),
              ]),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPaymentHealth(CustomerModel c) {
    final health = c.averagePaymentTime <= 7 ? 1.0 : c.averagePaymentTime <= 14 ? 0.65 : 0.3;
    final color = health > 0.7 ? Colors.green : health > 0.5 ? const Color(0xFFFFB800) : AppColors.error;
    final label = health > 0.7 ? 'ممتازة' : health > 0.5 ? 'جيدة' : 'تحتاج تحسين';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E1EF), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('صحة الدفع', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary)),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('متوسط وقت الدفع', style: const TextStyle(fontSize: 11, color: AppColors.outline)),
                  Text('${c.averagePaymentTime.toStringAsFixed(0)} يوم', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                ]),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: health,
                  backgroundColor: AppColors.surfaceContainerLow,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  borderRadius: BorderRadius.circular(4),
                  minHeight: 8,
                ),
              ]),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
              child: Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color)),
            ),
          ]),
          const SizedBox(height: 12),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            _paymentStat('اتفاقيات منجزة', c.totalAgreements.toString()),
            _paymentStat('مدفوعات معلقة', c.pendingPaymentsCount.toString()),
            _paymentStat('علاقة (سنوات)', _yearsDiff(c.relationshipSince)),
          ]),
        ],
      ),
    );
  }

  Widget _paymentStat(String label, String value) {
    return Column(children: [
      Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)),
      Text(label, style: const TextStyle(fontSize: 9, color: AppColors.outline)),
    ]);
  }

  String _yearsDiff(String since) {
    if (since.isEmpty) return '0';
    try {
      final start = DateTime.parse(since);
      final diff = DateTime.now().difference(start).inDays ~/ 365;
      return diff.toString();
    } catch (_) {
      return '0';
    }
  }
}
