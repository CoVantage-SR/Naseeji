import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_factory/core/theme/app_colors.dart';
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
              backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
              iconColor: Theme.of(context).colorScheme.onSurfaceVariant,
              onTap: () {},
            ),
            QuickActionCard(
              icon: Icons.local_shipping,
              label: 'الشحن',
              backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
              iconColor: Theme.of(context).colorScheme.onSurfaceVariant,
              onTap: () {},
            ),
          ],
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            QuickActionCard(
              icon: Icons.groups,
              label: 'العملاء',
              backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
              iconColor: Theme.of(context).colorScheme.onSurfaceVariant,
              onTap: () {},
            ),
            QuickActionCard(
              icon: Icons.payments,
              label: 'الأرباح',
              backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
              iconColor: Theme.of(context).colorScheme.onSurfaceVariant,
              onTap: () {},
            ),
            QuickActionCard(
              icon: Icons.campaign,
              label: 'الحملات',
              backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
              iconColor: Theme.of(context).colorScheme.onSurfaceVariant,
              onTap: () {},
            ),
            QuickActionCard(
              icon: Icons.assessment,
              label: 'التقارير',
              backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
              iconColor: Theme.of(context).colorScheme.onSurfaceVariant,
              onTap: () => context.push('/reports'),
            ),
          ],
        ),
      ],
    );
  }
}



