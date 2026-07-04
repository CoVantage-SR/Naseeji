import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../../controllers/profile_controller.dart';
import 'widgets/achievements_card.dart';
import 'widgets/business_info_card.dart';
import 'widgets/latest_textiles_section.dart';
import 'widgets/profile_hero_banner.dart';
import 'widgets/profile_info_block.dart';
import 'widgets/recent_activity_timeline.dart';
import 'widgets/stats_metrics_section.dart';

class SupplierProfileScreen extends ConsumerWidget {
  const SupplierProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileControllerProvider);

    return Scaffold(
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('خطأ: $err')),
        data: (profile) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top cover banner and logo
                ProfileHeroBanner(
                  bannerUrl: profile.bannerUrl,
                  logoUrl: profile.logoUrl,
                ),
                const SizedBox(height: 12),

                // Name & action buttons
                ProfileInfoBlock(
                  companyName: profile.companyName,
                  rating: profile.rating,
                ),
                const SizedBox(height: 24),

                // Business info (Location, experience years, categories)
                BusinessInfoCard(location: profile.city),
                const SizedBox(height: 16),

                // Achievements and B2B credentials
                const AchievementsCard(),
                const SizedBox(height: 16),

                // Stats metric progress bars
                const StatsMetricsSection(),
                const SizedBox(height: 24),

                // Product gallery list
                const LatestTextilesSection(),
                const SizedBox(height: 24),

                // Activity timeline history log
                const RecentActivityTimeline(),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 4,
        backgroundColor: Colors.white,
        elevation: 8,
        indicatorColor: const Color(0xFF72F8E4).withValues(alpha: 0.6),
        onDestinationSelected: (index) {
          if (index == 0) {
            context.go('/home');
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined, color: AppColors.onSurfaceVariant),
            selectedIcon: Icon(Icons.home, color: AppColors.secondary),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.category_outlined, color: AppColors.onSurfaceVariant),
            selectedIcon: Icon(Icons.category, color: AppColors.secondary),
            label: 'Products',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_cart_outlined, color: AppColors.onSurfaceVariant),
            selectedIcon: Icon(Icons.shopping_cart, color: AppColors.secondary),
            label: 'Orders',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline, color: AppColors.onSurfaceVariant),
            selectedIcon: Icon(Icons.chat_bubble, color: AppColors.secondary),
            label: 'Messages',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline, color: AppColors.onSurfaceVariant),
            selectedIcon: Icon(Icons.person, color: AppColors.secondary),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}
