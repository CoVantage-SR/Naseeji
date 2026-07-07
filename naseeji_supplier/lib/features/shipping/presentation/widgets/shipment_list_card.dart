import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../../domain/entities/shipment.dart';

class ShipmentListCard extends StatelessWidget {
  final Shipment s;

  const ShipmentListCard({super.key, required this.s});

  @override
  Widget build(BuildContext context) {
    Color statusColor = Colors.grey;
    String statusText = '';
    
    switch (s.status) {
      case ShipmentStatus.ready:
        statusColor = Colors.blue.shade700;
        statusText = 'جاهز للشحن';
        break;
      case ShipmentStatus.loaded:
        statusColor = Colors.indigo;
        statusText = 'تم التحميل للناقل';
        break;
      case ShipmentStatus.pickedUp:
        statusColor = Colors.orange;
        statusText = 'تم الاستلام';
        break;
      case ShipmentStatus.inTransit:
        statusColor = Colors.orange.shade700;
        statusText = 'في الطريق';
        break;
      case ShipmentStatus.arrived:
        statusColor = Colors.teal;
        statusText = 'وصلت الميناء/المستودع';
        break;
      case ShipmentStatus.delivered:
        statusColor = Colors.green;
        statusText = 'تم التسليم للمشتري';
        break;
      case ShipmentStatus.paymentPending:
        statusColor = Colors.purple;
        statusText = 'قيد الإفراج المالي';
        break;
      case ShipmentStatus.completed:
        statusColor = Colors.green.shade800;
        statusText = 'مكتملة ومسواة';
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
          // Header info
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
            child: Row(
              children: [
                // Factory logo
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Color(s.factoryLogoBgColorValue),
                  child: Text(s.factoryLogoText, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(s.factoryName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.onSurface)),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text('طلب: ${s.orderNumber}', style: const TextStyle(fontSize: 10, color: AppColors.outline)),
                          const SizedBox(width: 8),
                          Text('RFQ #${s.rfqNumber}', style: const TextStyle(fontSize: 10, color: AppColors.outline)),
                        ],
                      ),
                    ],
                  ),
                ),
                // Priority Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: s.priority == 'عالي جداً' ? Colors.red.shade50 : AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    s.priority,
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                      color: s.priority == 'عالي جداً' ? Colors.red.shade700 : AppColors.outline,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.surfaceContainerLow),

          // Content body
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s.productName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: AppColors.onSurfaceVariant)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Text('الكمية: ', style: TextStyle(fontSize: 11, color: AppColors.outline)),
                    Text('${s.quantity} ${s.unit}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
                    const Spacer(),
                    const Text('الناقل: ', style: TextStyle(fontSize: 11, color: AppColors.outline)),
                    Text(s.shippingCompany.isNotEmpty ? s.shippingCompany : 'بانتظار الاختيار', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
                  ],
                ),
                if (s.trackingNumber.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Text('رقم التتبع: ', style: TextStyle(fontSize: 11, color: AppColors.outline)),
                      Text(s.trackingNumber, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary)),
                      const Spacer(),
                      const Text('التوصيل المتوقع: ', style: TextStyle(fontSize: 11, color: AppColors.outline)),
                      Text(s.estimatedDelivery, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
                    ],
                  ),
                ],
                const SizedBox(height: 8),
                
                // Status tag & Progress bar
                Row(
                  children: [
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
                    if (s.issueReported != null) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(6)),
                        child: Text('بلاغ نشط', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.red.shade700)),
                      ),
                    ],
                    const Spacer(),
                    Text('${(s.progress * 100).toInt()}%', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: statusColor)),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value: s.progress,
                    color: statusColor,
                    backgroundColor: AppColors.surfaceContainerLow,
                    minHeight: 4,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'آخر تحديث: ${s.lastUpdate}',
                  style: const TextStyle(fontSize: 9, color: AppColors.outline, fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.surfaceContainerLow),

          // Actions
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                    onPressed: () => context.push('/shipping/tracking/${s.id}'),
                    icon: const Icon(Icons.map_outlined, size: 14),
                    label: const Text('تتبع الشحنة', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                    style: TextButton.styleFrom(foregroundColor: AppColors.primary, padding: EdgeInsets.zero),
                  ),
                ),
                Expanded(
                  child: TextButton.icon(
                    onPressed: () => context.push('/shipping/documents/${s.id}'),
                    icon: const Icon(Icons.description_outlined, size: 14),
                    label: const Text('المستندات', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                    style: TextButton.styleFrom(foregroundColor: AppColors.secondary, padding: EdgeInsets.zero),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => context.push('/shipping/details/${s.id}'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0040E0),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      minimumSize: const Size(0, 32),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: EdgeInsets.zero,
                    ),
                    child: const Text('التفاصيل', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
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
