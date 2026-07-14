import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../providers/account_provider.dart';
import 'account_reusable_widgets.dart';

// ─── Edit Basic Information Widget ─────────────────────────────────────────
class BasicInformationWidget extends StatelessWidget {
  final FactoryProfileModel profile;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<String> onDescriptionChanged;

  const BasicInformationWidget({
    super.key,
    required this.profile,
    required this.onNameChanged,
    required this.onDescriptionChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.rMD,
        side: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('المعلومات الأساسية',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary)),
            const SizedBox(height: 16),
            // Logo / Cover upload row
            Row(
              children: [
                Column(
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundImage: NetworkImage(profile.logoUrl),
                      onBackgroundImageError: (_, __) {},
                      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                      child: const Icon(Icons.factory_rounded, color: AppColors.primary),
                    ),
                    const SizedBox(height: 6),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        minimumSize: Size.zero,
                        shape: RoundedRectangleBorder(borderRadius: AppRadius.rSM),
                      ),
                      child: const Text('الشعار', style: TextStyle(fontSize: 10)),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ClipRRect(
                        borderRadius: AppRadius.rSM,
                        child: Image.network(
                          profile.coverUrl,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            height: 60,
                            color: AppColors.primary.withValues(alpha: 0.1),
                            child: const Icon(Icons.image_rounded, color: AppColors.primary),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          minimumSize: Size.zero,
                          shape: RoundedRectangleBorder(borderRadius: AppRadius.rSM),
                        ),
                        child: const Text('صورة الغلاف', style: TextStyle(fontSize: 10)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _editField('اسم المصنع', profile.name, Icons.factory_rounded, onNameChanged),
            const SizedBox(height: 12),
            _multilineField('وصف المصنع', profile.description, onDescriptionChanged),
          ],
        ),
      ),
    );
  }

  Widget _editField(String label, String initial, IconData icon, ValueChanged<String> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        const SizedBox(height: 6),
        TextFormField(
          initialValue: initial,
          onChanged: onChanged,
          style: const TextStyle(fontSize: 13),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 18, color: AppColors.primary),
            border: OutlineInputBorder(borderRadius: AppRadius.rSM),
            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          ),
        ),
      ],
    );
  }

  Widget _multilineField(String label, String initial, ValueChanged<String> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        const SizedBox(height: 6),
        TextFormField(
          initialValue: initial,
          onChanged: onChanged,
          maxLines: 4,
          style: const TextStyle(fontSize: 13),
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: AppRadius.rSM),
            contentPadding: const EdgeInsets.all(12),
          ),
        ),
      ],
    );
  }
}

// ─── Factory Information Widget ────────────────────────────────────────────
class EditFactoryInformationWidget extends StatelessWidget {
  final FactoryProfileModel profile;
  final ValueChanged<String> onTypeChanged;
  final ValueChanged<String> onCapacityChanged;
  final ValueChanged<String> onIndustryChanged;

  const EditFactoryInformationWidget({
    super.key,
    required this.profile,
    required this.onTypeChanged,
    required this.onCapacityChanged,
    required this.onIndustryChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.rMD,
        side: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('معلومات المصنع',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary)),
            const SizedBox(height: 16),
            _dropdownField('نوع المصنع', profile.factoryType, [
              'مصنع متكامل', 'مصنع غزل', 'مصنع نسيج', 'مصنع تشطيب', 'مصنع ملابس'
            ], onTypeChanged),
            const SizedBox(height: 12),
            _editField('الصناعة', profile.industry, Icons.category_rounded, onIndustryChanged),
            const SizedBox(height: 12),
            _editField('الطاقة الإنتاجية', profile.productionCapacity, Icons.factory_rounded, onCapacityChanged),
          ],
        ),
      ),
    );
  }

  Widget _editField(String label, String initial, IconData icon, ValueChanged<String> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        const SizedBox(height: 6),
        TextFormField(
          initialValue: initial,
          onChanged: onChanged,
          style: const TextStyle(fontSize: 13),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 18, color: AppColors.primary),
            border: OutlineInputBorder(borderRadius: AppRadius.rSM),
            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          ),
        ),
      ],
    );
  }

  Widget _dropdownField(String label, String value, List<String> items, ValueChanged<String> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: items.contains(value) ? value : items.first,
          onChanged: (v) => onChanged(v ?? ''),
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 12)))).toList(),
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: AppRadius.rSM),
            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          ),
        ),
      ],
    );
  }
}

