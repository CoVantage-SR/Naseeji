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
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10),
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
                  style: const TextStyle(fontSize: 10, color: AppColors.outline),
                ),
                Text(
                  'الخطوة ${activeIdx + 1} من ${_stages.length}',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
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
                            color: isActive ? AppColors.primary : isDone ? AppColors.secondary : Colors.transparent,
                            shape: BoxShape.circle,
                            border: Border.all(color: color, width: isActive ? 0 : 1.5),
                          ),
                          child: Icon(
                            isDone ? Icons.check : stage.icon,
                            size: 16,
                            color: isActive || isDone ? Colors.white : AppColors.outline,
                          ),
                        ),
                        const SizedBox(height: 4),
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
