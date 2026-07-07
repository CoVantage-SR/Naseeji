import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import 'premium_badge.dart';

class PremiumLockOverlay extends StatelessWidget {
  final VoidCallback onUpgradeTap;
  final VoidCallback? onCancelTap;

  const PremiumLockOverlay({
    super.key,
    required this.onUpgradeTap,
    this.onCancelTap,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
          child: Container(
            color: Colors.black.withValues(alpha: 0.55),
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.8, end: 1.0),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutBack,
              builder: (context, scale, child) {
                return Transform.scale(
                  scale: scale,
                  child: child,
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    )
                  ],
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Lock icon inside golden frame
                    Container(
                      width: 56,
                      height: 56,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(Icons.lock_outline, color: Colors.white, size: 28),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // VIP Badge
                    const PremiumBadge(fontSize: 11, padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3)),
                    const SizedBox(height: 12),
                    // Title
                    const Text(
                      'ميزات كبار الموردين VIP',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'افتح الأدوات المتقدمة للتسويق والتحليلات والترويج الذكي لمنتجاتك على منصة نسيجي.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: AppColors.outline),
                    ),
                    const SizedBox(height: 20),
                    const Divider(),
                    const SizedBox(height: 14),
                    // Benefits list
                    _buildBenefitRow('المنتجات المروجة والإعلانات الممولة'),
                    _buildBenefitRow('تحليلات وتقارير المبيعات والزيارات الذكية'),
                    _buildBenefitRow('إدارة الحملات التسويقية والخصومات الموسمية'),
                    _buildBenefitRow('تقارير أداء المنتجات الذكية ومعدلات التحويل'),
                    _buildBenefitRow('نسبة ظهور ووصول أعلى في نتائج البحث للمصانع'),
                    _buildBenefitRow('دعم فني ذو أولوية على مدار الساعة'),
                    const SizedBox(height: 24),
                    // Action Buttons
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: onUpgradeTap,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0040E0),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 1,
                        ),
                        child: const Text(
                          'ترقية الحساب الآن',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                    ),
                    if (onCancelTap != null) ...[
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: onCancelTap,
                        child: const Text(
                          'ربما لاحقاً',
                          style: TextStyle(color: AppColors.outline, fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBenefitRow(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle, color: Color(0xFF16A34A), size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }
}
