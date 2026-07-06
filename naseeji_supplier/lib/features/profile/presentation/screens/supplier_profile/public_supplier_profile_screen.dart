import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../../controllers/profile_controller.dart';

class PublicSupplierProfileScreen extends ConsumerStatefulWidget {
  const PublicSupplierProfileScreen({super.key});

  @override
  ConsumerState<PublicSupplierProfileScreen> createState() => _PublicSupplierProfileScreenState();
}

class _PublicSupplierProfileScreenState extends ConsumerState<PublicSupplierProfileScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> tabTitles = const [
    'ملخص الشركة',
    'المنتجات المتاحة',
    'معرض الصور',
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
                  title: Text(profile.companyName, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 13)),
                  centerTitle: true,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.onSurfaceVariant, size: 20),
                    onPressed: () => context.pop(),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 50),
                        // Cover & Logo
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              height: 100,
                              decoration: BoxDecoration(
                                image: DecorationImage(image: NetworkImage(profile.bannerUrl), fit: BoxFit.cover),
                              ),
                            ),
                            Positioned(
                              bottom: -32,
                              right: 20,
                              child: Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 3),
                                  image: DecorationImage(image: NetworkImage(profile.logoUrl), fit: BoxFit.cover),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 36),

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
                                    child: const Text('مورد معتمد', style: TextStyle(color: Color(0xFF006B5F), fontSize: 8, fontWeight: FontWeight.bold)),
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
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
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
                              const SizedBox(width: 8),
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
                _buildPublicOverviewTab(profile),
                _buildPublicProductsTab(),
                _buildPublicGalleryTab(),
                _buildPublicCertificatesTab(),
                _buildPublicReviewsTab(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPublicOverviewTab(dynamic profile) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE2E1EF))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text('ملخص تعريف الشركة للزوار', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF0040E0))),
                const SizedBox(height: 12),
                _buildRowItem('سنة التأسيس المعتمدة', '2016'),
                _buildRowItem('بلد المنشأ الرئيسي', 'المملكة العربية السعودية SA'),
                _buildRowItem('المساحة الإجمالية للمصنع', '12,500 متر مربع'),
                _buildRowItem('أجل السداد الافتراضي المتاح', 'Net 30 أيام'),
                _buildRowItem('متوسط زمن الاستجابة للمصانع', 'أقل من ساعتين'),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text('الأوسمة الحاصل عليها المورد', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildAchievementBadge('Top Supplier', Colors.orange),
              const SizedBox(width: 8),
              _buildAchievementBadge('Verified Business', Colors.blue),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPublicProductsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text('أبرز المنتجات المعروضة للطلب', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 16),
          _buildProductListItem('خيوط غزل القطن الطبيعي 100%', 'مخزون: 15,000م • MOQ: 100م', 'https://images.unsplash.com/photo-1544816155-12df9643f363?auto=format&fit=crop&w=100&q=80'),
          _buildProductListItem('قماش الكتان المقاوم للرطوبة والحرارة', 'مخزون: 8,200م • MOQ: 50م', 'https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?auto=format&fit=crop&w=100&q=80'),
        ],
      ),
    );
  }

  Widget _buildPublicGalleryTab() {
    final mockGallery = [
      'https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?auto=format&fit=crop&w=150&q=80',
      'https://images.unsplash.com/photo-1544816155-12df9643f363?auto=format&fit=crop&w=150&q=80',
    ];

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.2,
      ),
      itemCount: mockGallery.length,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(image: NetworkImage(mockGallery[index]), fit: BoxFit.cover),
          ),
        );
      },
    );
  }

  Widget _buildPublicCertificatesTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildCertificateItem('شهادة مطابقة مواصفات الجودة ISO 9001', 'نشط وموثق', true),
        _buildCertificateItem('شهادة منشأ للمنسوجات والقطنيات', 'نشط وموثق', true),
      ],
    );
  }

  Widget _buildPublicReviewsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildReviewTile('مصنع الملابس المتحدة', 'خامات ممتازة وخدمة توصيل سريعة جداً نوصي بالتعامل المستمر.', 5.0),
        _buildReviewTile('شركة الفوزان للأزياء', 'جودة القماش ممتازة والدفع الضامن آمن ومريح.', 4.5),
      ],
    );
  }

  Widget _buildRowItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(child: Text(value, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold), textAlign: TextAlign.left)),
          const SizedBox(width: 10),
          Text('$label:', style: const TextStyle(fontSize: 10, color: AppColors.outline)),
        ],
      ),
    );
  }

  static Widget _buildAchievementBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(label, style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildProductListItem(String name, String specs, String imgUrl) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Color(0xFFE2E1EF))),
      color: Colors.white,
      child: ListTile(
        title: Text(name, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold), textAlign: TextAlign.end),
        subtitle: Text(specs, style: const TextStyle(fontSize: 9, color: AppColors.outline), textAlign: TextAlign.end),
        trailing: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(image: NetworkImage(imgUrl), fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }

  Widget _buildCertificateItem(String name, String status, bool verified) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Color(0xFFE2E1EF))),
      color: Colors.white,
      child: ListTile(
        title: Text(name, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold), textAlign: TextAlign.end),
        subtitle: Text(status, style: const TextStyle(fontSize: 9, color: Color(0xFF16A34A)), textAlign: TextAlign.end),
        trailing: Icon(verified ? Icons.check_circle_outline : Icons.pending_outlined, color: const Color(0xFF16A34A), size: 20),
      ),
    );
  }

  Widget _buildReviewTile(String author, String text, double rating) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Color(0xFFE2E1EF))),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text('$rating', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 2),
                    const Icon(Icons.star, color: Colors.orange, size: 12),
                  ],
                ),
                Text(author, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 6),
            Text(text, style: const TextStyle(fontSize: 10, color: AppColors.onSurfaceVariant, height: 1.4), textAlign: TextAlign.end),
          ],
        ),
      ),
    );
  }

  void _showConfirmation(String msg) {
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
