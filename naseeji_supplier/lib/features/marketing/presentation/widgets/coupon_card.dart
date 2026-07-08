import 'package:flutter/material.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../../domain/entities/marketing_models.dart';

class CouponCard extends StatelessWidget {
  final B2BDiscountCoupon coupon;
  final ValueChanged<bool> onToggleStatus;

  const CouponCard({
    super.key,
    required this.coupon,
    required this.onToggleStatus,
  });

  @override
  Widget build(BuildContext context) {
    final expiryStr = '${coupon.expirationDate.year}/${coupon.expirationDate.month.toString().padLeft(2, '0')}/${coupon.expirationDate.day.toString().padLeft(2, '0')}';
    final bool isExpired = coupon.expirationDate.isBefore(DateTime.now());

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Switch(
                  value: coupon.active && !isExpired,
                  onChanged: isExpired ? null : onToggleStatus,
                  activeThumbColor: const Color(0xFF0040E0),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (isExpired) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFBA1A1A).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'منتهي الصلاحية',
                                style: TextStyle(fontSize: 8, color: Color(0xFFBA1A1A), fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                          Text(
                            coupon.code,
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0040E0)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        coupon.discountType == 'percentage'
                            ? 'خصم بقيمة ${coupon.discountValue.toStringAsFixed(0)}% (حد أقصى ${coupon.maxDiscount.toStringAsFixed(0)} ر.س)'
                            : 'خصم ثابت بقيمة ${coupon.discountValue.toStringAsFixed(0)} ر.س',
                        style: const TextStyle(fontSize: 11, color: AppColors.onSurface, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.outlineVariant),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: AppColors.surfaceContainerLow,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'تاريخ الانتهاء: $expiryStr',
                  style: const TextStyle(fontSize: 10, color: AppColors.onSurfaceVariant),
                ),
                Text(
                  'معدل الاستخدام: ${coupon.usageCount} / ${coupon.usageLimit}',
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
