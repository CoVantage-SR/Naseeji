import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
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

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Color(0x05000000), blurRadius: 10, offset: Offset(0, 4))],
        border: Border.all(color: const Color(0xFFE2E1EF), width: 0.5),
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
                        color: AppColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        quotation.id,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: AppColors.primary),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'RFQ: ${quotation.rfqNumber}',
                      style: const TextStyle(fontSize: 9, color: AppColors.outline),
                    ),
                    if (quotation.orderNumber != null) ...[
                      const SizedBox(width: 8),
                      Text(
                        'عقد: ${quotation.orderNumber}',
                        style: const TextStyle(fontSize: 9, color: AppColors.outline),
                      ),
                    ],
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 9, color: statusColor),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.surfaceContainerLow),

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
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 8),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    quotation.factoryInfo.factoryName,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: AppColors.onSurface),
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
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
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
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        quotation.productName,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: AppColors.onSurface),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'الكمية: ${quotation.quantity.toInt()} ${quotation.unit} • التوريد: ${quotation.preparationTime}',
                        style: const TextStyle(fontSize: 9, color: AppColors.outline),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            'سعر الوحدة: ${quotation.supplierUnitPrice.toStringAsFixed(2)} ${quotation.currency}',
                            style: const TextStyle(fontSize: 9, color: AppColors.outline),
                          ),
                          const Spacer(),
                          Text(
                            'السعر الإجمالي: ',
                            style: const TextStyle(fontSize: 9, color: AppColors.outline),
                          ),
                          Text(
                            '${quotation.grandTotal.toStringAsFixed(0)} ${quotation.currency}',
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary),
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
                  style: const TextStyle(fontSize: 8, color: AppColors.outline),
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
          const Divider(height: 1, color: AppColors.surfaceContainerLow),

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
                const SizedBox(width: 8),
                _buildActionButton(
                  icon: Icons.picture_as_pdf_outlined,
                  tooltip: 'مشاركة عرض PDF',
                  onTap: onSharePdf,
                ),
                const SizedBox(width: 8),
                _buildActionButton(
                  icon: Icons.timeline_outlined,
                  tooltip: 'الخط الزمني للحالة',
                  onTap: onTimeline,
                ),
                const SizedBox(width: 8),
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
                  child: const Text(
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
