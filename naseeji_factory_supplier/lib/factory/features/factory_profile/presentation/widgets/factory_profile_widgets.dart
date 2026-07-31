import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../providers/factory_profile_provider.dart';

// ══════════════════════════════════════════════════════════════
// 1. Top Header Bar (Back button, Title, Save action)
// ══════════════════════════════════════════════════════════════

class FactoryProfileHeader extends StatelessWidget {
  final VoidCallback onSave;

  const FactoryProfileHeader({super.key, required this.onSave});

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: surface,
        border: Border(bottom: BorderSide(color: border, width: 0.5)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              } else {
                context.go('/profile');
              }
            },
          ),
          const Spacer(),
          Text(
            'بيانات المصنع',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textPrimary,
            ),
          ),
          const Spacer(),
          TextButton.icon(
            onPressed: onSave,
            icon: const Icon(Icons.save_outlined, size: 18, color: AppColors.primary),
            label: const Text(
              'حفظ',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// 2. Profile Header Card (Logo, Name, Verified, Subscription)
// ══════════════════════════════════════════════════════════════

class FactoryProfileHeaderCard extends ConsumerWidget {
  final VoidCallback onChangeLogo;

  const FactoryProfileHeaderCard({super.key, required this.onChangeLogo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(factoryProfileProvider);
    final p = state.profile;

    final isDark = context.theme.brightness == Brightness.dark;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSecondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: AppRadius.rLG,
        border: Border.all(color: border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Right (RTL): Factory Logo + Camera Badge Button
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: border, width: 2),
                ),
                child: ClipOval(
                  child: Image.network(
                    p.logoUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      child: const Icon(Icons.factory_rounded, color: AppColors.primary, size: 36),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: InkWell(
                  onTap: onChangeLogo,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: surface,
                      shape: BoxShape.circle,
                      border: Border.all(color: border),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Icon(Icons.camera_alt_outlined, size: 14, color: textPrimary),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 14),

          // Middle: Factory Name, Type, Membership & Status Chip
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        p.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (p.isVerified) ...[
                      const SizedBox(width: 4),
                      const Icon(Icons.verified_rounded, color: Color(0xFF2563EB), size: 18),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  p.factoryType,
                  style: TextStyle(fontSize: 11, color: textSecondary),
                ),
                const SizedBox(height: 4),
                Text(
                  p.membershipDate,
                  style: TextStyle(fontSize: 10, color: textSecondary),
                ),
                const SizedBox(height: 6),

                // Active status chip
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF064E3B) : const Color(0xFFECFDF5),
                    borderRadius: AppRadius.rRound,
                    border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: Color(0xFF10B981),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        p.status,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF10B981),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // Left (RTL): Subscription Plan Card
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
              borderRadius: AppRadius.rMD,
              border: Border.all(color: border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'خطة الاشتراك',
                  style: TextStyle(fontSize: 9, color: textSecondary),
                ),
                const SizedBox(height: 2),
                Text(
                  p.subscriptionPlan,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2563EB),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'تنتهي في',
                  style: TextStyle(fontSize: 8, color: textSecondary),
                ),
                Text(
                  p.subscriptionExpiry,
                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.w500, color: textPrimary),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.workspace_premium_rounded, size: 14, color: AppColors.primary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// 3. Top Tab Navigation Bar (5 Horizontal Tabs)
// ══════════════════════════════════════════════════════════════

class FactoryProfileTabBar extends ConsumerWidget {
  const FactoryProfileTabBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(factoryProfileProvider);
    final notifier = ref.read(factoryProfileProvider.notifier);

    final tabs = [
      {'title': 'البيانات الأساسية', 'icon': Icons.home_outlined},
      {'title': 'المستندات', 'icon': Icons.description_outlined},
      {'title': 'العنوان والفروع', 'icon': Icons.location_on_outlined},
      {'title': 'معلومات التواصل', 'icon': Icons.phone_outlined},
      {'title': 'بيانات الفواتير', 'icon': Icons.request_quote_outlined},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final isSelected = state.selectedTabIndex == index;
          final tab = tabs[index];
          return InkWell(
            onTap: () => notifier.selectTab(index),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isSelected ? AppColors.primary : Colors.transparent,
                    width: 2.5,
                  ),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    tab['icon'] as IconData,
                    size: 20,
                    color: isSelected ? AppColors.primary : Colors.grey,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tab['title'] as String,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? AppColors.primary : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// 4. Basic Information Card (Matching 1:1 screenshot design)
// ══════════════════════════════════════════════════════════════

class BasicInformationCard extends ConsumerWidget {
  final Function(String field, String currentValue) onEditField;

  const BasicInformationCard({super.key, required this.onEditField});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(factoryProfileProvider);
    final p = state.profile;

    final isDark = context.theme.brightness == Brightness.dark;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSecondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: AppRadius.rLG,
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'البيانات الأساسية',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 16),

          _infoRow(
            context,
            label: 'اسم المصنع',
            value: p.name,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
            onEdit: () => onEditField('اسم المصنع', p.name),
          ),
          const Divider(height: 20),

          _infoRow(
            context,
            label: 'نوع المصنع',
            value: p.factoryType,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
            onEdit: () => onEditField('نوع المصنع', p.factoryType),
          ),
          const Divider(height: 20),

          _infoRow(
            context,
            label: 'السجل التجاري',
            value: p.commercialRegister,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
            onEdit: () => onEditField('السجل التجاري', p.commercialRegister),
          ),
          const Divider(height: 20),

          _infoRow(
            context,
            label: 'الرقم الضريبي',
            value: p.taxNumber,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
            onEdit: () => onEditField('الرقم الضريبي', p.taxNumber),
          ),
          const Divider(height: 20),

          _infoRow(
            context,
            label: 'البطاقة الضريبية',
            value: p.vatNumber,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
            onEdit: () => onEditField('البطاقة الضريبية', p.vatNumber),
          ),
          const Divider(height: 20),

          _infoRow(
            context,
            label: 'تاريخ تأسيس المصنع',
            value: p.establishmentDate,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
            onEdit: () => onEditField('تاريخ تأسيس المصنع', p.establishmentDate),
          ),
          const Divider(height: 20),

          _infoRow(
            context,
            label: 'نبذة عن المصنع',
            value: p.description,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
            isMultiLine: true,
            onEdit: () => onEditField('نبذة عن المصنع', p.description),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(
    BuildContext context, {
    required String label,
    required String value,
    required Color textPrimary,
    required Color textSecondary,
    required VoidCallback onEdit,
    bool isMultiLine = false,
  }) {
    return Row(
      crossAxisAlignment: isMultiLine ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        // Left (RTL): Edit button
        InkWell(
          onTap: onEdit,
          borderRadius: AppRadius.rSM,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: AppRadius.rSM,
            ),
            child: const Icon(Icons.edit_outlined, size: 14, color: AppColors.primary),
          ),
        ),
        const SizedBox(width: 12),

        // Middle: Value
        Expanded(
          flex: 6,
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: textPrimary,
            ),
          ),
        ),

        // Right (RTL): Label
        Expanded(
          flex: 4,
          child: Text(
            label,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 12,
              color: textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════
// 5. Documents & Licenses Section (Carousel + Add Button)
// ══════════════════════════════════════════════════════════════

class DocumentsLicensesCard extends ConsumerWidget {
  final VoidCallback onAddDocument;
  final VoidCallback onViewAll;

  const DocumentsLicensesCard({
    super.key,
    required this.onAddDocument,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(factoryProfileProvider);
    final docs = state.documents;

    final isDark = context.theme.brightness == Brightness.dark;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: AppRadius.rLG,
        border: Border.all(color: border),
      ),
      child: Column(
        children: [
          // Header title + View All
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'المستندات والتراخيص',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: textPrimary,
                ),
              ),
              TextButton(
                onPressed: onViewAll,
                child: const Text('عرض الكل', style: TextStyle(fontSize: 12, color: AppColors.primary)),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Horizontal Carousel with Left/Right Arrow Indicators
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 125,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: docs.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    final doc = docs[index];
                    return _docItemCard(context, doc: doc, isDark: isDark, surface: surface, border: border, textPrimary: textPrimary);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Full Width Outlined Button: + إضافة مستند جديد
          OutlinedButton.icon(
            onPressed: onAddDocument,
            style: OutlinedButton.styleFrom(
              backgroundColor: surface,
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary),
              minimumSize: const Size(double.infinity, 44),
              shape: RoundedRectangleBorder(borderRadius: AppRadius.rMD),
            ),
            icon: const Icon(Icons.add_circle_outline_rounded, size: 18),
            label: const Text('إضافة مستند جديد', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          ),
        ],
      ),
    );
  }

  Widget _docItemCard(
    BuildContext context, {
    required dynamic doc,
    required bool isDark,
    required Color surface,
    required Color border,
    required Color textPrimary,
  }) {
    return Container(
      width: 140,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
        borderRadius: AppRadius.rMD,
        border: Border.all(color: border),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: AppRadius.rSM,
            ),
            child: const Icon(Icons.badge_outlined, color: AppColors.primary, size: 20),
          ),
          const SizedBox(height: 6),
          Text(
            doc.title,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: textPrimary),
          ),
          const SizedBox(height: 2),
          Text(
            doc.documentNumber,
            maxLines: 1,
            style: const TextStyle(fontSize: 9, color: Colors.grey),
          ),
          const SizedBox(height: 6),

          // Valid Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 12),
              const SizedBox(width: 3),
              Text(
                doc.status,
                style: const TextStyle(fontSize: 9, color: Color(0xFF10B981), fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// 6. Factory Gallery Card (Thumbnails + Upload box)
// ══════════════════════════════════════════════════════════════

class FactoryGalleryCard extends ConsumerWidget {
  final VoidCallback onAddMedia;
  final VoidCallback onViewAll;

  const FactoryGalleryCard({
    super.key,
    required this.onAddMedia,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(factoryProfileProvider);
    final items = state.gallery;

    final isDark = context.theme.brightness == Brightness.dark;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: AppRadius.rLG,
        border: Border.all(color: border),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'معرض المصنع',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: textPrimary,
                ),
              ),
              TextButton(
                onPressed: onViewAll,
                child: const Text('عرض الكل', style: TextStyle(fontSize: 12, color: AppColors.primary)),
              ),
            ],
          ),
          const SizedBox(height: 12),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: [
                // Thumbnails
                ...items.map((item) {
                  return Container(
                    width: 90,
                    height: 90,
                    margin: const EdgeInsets.only(left: 8),
                    decoration: BoxDecoration(
                      borderRadius: AppRadius.rMD,
                      border: Border.all(color: border),
                    ),
                    child: ClipRRect(
                      borderRadius: AppRadius.rMD,
                      child: Image.network(
                        item.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.grey.shade300,
                          child: const Icon(Icons.image_not_supported_outlined, color: Colors.grey),
                        ),
                      ),
                    ),
                  );
                }),

                // Dotted Upload Box
                GestureDetector(
                  onTap: onAddMedia,
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.05),
                      borderRadius: AppRadius.rMD,
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.4),
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.cloud_upload_outlined, color: AppColors.primary, size: 24),
                        SizedBox(height: 4),
                        Text(
                          'إضافة صورة أو فيديو',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 8, color: AppColors.primary, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// 7. Delete Factory Button (Outlined Red Button)
// ══════════════════════════════════════════════════════════════

class DeleteFactoryButton extends StatelessWidget {
  final VoidCallback onDelete;

  const DeleteFactoryButton({super.key, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onDelete,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.error,
        side: const BorderSide(color: AppColors.error),
        minimumSize: const Size(double.infinity, 46),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.rMD),
      ),
      icon: const Icon(Icons.delete_outline_rounded, size: 18, color: AppColors.error),
      label: const Text(
        'حذف المصنع',
        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.error),
      ),
    );
  }
}



