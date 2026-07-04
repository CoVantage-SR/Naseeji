import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../drawer/navigation_drawer_view.dart';
import '../home/widgets/home_app_bar.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      endDrawer: const NavigationDrawerView(),
      appBar: HomeAppBar(scaffoldKey: scaffoldKey),
      body: Container(
        color: const Color(0xFFF8F9FF),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header title and subtitle
              const Text(
                'إحصائيات الأداء',
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'نظرة شاملة على نمو أعمال نسيجي',
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.outline,
                ),
              ),
              const SizedBox(height: 20),

              // Filter & Export buttons row
              Row(
                children: [
                  // PDF button
                  ElevatedButton.icon(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0040E0),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      elevation: 0,
                      minimumSize: const Size(60, 40),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    icon: const Icon(Icons.picture_as_pdf, size: 16),
                    label: const Text('PDF', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 8),
                  // Excel button
                  ElevatedButton.icon(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF006B5F),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      elevation: 0,
                      minimumSize: const Size(60, 40),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    icon: const Icon(Icons.download, size: 16),
                    label: const Text('Excel', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 8),
                  // Dropdown selector
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.5)),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.keyboard_arrow_down, color: AppColors.outline, size: 18),
                          Text('هذا الشهر', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Metric Cards
              _buildMetricCard(
                title: 'إجمالي المبيعات',
                value: '45,230 ر.س',
                trend: '+12%',
                isPositive: true,
                icon: Icons.show_chart,
                iconColor: const Color(0xFF0040E0),
                iconBgColor: const Color(0xFFE8EFFF),
                borderColor: const Color(0xFF0040E0),
              ),
              _buildMetricCard(
                title: 'صافي الأرباح',
                value: '12,840 ر.س',
                trend: '+8%',
                isPositive: true,
                icon: Icons.account_balance_wallet_outlined,
                iconColor: const Color(0xFF009688),
                iconBgColor: const Color(0xFFE0F2F1),
                borderColor: const Color(0xFF009688),
              ),
              _buildMetricCard(
                title: 'إجمالي العملاء',
                value: '1,240',
                trend: '+5%',
                isPositive: true,
                icon: Icons.people_outline,
                iconColor: const Color(0xFFFF5722),
                iconBgColor: const Color(0xFFFFECE0),
                borderColor: const Color(0xFFFF5722),
              ),
              _buildMetricCard(
                title: 'الطلبات المكتملة',
                value: '856',
                trend: '-2%',
                isPositive: false,
                icon: Icons.inventory_2_outlined,
                iconColor: const Color(0xFF673AB7),
                iconBgColor: const Color(0xFFEDE7F6),
                borderColor: const Color(0xFF673AB7),
              ),
              const SizedBox(height: 16),

              // Sales Trend Bar Chart Card
              _buildSalesTrendCard(),
              const SizedBox(height: 24),

              // Orders Distribution Donut Card
              _buildOrdersDistributionCard(),
              const SizedBox(height: 24),

              // Revenue Growth Callout Banner
              _buildRevenueGrowthBanner(),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String trend,
    required bool isPositive,
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required Color borderColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor.withValues(alpha: 0.6), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    isPositive ? Icons.trending_up : Icons.trending_down,
                    color: isPositive ? Colors.green : Colors.red,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    trend,
                    style: TextStyle(
                      color: isPositive ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.outline,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSalesTrendCard() {
    final List<Map<String, dynamic>> barData = [
      {'day': 'الجمعة', 'value': 0.5, 'isHighlight': false},
      {'day': 'الخميس', 'value': 0.85, 'isHighlight': true},
      {'day': 'الأربعاء', 'value': 0.7, 'isHighlight': false},
      {'day': 'الثلاثاء', 'value': 0.6, 'isHighlight': false},
      {'day': 'الاثنين', 'value': 0.4, 'isHighlight': false},
      {'day': 'الأحد', 'value': 0.55, 'isHighlight': false},
      {'day': 'السبت', 'value': 0.35, 'isHighlight': false},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFF0040E0),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'البيانات الحالية',
                    style: TextStyle(fontSize: 11, color: AppColors.outline),
                  ),
                ],
              ),
              const Text(
                'اتجاه المبيعات',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.onSurface),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 180,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: barData.map((data) {
                final isHighlight = data['isHighlight'] as bool;
                final value = data['value'] as double;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Container(
                        width: 30,
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: 140 * value,
                          decoration: BoxDecoration(
                            color: isHighlight ? const Color(0xFF0040E0) : const Color(0xFF9CB8FF),
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      data['day'] as String,
                      style: const TextStyle(fontSize: 10, color: AppColors.outline),
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

  Widget _buildOrdersDistributionCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'توزيع الطلبات',
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.onSurface),
          ),
          const SizedBox(height: 20),
          Center(
            child: SizedBox(
              width: 140,
              height: 140,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 130,
                    height: 130,
                    child: CircularProgressIndicator(
                      value: 0.68,
                      strokeWidth: 12,
                      backgroundColor: Colors.grey.shade100,
                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF0040E0)),
                    ),
                  ),
                  const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '68%',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.onSurface,
                        ),
                      ),
                      Text(
                        'جاهز للشحن',
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.outline,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildDistributionLegendItem('أقمشة قطنية', '450 طلب', const Color(0xFF0040E0)),
          _buildDistributionLegendItem('منسوجات حريرية', '210 طلب', const Color(0xFF009688)),
          _buildDistributionLegendItem('خيوط صناعية', '196 طلب', const Color(0xFFFF5722)),
        ],
      ),
    );
  }

  Widget _buildDistributionLegendItem(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            value,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.onSurface),
          ),
          Row(
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 13, color: AppColors.onSurfaceVariant),
              ),
              const SizedBox(width: 8),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueGrowthBanner() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF0040E0).withValues(alpha: 0.05),
            const Color(0xFF72F8E4).withValues(alpha: 0.05),
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF0040E0).withValues(alpha: 0.15)),
      ),
      child: Column(
        children: [
          const Text(
            'نمو الإيرادات',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'وصلنا إلى نمو قياسي بنسبة 24% في الربع الأخير من العام الحالي مقارنة بالفترة ذاتها من العام السابق.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: AppColors.onSurfaceVariant,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0040E0),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 12),
                elevation: 0,
              ),
              child: const Text(
                'عرض التقرير المفصل',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
