import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../orders/presentation/providers/orders_provider.dart';
import 'quality_reusable_widgets.dart';

class ReceiptHeaderWidget extends StatelessWidget {
  final OrderModel order;

  const ReceiptHeaderWidget({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: AppRadius.rMD,
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          const Icon(Icons.receipt_long_rounded, color: AppColors.primary, size: 36),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'سند استلام الشحنة وتأكيد الوصول',
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'المورد: ${order.supplierName}',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OrderSummaryWidget extends StatelessWidget {
  final OrderModel order;

  const OrderSummaryWidget({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return InformationCard(
      title: 'بيانات الطلب الأساسية',
      items: [
        {'label': 'رقم الطلب (Order ID)', 'value': order.id},
        {'label': 'المنتج المتعاقد عليه', 'value': order.productName},
        {'label': 'الكمية المطلوبة', 'value': '${order.quantity} وحدة'},
        {'label': 'القيمة الكلية للصفقة', 'value': '${order.finalPrice.toInt()} ج.م'},
      ],
    );
  }
}

class ShipmentInformationWidget extends StatelessWidget {
  final OrderModel order;

  const ShipmentInformationWidget({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return InformationCard(
      title: 'تفاصيل الشحن والتوصيل الفعلي',
      items: [
        {'label': 'رقم الشحنة (Shipment ID)', 'value': order.trackingNumber},
        {'label': 'شركة الشحن واللوجستيات', 'value': order.shippingCompany},
        {'label': 'الكمية الواصلة فعلياً', 'value': '${order.quantity} وحدة (كاملة)'},
        {'label': 'تاريخ وصول الشحنة', 'value': order.estimatedArrival},
      ],
    );
  }
}

class MediaPreviewWidget extends StatelessWidget {
  const MediaPreviewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock URLs for shipment photos and documents
    final prepImages = [
      'https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d',
      'https://images.unsplash.com/photo-1578575437130-527eed3abbec',
    ];

    final shippingDocs = [
      'بوليصة_الشحن_الموقعة.pdf',
      'شهادة_المنشأ_والمطابقة.pdf',
    ];

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.rMD,
        side: BorderSide(
          color: context.theme.brightness == Brightness.dark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'الوسائط والمستندات المرفقة من المورد',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primary),
            ),
            const SizedBox(height: 16),
            const Text(
              'صور التجهيز والتحميل:',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 90,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: prepImages.length,
                itemBuilder: (context, index) {
                  return ImagePreviewCard(imagePath: prepImages[index]);
                },
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'فيديو التحضير والشحن:',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  VideoPreviewCard(title: 'فيديو_فحص_التحميل.mp4'),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'المستندات وأوراق الشحن الرسمية:',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...shippingDocs.map((doc) => AttachmentCard(fileName: doc)),
          ],
        ),
      ),
    );
  }
}

class InspectionChecklistWidget extends StatelessWidget {
  final Map<String, bool> checklist;
  final ValueChanged<String> onItemToggled;

  const InspectionChecklistWidget({
    super.key,
    required this.checklist,
    required this.onItemToggled,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.rMD,
        side: BorderSide(
          color: context.theme.brightness == Brightness.dark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'قائمة التحقق المبدئية للشحنة',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primary),
            ),
            const SizedBox(height: 8),
            const Text(
              'يرجى مراجعة وتأكيد البنود التالية قبل الاستلام:',
              style: TextStyle(fontSize: 11, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ...checklist.entries.map((entry) {
              return ChecklistItem(
                label: entry.key,
                value: entry.value,
                onChanged: (val) => onItemToggled(entry.key),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class DeliveryStatusWidget extends StatelessWidget {
  final String status;

  const DeliveryStatusWidget({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color chipColor = AppColors.primary;
    String arabicText = 'جاهزة للفحص';

    switch (status) {
      case 'delivered':
        chipColor = AppColors.success;
        arabicText = 'تم تأكيد الاستلام';
        break;
      case 'disputed':
        chipColor = AppColors.warning;
        arabicText = 'قيد النزاع';
        break;
      case 'rejected':
        chipColor = AppColors.error;
        arabicText = 'مرفوضة';
        break;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'حالة مطابقة الاستلام:',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: chipColor.withValues(alpha: 0.15),
            borderRadius: AppRadius.rRound,
            border: Border.all(color: chipColor.withValues(alpha: 0.3)),
          ),
          child: Text(
            arabicText,
            style: TextStyle(
              color: chipColor,
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
          ),
        ),
      ],
    );
  }
}

class ActionButtonsWidget extends StatelessWidget {
  final VoidCallback onConfirm;
  final VoidCallback onReportIssue;
  final bool isAllChecked;

  const ActionButtonsWidget({
    super.key,
    required this.onConfirm,
    required this.onReportIssue,
    required this.isAllChecked,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PrimaryButton(
          label: 'تأكيد الاستلام المبدئي وبدء فحص الجودة',
          icon: Icons.done_all_rounded,
          onPressed: onConfirm, // Enable confirm anytime, checklist shows compliance
        ),
        const SizedBox(height: 10),
        SecondaryButton(
          label: 'الإبلاغ عن مشكلة استلام / خلل بالشحنة',
          icon: Icons.error_outline_rounded,
          color: AppColors.error,
          onPressed: onReportIssue,
        ),
      ],
    );
  }
}
