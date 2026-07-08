import 'package:flutter/material.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import 'package:naseeji_supplier/core/widgets/general_widgets.dart';

class UsageProgressCard extends StatelessWidget {
  final String title;
  final double usedValue;
  final double maxValue;
  final String unit;
  final VoidCallback onUpgrade;
  final VoidCallback onBuyAddon;

  const UsageProgressCard({
    super.key,
    required this.title,
    required this.usedValue,
    required this.maxValue,
    required this.unit,
    required this.onUpgrade,
    required this.onBuyAddon,
  });

  @override
  Widget build(BuildContext context) {
    final double percent = maxValue > 0 ? (usedValue / maxValue) : 0.0;
    
    Color progressColor = const Color(0xFF0040E0);
    Color warningColor = Colors.transparent;
    String warningMessage = '';

    if (percent >= 1.0) {
      progressColor = const Color(0xFFBA1A1A);
      warningColor = const Color(0xFFBA1A1A).withValues(alpha: 0.1);
      warningMessage = 'تم بلوغ الحد الأقصى للميزة (100%). قم بالترقية أو شراء ملحق للاستمرار.';
    } else if (percent >= 0.95) {
      progressColor = const Color(0xFFFF9800);
      warningColor = const Color(0xFFFF9800).withValues(alpha: 0.1);
      warningMessage = 'تحذير حرج: لقد استهلكت ${(percent * 100).toStringAsFixed(0)}% من هذه الميزة.';
    } else if (percent >= 0.80) {
      progressColor = const Color(0xFFFFC107);
      warningColor = const Color(0xFFFFC107).withValues(alpha: 0.1);
      warningMessage = 'تنبيه: لقد استهلكت ${(percent * 100).toStringAsFixed(0)}% من سعة هذه الميزة.';
    }

    return Card(
      elevation: 0.5,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: percent >= 0.95
              ? progressColor.withValues(alpha: 0.5)
              : AppColors.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${usedValue.toStringAsFixed(usedValue % 1 == 0 ? 0 : 1)} / ${maxValue.toStringAsFixed(maxValue % 1 == 0 ? 0 : 1)} $unit',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.onSurface),
                ),
                Text(
                  title,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.onSurface),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: percent.clamp(0.0, 1.0),
                minHeight: 8,
                backgroundColor: AppColors.outlineVariant,
                valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              ),
            ),

            if (warningMessage.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: warningColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  warningMessage,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: percent >= 0.95 ? const Color(0xFFBA1A1A) : const Color(0xFF664D03),
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],

            if (percent >= 0.80) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onBuyAddon,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF0040E0),
                        side: const BorderSide(color: Color(0xFF0040E0)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                      child: const Text('شراء ملحق التوسيع', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onUpgrade,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF006B5F),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                      child: const Text('ترقية الباقة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
