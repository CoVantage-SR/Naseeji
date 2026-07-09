import 'package:flutter/material.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';

class OrderStatusBanner extends StatelessWidget {
  final String currentStage;

  const OrderStatusBanner({super.key, required this.currentStage});

  static const List<_Stage> _stages = [
    _Stage(label: 'طلب عرض', icon: Icons.request_quote_outlined),
    _Stage(label: 'عرض سعر', icon: Icons.price_check_outlined),
    _Stage(label: 'تفاوض', icon: Icons.handshake_outlined),
    _Stage(label: 'اتفاق', icon: Icons.verified_outlined),
    _Stage(label: 'إنتاج', icon: Icons.factory_outlined),
    _Stage(label: 'شحن', icon: Icons.local_shipping_outlined),
    _Stage(label: 'استلام', icon: Icons.inventory_2_outlined),
    _Stage(label: 'دفع', icon: Icons.payments_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    final currentIdx = _stages.indexWhere(
      (s) => s.label == currentStage || currentStage.contains(s.label.split(' ').first),
    );
    final activeIdx = currentIdx < 0 ? 0 : currentIdx;

    return Container(
      margin: const EdgeInsets.only(left: 12, right: 12, bottom: 8, top: 8),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'مرحلة: $currentStage',
                  style: TextStyle(fontSize: 10, color: AppColors.outline),
                ),
                Text(
                  'الخطوة ${activeIdx + 1} من ${_stages.length}',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
          SizedBox(
            height: 64,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _stages.length,
              itemBuilder: (context, index) {
                final stage = _stages[index];
                final isActive = index == activeIdx;
                final isDone = index < activeIdx;
                final color = isActive
                    ? AppColors.primary
                    : isDone
                        ? AppColors.secondary
                        : AppColors.outlineVariant;
                return Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: isActive ? AppColors.primary : isDone ? AppColors.secondary.withValues(alpha: 0.15) : Colors.transparent,
                            shape: BoxShape.circle,
                            border: Border.all(color: color, width: isActive ? 0 : 1.5),
                            boxShadow: isActive
                                ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 6, offset: const Offset(0, 2))]
                                : null,
                          ),
                          child: Icon(
                            isDone ? Icons.check : stage.icon,
                            size: 16,
                            color: isActive ? Colors.white : isDone ? AppColors.secondary : AppColors.outline,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          stage.label,
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                            color: color,
                          ),
                        ),
                      ],
                    ),
                    if (index < _stages.length - 1)
                      Container(
                        width: 20,
                        height: 1.5,
                        margin: const EdgeInsets.only(bottom: 18),
                        color: index < activeIdx ? AppColors.secondary : AppColors.outlineVariant,
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Stage {
  final String label;
  final IconData icon;
  const _Stage({required this.label, required this.icon});
}
