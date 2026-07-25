import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../controllers/profile_controller.dart';

class SupplierProfileScreen extends ConsumerWidget {
  const SupplierProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileControllerProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FAFB),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              children: [
                // 1. Top Custom App Bar Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Right: Settings Gear + Title & Subtitle
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: const BoxDecoration(
                            color: Color(0xFFEFF6FF),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.settings_outlined,
                            color: Color(0xFF2563EB),
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'حسابي',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF111827),
                                height: 1.1,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'إدارة بياناتك وإعدادات حسابك',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF6B7280),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Left: Notification Bell Icon with Badge '3'
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        IconButton(
                          onPressed: () => context.push('/notifications'),
                          icon: const Icon(
                            Icons.notifications_none_rounded,
                            color: Color(0xFF4B5563),
                            size: 24,
                          ),
                        ),
                        Positioned(
                          top: 6,
                          right: 6,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Color(0xFFEF4444),
                              shape: BoxShape.circle,
                            ),
                            child: const Text(
                              '3',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                height: 1.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // 2. Profile Main Header Card (Supplier Profile Card)
                profileAsync.when(
                  loading: () => _buildProfileHeaderCard(
                    context,
                    companyName: 'مصنع الخليج للملابس',
                    category: 'مورد أقمشة وملابس جاهزة',
                    location: 'المنصورة، مصر',
                    joinedDate: 'عضو منذ مايو 2024',
                    email: 'info@gulf-factory.com',
                    phone: '+20 101 234 5678',
                    accountType: 'مورد موثق',
                  ),
                  error: (_, __) => _buildProfileHeaderCard(
                    context,
                    companyName: 'مصنع الخليج للملابس',
                    category: 'مورد أقمشة وملابس جاهزة',
                    location: 'المنصورة، مصر',
                    joinedDate: 'عضو منذ مايو 2024',
                    email: 'info@gulf-factory.com',
                    phone: '+20 101 234 5678',
                    accountType: 'مورد موثق',
                  ),
                  data: (profile) => _buildProfileHeaderCard(
                    context,
                    companyName: profile.companyName.isNotEmpty ? profile.companyName : 'مصنع الخليج للملابس',
                    category: 'مورد أقمشة وملابس جاهزة',
                    location: '${profile.city}، مصر',
                    joinedDate: 'عضو منذ مايو 2024',
                    email: profile.email.isNotEmpty ? profile.email : 'info@gulf-factory.com',
                    phone: profile.phone.isNotEmpty ? profile.phone : '+20 101 234 5678',
                    accountType: 'مورد موثق',
                  ),
                ),

                const SizedBox(height: 14),

                // 3. Current Subscription Card (Blue Banner)
                _buildSubscriptionCard(context),

                const SizedBox(height: 14),

                // 4. Performance & Metrics Grid (4 Cards Row)
                _buildMetricsGrid(),

                const SizedBox(height: 14),

                // 5. Settings Options Menu Card Group
                _buildSettingsMenuList(context),

                const SizedBox(height: 16),

                // 6. About App Version Info Row
                InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(8),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.info_outline_rounded, size: 18, color: Color(0xFF6B7280)),
                            SizedBox(width: 6),
                            Text(
                              'عن التطبيق',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF4B5563),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'الإصدار 1.3.0',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF9CA3AF),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // 7. Logout Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      _showLogoutDialog(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFEF2F2),
                      foregroundColor: const Color(0xFFEF4444),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.logout_rounded, size: 20, color: Color(0xFFEF4444)),
                        SizedBox(width: 8),
                        Text(
                          'تسجيل الخروج',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFEF4444),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Widget 1: Profile Main Header Card
  // ---------------------------------------------------------------------------
  Widget _buildProfileHeaderCard(
    BuildContext context, {
    required String companyName,
    required String category,
    required String location,
    required String joinedDate,
    required String email,
    required String phone,
    required String accountType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () => context.push('/profile/edit'),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                // Top Row: Avatar with Camera Icon, Info Column, Chevron
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Avatar Stack
                    Stack(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: const BoxDecoration(
                            color: Color(0xFF0F4C44),
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Text(
                              'M',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          child: Container(
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              color: const Color(0xFF2563EB),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Icon(
                              Icons.camera_alt_rounded,
                              size: 11,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),

                    // Info Column
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Company Name + Verified Badge
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  companyName,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF111827),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.verified_rounded,
                                size: 16,
                                color: Color(0xFF2563EB),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),

                          // Category
                          Text(
                            category,
                            style: const TextStyle(
                              fontSize: 11.5,
                              color: Color(0xFF6B7280),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),

                          // Location & Joined Date
                          Row(
                            children: [
                              const Icon(Icons.location_on_outlined, size: 12, color: Color(0xFF9CA3AF)),
                              const SizedBox(width: 2),
                              Text(
                                location,
                                style: const TextStyle(
                                  fontSize: 10.5,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Icon(Icons.calendar_today_outlined, size: 11, color: Color(0xFF9CA3AF)),
                              const SizedBox(width: 3),
                              Text(
                                joinedDate,
                                style: const TextStyle(
                                  fontSize: 10.5,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Left Chevron Arrow
                    const Icon(
                      Icons.chevron_left_rounded,
                      size: 22,
                      color: Color(0xFF9CA3AF),
                    ),
                  ],
                ),

                const SizedBox(height: 12),
                const Divider(height: 1, color: Color(0xFFF3F4F6)),
                const SizedBox(height: 12),

                // Bottom Row (3 Columns: Email, Phone, Account Type)
                Row(
                  children: [
                    // Email
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'البريد الإلكتروني',
                            style: TextStyle(
                              fontSize: 10,
                              color: Color(0xFF9CA3AF),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            email,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF111827),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),

                    // Phone
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'رقم الهاتف',
                            style: TextStyle(
                              fontSize: 10,
                              color: Color(0xFF9CA3AF),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Directionality(
                            textDirection: TextDirection.ltr,
                            child: Text(
                              phone,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF111827),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),

                    // Account Type
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'نوع الحساب',
                            style: TextStyle(
                              fontSize: 10,
                              color: Color(0xFF9CA3AF),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFF6FF),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              'مورد موثق',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2563EB),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Widget 2: Subscription & Billing Banner Card
  // ---------------------------------------------------------------------------
  Widget _buildSubscriptionCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F8FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFDBEAFE)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Right Side: Crown Badge & Subscription Details
              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: const BoxDecoration(
                      color: Color(0xFFDBEAFE),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.workspace_premium_rounded,
                      color: Color(0xFF2563EB),
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'الباقة الحالية',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF6B7280),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Text(
                            'باقة احترافية',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF111827),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFDBEAFE),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'نشطة',
                              style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2563EB),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'تجدد في 23 مايو 2025',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // Left Side: Circular Remaining Days Gauge (14 Days)
              SizedBox(
                width: 52,
                height: 52,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomPaint(
                      size: const Size(52, 52),
                      painter: _GaugePainter(
                        progress: 0.65,
                        strokeWidth: 4.5,
                        color: const Color(0xFF2563EB),
                        backgroundColor: const Color(0xFFDBEAFE),
                      ),
                    ),
                    const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '14',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF111827),
                            height: 1.0,
                          ),
                        ),
                        SizedBox(height: 1),
                        Text(
                          'يوماً متبقية',
                          style: TextStyle(
                            fontSize: 7.5,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF6B7280),
                            height: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Bottom Full-width Outline Button inside Card
          SizedBox(
            width: double.infinity,
            height: 38,
            child: OutlinedButton(
              onPressed: () => context.push('/subscription/management'),
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
                side: const BorderSide(color: Color(0xFFBFDBFE), width: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.chevron_left_rounded, size: 18, color: Color(0xFF2563EB)),
                  SizedBox(width: 4),
                  Text(
                    'إدارة الاشتراك والفواتير',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2563EB),
                    ),
                  ),
                  SizedBox(width: 6),
                  Icon(Icons.workspace_premium_rounded, size: 16, color: Color(0xFF2563EB)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Widget 3: Metrics Grid (4 Stat Cards Row)
  // ---------------------------------------------------------------------------
  Widget _buildMetricsGrid() {
    final metrics = [
      const _MetricItem(
        title: 'المنتجات النشطة',
        value: '12',
        icon: Icons.military_tech_outlined,
        iconColor: Color(0xFFEA580C),
        bgColor: Color(0xFFFFF7ED),
      ),
      const _MetricItem(
        title: 'الطلبات المكتملة',
        value: '24',
        icon: Icons.shield_outlined,
        iconColor: Color(0xFF2563EB),
        bgColor: Color(0xFFEFF6FF),
      ),
      const _MetricItem(
        title: 'معدل الاستجابة',
        value: '98%',
        icon: Icons.favorite_outline_rounded,
        iconColor: Color(0xFF9333EA),
        bgColor: Color(0xFFF3E8FF),
      ),
      const _MetricItem(
        title: 'تقييمك',
        value: '4.8',
        icon: Icons.bookmark_outline_rounded,
        iconColor: Color(0xFF16A34A),
        bgColor: Color(0xFFF0FDF4),
      ),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: metrics.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;

          return Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: index == metrics.length - 1
                    ? null
                    : const Border(
                        left: BorderSide(color: Color(0xFFF3F4F6), width: 1),
                      ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: item.bgColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(item.icon, size: 16, color: item.iconColor),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6B7280),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Widget 4: Settings Menu List Options Card
  // ---------------------------------------------------------------------------
  Widget _buildSettingsMenuList(BuildContext context) {
    final menuItems = [
      _MenuItemData(
        title: 'البيانات الأساسية',
        subtitle: 'تعديل اسم المصنع وبيانات التواصل',
        icon: Icons.person_outline_rounded,
        iconColor: const Color(0xFF2563EB),
        bgColor: const Color(0xFFEFF6FF),
        route: '/profile/edit',
      ),
      _MenuItemData(
        title: 'فريق العمل',
        subtitle: 'إدارة الموظفين والصلاحيات',
        icon: Icons.group_outlined,
        iconColor: const Color(0xFF16A34A),
        bgColor: const Color(0xFFF0FDF4),
        route: '/team',
      ),
      _MenuItemData(
        title: 'طرق الدفع والحسابات البنكية',
        subtitle: 'إدارة حساباتك البنكية وطرق الدفع والاشتراك',
        icon: Icons.credit_card_rounded,
        iconColor: const Color(0xFF9333EA),
        bgColor: const Color(0xFFF3E8FF),
        route: '/subscription',
      ),
      _MenuItemData(
        title: 'إعدادات الإشعارات',
        subtitle: 'تخصيص الإشعارات والتنبيهات',
        icon: Icons.notifications_none_rounded,
        iconColor: const Color(0xFFEA580C),
        bgColor: const Color(0xFFFFF7ED),
        route: '/notifications/settings',
      ),
      _MenuItemData(
        title: 'الأمان وتسجيل الدخول',
        subtitle: 'تغيير كلمة المرور وإعدادات الأمان',
        icon: Icons.shield_outlined,
        iconColor: const Color(0xFF2563EB),
        bgColor: const Color(0xFFEFF6FF),
        route: '/profile/edit',
      ),
      _MenuItemData(
        title: 'اللغة والمظهر',
        subtitle: 'تغيير اللغة والمظهر العام للتطبيق',
        icon: Icons.dark_mode_outlined,
        iconColor: const Color(0xFF4B5563),
        bgColor: const Color(0xFFF3F4F6),
        route: '/profile/edit',
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: menuItems.length,
          separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFF3F4F6)),
          itemBuilder: (context, index) {
            final item = menuItems[index];

            return ListTile(
              onTap: () => context.push(item.route),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
              leading: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: item.bgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(item.icon, size: 18, color: item.iconColor),
              ),
              title: Text(
                item.title,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),
              subtitle: Text(
                item.subtitle,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF6B7280),
                ),
              ),
              trailing: const Icon(
                Icons.chevron_left_rounded,
                size: 20,
                color: Color(0xFF9CA3AF),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('تسجيل الخروج', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          content: const Text('هل أنت تأكد من رغبتك في تسجيل الخروج من حسابك؟', style: TextStyle(fontSize: 13)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                context.go('/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF4444),
                foregroundColor: Colors.white,
              ),
              child: const Text('تسجيل الخروج'),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------
class _MetricItem {
  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;
  final Color bgColor;

  const _MetricItem({
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.bgColor,
  });
}

class _MenuItemData {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final String route;

  const _MenuItemData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.route,
  });
}

class _GaugePainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final Color color;
  final Color backgroundColor;

  _GaugePainter({
    required this.progress,
    required this.strokeWidth,
    required this.color,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final bgPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fgPaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi,
      false,
      bgPaint,
    );

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
