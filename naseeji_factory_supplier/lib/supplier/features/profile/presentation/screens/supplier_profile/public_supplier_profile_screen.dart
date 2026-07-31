import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_factory/supplier/core/theme/app_colors.dart';
import '../../controllers/profile_controller.dart';
import 'widgets/sliver_app_bar_delegate.dart';
import 'widgets/public_overview_tab_view.dart';
import 'widgets/public_certificates_tab_view.dart';
import 'widgets/public_reviews_tab_view.dart';
import 'widgets/public_profile_header_card.dart';

class PublicSupplierProfileScreen extends ConsumerStatefulWidget {
  const PublicSupplierProfileScreen({super.key});

  @override
  ConsumerState<PublicSupplierProfileScreen> createState() => _PublicSupplierProfileScreenState();
}

class _PublicSupplierProfileScreenState extends ConsumerState<PublicSupplierProfileScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> tabTitles = const [
    'ملخص الشركة',
    'الشهادات المعتمدة',
    'التقييمات والآراء',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabTitles.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileControllerProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: profileAsync.when(
        loading: () => Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (err, stack) => Center(child: Text('خطأ: $err')),
        data: (profile) {
          return NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  expandedHeight: 265,
                  floating: false,
                  pinned: true,
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  elevation: 0.5,
                  title: innerBoxIsScrolled
                      ? Text(
                          profile.companyName,
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        )
                      : null,
                  centerTitle: true,
                  leading: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: AppColors.onSurfaceVariant,
                      size: 25,
                    ),
                    onPressed: () => context.pop(),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    background: PublicProfileHeaderCard(profile: profile),
                  ),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: SliverAppBarDelegate(
                    TabBar(
                      controller: _tabController,
                      isScrollable: false,
                      labelColor: const Color(0xFF0040E0),
                      unselectedLabelColor: Theme.of(context).colorScheme.onSurfaceVariant,
                      indicatorColor: const Color(0xFF0040E0),
                      labelStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      tabs: tabTitles.map((title) => Tab(text: title)).toList(),
                    ),
                  ),
                ),
              ];
            },
            body: TabBarView(
              controller: _tabController,
              children: [
                PublicOverviewTabView(profile: profile),
                PublicCertificatesTabView(profile: profile),
                PublicReviewsTabView(profile: profile),
              ],
            ),
          );
        },
      ),
    );
  }
}