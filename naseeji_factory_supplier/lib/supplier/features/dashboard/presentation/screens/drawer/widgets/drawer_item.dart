import 'package:flutter/material.dart';
import 'package:naseeji_factory/core/theme/app_colors.dart';

class DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String path;
  final String currentRoute;
  final VoidCallback onTap;

  const DrawerItem({
    super.key,
    required this.icon,
    required this.title,
    required this.path,
    required this.currentRoute,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = currentRoute == path;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: Material(
        color: isActive ? AppColors.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          leading: Icon(icon, color: isActive ? Colors.white : Theme.of(context).colorScheme.onSurfaceVariant),
          title: Text(
            title,
            style: TextStyle(
              color: isActive ? Colors.white : Theme.of(context).colorScheme.onSurface,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              fontSize: 13,
            ),
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}


