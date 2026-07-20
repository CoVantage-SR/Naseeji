import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/widgets/reusable_widgets.dart';
import '../providers/documents_provider.dart';
import '../../../domain/entities/product_detail_entities.dart';

/// Displays downloadable product documents: PDFs, certificates, lab reports.
/// Reads data from [documentsProvider].
class DocumentsWidget extends ConsumerWidget {
  final String productId;
  final VoidCallback onDownload;

  const DocumentsWidget({super.key, required this.productId, required this.onDownload});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(documentsProvider(productId: productId));

    return state.when(
      loading: () => const SizedBox(height: 60, child: Center(child: CircularProgressIndicator())),
      error: (_, __) => const SizedBox.shrink(),
      data: (docs) => PrimaryCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.folder_open_rounded, color: AppColors.info, size: 18),
                const SizedBox(width: 8),
                Text(
                  'الوثائق والشهادات',
                  style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            AppSpacing.hMD,
            ...docs.map((doc) => _DocumentRow(doc: doc, onDownload: onDownload)),
          ],
        ),
      ),
    );
  }
}

class _DocumentRow extends StatelessWidget {
  final DocumentItem doc;
  final VoidCallback onDownload;

  const _DocumentRow({required this.doc, required this.onDownload});

  IconData get _typeIcon {
    return switch (doc.type) {
      'certificate' => Icons.workspace_premium_rounded,
      'lab_report' => Icons.science_rounded,
      _ => Icons.picture_as_pdf_rounded,
    };
  }

  Color get _typeColor {
    return switch (doc.type) {
      'certificate' => AppColors.warning,
      'lab_report' => AppColors.success,
      _ => AppColors.info,
    };
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    final sizeText = doc.fileSizeKb > 999 ? '${(doc.fileSizeKb / 1024).toStringAsFixed(1)} MB' : '${doc.fileSizeKb} KB';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: _typeColor.withValues(alpha: isDark ? 0.1 : 0.06),
        borderRadius: AppRadius.rMD,
        border: Border.all(color: _typeColor.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(_typeIcon, color: _typeColor, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(doc.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                Text(sizeText, style: context.textTheme.bodySmall?.copyWith(color: Colors.grey)),
              ],
            ),
          ),
          if (doc.isDownloadable)
            IconButton(
              icon: const Icon(Icons.download_rounded),
              color: _typeColor,
              onPressed: onDownload,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            ),
        ],
      ),
    );
  }
}
