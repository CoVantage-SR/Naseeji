import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../../core/constants/app_colors.dart';
import '../../../../../../../core/extensions/context_extensions.dart';
import '../../../../../../../core/widgets/reusable_widgets.dart';

class HomeAppBarWidget extends ConsumerWidget implements PreferredSizeWidget {
  final String factoryName;
  final String greeting;
  final int notificationCount;
  final int messageCount;
  final VoidCallback? onMenuPressed;
  final VoidCallback? onSearchPressed;
  final VoidCallback? onMessagesPressed;
  final VoidCallback? onNotificationsPressed;

  const HomeAppBarWidget({
    super.key,
    required this.factoryName,
    required this.greeting,
    this.notificationCount = 0,
    this.messageCount = 0,
    this.onMenuPressed,
    this.onSearchPressed,
    this.onMessagesPressed,
    this.onNotificationsPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.menu_rounded, color: AppColors.primary),
        onPressed: onMenuPressed ?? () => Scaffold.of(context).openDrawer(),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            greeting,
            style: context.textTheme.labelSmall?.copyWith(
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            factoryName,
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search_rounded, color: AppColors.primary),
          onPressed: onSearchPressed ?? () => context.push('/search'),
        ),
        NotificationBadge(
          count: messageCount,
          child: IconButton(
            icon: const Icon(Icons.chat_bubble_outline_rounded, color: AppColors.primary),
            onPressed: onMessagesPressed ?? () => checkGuestAction(context, ref, () => context.push('/chat')),
          ),
        ),
        NotificationBadge(
          count: notificationCount,
          child: IconButton(
            icon: const Icon(Icons.notifications_none_rounded, color: AppColors.primary),
            onPressed: onNotificationsPressed ?? () => checkGuestAction(context, ref, () => context.push('/notifications')),
          ),
        ),
        const SizedBox(width: 8),
      ],
      elevation: 0,
      scrolledUnderElevation: 1,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
