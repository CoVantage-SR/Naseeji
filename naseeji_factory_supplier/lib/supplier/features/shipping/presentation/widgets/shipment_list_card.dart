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
        color: Theme.of(context).colorScheme.surface,
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
                  child: Text(s.factoryLogoText, style: TextStyle(color: Theme.of(context).colorScheme.surface, fontWeight: FontWeight.bold, fontSize: 11)),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(s.factoryName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Theme.of(context).colorScheme.onSurface)),
                      SizedBox(height: 2),
                      Row(
                        children: [
                          Text('طلب: ${s.orderNumber}', style: TextStyle(fontSize: 10, color: AppColors.outline)),
                          SizedBox(width: 8),
                          Text('RFQ #${s.rfqNumber}', style: TextStyle(fontSize: 10, color: AppColors.outline)),
                        ],
                      ),
                    ],
                  ),
                ),
                // Priority Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: s.priority == 'عالي جداً' ? Colors.red.shade50 : Theme.of(context).colorScheme.surfaceContainerLow,
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
          Divider(height: 1, color: AppColors.surfaceContainerLow),

          // Content body
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s.productName, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                SizedBox(height: 4),
                Row(
                  children: [
                    Text('الكمية: ', style: TextStyle(fontSize: 11, color: AppColors.outline)),
                    Text('${s.quantity} ${s.unit}', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
                    const Spacer(),
                    Text('الناقل: ', style: TextStyle(fontSize: 11, color: AppColors.outline)),
                    Text(s.shippingCompany.isNotEmpty ? s.shippingCompany : 'بانتظار الاختيار', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
                  ],
                ),
                if (s.trackingNumber.isNotEmpty) ...[
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Text('رقم التتبع: ', style: TextStyle(fontSize: 11, color: AppColors.outline)),
                      Text(s.trackingNumber, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary)),
                      const Spacer(),
                      Text('التوصيل المتوقع: ', style: TextStyle(fontSize: 11, color: AppColors.outline)),
                      Text(s.estimatedDelivery, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
                    ],
                  ),
                ],
                SizedBox(height: 8),
                
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
                      SizedBox(width: 8),
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
                SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value: s.progress,
                    color: statusColor,
                    backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
                    minHeight: 4,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'آخر تحديث: ${s.lastUpdate}',
                  style: TextStyle(fontSize: 9, color: AppColors.outline, fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: AppColors.surfaceContainerLow),

          // Actions
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                    onPressed: () => context.push('/shipping/tracking/${s.id}'),
                    icon: const Icon(Icons.map_outlined, size: 14),
                    label: Text('تتبع الشحنة', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                    style: TextButton.styleFrom(foregroundColor: AppColors.primary, padding: EdgeInsets.zero),
                  ),
                ),
                Expanded(
                  child: TextButton.icon(
                    onPressed: () => context.push('/shipping/documents/${s.id}'),
                    icon: const Icon(Icons.description_outlined, size: 14),
                    label: Text('المستندات', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
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
                    child: Text('التفاصيل', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
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