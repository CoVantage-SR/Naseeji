import 'package:flutter/material.dart';

class QuickActionsSection extends StatelessWidget {
  final VoidCallback onSendRfq;
  final VoidCallback onSearchSupplier;
  final VoidCallback onOrders;
  final VoidCallback onDeals;

  const QuickActionsSection({
    super.key,
    required this.onSendRfq,
    required this.onSearchSupplier,
    required this.onOrders,
    required this.onDeals,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: _buildActionItem(
              context: context,
              title: 'إرسال RFQ',
              icon: Icons.near_me_outlined,
              onTap: onSendRfq,
              colorScheme: colorScheme,
              theme: theme,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildActionItem(
              context: context,
              title: 'البحث عن مورد',
              icon: Icons.person_search_outlined,
              onTap: onSearchSupplier,
              colorScheme: colorScheme,
              theme: theme,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildActionItem(
              context: context,
              title: 'الطلبات',
              icon: Icons.assignment_outlined,
              onTap: onOrders,
              colorScheme: colorScheme,
              theme: theme,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildActionItem(
              context: context,
              title: 'الصفقات',
              icon: Icons.handshake_outlined,
              onTap: onDeals,
              colorScheme: colorScheme,
              theme: theme,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem({
    required BuildContext context,
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    required ColorScheme colorScheme,
    required ThemeData theme,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
        decoration: BoxDecoration(
          color: theme.cardTheme.color ?? colorScheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: theme.dividerColor.withValues(alpha: 0.25),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.blue.shade600,
              size: 26,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


