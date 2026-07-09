import 'package:flutter/material.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import 'premium_badge.dart';

class VipBottomSheet extends StatefulWidget {
  const VipBottomSheet({super.key});

  @override
  State<VipBottomSheet> createState() => _VipBottomSheetState();
}

class _VipBottomSheetState extends State<VipBottomSheet> {
  String _selectedPlan = 'yearly'; // 'monthly', 'yearly', 'enterprise'

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Bottom sheet handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              SizedBox(height: 16),
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PremiumBadge(fontSize: 12, padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4)),
                  SizedBox(width: 8),
                  Text(
                    'اختر خطة ترقية حسابك',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 6),
              Text(
                'احصل على وصول غير محدود لكافة ميزات التسويق والتحليلات الذكية لزيادة مبيعاتك ونمو نشاطك.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: AppColors.outline),
              ),
              SizedBox(height: 20),

              // Pricing Plans Cards
              Row(
                children: [
                  Expanded(
                    child: _buildPlanCard(
                      id: 'monthly',
                      title: 'شهري',
                      price: '١٥٠ ر.س',
                      period: '/ شهرياً',
                      desc: 'خيار مرن للاختبار والتجربة',
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: _buildPlanCard(
                      id: 'yearly',
                      title: 'سنوي (الأكثر توفيراً)',
                      price: '١٠٠ ر.س',
                      period: '/ شهرياً',
                      desc: 'توفير ٣٣٪ (١٢٠٠ ر.س سنوياً)',
                      badge: 'وفر ٣٣٪',
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              _buildPlanCard(
                id: 'enterprise',
                title: 'المؤسسات الكبرى (Enterprise)',
                price: 'تواصل معنا',
                period: '',
                desc: 'دعم مخصص، تكامل تقني متقدم وحلول ربط متكاملة',
                isWide: true,
              ),

              SizedBox(height: 24),
              // Comparison Table
              Text(
                'مقارنة الميزات والخدمات',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Theme.of(context).colorScheme.onSurface),
              ),
              SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    _buildCompRow('أرشفة وعرض المنتجات وتصنيفها', 'أساسي', 'VIP مميز', basicCheck: true, vipCheck: true),
                    const Divider(height: 16),
                    _buildCompRow('لوحة تحكم إعلانات المنتجات المروجة', '❌ غير متاح', '✓ متاح بالكامل', basicCheck: false, vipCheck: true),
                    const Divider(height: 16),
                    _buildCompRow('تحليلات الزوار والمبيعات المتقدمة', '❌ غير متاح', '✓ تقارير ذكية ورسوم بيانية', basicCheck: false, vipCheck: true),
                    const Divider(height: 16),
                    _buildCompRow('بث العروض للمصانع والطلبات الفورية', '❌ غير متاح', '✓ غير محدود', basicCheck: false, vipCheck: true),
                    const Divider(height: 16),
                    _buildCompRow('الدعم الفني وإدارة الحساب ذات الأولوية', 'البريد الإلكتروني', 'مستشار حسابات مخصص ٢٤/٧', basicCheck: true, vipCheck: true, isCustomText: true),
                  ],
                ),
              ),

              SizedBox(height: 24),
              // Action Buttons
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, true); // Return true to indicate successful subscription
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0040E0),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 2,
                ),
                child: Text(
                  _selectedPlan == 'enterprise' ? 'تواصل مع فريق المبيعات' : 'اشترك الآن وفعل الميزات',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
              SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(
                  'ربما لاحقاً',
                  style: TextStyle(color: AppColors.outline, fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlanCard({
    required String id,
    required String title,
    required String price,
    required String period,
    required String desc,
    String? badge,
    bool isWide = false,
  }) {
    final isSelected = _selectedPlan == id;
    return InkWell(
      onTap: () => setState(() => _selectedPlan = id),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFFFFA500) : AppColors.outlineVariant,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFFFFA500).withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ]
              : null,
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: isSelected ? const Color(0xFFE68A00) : Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 6),
                Row(
                  textBaseline: TextBaseline.alphabetic,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  children: [
                    Text(
                      price,
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: isWide ? 15 : 18,
                        color: isSelected ? const Color(0xFF0040E0) : Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      period,
                      style: TextStyle(fontSize: 10, color: AppColors.outline),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  desc,
                  style: TextStyle(fontSize: 9, color: AppColors.outline),
                ),
              ],
            ),
            if (badge != null)
              Positioned(
                top: -24,
                left: -6,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    badge,
                    style: TextStyle(color: Theme.of(context).colorScheme.surface, fontSize: 8, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompRow(
    String feature,
    String basic,
    String vip, {
    required bool basicCheck,
    required bool vipCheck,
    bool isCustomText = false,
  }) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Text(
            feature,
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            basic,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              color: basicCheck ? AppColors.outline : Colors.red,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            vip,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              color: vipCheck ? const Color(0xFF16A34A) : AppColors.outline,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