// ─── Edit Contact Information Widget ──────────────────────────────────────
class EditContactInformationWidget extends StatelessWidget {
  final FactoryProfileModel profile;
  final ValueChanged<String> onPhoneChanged;
  final ValueChanged<String> onEmailChanged;
  final ValueChanged<String> onWebsiteChanged;
  final ValueChanged<String> onAddressChanged;

  const EditContactInformationWidget({
    super.key,
    required this.profile,
    required this.onPhoneChanged,
    required this.onEmailChanged,
    required this.onWebsiteChanged,
    required this.onAddressChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.rMD,
        side: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('بيانات التواصل',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary)),
            const SizedBox(height: 16),
            _editField('رقم الهاتف', profile.phone, Icons.phone_rounded, TextInputType.phone, onPhoneChanged),
            const SizedBox(height: 12),
            _editField('البريد الإلكتروني', profile.email, Icons.email_rounded, TextInputType.emailAddress, onEmailChanged),
            const SizedBox(height: 12),
            _editField('الموقع الإلكتروني', profile.website, Icons.language_rounded, TextInputType.url, onWebsiteChanged),
            const SizedBox(height: 12),
            _editField('العنوان', profile.address, Icons.place_rounded, TextInputType.streetAddress, onAddressChanged),
          ],
        ),
      ),
    );
  }

  Widget _editField(String label, String initial, IconData icon, TextInputType type, ValueChanged<String> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        const SizedBox(height: 6),
        TextFormField(
          initialValue: initial,
          onChanged: onChanged,
          keyboardType: type,
          style: const TextStyle(fontSize: 13),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 18, color: AppColors.primary),
            border: OutlineInputBorder(borderRadius: AppRadius.rSM),
            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          ),
        ),
      ],
    );
  }
}

// ─── Documents Widget ──────────────────────────────────────────────────────
class EditDocumentsWidget extends StatelessWidget {
  const EditDocumentsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    final docs = [
      ('السجل التجاري', Icons.description_rounded, true),
      ('البطاقة الضريبية', Icons.receipt_long_rounded, true),
      ('شهادة ISO', Icons.verified_rounded, false),
      ('شهادات الجودة', Icons.workspace_premium_rounded, false),
    ];
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.rMD,
        side: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('المستندات والوثائق الرسمية',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary)),
            const SizedBox(height: 12),
            ...docs.map((d) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Container(
                        width: 40, height: 40,
                        decoration: BoxDecoration(
                          color: d.$3 ? AppColors.success.withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.08),
                          borderRadius: AppRadius.rSM,
                        ),
                        child: Icon(d.$2, size: 20, color: d.$3 ? AppColors.success : Colors.grey),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(d.$1, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                            Text(d.$3 ? 'تم الرفع ✓' : 'لم يُرفع بعد', style: TextStyle(fontSize: 10, color: d.$3 ? AppColors.success : Colors.grey)),
                          ],
                        ),
                      ),
                      OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          minimumSize: Size.zero,
                          shape: RoundedRectangleBorder(borderRadius: AppRadius.rSM),
                        ),
                        child: Text(d.$3 ? 'تحديث' : 'رفع', style: const TextStyle(fontSize: 11)),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

// ─── Save Actions Widget ───────────────────────────────────────────────────
class SaveActionsWidget extends StatelessWidget {
  final VoidCallback onSave;
  final VoidCallback onCancel;
  const SaveActionsWidget({super.key, required this.onSave, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PrimaryButton(label: 'حفظ التغييرات', icon: Icons.save_rounded, onPressed: onSave),
        const SizedBox(height: 10),
        SecondaryButton(label: 'إلغاء', onPressed: onCancel),
      ],
    );
  }
}
