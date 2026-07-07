import 'package:flutter/material.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../../domain/entities/agreement_model.dart';

class AgreementDocumentCard extends StatelessWidget {
  final AgreementDocument doc;
  final VoidCallback onReplace;

  const AgreementDocumentCard({
    super.key,
    required this.doc,
    required this.onReplace,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.surfaceContainerLow),
      ),
      child: Row(
        children: [
          const Icon(Icons.picture_as_pdf_outlined, color: Colors.red, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(doc.type, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.onSurface)),
                const SizedBox(height: 2),
                Text('${doc.name} • إصدار v${doc.version}', style: const TextStyle(fontSize: 9, color: AppColors.outline)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined, size: 18, color: AppColors.outline),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تمت مشاركة مستند ${doc.type} بنجاح.')));
            },
          ),
          IconButton(
            icon: const Icon(Icons.file_download_outlined, size: 18, color: AppColors.outline),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تم تنزيل المستند ${doc.name} على جهازك.')));
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, size: 18, color: AppColors.outline),
            onSelected: (val) {
              if (val == 'replace') {
                onReplace();
              }
            },
            itemBuilder: (ctx) => [
              const PopupMenuItem(value: 'replace', child: Row(children: [Icon(Icons.sync_outlined, size: 16), SizedBox(width: 6), Text('استبدال المستند', style: TextStyle(fontSize: 11))])),
            ],
          ),
        ],
      ),
    );
  }
}
