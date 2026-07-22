import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../domain/entities/deal_model.dart';
import 'deal_status_badge_widget.dart';

class DealCardWidget extends StatelessWidget {
  final DealModel deal;

  const DealCardWidget({super.key, required this.deal});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: InkWell(
        onTap: () => context.push('/deals/details/${deal.id}'),
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row: Deal Number, Status Badge, & Days Remaining
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        deal.dealNumber,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      DealStatusBadgeWidget(status: deal.status),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.timer_outlined, size: 12, color: colorScheme.outline),
                      const SizedBox(width: 3),
                      Text(
                        '${deal.daysRemaining} يوم متبقي',
                        style: TextStyle(fontSize: 9.5, color: colorScheme.outline),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Divider(height: 1, color: colorScheme.outlineVariant.withValues(alpha: 0.3)),
              const SizedBox(height: 8),

              // Middle Row: Factory Avatar & Details + Product Specs & Qty
              Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: Color(deal.factoryInfo.logoBgColorValue),
                    child: Text(
                      deal.factoryInfo.logoText.substring(0, 1),
                      style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          deal.factoryInfo.name,
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Icon(Icons.inventory_2_outlined, size: 12, color: colorScheme.primary),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                '${deal.product.name} (${deal.product.quantity} ${deal.product.unit})',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),

              // Footer Row: Last Updated & Arrow Icon
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'آخر تحديث: ${deal.formattedLastUpdated}',
                    style: TextStyle(fontSize: 9, color: colorScheme.outline),
                  ),
                  Icon(Icons.arrow_forward_ios_rounded, size: 11, color: colorScheme.primary),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
