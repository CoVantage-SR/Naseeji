// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import 'package:naseeji_supplier/features/profile/domain/entities/supplier_profile.dart';

class PublicOverviewTabView extends StatelessWidget {
  final SupplierProfile profile;

  const PublicOverviewTabView({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // B2B Stats Grid (Modern cards with subtle gradients and border highlights)
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
            childAspectRatio: 1,
            children: [
              _buildGridCard(
                'سنة التأسيس',
                '2016',
                Icons.calendar_today_outlined,
                const Color(0xFF0040E0),
              ),
              _buildGridCard(
                'مساحة المصنع',
                '12,500 م²',
                Icons.domain_outlined,
                const Color(0xFF006B5F),
              ),
              _buildGridCard(
                'خطوط الإنتاج',
                '14 خط نشط',
                Icons.precision_manufacturing_outlined,
                Colors.purple,
              ),
              _buildGridCard(
                'مناطق التصدير',
                'دول الخليج',
                Icons.public_outlined,
                Colors.orange,
              ),
            ],
          ),
          SizedBox(height: 1),

          // Business Description Section
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E1EF)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'نبذة عن خطوط الإنتاج والقدرة',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(
                      Icons.info_outline,
                      color: const Color(0xFF0040E0),
                      size: 18,
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  'نعمل بأحدث التقنيات الألمانية في غزل ونسيج القطنيات الفاخرة والمخلوطة، ونوفر لشركائنا من مصانع الأزياء خامات معتمدة ومطابقة لأعلى مقاييس الجودة العالمية مع إمكانية التخصيص حسب الطلب.',
                  style: TextStyle(
                    fontSize: 11,
                    height: 1.5,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.end,
                ),
              ],
            ),
          ),
          SizedBox(height: 10),

          // Additional Public B2B Details list
          Text(
            'تفاصيل المعاملات والشحن',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          SizedBox(height: 10),
          _buildDetailRow(
            'متوسط سرعة الرد الموثق',
            'أقل من ساعتين',
            Icons.bolt_outlined,
          ),
          _buildDetailRow(
            'أجل السداد الافتراضي المتاح للشركاء',
            'Net 30 يوم (بعد التدقيق المالي)',
            Icons.credit_card_outlined,
          ),
          _buildDetailRow(
            'مرفق التصدير الرئيسي المعتمد',
            'ميناء الملك عبد الله، جدة',
            Icons.local_shipping_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildGridCard(
    String label,
    String value,
    IconData icon,
    Color accentColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E1EF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: accentColor, size: 20),
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: accentColor,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: AppColors.onSurface,
                ),
              ),
              SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(fontSize: 9, color: AppColors.outline),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String title, String val, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E1EF)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Text(
              val,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: AppColors.onSurface,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          SizedBox(width: 10),
          Text(
            title,
            style: TextStyle(fontSize: 10, color: AppColors.outline),
          ),
          SizedBox(width: 8),
          Icon(icon, color: const Color(0xFF0040E0), size: 16),
        ],
      ),
    );
  }
}