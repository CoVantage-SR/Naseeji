import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/profile_controller.dart';
import 'widgets/achievements_card.dart';
import 'widgets/business_info_card.dart';
import 'widgets/latest_textiles_section.dart';
import 'widgets/profile_app_bar.dart';
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
      appBar: const ProfileAppBar(),
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
    );
  }
}
