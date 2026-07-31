import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_factory/core/theme/app_colors.dart';
import 'package:naseeji_factory/core/widgets/app_bottom_navigation_bar.dart';
import '../controllers/financial_controllers.dart';
import '../widgets/financial_summary_card.dart';

class FinancialDashboardScreen extends ConsumerWidget {
  const FinancialDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(financialDashboardControllerProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0.5,
        title: Text(
          'المركز المالي',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: AppColors.onSurfaceVariant, size: 20),
          onPressed: () => context.go('/home'),
        ),
      ),
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: dashboardAsync.when(
          loading: () => Center(child: CircularProgressIndicator(color: AppColors.primary)),
          error: (err, stack) => Center(child: Text('خطأ في تحميل البيانات: $err')),
          data: (data) {
            return RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () => ref.read(financialDashboardControllerProvider.notifier).refresh(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Financial Health Indicator Banner
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE3FCEF),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF00875A).withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.check_circle_outline, color: const Color(0xFF00875A), size: 20),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'الحالة المالية للمؤسسة: ممتازة (مؤشر الصحة ${(data.healthIndicator * 100).toStringAsFixed(0)}%)',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF00875A),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),

                    // Balance Grid (Top Core Cards)
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.3,
                      children: [
                        FinancialSummaryCard(
                          title: 'الرصيد المتاح',
                          value: data.availableBalance,
                          icon: Icons.account_balance_wallet,
                          iconColor: const Color(0xFF00875A),
                          onTap: () => context.push('/finance/wallet'),
                        ),
                        FinancialSummaryCard(
                          title: 'الرصيد المعلق',
                          value: data.pendingBalance,
                          icon: Icons.hourglass_empty,
                          iconColor: const Color(0xFFB17000),
                          onTap: () => context.push('/finance/wallet'),
                        ),
                        FinancialSummaryCard(
                          title: 'الرصيد المجمد',
                          value: data.frozenBalance,
                          icon: Icons.lock_outline,
                          iconColor: const Color(0xFFDE350B),
                          onTap: () => context.push('/finance/wallet'),
                        ),
                        FinancialSummaryCard(
                          title: 'صافي الأرباح',
                          value: data.netProfit,
                          icon: Icons.trending_up,
                          iconColor: AppColors.primary,
                          onTap: () => context.push('/finance/analytics'),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    // Quick Actions Section
                    Text(
                      'إجراءات سريعة',
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                    ),
                    SizedBox(height: 10),
                    GridView.count(
                      crossAxisCount: 3,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1.1,
                      children: [
                        _buildQuickActionItem(
                          context,
                          icon: Icons.account_balance,
                          label: 'سحب رصيد',
                          route: '/finance/withdrawals/request',
                        ),
                        _buildQuickActionItem(
                          context,
                          icon: Icons.description_outlined,
                          label: 'الفواتير',
                          route: '/finance/invoices',
                        ),
                        _buildQuickActionItem(
                          context,
                          icon: Icons.credit_card,
                          label: 'وسائل الدفع',
                          route: '/finance/methods',
                        ),
                        _buildQuickActionItem(
                          context,
                          icon: Icons.bar_chart,
                          label: 'التحليلات',
                          route: '/finance/analytics',
                        ),
                        _buildQuickActionItem(
                          context,
                          icon: Icons.assignment_outlined,
                          label: 'التقارير',
                          route: '/finance/reports',
                        ),
                        _buildQuickActionItem(
                          context,
                          icon: Icons.percent,
                          label: 'الضرائب',
                          route: '/finance/tax',
                        ),
                      ],
                    ),
                    SizedBox(height: 24),

                    // Additional Metric Details
                    Text(
                      'ملخص الأداء المالي',
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
                      ),
                      child: Column(
                        children: [
                          _buildPerformanceRow('إجمالي الإيرادات', data.totalRevenue),
                          const Divider(height: 24, color: AppColors.outlineVariant),
                          _buildPerformanceRow('إيرادات الشهر الحالي', data.monthlyRevenue),
                          const Divider(height: 24, color: AppColors.outlineVariant),
                          _buildPerformanceRow('عمولات المنصة المدفوعة', data.platformFees),
                          const Divider(height: 24, color: AppColors.outlineVariant),
                          _buildPerformanceRow('المبالغ غير المفلترة بالفواتير', data.outstandingInvoices),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),

                    // Navigation to Sub-modules
                    Material(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      clipBehavior: Clip.antiAlias,
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
                        ),
                        title: Text('سجل المعاملات والعمليات', textAlign: TextAlign.right),
                        trailing: const Icon(Icons.arrow_back_ios, size: 14),
                        leading: const Icon(Icons.history, color: AppColors.primary),
                        onTap: () => context.push('/finance/transactions'),
                      ),
                    ),
                    SizedBox(height: 10),
                    Material(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      clipBehavior: Clip.antiAlias,
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
                        ),
                        title: Text('ضمان وحماية الدفعات (Escrow)', textAlign: TextAlign.right),
                        trailing: const Icon(Icons.arrow_back_ios, size: 14),
                        leading: const Icon(Icons.security, color: Color(0xFF006B5F)),
                        onTap: () => context.push('/finance/escrow'),
                      ),
                    ),
                    SizedBox(height: 10),
                    Material(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      clipBehavior: Clip.antiAlias,
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
                        ),
                        title: Text('إدارة المرتجعات والتعويضات', textAlign: TextAlign.right),
                        trailing: const Icon(Icons.arrow_back_ios, size: 14),
                        leading: const Icon(Icons.assignment_return_outlined, color: Color(0xFFBA1A1A)),
                        onTap: () => context.push('/finance/refunds'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: const AppBottomNavigationBar(currentIndex: 4),
    );
  }

  Widget _buildQuickActionItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String route,
  }) {
    return Card(
      color: Theme.of(context).colorScheme.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: InkWell(
        onTap: () => context.push(route),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: AppColors.primary, size: 22),
              SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPerformanceRow(String label, double val) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '${val.toStringAsFixed(2)} جنيه',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.onSurface),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 13, color: AppColors.onSurfaceVariant),
        ),
      ],
    );
  }
}


