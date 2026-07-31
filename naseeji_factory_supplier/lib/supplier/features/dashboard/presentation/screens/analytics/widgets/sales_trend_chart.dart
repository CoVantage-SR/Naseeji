import 'package:flutter/material.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';

class SalesTrendChart extends StatelessWidget {
  final List<Map<String, dynamic>> barData;

  const SalesTrendChart({
    super.key,
    required this.barData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Color(0xFF0040E0),
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 6),
                  Text(
                    'البيانات الحالية',
                    style: TextStyle(fontSize: 11, color: AppColors.outline),
                  ),
                ],
              ),
              Text(
                'اتجاه المبيعات',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
              ),
            ],
          ),
          SizedBox(height: 24),
          SizedBox(
            height: 180,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: barData.map((data) {
                final isHighlight = data['isHighlight'] as bool;
                final value = data['value'] as double;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Container(
                        width: 30,
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: 140 * value,
                          decoration: BoxDecoration(
                            color: isHighlight ? const Color(0xFF0040E0) : const Color(0xFF9CB8FF),
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      data['day'] as String,
                      style: TextStyle(fontSize: 10, color: AppColors.outline),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
