import 'package:flutter/material.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';

class QuotationAttachmentCard extends StatelessWidget {
  final String title;
  final String filename;
  final IconData icon;
  final VoidCallback? onPreview;
  final VoidCallback? onDownload;
  final VoidCallback? onReplace;
  final VoidCallback? onShare;

  const QuotationAttachmentCard({
    super.key,
    required this.title,
    required this.filename,
    required this.icon,
    this.onPreview,
    this.onDownload,
    this.onReplace,
    this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E1EF), width: 0.5),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.primary, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: AppColors.onSurface),
                ),
                const SizedBox(height: 2),
                Text(
                  filename,
                  style: const TextStyle(fontSize: 8, color: AppColors.outline),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          
          // Action Buttons
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildIconBtn(icon: Icons.visibility_outlined, tooltip: 'معاينة فنية', onTap: onPreview),
              _buildIconBtn(icon: Icons.download_outlined, tooltip: 'تحميل الملف', onTap: onDownload),
              if (onReplace != null)
                _buildIconBtn(icon: Icons.sync, tooltip: 'استبدال', onTap: onReplace),
              _buildIconBtn(icon: Icons.share_outlined, tooltip: 'مشاركة', onTap: onShare),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIconBtn({required IconData icon, required String tooltip, VoidCallback? onTap}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      child: Tooltip(
        message: tooltip,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(4),
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Icon(icon, color: AppColors.primary, size: 14),
          ),
        ),
      ),
    );
  }
}
