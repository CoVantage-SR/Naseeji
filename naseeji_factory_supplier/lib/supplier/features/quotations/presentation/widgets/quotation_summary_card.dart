import 'package:flutter/material.dart';
import 'package:naseeji_factory/core/theme/app_colors.dart';
import '../../domain/entities/quotation_model.dart';

class QuotationSummaryCard extends StatelessWidget {
  final QuotationModel quotation;
  final VoidCallback? onView;
  final VoidCallback? onOpenChat;
  final VoidCallback? onTimeline;
  final VoidCallback? onDuplicate;
  final VoidCallback? onSharePdf;

  const QuotationSummaryCard({
    super.key,
    required this.quotation,
    this.onView,
    this.onOpenChat,
    this.onTimeline,
    this.onDuplicate,
    this.onSharePdf,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor = Colors.grey;
    String statusText = '';
    switch (quotation.status) {
      case QuotationStatus.draft:
        statusColor = Colors.grey;
        statusText = 'مسودة';
        break;
      case QuotationStatus.sent:
        statusColor = Colors.blue;
        statusText = 'مرسل';
        break;
      case QuotationStatus.underNegotiation:
        statusColor = Colors.orange;
        statusText = 'قيد التفاوض';
        break;
      case QuotationStatus.accepted:
        statusColor = Colors.green;
        statusText = 'مقبول';
        break;
      case QuotationStatus.rejected:
        statusColor = Colors.red;
        statusText = 'مرفوض';
        break;
      case QuotationStatus.expired:
        statusColor = Colors.grey.shade700;
        statusText = 'منتهي';
        break;
    }

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: isDark ? 0.08 : 0.03), blurRadius: 10, offset: const Offset(0, 4))],
        border: Border.all(color: theme.colorScheme.outline, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header: Quotation Number & Status
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        quotation.id,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: theme.colorScheme.primary),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'RFQ: ${quotation.rfqNumber}',
                      style: TextStyle(fontSize: 9, color: theme.colorScheme.onSurfaceVariant),
                    ),
                    if (quotation.orderNumber != null) ...[
                      const SizedBox(width: 8),
                      Text(
                        'عقد: ${quotation.orderNumber}',
                        style: TextStyle(fontSize: 9, color: theme.colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: isDark ? 0.2 : 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 9, color: isDark ? statusColor.withValues(alpha: 0.9) : statusColor),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: theme.colorScheme.outlineVariant),

          // Factory Info
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundColor: Color(quotation.factoryInfo.logoBgColorValue),
                  child: Text(
                    quotation.factoryInfo.logoText,
                    style: TextStyle(color: Theme.of(context).colorScheme.surface, fontWeight: FontWeight.bold, fontSize: 8),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    quotation.factoryInfo.factoryName,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Theme.of(context).colorScheme.onSurface),
                  ),
                ),
                if (quotation.hasNegotiationBadge)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.orange.shade200, width: 0.5),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.gavel, color: Colors.orange, size: 8),
                        SizedBox(width: 2),
                        Text('طلب تفاوض', style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.orange)),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          // Product details
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: NetworkImage(quotation.productImageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        quotation.productName,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Theme.of(context).colorScheme.onSurface),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Text(
                        'الكمية: ${quotation.quantity.toInt()} ${quotation.unit} • التوريد: ${quotation.preparationTime}',
                        style: TextStyle(fontSize: 9, color: AppColors.outline),
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            'سعر الوحدة: ${quotation.supplierUnitPrice.toStringAsFixed(2)} ${quotation.currency}',
                            style: TextStyle(fontSize: 9, color: AppColors.outline),
                          ),
                          const Spacer(),
                          Text(
                            'السعر الإجمالي: ',
                            style: TextStyle(fontSize: 9, color: AppColors.outline),
                          ),
                          Text(
                            '${quotation.grandTotal.toStringAsFixed(0)} ${quotation.currency}',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Expiration & Dates
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'تاريخ العرض: ${quotation.createdDate}',
                  style: TextStyle(fontSize: 8, color: AppColors.outline),
                ),
                Text(
                  'انتهاء الصلاحية: ${quotation.expirationDate}',
                  style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w600,
                    color: quotation.status == QuotationStatus.expired ? AppColors.error : AppColors.outline,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: AppColors.surfaceContainerLow),

          // Actions
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildActionButton(
                  icon: Icons.copy_outlined,
                  tooltip: 'تكرار كمسودة',
                  onTap: onDuplicate,
                ),
                SizedBox(width: 8),
                _buildActionButton(
                  icon: Icons.picture_as_pdf_outlined,
                  tooltip: 'مشاركة عرض PDF',
                  onTap: onSharePdf,
                ),
                SizedBox(width: 8),
                _buildActionButton(
                  icon: Icons.timeline_outlined,
                  tooltip: 'الخط الزمني للحالة',
                  onTap: onTimeline,
                ),
                SizedBox(width: 8),
                _buildActionButton(
                  icon: Icons.forum_outlined,
                  tooltip: 'محادثة المصنع',
                  onTap: onOpenChat,
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: onView,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 0,
                  ),
                  child: Text(
                    'تفاصيل العرض',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({required IconData icon, required String tooltip, VoidCallback? onTap}) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        icon: Icon(icon, color: AppColors.primary, size: 14),
        tooltip: tooltip,
        padding: EdgeInsets.zero,
        onPressed: onTap,
      ),
    );
  }
}


