import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../../controllers/profile_controller.dart';
import 'widgets/sliver_app_bar_delegate.dart';
import 'widgets/public_overview_tab_view.dart';
import 'widgets/public_certificates_tab_view.dart';
import 'widgets/public_reviews_tab_view.dart';

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
      backgroundColor: const Color(0xFFF8F9FF),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (err, stack) => Center(child: Text('خطأ: $err')),
        data: (profile) {
          return NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  expandedHeight: 290,
                  floating: false,
                  pinned: true,
                  backgroundColor: Colors.white,
                  elevation: 0.5,
                  title: innerBoxIsScrolled
                      ? Text(profile.companyName, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 13))
                      : null,
                  centerTitle: true,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.onSurfaceVariant, size: 20),
                    onPressed: () => context.pop(),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Cover & Logo
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              height: 120,
                              decoration: BoxDecoration(
                                image: DecorationImage(image: NetworkImage(profile.bannerUrl), fit: BoxFit.cover),
                              ),
                            ),
                            Positioned(
                              bottom: -36,
                              right: 20,
                              child: Container(
                                width: 72,
                                height: 72,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 3),
                                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8)],
                                  image: DecorationImage(image: NetworkImage(profile.logoUrl), fit: BoxFit.cover),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),

                        // Header Info
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(color: const Color(0xFFE2F9F5), borderRadius: BorderRadius.circular(4)),
                                    child: const Row(
                                      children: [
                                        Icon(Icons.verified, color: Color(0xFF006B5F), size: 10),
                                        SizedBox(width: 4),
                                        Text('مورد معتمد', style: TextStyle(color: Color(0xFF006B5F), fontSize: 8, fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(profile.companyName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text('${profile.city}، SA', style: const TextStyle(fontSize: 10, color: AppColors.outline)),
                                  const SizedBox(width: 4),
                                  const Icon(Icons.location_on_outlined, color: AppColors.outline, size: 12),
                                  const SizedBox(width: 12),
                                  Text('${profile.rating} / 5.0 (تقييمات نسيجي)', style: const TextStyle(fontSize: 10, color: AppColors.outline)),
                                  const SizedBox(width: 4),
                                  const Icon(Icons.star, color: Colors.orange, size: 12),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),

                        // Public interaction actions
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () => _showConfirmation('تم إرسال طلب تواصل للمورد.'),
                                  icon: const Icon(Icons.chat_bubble_outline, size: 14, color: Colors.white),
                                  label: const Text('بدء دردشة ثنائية', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF0040E0),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () => _showConfirmation('تم حفظ المورد في قائمة المتابعة.'),
                                  icon: const Icon(Icons.person_add_alt_1_outlined, size: 14, color: Color(0xFF0040E0)),
                                  label: const Text('متابعة المورد', style: TextStyle(fontSize: 11, color: Color(0xFF0040E0), fontWeight: FontWeight.bold)),
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: Color(0xFF0040E0)),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: SliverAppBarDelegate(
                    TabBar(
                      controller: _tabController,
                      isScrollable: false,
                      labelColor: const Color(0xFF0040E0),
                      unselectedLabelColor: AppColors.onSurfaceVariant,
                      indicatorColor: const Color(0xFF0040E0),
                      labelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
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

  void _showConfirmation(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}
