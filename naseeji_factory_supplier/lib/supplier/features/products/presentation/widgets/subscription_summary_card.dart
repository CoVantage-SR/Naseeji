import 'package:flutter/material.dart';
import 'package:naseeji_factory/core/theme/app_colors.dart';
import '../../../subscription/domain/entities/subscription_models.dart';

class SubscriptionSummaryCard extends StatelessWidget {
  final SupplierSubscription subscription;
  final VoidCallback onDetailsTap;

  const SubscriptionSummaryCard({
    super.key,
    required this.subscription,
    required this.onDetailsTap,
  });

  @override
  Widget build(BuildContext context) {
    final expiryStr = '${subscription.expiryDate.year}/${subscription.expiryDate.month.toString().padLeft(2, '0')}/${subscription.expiryDate.day.toString().padLeft(2, '0')}';
    
    Color statusColor = const Color(0xFF006B5F);
    if (subscription.status == SubscriptionStatus.expired) {
      statusColor = const Color(0xFFBA1A1A);
    } else if (subscription.status == SubscriptionStatus.expiring) {
      statusColor = const Color(0xFFFF9800);
    }

    return Card(
      elevation: 0.5,
      color: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
      ),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        subscription.status == SubscriptionStatus.active
                            ? 'نشط'
                            : (subscription.status == SubscriptionStatus.expiring ? 'ينتهي قريباً' : 'منتهي'),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  subscription.planName,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            const Divider(color: AppColors.outlineVariant),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'التجديد القادم: $expiryStr',
                  style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
                Text(
                  'المتبقي: ${subscription.remainingDays} يوم',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                ),
              ],
            ),
            SizedBox(height: 12),
            GestureDetector(
              onTap: onDetailsTap,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'تفاصيل استهلاك الموارد والحدود',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0040E0),
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward,
                    size: 14,
                    color: Color(0xFF0040E0),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


