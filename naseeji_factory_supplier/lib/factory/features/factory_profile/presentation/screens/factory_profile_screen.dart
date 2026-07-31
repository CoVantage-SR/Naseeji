import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../domain/entities/factory_profile_entities.dart';
import '../providers/factory_profile_provider.dart';
import '../widgets/factory_profile_dialogs.dart';
import '../widgets/factory_profile_widgets.dart';

class FactoryProfileScreen extends ConsumerStatefulWidget {
  const FactoryProfileScreen({super.key});

  @override
  ConsumerState<FactoryProfileScreen> createState() => _FactoryProfileScreenState();
}

class _FactoryProfileScreenState extends ConsumerState<FactoryProfileScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final state = ref.watch(factoryProfileProvider);

    final isDark = context.theme.brightness == Brightness.dark;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSecondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            // 1. Top Header Bar (Back button, Title, Save action)
            FactoryProfileHeader(
              onSave: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم حفظ بيانات المصنع بنجاح!')),
                );
              },
            ),

            // 2. Scrollable Body Content
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                physics: const BouncingScrollPhysics(),
                children: [
                  // 2.1 Profile Header Card (Logo, Name, Verified, Subscription)
                  FactoryProfileHeaderCard(
                    onChangeLogo: () => _showChangeLogoDialog(context),
                  ),
                  const SizedBox(height: 12),

                  // 2.2 Top 5 Horizontal Tabs
                  const FactoryProfileTabBar(),
                  const SizedBox(height: 16),

                  // 2.3 Selected Tab Content Section
                  _buildTabSection(state, isDark, surface, border, textPrimary, textSecondary),
                  const SizedBox(height: 16),

                  // 2.4 Documents & Licenses Card (1:1 matching screenshot)
                  DocumentsLicensesCard(
                    onAddDocument: () => _showAddDocumentSheet(context),
                    onViewAll: () => _showFullDocumentsDialog(context, state.documents),
                  ),
                  const SizedBox(height: 16),

                  // 2.5 Factory Gallery Card (1:1 matching screenshot)
                  FactoryGalleryCard(
                    onAddMedia: () => _showAddMediaDialog(context),
                    onViewAll: () => _showFullGalleryDialog(context, state.gallery),
                  ),
                  const SizedBox(height: 20),

                  // 2.6 Delete Factory Button
                  DeleteFactoryButton(
                    onDelete: () => _showDeleteFactoryDialog(context),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabSection(
    FactoryProfileState state,
    bool isDark,
    Color surface,
    Color border,
    Color textPrimary,
    Color textSecondary,
  ) {
    switch (state.selectedTabIndex) {
      case 0:
        return BasicInformationCard(
          onEditField: (field, value) => _showEditFieldSheet(context, field, value),
        );
      case 1:
        return DocumentsLicensesCard(
          onAddDocument: () => _showAddDocumentSheet(context),
          onViewAll: () => _showFullDocumentsDialog(context, state.documents),
        );
      case 2:
        return _locationCard(state.location, surface, border, textPrimary, textSecondary);
      case 3:
        return _contactCard(state.contact, surface, border, textPrimary, textSecondary);
      case 4:
        return _billingCard(state.billing, surface, border, textPrimary, textSecondary);
      default:
        return BasicInformationCard(
          onEditField: (field, value) => _showEditFieldSheet(context, field, value),
        );
    }
  }

  Widget _locationCard(FactoryLocationEntity loc, Color surface, Color border, Color textPrimary, Color textSecondary) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: surface, borderRadius: AppRadius.rLG, border: Border.all(color: border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('العنوان والموقع الجغرافي', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: textPrimary)),
          const SizedBox(height: 12),
          _detailRow(Icons.location_on_outlined, 'العنوان تفصيلياً', loc.address, textPrimary, textSecondary),
          const Divider(height: 16),
          _detailRow(Icons.map_outlined, 'المنطقة الصناعية', '${loc.industrialZone} - ${loc.city}', textPrimary, textSecondary),
          const Divider(height: 16),
          _detailRow(Icons.pin_drop_outlined, 'إحداثيات GPS', loc.gpsCoordinates, textPrimary, textSecondary),
        ],
      ),
    );
  }

  Widget _contactCard(FactoryContactEntity c, Color surface, Color border, Color textPrimary, Color textSecondary) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: surface, borderRadius: AppRadius.rLG, border: Border.all(color: border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('معلومات التواصل والربط الإلكتروني', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: textPrimary)),
          const SizedBox(height: 12),
          _detailRow(Icons.email_outlined, 'البريد الرسمي', c.companyEmail, textPrimary, textSecondary),
          const Divider(height: 16),
          _detailRow(Icons.phone_outlined, 'الهاتف الارضي', c.phoneNumber, textPrimary, textSecondary),
          const Divider(height: 16),
          _detailRow(Icons.chat_bubble_outline_rounded, 'واتساب الخدمة', c.whatsApp, textPrimary, textSecondary),
          const Divider(height: 16),
          _detailRow(Icons.language_outlined, 'الموقع الإلكتروني', c.website, textPrimary, textSecondary),
        ],
      ),
    );
  }

  Widget _billingCard(FactoryBillingEntity b, Color surface, Color border, Color textPrimary, Color textSecondary) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: surface, borderRadius: AppRadius.rLG, border: Border.all(color: border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('بيانات الفواتير والتعاملات المالية', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: textPrimary)),
          const SizedBox(height: 12),
          _detailRow(Icons.business_rounded, 'اسم الشركة للفواتير', b.companyName, textPrimary, textSecondary),
          const Divider(height: 16),
          _detailRow(Icons.email_outlined, 'بريد استلام الفواتير', b.invoiceEmail, textPrimary, textSecondary),
          const Divider(height: 16),
          _detailRow(Icons.monetization_on_outlined, 'شروط السداد المعتمدة', b.paymentTerms, textPrimary, textSecondary),
          const Divider(height: 16),
          _detailRow(Icons.account_balance_outlined, 'معرف InstaPay', b.instapay, textPrimary, textSecondary),
          const Divider(height: 16),
          _detailRow(Icons.numbers_outlined, 'رمز SWIFT', b.swift, textPrimary, textSecondary),
        ],
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String val, Color textPrimary, Color textSecondary) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(label, style: TextStyle(fontSize: 11, color: textSecondary)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            val,
            textAlign: TextAlign.left,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textPrimary),
          ),
        ),
      ],
    );
  }

  void _showEditFieldSheet(BuildContext context, String field, String currentVal) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => EditBasicFieldSheet(fieldName: field, currentValue: currentVal),
    );
  }

  void _showAddDocumentSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => const UploadDocumentSheet(),
    );
  }

  void _showChangeLogoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => ChangeLogoDialog(
        onConfirm: (url) {
          ref.read(factoryProfileProvider.notifier).updateLogo(url);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم تحديث شعار المصنع.')));
        },
      ),
    );
  }

  void _showDeleteFactoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => DeleteFactoryDialog(
        onConfirm: () {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم تقديم طلب حذف ملف المصنع.')));
        },
      ),
    );
  }

  void _showAddMediaDialog(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('يرجى اختيار صورة أو فيديو لرفعها بمعرض المصنع.')),
    );
  }

  void _showFullDocumentsDialog(BuildContext context, List docs) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('جميع المستندات والتراخيص'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: docs.length,
            itemBuilder: (_, idx) {
              final d = docs[idx];
              return ListTile(
                leading: const Icon(Icons.badge_outlined, color: AppColors.primary),
                title: Text(d.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('رقم: ${d.documentNumber} • تاريخ الانتهاء: ${d.expiryDate}'),
              );
            },
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('إغلاق')),
        ],
      ),
    );
  }

  void _showFullGalleryDialog(BuildContext context, List items) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('معرض صور وفيديوهات المصنع'),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 8, mainAxisSpacing: 8),
            itemCount: items.length,
            itemBuilder: (_, idx) {
              final item = items[idx];
              return ClipRRect(
                borderRadius: AppRadius.rSM,
                child: Image.network(item.imageUrl, fit: BoxFit.cover),
              );
            },
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('إغلاق')),
        ],
      ),
    );
  }
}



