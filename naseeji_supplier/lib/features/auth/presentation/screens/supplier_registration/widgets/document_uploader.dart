import 'package:flutter/material.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';

class DocumentUploader extends StatelessWidget {
  final String? uploadedFileName;
  final VoidCallback onTap;

  const DocumentUploader({
    super.key,
    required this.uploadedFileName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant,
            style: BorderStyle.solid,
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Icon(Icons.cloud_upload_outlined, size: 40, color: Theme.of(context).colorScheme.primary),
            SizedBox(height: 12),
            Text(
              uploadedFileName ?? 'اضغط هنا لرفع نسخة من السجل التجاري',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: uploadedFileName != null ? FontWeight.bold : FontWeight.normal,
                color: uploadedFileName != null ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'الحد الأقصى للملف 10 ميجا بايت (صيغة PDF)',
              style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.outline),
            ),
          ],
        ),
      ),
    );
  }
}
