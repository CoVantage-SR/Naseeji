import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../controllers/profile_controller.dart';

class BasicDataScreen extends ConsumerWidget {
  const BasicDataScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileControllerProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FAFB),
        body: SafeArea(
          child: Column(
            children: [
              // 1. Top Custom App Bar Header (RTL)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Right: Back Button + Title & Subtitle
                    Row(
                      children: [
                        InkWell(
                          onTap: () => context.pop(),
                          borderRadius: BorderRadius.circular(22),
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: const BoxDecoration(
                              color: Color(0xFFEFF6FF),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_forward_rounded,
                              color: Color(0xFF2563EB),
                              size: 22,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'البيانات الأساسية',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF111827),
                                height: 1.1,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'إدارة معلومات المصنع والبيانات الأساسية',
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
              ),

              // Scrollable Body Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    children: [
                      // 2. Card 1: معلومات المصنع (Factory Info Card)
                      profileAsync.when(
                        loading: () => _buildFactoryInfoCard(
                          context,
                          companyName: 'مصنع الخليج للملابس',
                          category: 'مورد أقمشة وملابس جاهزة',
                          joinedDate: '23 مايو 2024',
                          accountType: 'مورد موثق',
                          subscriptionPlan: 'الباقة الاحترافية',
                        ),
                        error: (_, __) => _buildFactoryInfoCard(
                          context,
                          companyName: 'مصنع الخليج للملابس',
                          category: 'مورد أقمشة وملابس جاهزة',
                          joinedDate: '23 مايو 2024',
                          accountType: 'مورد موثق',
                          subscriptionPlan: 'الباقة الاحترافية',
                        ),
                        data: (profile) => _buildFactoryInfoCard(
                          context,
                          companyName: profile.companyName.isNotEmpty ? profile.companyName : 'مصنع الخليج للملابس',
                          category: profile.businessType.isNotEmpty ? profile.businessType : 'مورد أقمشة وملابس جاهزة',
                          joinedDate: '23 مايو 2024',
                          accountType: 'مورد موثق',
                          subscriptionPlan: 'الباقة الاحترافية',
                        ),
                      ),

                      const SizedBox(height: 16),

                      // 3. Card 2: البيانات الأساسية (Basic Info Details List Card)
                      profileAsync.when(
                        loading: () => _buildBasicInfoDetailsCard(
                          context,
                          companyName: 'مصنع الخليج للملابس',
                          description: 'متخصصون في تصنيع وتوريد الأقمشة والملابس الجاهزة بجودة عالية',
                          country: 'مصر',
                          governorate: 'الدقهلية',
                          address: 'المنصورة، المنطقة الصناعية، قطعة 45',
                          crNumber: '1010892341',
                          taxNumber: '341-982-105',
                          phone: '+20 101 234 5678',
                          email: 'info@gulf-factory.com',
                          website: 'www.gulf-factory.com',
                        ),
                        error: (_, __) => _buildBasicInfoDetailsCard(
                          context,
                          companyName: 'مصنع الخليج للملابس',
                          description: 'متخصصون في تصنيع وتوريد الأقمشة والملابس الجاهزة بجودة عالية',
                          country: 'مصر',
                          governorate: 'الدقهلية',
                          address: 'المنصورة، المنطقة الصناعية، قطعة 45',
                          crNumber: '1010892341',
                          taxNumber: '341-982-105',
                          phone: '+20 101 234 5678',
                          email: 'info@gulf-factory.com',
                          website: 'www.gulf-factory.com',
                        ),
                        data: (profile) => _buildBasicInfoDetailsCard(
                          context,
                          companyName: profile.companyName.isNotEmpty ? profile.companyName : 'مصنع الخليج للملابس',
                          description: profile.description.isNotEmpty
                              ? profile.description
                              : 'متخصصون في تصنيع وتوريد الأقمشة والملابس الجاهزة بجودة عالية',
                          country: profile.country.isNotEmpty ? profile.country : 'مصر',
                          governorate: profile.city.isNotEmpty ? profile.city : 'الدقهلية',
                          address: profile.fullAddress.isNotEmpty
                              ? profile.fullAddress
                              : 'المنصورة، المنطقة الصناعية، قطعة 45',
                          crNumber: profile.commercialRegister.isNotEmpty
                              ? profile.commercialRegister
                              : '1010892341',
                          taxNumber: profile.taxRegistration.isNotEmpty ? profile.taxRegistration : '341-982-105',
                          phone: profile.phone.isNotEmpty ? profile.phone : '+20 101 234 5678',
                          email: profile.email.isNotEmpty ? profile.email : 'info@gulf-factory.com',
                          website: profile.website.isNotEmpty ? profile.website : 'www.gulf-factory.com',
                        ),
                      ),

                      const SizedBox(height: 16),

                      // 4. Section 3: روابط التواصل الاجتماعي (Social Media Links Card Grid)
                      _buildSocialLinksSection(),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Bottom Action Button (تعديل البيانات)
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
          ),
          child: SafeArea(
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () => context.push('/profile/edit'),
                icon: const Icon(Icons.edit_outlined, size: 18, color: Colors.white),
                label: const Text(
                  'تعديل البيانات',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Card 1: معلومات المصنع
  // ---------------------------------------------------------------------------
  Widget _buildFactoryInfoCard(
    BuildContext context, {
    required String companyName,
    required String category,
    required String joinedDate,
    required String accountType,
    required String subscriptionPlan,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
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
      child: Column(
        children: [
          // Section Title Row
          const Row(
            children: [
              ContainerIconHeader(icon: Icons.apartment_rounded),
              SizedBox(width: 8),
              Text(
                'معلومات المصنع',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Main Profile Avatar + Title & Status Badge
          Row(
            children: [
              Stack(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                      color: Color(0xFF0F4C44),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        'M',
                        style: TextStyle(
                          fontSize: 28,
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
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2563EB),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(
                        Icons.camera_alt_rounded,
                        size: 10,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                    Text(
                      category,
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: Color(0xFF6B7280),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCFCE7),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ContainerDot(color: Color(0xFF16A34A)),
                          SizedBox(width: 4),
                          Text(
                            'موثق',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF16A34A),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF3F4F6)),
          const SizedBox(height: 12),

          // Bottom 3 Stats Columns
          Row(
            children: [
              // Column 1: تاريخ الانضمام
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.calendar_today_outlined, size: 12, color: Color(0xFF2563EB)),
                        SizedBox(width: 4),
                        Text(
                          'تاريخ الانضمام',
                          style: TextStyle(
                            fontSize: 10,
                            color: Color(0xFF6B7280),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      joinedDate,
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111827),
                      ),
                    ),
                  ],
                ),
              ),

              // Column 2: نوع الحساب
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.person_outline_rounded, size: 12, color: Color(0xFF2563EB)),
                        SizedBox(width: 4),
                        Text(
                          'نوع الحساب',
                          style: TextStyle(
                            fontSize: 10,
                            color: Color(0xFF6B7280),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      accountType,
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111827),
                      ),
                    ),
                  ],
                ),
              ),

              // Column 3: حالة الاشتراك
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.workspace_premium_rounded, size: 12, color: Color(0xFF2563EB)),
                        SizedBox(width: 4),
                        Text(
                          'حالة الاشتراك',
                          style: TextStyle(
                            fontSize: 10,
                            color: Color(0xFF6B7280),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subscriptionPlan,
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2563EB),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Card 2: البيانات الأساسية التفصيلية
  // ---------------------------------------------------------------------------
  Widget _buildBasicInfoDetailsCard(
    BuildContext context, {
    required String companyName,
    required String description,
    required String country,
    required String governorate,
    required String address,
    required String crNumber,
    required String taxNumber,
    required String phone,
    required String email,
    required String website,
  }) {
    final items = [
      _InfoRowData(label: companyName, icon: Icons.apartment_rounded),
      _InfoRowData(label: description, icon: Icons.article_outlined),
      _InfoRowData(label: country, icon: Icons.location_on_outlined),
      _InfoRowData(label: governorate, icon: Icons.map_outlined),
      _InfoRowData(label: address, icon: Icons.place_outlined),
      _InfoRowData(label: crNumber, icon: Icons.assignment_outlined),
      _InfoRowData(label: taxNumber, icon: Icons.receipt_long_outlined),
      _InfoRowData(label: phone, icon: Icons.phone_outlined, isLtr: true),
      _InfoRowData(label: email, icon: Icons.mail_outline_rounded),
      _InfoRowData(label: website, icon: Icons.language_rounded),
    ];

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title Row
          const Padding(
            padding: EdgeInsets.fromLTRB(14, 14, 14, 8),
            child: Row(
              children: [
                ContainerIconHeader(icon: Icons.article_outlined),
                SizedBox(width: 8),
                Text(
                  'البيانات الأساسية',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),
              ],
            ),
          ),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFF3F4F6)),
            itemBuilder: (context, index) {
              final item = items[index];

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.label,
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF374151),
                        ),
                        textDirection: item.isLtr ? TextDirection.ltr : TextDirection.rtl,
                        textAlign: item.isLtr ? TextAlign.right : TextAlign.left,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEFF6FF),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        item.icon,
                        size: 16,
                        color: const Color(0xFF2563EB),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Card 3: روابط التواصل الاجتماعي
  // ---------------------------------------------------------------------------
  Widget _buildSocialLinksSection() {
    final socialItems = [
      const _SocialLinkData(
        title: 'واتساب',
        handle: '+20 101 234 5678',
        icon: Icons.chat_rounded,
        iconColor: Color(0xFF25D366),
      ),
      const _SocialLinkData(
        title: 'لينكدان',
        handle: 'Gulf Factory',
        icon: Icons.work_rounded,
        iconColor: Color(0xFF0A66C2),
      ),
      const _SocialLinkData(
        title: 'فيسبوك',
        handle: 'Gulf Factory',
        icon: Icons.facebook_rounded,
        iconColor: Color(0xFF1877F2),
      ),
      const _SocialLinkData(
        title: 'إنستجرام',
        handle: 'gulf_factory',
        icon: Icons.camera_alt_rounded,
        iconColor: Color(0xFFE4405F),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header Row
        const Row(
          children: [
            ContainerIconHeader(icon: Icons.share_outlined),
            SizedBox(width: 8),
            Text(
              'روابط التواصل الاجتماعي',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111827),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // 4 Horizontal Cards Row
        Row(
          children: socialItems.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;

            return Expanded(
              child: Container(
                margin: EdgeInsets.only(left: index == socialItems.length - 1 ? 0 : 8),
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(item.icon, size: 24, color: item.iconColor),
                    const SizedBox(height: 6),
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.handle,
                      style: const TextStyle(
                        fontSize: 9.5,
                        color: Color(0xFF6B7280),
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------
class ContainerIconHeader extends StatelessWidget {
  final IconData icon;

  const ContainerIconHeader({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: const BoxDecoration(
        color: Color(0xFFEFF6FF),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 16, color: const Color(0xFF2563EB)),
    );
  }
}

class ContainerDot extends StatelessWidget {
  final Color color;

  const ContainerDot({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _InfoRowData {
  final String label;
  final IconData icon;
  final bool isLtr;

  const _InfoRowData({
    required this.label,
    required this.icon,
    this.isLtr = false,
  });
}

class _SocialLinkData {
  final String title;
  final String handle;
  final IconData icon;
  final Color iconColor;

  const _SocialLinkData({
    required this.title,
    required this.handle,
    required this.icon,
    required this.iconColor,
  });
}
