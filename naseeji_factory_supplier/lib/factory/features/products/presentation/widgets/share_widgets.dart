import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/extensions/context_extensions.dart';

class ShareProductBottomSheet extends StatelessWidget {
  final String productName;
  final String supplierName;
  final VoidCallback onCopyLink;
  final VoidCallback onDownloadPdf;

  const ShareProductBottomSheet({
    super.key,
    required this.productName,
    required this.supplierName,
    required this.onCopyLink,
    required this.onDownloadPdf,
  });

  void _showQrDialog(BuildContext context) {
    Navigator.of(context).pop();
    showDialog(
      context: context,
      builder: (context) => ProductQrDialog(
        productName: productName,
        supplierName: supplierName,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'مشاركة المنتج',
            style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'شارك تفاصيل منتج "$productName" مع الموردين أو فريق العمل.',
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
          AppSpacing.hLG,
          // Share Options Grid
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildShareButton(
                context,
                Icons.link_rounded,
                'نسخ الرابط',
                AppColors.primary,
                onCopyLink,
              ),
              _buildShareButton(
                context,
                Icons.qr_code_2_rounded,
                'رمز QR',
                Colors.purple,
                () => _showQrDialog(context),
              ),
              _buildShareButton(
                context,
                Icons.send_rounded,
                'مشاركة داخلية',
                Colors.blue,
                () {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تمت المشاركة مع أعضاء فريق المصنع بنجاح!')),
                  );
                },
              ),
              _buildShareButton(
                context,
                Icons.picture_as_pdf_outlined,
                'كتالوج PDF',
                AppColors.info,
                onDownloadPdf,
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Copyable link field
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: isDark ? AppColors.backgroundDark : Colors.grey.shade100,
              borderRadius: AppRadius.rSM,
              border: Border.all(color: isDark ? AppColors.borderDark : Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'https://naseeji.com/products/prod_1',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                TextButton(
                  onPressed: onCopyLink,
                  child: const Text('نسخ'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildShareButton(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(30),
          child: Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 26),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
      ],
    );
  }
}

/// Dialog showing Product QR Code for easy sharing/scanning
class ProductQrDialog extends StatelessWidget {
  final String productName;
  final String supplierName;

  const ProductQrDialog({
    super.key,
    required this.productName,
    required this.supplierName,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
      title: Column(
        children: [
          const Icon(Icons.qr_code_2_rounded, size: 48, color: AppColors.primary),
          const SizedBox(height: 8),
          Text(
            productName,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          Text(
            supplierName,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Image.network(
              'https://api.qrserver.com/v1/create-qr-code/?size=180x180&data=https://naseeji.com/products/prod_1',
              width: 180,
              height: 180,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 180,
                height: 180,
                color: Colors.grey.shade100,
                child: const Icon(Icons.qr_code_2_rounded, size: 80, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'امسح رمز QR للوصول السريع إلى تفاصيل المنتج والمواصفات',
            style: TextStyle(fontSize: 11, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('إغلاق'),
        ),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('تم حفظ رمز QR في المعرض بنجاح!')),
            );
          },
          icon: const Icon(Icons.download_rounded, size: 18),
          label: const Text('تحميل الرمز'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }
}



