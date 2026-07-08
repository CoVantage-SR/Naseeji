import 'package:flutter/material.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import 'package:naseeji_supplier/core/widgets/general_widgets.dart';
import '../../domain/entities/subscription_models.dart';

class AddonCard extends StatelessWidget {
  final AddonItem addon;
  final VoidCallback onBuy;
  final VoidCallback onTapDetails;

  const AddonCard({
    super.key,
    required this.addon,
    required this.onBuy,
    required this.onTapDetails,
  });

  @override
  Widget build(BuildContext context) {
    IconData icon = Icons.extension;
    Color color = const Color(0xFF0040E0);

    if (addon.type == AddonType.products) {
      icon = Icons.shopping_bag_outlined;
      color = const Color(0xFF006B5F);
    } else if (addon.type == AddonType.storage) {
      icon = Icons.cloud_queue;
      color = const Color(0xFF9C27B0);
    } else if (addon.type == AddonType.ads) {
      icon = Icons.campaign_outlined;
      color = const Color(0xFFFF9800);
    } else if (addon.type == AddonType.aiAnalytics) {
      icon = Icons.psychology_outlined;
      color = const Color(0xFFE91E63);
    }

    return Card(
      elevation: 0.5,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTapDetails,
        borderRadius: BorderRadius.circular(12),
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
                      Text(
                        '${addon.price.toStringAsFixed(0)} ر.س',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.onSurface),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            addon.name,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.onSurface),
                          ),
                          Text(
                            addon.usage,
                            style: const TextStyle(fontSize: 10, color: AppColors.onSurfaceVariant),
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(icon, color: color, size: 20),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                addon.description,
                style: const TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant, height: 1.4),
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: 12),
              const Divider(color: AppColors.outlineVariant),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'السرية: ${addon.validity}',
                    style: const TextStyle(fontSize: 9, color: AppColors.onSurfaceVariant),
                  ),
                  ElevatedButton(
                    onPressed: onBuy,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0040E0),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    ),
                    child: const Text('شراء الآن', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
