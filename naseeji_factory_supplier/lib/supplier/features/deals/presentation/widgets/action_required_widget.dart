import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_factory/supplier/features/deals/domain/entities/deal_model.dart';

class ActionRequiredWidget extends StatelessWidget {
  final List<DealModel> actionDeals;

  const ActionRequiredWidget({super.key, required this.actionDeals});

  @override
  Widget build(BuildContext context) {
    if (actionDeals.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB), // Amber 50
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF59E0B).withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.error_outline_rounded, color: Color(0xFFD97706), size: 16),
              const SizedBox(width: 6),
              Text(
                'يتطلب إجراء عاجل منك (${actionDeals.length})',
                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF92400E),
                ),
              ),
              const Spacer(),
              const Text(
                'اضغط لمتابعة الإجراء ⚡',
                style: TextStyle(fontSize: 9.5, color: Color(0xFFB45309), fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 6),
          SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: actionDeals.length,
              separatorBuilder: (context, index) => const SizedBox(width: 6),
              itemBuilder: (context, index) {
                final deal = actionDeals[index];
                return InkWell(
                  onTap: () => context.push('/deals/details/${deal.id}'),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFFBBF24)),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 12,
                          backgroundColor: const Color(0xFFFEF3C7),
                          child: Text(
                            deal.factoryInfo.logoText.substring(0, 1),
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFFD97706)),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              deal.dealNumber,
                              style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: colorScheme.onSurface),
                            ),
                            Text(
                              _getActionTitle(deal.status),
                              style: const TextStyle(fontSize: 9, color: Color(0xFFD97706), fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _getActionTitle(DealStatus status) {
    switch (status) {
      case DealStatus.newDeal:
      case DealStatus.waitingSupplierReview:
        return 'أرسل عرض السعر';
      case DealStatus.quotationSent:
        return 'تم إرسال العرض';
      case DealStatus.negotiation:
        return 'رد على العرض المقابل';
      case DealStatus.agreementPending:
        return 'وقع الاتفاق الإلكتروني';
      case DealStatus.signed:
        return 'ابدأ عمليات الإنتاج';
      case DealStatus.readyForDelivery:
        return 'حدد طريقة التسليم';
      case DealStatus.qualityInspection:
        return 'راجع نتيجة الفحص';
      default:
        return 'مطلوب إجراء';
    }
  }
}

