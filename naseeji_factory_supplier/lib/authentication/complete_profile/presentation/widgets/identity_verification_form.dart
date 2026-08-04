import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/app_radius.dart';
import 'document_upload_card.dart';

class IdentityVerificationForm extends StatelessWidget {
  final TextEditingController businessNameController;
  final TextEditingController businessAddressController;
  final String? selectedBusinessType;
  final XFile? idFrontFile;
  final XFile? idBackFile;
  final XFile? selfieFile;
  final Map<String, String> validationErrors;
  final ValueChanged<String> onBusinessNameChanged;
  final ValueChanged<String> onBusinessTypeChanged;
  final ValueChanged<String> onBusinessAddressChanged;
  final Function(XFile) onPickIdFront;
  final Function(XFile) onPickIdBack;
  final Function(XFile) onPickSelfie;
  final VoidCallback onDeleteIdFront;
  final VoidCallback onDeleteIdBack;
  final VoidCallback onDeleteSelfie;

  const IdentityVerificationForm({
    super.key,
    required this.businessNameController,
    required this.businessAddressController,
    this.selectedBusinessType,
    this.idFrontFile,
    this.idBackFile,
    this.selfieFile,
    required this.validationErrors,
    required this.onBusinessNameChanged,
    required this.onBusinessTypeChanged,
    required this.onBusinessAddressChanged,
    required this.onPickIdFront,
    required this.onPickIdBack,
    required this.onPickSelfie,
    required this.onDeleteIdFront,
    required this.onDeleteIdBack,
    required this.onDeleteSelfie,
  });

  static const List<Map<String, String>> businessTypes = [
    {'value': 'Workshop', 'label': 'ورشة تصنيع (Workshop)'},
    {'value': 'Small Factory', 'label': 'مصنع صغير (Small Factory)'},
    {'value': 'Supplier', 'label': 'مورد مستقل (Supplier)'},
    {'value': 'Trader', 'label': 'تاجر / موزع (Trader)'},
    {'value': 'Home Business', 'label': 'مشروع منزلي (Home Business)'},
    {'value': 'Other', 'label': 'نشاط آخر (Other)'},
  ];

  Future<void> _pickFile(Function(XFile) onPicked) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (image != null) {
      onPicked(image);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. National ID Front Upload
        DocumentUploadCard(
          title: 'وجه البطاقة الشخصية (Front ID) *',
          icon: Icons.credit_card_rounded,
          file: idFrontFile,
          errorText: validationErrors['idFront'],
          onPick: () => _pickFile(onPickIdFront),
          onDelete: onDeleteIdFront,
        ),

        const SizedBox(height: 14),

        // 2. National ID Back Upload
        DocumentUploadCard(
          title: 'ظهر البطاقة الشخصية (Back ID) *',
          icon: Icons.credit_card_outlined,
          file: idBackFile,
          errorText: validationErrors['idBack'],
          onPick: () => _pickFile(onPickIdBack),
          onDelete: onDeleteIdBack,
        ),

        const SizedBox(height: 14),

        // 3. Selfie Holding ID Upload
        DocumentUploadCard(
          title: 'صورة سيلفي مع البطاقة (Selfie Holding ID) *',
          description: 'صورة واضحة لوجهك أثناء الإمساك ببطاقتك الشخصية',
          icon: Icons.face_retouching_natural_rounded,
          file: selfieFile,
          errorText: validationErrors['selfieWithId'],
          onPick: () => _pickFile(onPickSelfie),
          onDelete: onDeleteSelfie,
        ),

        const SizedBox(height: 16),

        // 4. Business Name Field
        TextFormField(
          controller: businessNameController,
          onChanged: onBusinessNameChanged,
          decoration: InputDecoration(
            labelText: 'اسم النشاط التجاري / الورشة / المحل *',
            hintText: 'مثال: ورشة الأمل للنسيج والتريكو',
            prefixIcon: const Icon(Icons.storefront_outlined),
            errorText: validationErrors['businessName'],
            filled: true,
            fillColor: isDark ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.3) : Colors.white,
            border: OutlineInputBorder(borderRadius: AppRadius.rSM),
          ),
        ),

        const SizedBox(height: 14),

        // 5. Business Type Dropdown
        DropdownButtonFormField<String>(
          initialValue: selectedBusinessType,
          validator: (v) => v == null ? 'يرجى اختيار نوع النشاط' : null,
          items: businessTypes
              .map((type) => DropdownMenuItem<String>(
                    value: type['value'],
                    child: Text(type['label']!),
                  ))
              .toList(),
          onChanged: (val) {
            if (val != null) onBusinessTypeChanged(val);
          },
          decoration: InputDecoration(
            labelText: 'نوع النشاط التجاري *',
            prefixIcon: const Icon(Icons.work_outline_rounded),
            errorText: validationErrors['businessType'],
            filled: true,
            fillColor: isDark ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.3) : Colors.white,
            border: OutlineInputBorder(borderRadius: AppRadius.rSM),
          ),
        ),

        const SizedBox(height: 14),

        // 6. Business Address Field
        TextFormField(
          controller: businessAddressController,
          onChanged: onBusinessAddressChanged,
          decoration: InputDecoration(
            labelText: 'عنوان ورشتك أو مكان نشاطك *',
            hintText: 'مثال: شارع المصانع - منطقة الورش - المحلة الكبرى',
            prefixIcon: const Icon(Icons.location_on_outlined),
            errorText: validationErrors['businessAddress'],
            filled: true,
            fillColor: isDark ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.3) : Colors.white,
            border: OutlineInputBorder(borderRadius: AppRadius.rSM),
          ),
        ),
      ],
    );
  }
}
