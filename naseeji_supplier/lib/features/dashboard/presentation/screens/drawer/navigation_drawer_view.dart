import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/session/session_tracker.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../../../profile/presentation/controllers/profile_controller.dart';

class NavigationDrawerView extends ConsumerWidget {
  const NavigationDrawerView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileControllerProvider);

    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drawer Header
          profileAsync.when(
            loading: () => const DrawerHeader(
              decoration: BoxDecoration(color: AppColors.primary),
              child: Center(child: CircularProgressIndicator(color: Colors.white)),
            ),
            error: (err, stack) => DrawerHeader(
              decoration: const BoxDecoration(color: AppColors.primary),
              child: Center(child: Text('خطأ: $err', style: const TextStyle(color: Colors.white))),
            ),
            data: (profile) {
              return UserAccountsDrawerHeader(
                decoration: const BoxDecoration(color: AppColors.primary),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage(profile.logoUrl),
                  backgroundColor: Colors.white,
                ),
                accountName: Text(
                  profile.companyName,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                accountEmail: Text(
                  profile.email,
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 12),
                ),
              );
            },
          ),

          // Menu Items
          ListTile(
            leading: const Icon(Icons.dashboard_outlined),
            title: const Text('الرئيسية'),
            onTap: () {
              Navigator.pop(context); // Close drawer
              context.go('/home');
            },
          ),
          ListTile(
            leading: const Icon(Icons.search_outlined),
            title: const Text('البحث العالمي'),
            onTap: () {
              Navigator.pop(context);
              context.push('/search');
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications_outlined),
            title: const Text('مركز الإشعارات'),
            onTap: () {
              Navigator.pop(context);
              context.push('/notifications');
            },
          ),
          ListTile(
            leading: const Icon(Icons.account_circle_outlined),
            title: const Text('الملف الشخصي للمورد'),
            onTap: () {
              Navigator.pop(context);
              context.push('/profile');
            },
          ),
          const Divider(),
          const Spacer(),

          // Logout Button
          ListTile(
            leading: const Icon(Icons.logout, color: AppColors.error),
            title: const Text(
              'تسجيل الخروج',
              style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold),
            ),
            onTap: () {
              ref.read(sessionTrackerProvider.notifier).endSession();
              context.go('/login');
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
