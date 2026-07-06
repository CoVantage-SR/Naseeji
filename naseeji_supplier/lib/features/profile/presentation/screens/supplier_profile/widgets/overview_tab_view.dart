import 'package:flutter/material.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import 'package:naseeji_supplier/features/profile/domain/entities/supplier_profile.dart';
import 'recent_activity_timeline.dart';

class OverviewTabView extends StatelessWidget {
  final SupplierProfile profile;

  const OverviewTabView({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              Expanded(child: _buildMetricCard('نسبة الرد السريع', '98%', Icons.bolt_outlined, Colors.orange)),
              const SizedBox(width: 10),
              Expanded(child: _buildMetricCard('التوصيل في الموعد', '95%', Icons.local_shipping_outlined, Colors.green)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _buildMetricCard('المنتجات المفعلة', '${profile.productsCount}', Icons.inventory_2_outlined, const Color(0xFF0040E0))),
              const SizedBox(width: 10),
              Expanded(child: _buildMetricCard('الطلبات المكتملة', '${profile.ordersCount}', Icons.done_all_outlined, const Color(0xFF006B5F))),
            ],
          ),
          const SizedBox(height: 20),

          const Text('نبذة عن أعمال الشركة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 8),
          const Text(
            'نحن مصنع متخصص في تصنيع خامات الأقمشة والقطن الممتاز عالي الجودة لتلبية احتياجات مصانع الملابس الجاهزة وشركات النسيج B2B في الشرق الأوسط.',
            style: TextStyle(fontSize: 11, height: 1.4, color: AppColors.onSurfaceVariant),
            textAlign: TextAlign.end,
          ),
          const SizedBox(height: 20),

          const Text('أوسمة الجودة والاعتمادات', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildAchievementBadge('Top Supplier', Colors.orange),
              const SizedBox(width: 8),
              _buildAchievementBadge('Verified Business', Colors.blue),
              const SizedBox(width: 8),
              _buildAchievementBadge('ISO Certified', Colors.green),
            ],
          ),
          const SizedBox(height: 20),

          const Text('أحدث نشاطات الشركة الموثقة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 12),
          const RecentActivityTimeline(),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String label, String val, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE2E1EF))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: color, size: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(val, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              Text(label, style: const TextStyle(fontSize: 9, color: AppColors.outline)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(label, style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.bold)),
    );
  }
}
