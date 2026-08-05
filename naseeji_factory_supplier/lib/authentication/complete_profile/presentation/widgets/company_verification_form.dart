import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/app_radius.dart';
import 'document_upload_card.dart';

class CompanyVerificationForm extends StatelessWidget {
  final TextEditingController crController;
  final TextEditingController taxController;
  final XFile? crDocumentFile;
  final XFile? taxDocumentFile;
  final Map<String, String> validationErrors;
  final ValueChanged<String> onCrChanged;
  final ValueChanged<String> onTaxChanged;
  final Function(XFile) onPickCrDocument;
  final Function(XFile) onPickTaxDocument;
  final VoidCallback onDeleteCrDocument;
  final VoidCallback onDeleteTaxDocument;

  const CompanyVerificationForm({
    super.key,
    required this.crController,
    required this.taxController,
    this.crDocumentFile,
    this.taxDocumentFile,
    required this.validationErrors,
    required this.onCrChanged,
    required this.onTaxChanged,
    required this.onPickCrDocument,
    required this.onPickTaxDocument,
    required this.onDeleteCrDocument,
    required this.onDeleteTaxDocument,
  });

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
        // CR Number
        TextFormField(
          controller: crController,
          onChanged: onCrChanged,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'رقم السجل التجاري (اختياري)',
            hintText: 'مثال: 123456',
            prefixIcon: const Icon(Icons.subtitles_outlined),
            errorText: validationErrors['commercialRegister'],
            filled: true,
            fillColor: isDark ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.3) : Colors.white,
            border: OutlineInputBorder(borderRadius: AppRadius.rSM),
          ),
        ),

        const SizedBox(height: 14),

        // Tax Number
        TextFormField(
          controller: taxController,
          onChanged: onTaxChanged,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'رقم البطاقة الضريبية (اختياري)',
            hintText: 'مثال: 987654321',
            prefixIcon: const Icon(Icons.receipt_long_outlined),
            errorText: validationErrors['taxNumber'],
            filled: true,
            fillColor: isDark ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.3) : Colors.white,
            border: OutlineInputBorder(borderRadius: AppRadius.rSM),
          ),
        ),

        const SizedBox(height: 16),

        // Upload CR Document
        DocumentUploadCard(
          title: 'رفع ملف السجل التجاري (اختياري)',
          icon: Icons.folder_open_rounded,
          file: crDocumentFile,
          errorText: validationErrors['crDocument'],
          onPick: () => _pickFile(onPickCrDocument),
          onDelete: onDeleteCrDocument,
        ),

        const SizedBox(height: 14),

        // Upload Tax Card Document
        DocumentUploadCard(
          title: 'رفع ملف البطاقة الضريبية (اختياري)',
          icon: Icons.badge_outlined,
          file: taxDocumentFile,
          errorText: validationErrors['taxDocument'],
          onPick: () => _pickFile(onPickTaxDocument),
          onDelete: onDeleteTaxDocument,
        ),
      ],
    );
  }
}
