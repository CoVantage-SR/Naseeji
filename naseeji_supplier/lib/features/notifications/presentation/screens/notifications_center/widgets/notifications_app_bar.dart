import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';

class NotificationsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onMarkAllRead;

  const NotificationsAppBar({super.key, required this.onMarkAllRead});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.5,
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: onMarkAllRead,
            child: const Text(
              'تحديد الكل كمقروء',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Row(
            children: [
              const Text(
                'الإشعارات',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.arrow_forward, color: AppColors.onSurface),
                onPressed: () => context.pop(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
