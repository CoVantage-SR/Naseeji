import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../../controllers/profile_controller.dart';
import 'widgets/overview_tab_view.dart';
import 'widgets/company_info_tab_view.dart';
import 'widgets/certificates_tab_view.dart';
import 'widgets/payments_tab_view.dart';
import 'widgets/settings_tab_view.dart';

class SupplierProfileScreen extends ConsumerStatefulWidget {
  const SupplierProfileScreen({super.key});

  @override
  ConsumerState<SupplierProfileScreen> createState() => _SupplierProfileScreenState();
}

class _SupplierProfileScreenState extends ConsumerState<SupplierProfileScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> tabTitles = const [
    'ملخص الأعمال',
    'بيانات الشركة',
    'الشهادات والاعتمادات',
    'طرق السداد',
    'الإعدادات',
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
                      ? Text(profile.companyName, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 14))
                      : null,
                  centerTitle: true,
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

                        // Header Metadata details
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
                                  Text(profile.companyName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text('${profile.city}،SA', style: const TextStyle(fontSize: 10, color: AppColors.outline)),
                                  const SizedBox(width: 4),
                                  const Icon(Icons.location_on_outlined, color: AppColors.outline, size: 12),
                                  const SizedBox(width: 12),
                                  const Text('10 سنوات خبرة', style: TextStyle(fontSize: 10, color: AppColors.outline)),
                                  const SizedBox(width: 4),
                                  const Icon(Icons.workspace_premium_outlined, color: AppColors.outline, size: 12),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),

                        // Profile Actions Row
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () {
                                    context.push('/profile/public-preview');
                                  },
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: Color(0xFF0040E0)),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                  ),
                                  child: const Text('معاينة كزائر', style: TextStyle(color: Color(0xFF0040E0), fontSize: 11, fontWeight: FontWeight.bold)),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    _showEditProfileDialog(profile);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF0040E0),
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                  ),
                                  child: const Text('تعديل البيانات', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
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
                  delegate: _SliverAppBarDelegate(
                    TabBar(
                      controller: _tabController,
                      isScrollable: true,
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
                OverviewTabView(profile: profile),
                CompanyInfoTabView(profile: profile),
                CertificatesTabView(profile: profile),
                PaymentsTabView(profile: profile),
                SettingsTabView(profile: profile),
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
          } else if (index == 2) {
            context.go('/orders');
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
            icon: Icon(Icons.person, color: Color(0xFF0040E0)),
            selectedIcon: Icon(Icons.person, color: AppColors.secondary),
            label: 'Account',
          ),
        ],
      ),
    );
  }

  void _showEditProfileDialog(dynamic profile) {
    final nameCtrl = TextEditingController(text: profile.companyName);
    final emailCtrl = TextEditingController(text: profile.email);
    final phoneCtrl = TextEditingController(text: profile.phone);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('تعديل الملف التعريفي للشركة', textAlign: TextAlign.center, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDialogTextField('اسم الشركة المعتمد', nameCtrl),
            const SizedBox(height: 10),
            _buildDialogTextField('البريد الإلكتروني للإدارة', emailCtrl),
            const SizedBox(height: 10),
            _buildDialogTextField('رقم هاتف المنشأة للتواصل', phoneCtrl),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('تراجع'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessToast('تم تحديث الملف التعريفي للشركة وجاري التدقيق والمراجعة.');
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0040E0), foregroundColor: Colors.white),
            child: const Text('حفظ التعديلات'),
          ),
        ],
      ),
    );
  }

  Widget _buildDialogTextField(String label, TextEditingController ctrl) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: TextField(
        controller: ctrl,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontSize: 11),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  void _showSuccessToast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  const _SliverAppBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
