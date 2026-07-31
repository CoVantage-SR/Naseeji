import 'package:flutter/material.dart';

class MarketplaceHeader extends StatelessWidget implements PreferredSizeWidget {
  final int unreadNotificationsCount;
  final VoidCallback onNotificationsTap;
  final VoidCallback onSearchTap;
  final VoidCallback onFilterTap;

  const MarketplaceHeader({
    super.key,
    this.unreadNotificationsCount = 3,
    required this.onNotificationsTap,
    required this.onSearchTap,
    required this.onFilterTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(56.0);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppBar(
      backgroundColor: theme.appBarTheme.backgroundColor ?? colorScheme.surface,
      elevation: 0,
      centerTitle: true,
      automaticallyImplyLeading: false,
      title: Text(
        'السوق',
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      actions: [
        IconButton(
          onPressed: onFilterTap,
          icon: Icon(
            Icons.filter_alt_outlined,
            color: colorScheme.onSurface,
            size: 22,
          ),
        ),
        IconButton(
          onPressed: onSearchTap,
          icon: Icon(
            Icons.search_rounded,
            color: colorScheme.onSurface,
            size: 24,
          ),
        ),
        const SizedBox(width: 4),
      ],
      leading: Stack(
        alignment: Alignment.center,
        children: [
          IconButton(
            onPressed: onNotificationsTap,
            icon: Icon(
              Icons.notifications_none_rounded,
              color: colorScheme.onSurface,
              size: 26,
            ),
          ),
          if (unreadNotificationsCount > 0)
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(
                  minWidth: 16,
                  minHeight: 16,
                ),
                child: Text(
                  '$unreadNotificationsCount',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

