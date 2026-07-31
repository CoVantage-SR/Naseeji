import 'package:flutter/material.dart';
import 'package:naseeji_factory/supplier/core/theme/app_colors.dart';
import '../widgets/vip_feature_guard.dart';

class AnalyticsTab extends StatelessWidget {
  final VoidCallback? onCancelVip;

  const AnalyticsTab({super.key, this.onCancelVip});

  @override
  Widget build(BuildContext context) {
    return VipFeatureGuard(
      onCancelTap: onCancelVip,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: AppColors.background,
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Revenue Overview Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10)],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'إحصائيات المبيعات والأرباح',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Theme.of(context).colorScheme.onSurface),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(4)),
                            child: Text('+١٢.٤٪ هذا الشهر', style: TextStyle(color: Colors.green.shade700, fontSize: 10, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Text(
                        '١٤٥,٠٠٠ جنيه',
                        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24, color: AppColors.primary),
                      ),
                      SizedBox(height: 16),
                      // Mock Sales Chart Bars
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _buildChartBar('يناير', 40),
                          _buildChartBar('فبراير', 60),
                          _buildChartBar('مارس', 35),
                          _buildChartBar('أبريل', 85),
                          _buildChartBar('مايو', 70),
                          _buildChartBar('يونيو', 100, isCurrent: true),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),

                // Key Performance Metrics Grid
                Text(
                  'المؤشرات الرئيسية للأداء (KPIs)',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Theme.of(context).colorScheme.onSurface),
                ),
                SizedBox(height: 10),
                GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 1.5,
                  children: [
                    _buildKpiCard('زيارات المنتجات', '١٥,٢٤٠', Icons.trending_up, Colors.blue),
                    _buildKpiCard('نقرات الزوار', '٣,٤١٢', Icons.touch_app_outlined, Colors.purple),
                    _buildKpiCard('طلبات التسعير RFQs', '٨٢ طلب', Icons.request_quote_outlined, Colors.orange),
                    _buildKpiCard('نسبة تحويل العروض', '٤.٨٪', Icons.percent, Colors.green),
                  ],
                ),

                SizedBox(height: 20),

                // Best Selling Products Section
                Text(
                  'المنتجات الأكثر مبيعاً وطلباً',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Theme.of(context).colorScheme.onSurface),
                ),
                SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10)],
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    children: [
                      _buildProductRankRow('1', 'خيوط غزل القطن الفاخر', '٥,٢٠٠ وحدة مباعة', 'COT-YRN-001'),
                      const Divider(height: 1),
                      _buildProductRankRow('2', 'قماش قطني طبيعي ١٠٠٪', '٢,٣٠٠ وحدة مباعة', 'COT-FAB-002'),
                      const Divider(height: 1),
                      _buildProductRankRow('3', 'نسيج صوف مخلوط مميز', '٩٥٠ وحدة مباعة', 'WOL-MIX-003'),
                    ],
                  ),
                ),

                SizedBox(height: 20),

                // Customer Insights Section
                Text(
                  'رؤى سلوك العملاء والمصانع',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Theme.of(context).colorScheme.onSurface),
                ),
                SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10)],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInsightRow('المصانع الأكثر تفاعلاً معك تتركز في منطقتي الرياض وجدة.'),
                      _buildInsightRow('أكثر الأوقات نشاطاً لاستلام طلبات التسعير RFQs هي صباح يوم الاثنين.'),
                      _buildInsightRow('خيوط القطن الفاخر تسجل معدل استفسارات أعلى بنسبة ٣٥٪ من بقية الأصناف.'),
                    ],
                  ),
                ),

                SizedBox(height: 20),

                // Export Monthly Reports Section
                Text(
                  'التقارير الشهرية وتصدير البيانات',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Theme.of(context).colorScheme.onSurface),
                ),
                SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10)],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('تقرير أداء شهر يونيو ٢٠٢٦ جاهز', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                            SizedBox(height: 2),
                            Text('يحتوي على كافة أرقام المبيعات، الزيارات، وعروض الأسعار المكتملة.', style: TextStyle(fontSize: 10, color: AppColors.outline)),
                          ],
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          minimumSize: const Size(0, 36),
                        ),
                        icon: const Icon(Icons.file_download_outlined, size: 16),
                        label: Text('تصدير PDF', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChartBar(String label, double percentageHeight, {bool isCurrent = false}) {
    return Column(
      children: [
        Container(
          height: 120,
          width: 28,
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(6),
          ),
          alignment: Alignment.bottomCenter,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 600),
            height: percentageHeight * 1.2,
            width: 28,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isCurrent
                    ? [const Color(0xFFFFA500), const Color(0xFFFF8C00)]
                    : [AppColors.primary, AppColors.primary.withValues(alpha: 0.7)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
        SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 9,
            fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
            color: isCurrent ? const Color(0xFFFF8C00) : AppColors.outline,
          ),
        ),
      ],
    );
  }

  Widget _buildKpiCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: TextStyle(fontSize: 10, color: AppColors.outline)),
              Icon(icon, color: color, size: 16),
            ],
          ),
          SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: AppColors.onSurface),
          ),
        ],
      ),
    );
  }

  Widget _buildProductRankRow(String rank, String name, String sales, String sku) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: rank == '1' ? const Color(0xFFFFD700).withValues(alpha: 0.15) : AppColors.surfaceContainerLow,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                rank,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: rank == '1' ? const Color(0xFFE6B800) : AppColors.onSurfaceVariant,
                ),
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                SizedBox(height: 2),
                Text('الرمز: $sku', style: TextStyle(fontSize: 9, color: AppColors.outline)),
              ],
            ),
          ),
          Text(
            sales,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: AppColors.primary),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightRow(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 4),
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
