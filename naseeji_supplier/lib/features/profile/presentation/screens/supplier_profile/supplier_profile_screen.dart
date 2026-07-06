import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../../controllers/profile_controller.dart';
import 'widgets/recent_activity_timeline.dart';

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
    'المنتجات',
    'معرض الصور',
    'الشهادات',
    'التحليلات والأداء',
    'العملاء',
    'الشحن اللوجستي',
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
                                  const Text('10 سنوات خبرة', style: const TextStyle(fontSize: 10, color: AppColors.outline)),
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
                _buildOverviewTab(profile),
                _buildCompanyInfoTab(profile),
                _buildProductsTab(),
                _buildGalleryTab(),
                _buildCertificatesTab(),
                _buildPerformanceTab(),
                _buildCustomersTab(),
                _buildShippingTab(),
                _buildPaymentsTab(),
                _buildSettingsTab(),
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

  // TAB 1 — Overview
  Widget _buildOverviewTab(dynamic profile) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Statistics grid row
          Row(
            children: [
              Expanded(child: _buildMetricCard('نسبة الرد السريع', '98%', Icons.bolt_outlined, Colors.orange)),
              const SizedBox(width: 10),
              Expanded(child: _buildMetricCard('التوصيل في الموعد', '95%', Icons.local_shipping_outlined, Colors.green)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _buildMetricCard('المنتجات المفعلة', '${profile.productsCount}', Icons.inventory_2_outlined, const Color(0xFF0040E0))),
              const SizedBox(width: 10),
              Expanded(child: _buildMetricCard('الطلبات المكتملة', '${profile.ordersCount}', Icons.done_all_outlined, const Color(0xFF006B5F))),
            ],
          ),
          const SizedBox(height: 20),

          // Business Summary
          const Text('نبذة عن أعمال الشركة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 8),
          const Text(
            'نحن مصنع متخصص في تصنيع خامات الأقمشة والقطن الممتاز عالي الجودة لتلبية احتياجات مصانع الملابس الجاهزة وشركات النسيج B2B في الشرق الأوسط.',
            style: TextStyle(fontSize: 11, height: 1.4, color: AppColors.onSurfaceVariant),
            textAlign: TextAlign.end,
          ),
          const SizedBox(height: 20),

          // Credentials achievements badges
          const Text('أوسمة الجودة والاعتمادات', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 12),
          const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildAchievementBadge('Top Supplier', Colors.orange),
              SizedBox(width: 8),
              _buildAchievementBadge('Verified Business', Colors.blue),
              SizedBox(width: 8),
              _buildAchievementBadge('ISO Certified', Colors.green),
            ],
          ),
          const SizedBox(height: 20),

          // Activity Timeline
          const Text('أحدث نشاطات الشركة الموثقة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 12),
          const RecentActivityTimeline(),
        ],
      ),
    );
  }

  // TAB 2 — Company Information
  Widget _buildCompanyInfoTab(dynamic profile) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE2E1EF))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text('المعلومات القانونية والتجارية للمنشأة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF0040E0))),
            const SizedBox(height: 12),
            _buildRowItem('الاسم التجاري المعتمد', profile.companyName),
            _buildRowItem('رقم السجل التجاري (CR)', '1010998822 (نشط)'),
            _buildRowItem('رقم التسجيل الضريبي (VAT)', '300998877110003'),
            _buildRowItem('نوع النشاط التجاري', 'جهة تصنيع وتوريد جملة'),
            _buildRowItem('المساحة الإجمالية للمصنع', '12,500 متر مربع'),
            _buildRowItem('عدد العمال والموظفين الفنيين', '250+ فني خياطة ونسيج'),
            _buildRowItem('الطاقة الإنتاجية الشهرية', '150,000 متر طولي'),
            _buildRowItem('موقع المنشأة وعنوان الإدارة', 'شارع الصناعية، الرياض، SA'),
            _buildRowItem('الموقع الإلكتروني', 'www.naseejitex.com'),
            _buildRowItem('رقم الهاتف للتواصل', profile.phone),
            _buildRowItem('البريد الإلكتروني للطلبات', profile.email),
          ],
        ),
      ),
    );
  }

  // TAB 3 — Products
  Widget _buildProductsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add, size: 14, color: Color(0xFF0040E0)),
                label: const Text('إضافة منتج جديد', style: TextStyle(color: Color(0xFF0040E0), fontSize: 11)),
                style: OutlinedButton.styleFrom(side: const BorderSide(color: Color(0xFF0040E0))),
              ),
              const Text('إدارة الكتالوج والمنتجات المفعلة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 16),
          _buildProductListItem('خيوط غزل القطن الطبيعي 100%', 'مخزون: 15,000م • MOQ: 100م', 'https://images.unsplash.com/photo-1544816155-12df9643f363?auto=format&fit=crop&w=100&q=80'),
          _buildProductListItem('قماش الكتان المقاوم للرطوبة والحرارة', 'مخزون: 8,200م • MOQ: 50م', 'https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?auto=format&fit=crop&w=100&q=80'),
          _buildProductListItem('منسوجات البوليستر المقوى الصناعي', 'مخزون: 30,000م • MOQ: 500م', 'https://images.unsplash.com/photo-1596461404969-9ae70f2830c1?auto=format&fit=crop&w=100&q=80'),
        ],
      ),
    );
  }

  // TAB 4 — Gallery
  Widget _buildGalleryTab() {
    final mockGallery = [
      'https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?auto=format&fit=crop&w=150&q=80',
      'https://images.unsplash.com/photo-1544816155-12df9643f363?auto=format&fit=crop&w=150&q=80',
      'https://images.unsplash.com/photo-1596461404969-9ae70f2830c1?auto=format&fit=crop&w=150&q=80',
      'https://images.unsplash.com/photo-1576086213369-97a306d36557?auto=format&fit=crop&w=150&q=80',
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

  // TAB 5 — Certificates
  Widget _buildCertificatesTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildCertificateItem('شهادة مطابقة مواصفات الجودة ISO 9001', 'صالحة لغاية 2027-12', true),
        _buildCertificateItem('شهادة منشأ للمنسوجات والقطنيات', 'صالحة لغاية 2026-10', true),
        _buildCertificateItem('رخصة التصدير الصناعية المعتمدة للمؤسسة', 'صالحة لغاية 2027-04', true),
      ],
    );
  }

  // TAB 6 — Performance
  Widget _buildPerformanceTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text('لوحة قياس مؤشرات الأداء والنمو B2B', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE2E1EF))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildRowItem('إجمالي مبيعات وإيرادات العروض المعتمدة', '340,000 ر.س'),
                _buildRowItem('معدل نمو الأرباح الربع سنوي', '18.4% +'),
                _buildRowItem('نسبة قبول عروض الأسعار (Conversion)', '88%'),
                _buildRowItem('نسبة إخفاق أو إلغاء الشحنات', '1.2% (ممتاز)'),
                _buildRowItem('العملاء المتكررين والأوفياء لنسيجي', '32 مصنع دائم'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // TAB 7 — Customers
  Widget _buildCustomersTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildCustomerTile('مصنع الرياض للملابس الجاهزة', 'المنطقة الصناعية الأولى • 5 صفقات مكتملة', 'RC'),
        _buildCustomerTile('حلول جدة للنسيج والملابس', 'المدينة الصناعية الثانية • 3 صفقات مكتملة', 'JT'),
        _buildCustomerTile('شركة الأزياء الموحدة للاستيراد والتصدير', 'المنطقة الحرة بميناء الملك عبد الله • صفقة واحدة نشطة', 'UF'),
      ],
    );
  }

  // TAB 8 — Shipping
  Widget _buildShippingTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE2E1EF))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text('الشركاء واللوجستيات والتغطية الجغرافية', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF0040E0))),
            const SizedBox(height: 12),
            _buildRowItem('شركات النقل واللوجستيات المفضلة', 'أرامكس Aramex • دي إتش إل DHL'),
            _buildRowItem('تغطية النطاق الجغرافي للشحن', 'كافة مدن المملكة العربية السعودية • دول مجلس التعاون'),
            _buildRowItem('متوسط مدة شحن الطلب الداخلي', '2-3 أيام عمل'),
            _buildRowItem('معدل نجاح تتبع وتوصيل الشحنات', '99.4%'),
          ],
        ),
      ),
    );
  }

  // TAB 9 — Payments
  Widget _buildPaymentsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE2E1EF))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text('طرق الدفع والتسهيلات الائتمانية والعملات المقبولة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF006B5F))),
            const SizedBox(height: 12),
            _buildRowItem('العملات المقبولة لسداد المستندات', 'ريال سعودي (SAR) • دولار أمريكي (USD)'),
            _buildRowItem('طرق السداد المعتمدة', 'تحويل بنكي مباشر • دفع ضامن (Escrow) • شيكات معتمدة'),
            _buildRowItem('أجل السداد المعتمد (Credit terms)', 'Net 30 أيام • دفعة مقدمة 30% مع تأمين الشحنة'),
            _buildRowItem('الحساب البنكي الرئيسي للمورد', 'البنك الأهلي السعودي SNB - آيبان SA90000001234567890'),
          ],
        ),
      ),
    );
  }

  // TAB 10 — Settings
  Widget _buildSettingsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ListTile(
          trailing: const Icon(Icons.arrow_forward_ios, size: 14),
          title: const Text('تغيير كلمة المرور الشخصية للمفتاح', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold), textAlign: TextAlign.end),
          leading: const Icon(Icons.lock_outline, color: AppColors.outline),
          onTap: () {},
        ),
        ListTile(
          trailing: const Icon(Icons.arrow_forward_ios, size: 14),
          title: const Text('لغة واجهة التطبيق واللوكاليزيشن', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold), textAlign: TextAlign.end),
          leading: const Icon(Icons.language, color: AppColors.outline),
          onTap: () {},
        ),
        ListTile(
          trailing: const Icon(Icons.arrow_forward_ios, size: 14),
          title: const Text('الأجهزة المتصلة والصلاحيات الأمنية والرموز', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold), textAlign: TextAlign.end),
          leading: const Icon(Icons.devices_outlined, color: AppColors.outline),
          onTap: () {},
        ),
        ListTile(
          trailing: const Icon(Icons.arrow_forward_ios, size: 14),
          title: const Text('تسجيل الخروج الآمن للمورد', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.error), textAlign: TextAlign.end),
          leading: const Icon(Icons.logout, color: AppColors.error),
          onTap: () {},
        ),
      ],
    );
  }

  // Common UI builders
  Widget _buildMetricCard(String label, String val, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE2E1EF))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: color, size: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(val, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              Text(label, style: const TextStyle(fontSize: 9, color: AppColors.outline)),
            ],
          ),
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
        leading: const Icon(Icons.arrow_back_ios, size: 12),
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

  Widget _buildCertificateItem(String name, String date, bool verified) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Color(0xFFE2E1EF))),
      color: Colors.white,
      child: ListTile(
        title: Text(name, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold), textAlign: TextAlign.end),
        subtitle: Text(date, style: const TextStyle(fontSize: 9, color: AppColors.outline), textAlign: TextAlign.end),
        trailing: Icon(verified ? Icons.check_circle_outline : Icons.pending_outlined, color: verified ? const Color(0xFF16A34A) : Colors.orange, size: 20),
        leading: IconButton(
          icon: const Icon(Icons.download_rounded, color: Color(0xFF0040E0), size: 18),
          onPressed: () {},
        ),
      ),
    );
  }

  Widget _buildCustomerTile(String name, String subtitle, String initials) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Color(0xFFE2E1EF))),
      color: Colors.white,
      child: ListTile(
        title: Text(name, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold), textAlign: TextAlign.end),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 9, color: AppColors.outline), textAlign: TextAlign.end),
        leading: const Icon(Icons.arrow_back_ios, size: 12),
        trailing: Container(
          width: 36,
          height: 36,
          decoration: const BoxDecoration(color: Color(0xFFE8F0FE), shape: BoxShape.circle),
          child: Center(
            child: Text(
              initials,
              style: const TextStyle(color: Color(0xFF0040E0), fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
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
