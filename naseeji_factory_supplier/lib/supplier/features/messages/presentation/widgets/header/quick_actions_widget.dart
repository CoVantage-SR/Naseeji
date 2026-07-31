import 'package:flutter/material.dart';

class QuickActionsWidget extends StatelessWidget {
  final VoidCallback onViewDealDetails;
  final VoidCallback onViewProduct;
  final VoidCallback onViewAgreement;
  final VoidCallback onViewFiles;
  final VoidCallback onDownloadPdf;

  const QuickActionsWidget({
    super.key,
    required this.onViewDealDetails,
    required this.onViewProduct,
    required this.onViewAgreement,
    required this.onViewFiles,
    required this.onDownloadPdf,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildActionButton(
            context,
            icon: Icons.receipt_long_outlined,
            label: 'تفاصيل الصفقة',
            onTap: onViewDealDetails,
          ),
          const SizedBox(width: 6),
          _buildActionButton(
            context,
            icon: Icons.inventory_2_outlined,
            label: 'عرض المنتج',
            onTap: onViewProduct,
          ),
          const SizedBox(width: 6),
          _buildActionButton(
            context,
            icon: Icons.assignment_outlined,
            label: 'عرض الاتفاق',
            onTap: onViewAgreement,
          ),
          const SizedBox(width: 6),
          _buildActionButton(
            context,
            icon: Icons.folder_open_outlined,
            label: 'الملفات',
            onTap: onViewFiles,
          ),
          const SizedBox(width: 6),
          _buildActionButton(
            context,
            icon: Icons.picture_as_pdf_outlined,
            label: 'تحميل PDF',
            onTap: onDownloadPdf,
            isPrimary: true,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isPrimary = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: isPrimary
          ? colorScheme.primary.withValues(alpha: 0.1)
          : colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 13,
                color: isPrimary ? colorScheme.primary : colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.bold,
                  color: isPrimary ? colorScheme.primary : colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


