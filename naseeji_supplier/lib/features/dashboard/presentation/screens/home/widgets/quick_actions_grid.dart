import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import 'quick_action_card.dart';

class QuickActionsGrid extends StatelessWidget {
  const QuickActionsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            QuickActionCard(
              icon: Icons.add_box,
              label: 'إضافة منتج',
              backgroundColor: AppColors.primaryContainer.withValues(alpha: 0.1),
              iconColor: AppColors.primary,
              onTap: () {},
            ),
            QuickActionCard(
              icon: Icons.shopping_bag,
              label: 'الطلبات',
              backgroundColor: AppColors.secondaryContainer.withValues(alpha: 0.1),
              iconColor: AppColors.secondary,
              onTap: () {},
            ),
            QuickActionCard(
              icon: Icons.description,
              label: 'عروض الأسعار',
              backgroundColor: AppColors.surfaceContainerLow,
              iconColor: AppColors.onSurfaceVariant,
              onTap: () {},
            ),
            QuickActionCard(
              icon: Icons.local_shipping,
              label: 'الشحن',
              backgroundColor: AppColors.surfaceContainerLow,
              iconColor: AppColors.onSurfaceVariant,
              onTap: () {},
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            QuickActionCard(
              icon: Icons.groups,
              label: 'العملاء',
              backgroundColor: AppColors.surfaceContainerHigh,
              iconColor: AppColors.onSurfaceVariant,
              onTap: () {},
            ),
            QuickActionCard(
              icon: Icons.payments,
              label: 'الأرباح',
              backgroundColor: AppColors.surfaceContainerHigh,
              iconColor: AppColors.onSurfaceVariant,
              onTap: () {},
            ),
            QuickActionCard(
              icon: Icons.campaign,
              label: 'الحملات',
              backgroundColor: AppColors.surfaceContainerHigh,
              iconColor: AppColors.onSurfaceVariant,
              onTap: () {},
            ),
            QuickActionCard(
              icon: Icons.assessment,
              label: 'التقارير',
              backgroundColor: AppColors.surfaceContainerHigh,
              iconColor: AppColors.onSurfaceVariant,
              onTap: () => context.push('/analytics'),
            ),
          ],
        ),
      ],
    );
  }
}
