import 'package:flutter/material.dart';
import 'package:naseeji_factory/core/theme/app_colors.dart';
import '../../domain/entities/subscription_models.dart';

class SubscriptionStatusCard extends StatelessWidget {
  final SupplierSubscription subscription;
  final ValueChanged<bool> onAutoRenewChanged;
  final VoidCallback onUpgrade;
  final VoidCallback onRenew;

  const SubscriptionStatusCard({
    super.key,
    required this.subscription,
    required this.onAutoRenewChanged,
    required this.onUpgrade,
    required this.onRenew,
  });

  @override
  Widget build(BuildContext context) {
    final startStr = '${subscription.startDate.year}/${subscription.startDate.month.toString().padLeft(2, '0')}/${subscription.startDate.day.toString().padLeft(2, '0')}';
    final expiryStr = '${subscription.expiryDate.year}/${subscription.expiryDate.month.toString().padLeft(2, '0')}/${subscription.expiryDate.day.toString().padLeft(2, '0')}';

    final Color statusColor = subscription.status == SubscriptionStatus.active
        ? const Color(0xFF006B5F)
        : (subscription.status == SubscriptionStatus.expiring
            ? const Color(0xFFFF9800)
            : const Color(0xFFBA1A1A));

    return Card(
      elevation: 0.5,
      color: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    subscription.status == SubscriptionStatus.active ? 'نشط' : (subscription.status == SubscriptionStatus.expiring ? 'ينتهي قريباً' : 'منتهي'),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                ),
                Text(
                  subscription.planName,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            const Divider(color: AppColors.outlineVariant),
            SizedBox(height: 12),

            _buildDetailRow(context, 'تاريخ البدء', startStr),
            _buildDetailRow(context, 'تاريخ الانتهاء', expiryStr),
            _buildDetailRow(context, 'التجديد القادم', expiryStr),
            _buildDetailRow(context, 'قيمة التجديد', '${subscription.price.toStringAsFixed(0)} جنيه / ${subscription.billingCycle == BillingCycle.yearly ? "سنوي" : "شهري"}'),
            _buildDetailRow(context, 'طريقة الدفع للمحاسبة', subscription.paymentMethod),
            
            SizedBox(height: 8),
            const Divider(color: AppColors.outlineVariant),
            SizedBox(height: 8),

            // Auto renew switch
            SwitchListTile(
              value: subscription.autoRenew,
              onChanged: onAutoRenewChanged,
              title: Text(
                'التجديد التلقائي للاشتراك',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                textAlign: TextAlign.right,
              ),
              subtitle: Text(
                'سداد الرسوم آلياً عبر البطاقة المحددة',
                style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.onSurfaceVariant),
                textAlign: TextAlign.right,
              ),
              activeThumbColor: const Color(0xFF0040E0),
              contentPadding: EdgeInsets.zero,
              dense: true,
            ),
            
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onRenew,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF2DD4BF) : const Color(0xFF006B5F),
                      side: BorderSide(color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF2DD4BF) : const Color(0xFF006B5F)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text('تجديد مبكر', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onUpgrade,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0040E0),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text('ترقية الباقة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF111827),
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }
}

