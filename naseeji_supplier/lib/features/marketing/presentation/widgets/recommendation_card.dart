import 'package:flutter/material.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';

class RecommendationCard extends StatelessWidget {
  final String title;
  final String description;
  final String actionLabel;
  final VoidCallback onTapAction;
  final IconData icon;
  final Color iconColor;

  const RecommendationCard({
    super.key,
    required this.title,
    required this.description,
    required this.actionLabel,
    required this.onTapAction,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: iconColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: iconColor.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: iconColor),
              ),
              const SizedBox(width: 8),
              Icon(icon, color: iconColor, size: 20),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant, height: 1.4),
            textAlign: TextAlign.right,
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              icon: Icon(Icons.arrow_back, size: 14, color: iconColor),
              label: Text(
                actionLabel,
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: iconColor),
              ),
              onPressed: onTapAction,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                backgroundColor: iconColor.withValues(alpha: 0.1),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
