import 'package:flutter/material.dart';
import 'package:naseeji_factory/core/theme/app_colors.dart';

class AiInsightCard extends StatelessWidget {
  final String message;
  final AiInsightType type;
  final String? actionLabel;
  final VoidCallback? onAction;

  const AiInsightCard({
    super.key,
    required this.message,
    this.type = AiInsightType.info,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final config = _insightConfig(type);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: config.bgColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: config.bgColor.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (onAction != null && actionLabel != null) ...[
            TextButton(
              onPressed: onAction,
              style: TextButton.styleFrom(
                foregroundColor: config.bgColor,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(actionLabel!, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Text(
              message,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 13,
                color: Theme.of(context).colorScheme.onSurface,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: config.bgColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(config.icon, size: 18, color: config.bgColor),
          ),
        ],
      ),
    );
  }

  _InsightConfig _insightConfig(AiInsightType type) {
    switch (type) {
      case AiInsightType.success:
        return _InsightConfig(Icons.trending_up_rounded, const Color(0xFF00875A));
      case AiInsightType.warning:
        return _InsightConfig(Icons.warning_amber_rounded, const Color(0xFFB45309));
      case AiInsightType.alert:
        return _InsightConfig(Icons.error_outline_rounded, const Color(0xFFDE350B));
      case AiInsightType.tip:
        return _InsightConfig(Icons.lightbulb_outline_rounded, const Color(0xFF6366F1));
      case AiInsightType.info:
        return _InsightConfig(Icons.insights_rounded, AppColors.primary);
    }
  }
}

enum AiInsightType { success, warning, alert, tip, info }

class _InsightConfig {
  final IconData icon;
  final Color bgColor;
  const _InsightConfig(this.icon, this.bgColor);
}



