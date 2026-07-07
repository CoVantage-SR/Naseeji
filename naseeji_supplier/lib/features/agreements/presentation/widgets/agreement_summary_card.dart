import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../../domain/entities/agreement_model.dart';

class AgreementSummaryCard extends StatelessWidget {
  final B2BAgreement a;

  const AgreementSummaryCard({super.key, required this.a});

  @override
  Widget build(BuildContext context) {
    Color statusColor = Colors.grey;
    String statusText = '';

    switch (a.status) {
      case AgreementStatus.pendingApproval:
        statusColor = Colors.orange;
        statusText = 'انتظار الموافقة';
        break;
      case AgreementStatus.active:
        statusColor = Colors.green;
        statusText = 'سارية ونشطة';
        break;
      case AgreementStatus.completed:
        statusColor = Colors.blue.shade800;
        statusText = 'مكتملة ومغلقة';
        break;
      case AgreementStatus.cancelled:
        statusColor = Colors.red;
        statusText = 'ملغاة';
        break;
      case AgreementStatus.expired:
        statusColor = Colors.grey.shade700;
        statusText = 'منتهية الصلاحية';
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Card Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Color(a.factoryInfo.logoBgColorValue),
                  child: Text(a.factoryInfo.logoText, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(a.factoryInfo.factoryName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.onSurface)),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text('اتفاقية: ${a.id}', style: const TextStyle(fontSize: 10, color: AppColors.outline)),
                          const SizedBox(width: 8),
                          Text('طلب: ${a.orderNumber}', style: const TextStyle(fontSize: 10, color: AppColors.outline)),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: statusColor),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.surfaceContainerLow),

          // Card Content
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(a.product.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: AppColors.onSurfaceVariant)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Text('الكمية: ', style: TextStyle(fontSize: 11, color: AppColors.outline)),
                    Text('${a.product.quantity} ${a.product.unit}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
                    const Spacer(),
                    const Text('السعر النهائي: ', style: TextStyle(fontSize: 11, color: AppColors.outline)),
                    Text('${a.pricing.finalPrice.toStringAsFixed(2)} ${a.pricing.currency}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Text('المجموع الكلي: ', style: TextStyle(fontSize: 11, color: AppColors.outline)),
                    Text('${a.pricing.grandTotal.toStringAsFixed(2)} ${a.pricing.currency}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.green)),
                    const Spacer(),
                    const Text('طريقة الدفع: ', style: TextStyle(fontSize: 11, color: AppColors.outline)),
                    Text(a.paymentTerms.method.split(' ').first, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Text('تاريخ التوريد: ', style: TextStyle(fontSize: 11, color: AppColors.outline)),
                    Text(a.deliveryTerms.deliveryDate, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
                    const Spacer(),
                    const Text('تحديث: ', style: TextStyle(fontSize: 11, color: AppColors.outline)),
                    Text(a.lastUpdated, style: const TextStyle(fontSize: 10, color: AppColors.outline, fontStyle: FontStyle.italic)),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.surfaceContainerLow),

          // Card Footer Actions
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                    onPressed: () {
                      // Navigate to timeline page
                      context.push('/agreements/history/${a.id}?rfqId=${a.rfqNumber}');
                    },
                    icon: const Icon(Icons.history_outlined, size: 14),
                    label: const Text('السجل والزمن', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                    style: TextButton.styleFrom(foregroundColor: AppColors.primary, padding: EdgeInsets.zero),
                  ),
                ),
                Expanded(
                  child: TextButton.icon(
                    onPressed: () {
                      // Navigate to documents page
                      context.push('/agreements/documents/${a.id}');
                    },
                    icon: const Icon(Icons.description_outlined, size: 14),
                    label: const Text('المستندات', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                    style: TextButton.styleFrom(foregroundColor: AppColors.secondary, padding: EdgeInsets.zero),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to details page
                      context.push('/agreements/details/${a.id}');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0040E0),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      minimumSize: const Size(0, 32),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: EdgeInsets.zero,
                    ),
                    child: const Text('التفاصيل والفسح', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
