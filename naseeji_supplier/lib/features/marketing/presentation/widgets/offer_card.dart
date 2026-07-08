import 'package:flutter/material.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../../domain/entities/marketing_models.dart';

class OfferCard extends StatelessWidget {
  final PromotionalOffer offer;
  final VoidCallback? onToggleStatus;

  const OfferCard({
    super.key,
    required this.offer,
    this.onToggleStatus,
  });

  String _getOfferTypeLabel(OfferType type) {
    switch (type) {
      case OfferType.percentageDiscount:
        return 'نسبة مئوية';
      case OfferType.fixedDiscount:
        return 'خصم ثابت';
      case OfferType.buyMoreSaveMore:
        return 'اشترِ أكثر ووفر';
      case OfferType.freeShipping:
        return 'شحن مجاني للكميات';
      case OfferType.vipPricing:
        return 'تسعير VIP خاص';
      case OfferType.bundleOffers:
        return 'باقة مجمعة';
      case OfferType.seasonalOffers:
        return 'عرض موسمي';
      case OfferType.firstOrderDiscount:
        return 'خصم الطلب الأول';
      case OfferType.minimumQuantityDiscount:
        return 'خصم الحد الأدنى';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: offer.active ? const Color(0xFF006B5F).withValues(alpha: 0.1) : AppColors.outline.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  offer.active ? 'نشط' : 'غير نشط',
                  style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                    color: offer.active ? const Color(0xFF006B5F) : AppColors.outline,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  offer.title,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.onSurface),
                  textAlign: TextAlign.right,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            offer.description,
            style: const TextStyle(fontSize: 10, color: AppColors.onSurfaceVariant),
            textAlign: TextAlign.right,
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.outlineVariant),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'نوع العرض: ${_getOfferTypeLabel(offer.type)}',
                style: const TextStyle(fontSize: 9, color: AppColors.onSurfaceVariant),
              ),
              Text(
                'الوصول: ${offer.reach} | التحويلات: ${offer.conversions}',
                style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.onSurfaceVariant),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
