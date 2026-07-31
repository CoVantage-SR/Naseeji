import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class QuickActionFab extends StatelessWidget {
  const QuickActionFab({super.key});

  static void showQuickActionsBottomSheet(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.flash_on_rounded, color: colorScheme.primary, size: 22),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'عمليات سريعة للتحكم',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.1,
                children: [
                  _QuickOptionTile(
                    title: 'إضافة منتج',
                    icon: Icons.add_box_outlined,
                    color: Colors.blue,
                    onTap: () {
                      Navigator.pop(context);
                      context.push('/products/add');
                    },
                  ),
                  _QuickOptionTile(
                    title: 'طلبات الأسعار',
                    icon: Icons.description_outlined,
                    color: Colors.purple,
                    onTap: () {
                      Navigator.pop(context);
                      context.push('/orders');
                    },
                  ),
                  _QuickOptionTile(
                    title: 'الصفقات',
                    icon: Icons.handshake_outlined,
                    color: Colors.teal,
                    onTap: () {
                      Navigator.pop(context);
                      context.push('/deals');
                    },
                  ),
                  _QuickOptionTile(
                    title: 'المحادثات',
                    icon: Icons.chat_outlined,
                    color: Colors.orange,
                    onTap: () {
                      Navigator.pop(context);
                      context.push('/messages');
                    },
                  ),
                  _QuickOptionTile(
                    title: 'الاشتراك',
                    icon: Icons.workspace_premium_outlined,
                    color: Colors.amber.shade800,
                    onTap: () {
                      Navigator.pop(context);
                      context.push('/subscription/plans');
                    },
                  ),
                  _QuickOptionTile(
                    title: 'الحساب',
                    icon: Icons.person_outline_rounded,
                    color: Colors.indigo,
                    onTap: () {
                      Navigator.pop(context);
                      context.push('/profile');
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return FloatingActionButton.extended(
      heroTag: 'home_quick_action_fab_v2',
      onPressed: () => showQuickActionsBottomSheet(context),
      backgroundColor: colorScheme.primary,
      foregroundColor: Colors.white,
      elevation: 3,
      icon: const Icon(Icons.flash_on_rounded, size: 18),
      label: const Text(
        'عملية سريعة',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5),
      ),
    );
  }
}

class _QuickOptionTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _QuickOptionTile({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

