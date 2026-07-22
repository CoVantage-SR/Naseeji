// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../../domain/entities/shipment.dart';

class DetailsTabView extends StatelessWidget {
  final Shipment s;

  const DetailsTabView({super.key, required this.s});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Current Status Tracker Header
          _buildStatusProgressHeader(s),
          SizedBox(height: 16),

          // Order details card
          _buildSectionCard(
            title: 'تفاصيل الطلب والمنتج',
            icon: Icons.assignment_outlined,
            children: [
              _buildDetailRow('اسم المنتج', s.productName),
              _buildDetailRow('الكمية الإجمالية', '${s.quantity} ${s.unit}'),
              _buildDetailRow('الوزن الكلي للشحنة', '${s.weight} كجم'),
              _buildDetailRow('الحجم الكلي للشحنة', '${s.volume} متر مكعب'),
              _buildDetailRow('عدد الكرتونات والطرود', '${s.cartons} كرتونة • ${s.packages} طرد كبير'),
              _buildDetailRow('الرقم المرجعي RFQ', s.rfqNumber, isLink: true),
            ],
          ),
          SizedBox(height: 16),

          // Carrier details card
          _buildSectionCard(
            title: 'تفاصيل الشحن والناقل',
            icon: Icons.local_shipping_outlined,
            children: [
              _buildDetailRow('شركة الشحن الناقلة', s.shippingCompany.isNotEmpty ? s.shippingCompany : 'لم يحدد بعد'),
              _buildDetailRow('طريقة ونوع الشحن', s.shippingMethod.isNotEmpty ? s.shippingMethod : 'لم يحدد بعد'),
              _buildDetailRow('رقم التتبع (Tracking Number)', s.trackingNumber.isNotEmpty ? s.trackingNumber : 'بانتظار التحديث', isPrimary: s.trackingNumber.isNotEmpty),
              _buildDetailRow('موعد الاستلام الفعلي', s.timeline.first.date),
              _buildDetailRow('الوصول المتوقع للمستودع', s.estimatedDelivery),
              _buildDetailRow('عنوان مستودع التسليم', s.deliveryAddress),
              if (s.driverName.isNotEmpty) ...[
                const Divider(height: 12),
                _buildDetailRow('اسم السائق الناقل', s.driverName),
                _buildDetailRow('رقم هاتف السائق', s.driverPhone),
                _buildDetailRow('رقم لوحة المركبة', s.vehicleNumber),
              ],
            ],
          ),
          SizedBox(height: 16),

          // Shipping Cost breakdown card
          _buildSectionCard(
            title: 'تفاصيل التكاليف والمالية اللوجستية',
            icon: Icons.account_balance_wallet_outlined,
            children: [
              _buildDetailRow('تكلفة الشحن المباشرة', '${s.cost.shipping.toStringAsFixed(2)} جنيه'),
              _buildDetailRow('تكلفة التأمين اللوجستي', '${s.cost.insurance.toStringAsFixed(2)} جنيه'),
              _buildDetailRow('الضرائب والرسوم الجمركية', '${s.cost.taxes.toStringAsFixed(2)} جنيه'),
              _buildDetailRow('رسوم التحميل والتفريغ', '${s.cost.handling.toStringAsFixed(2)} جنيه'),
              _buildDetailRow('تكلفة التعبئة والتغليف المتخصصة', '${s.cost.packaging.toStringAsFixed(2)} جنيه'),
              if (s.cost.other > 0) _buildDetailRow('رسوم لوجستية أخرى إضافية', '${s.cost.other.toStringAsFixed(2)} جنيه'),
              const Divider(height: 12),
              _buildDetailRow('المجموع الكلي اللوجستي', '${s.cost.total.toStringAsFixed(2)} جنيه', isBold: true),
              _buildDetailRow('حالة الدفعة المالية للشحن', s.status == ShipmentStatus.completed ? 'تم الإفراج والدفع' : 'قيد التعليق اللوجستي المربوط'),
            ],
          ),
          SizedBox(height: 16),

          // Factory Confirmation Details
          if (s.factoryConfirmation != null)
            _buildSectionCard(
              title: 'تأكيد استلام وفحص المصنع',
              icon: Icons.verified_user_outlined,
              children: [
                _buildDetailRow('حالة الاستلام الفعلي', s.factoryConfirmation!.received ? 'تم استلام وتأكيد وصول الشحنة' : 'لم يتم الاستلام بعد'),
                _buildDetailRow('حالة التدقيق الجمركي والفحص', s.factoryConfirmation!.inspectionStatus),
                _buildDetailRow('الكمية المقبولة المستلمة', '${s.factoryConfirmation!.acceptedQty.toStringAsFixed(0)} ${s.unit}'),
                _buildDetailRow('الكمية المرفوضة (إن وجدت)', '${s.factoryConfirmation!.rejectedQty.toStringAsFixed(0)} ${s.unit}', isWarning: s.factoryConfirmation!.rejectedQty > 0),
                _buildDetailRow('ملاحظات الجودة للمستودع', s.factoryConfirmation!.notes),
                _buildDetailRow('رأي المشتري النهائي', s.factoryConfirmation!.feedback),
                if (s.factoryConfirmation!.images.isNotEmpty) ...[
                  SizedBox(height: 8),
                  Text('صور توثيق الاستلام في موقع الفحص:', style: TextStyle(fontSize: 10, color: AppColors.outline)),
                  SizedBox(height: 6),
                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: s.factoryConfirmation!.images.length,
                      itemBuilder: (context, i) => Container(
                        margin: const EdgeInsets.only(left: 6),
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          image: DecorationImage(image: NetworkImage(s.factoryConfirmation!.images[i]), fit: BoxFit.cover),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          SizedBox(height: 16),

          // Active Reported Issue Card
          if (s.issueReported != null)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: AppColors.error),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('تم فتح بلاغ/نزاع لوجستي نشط', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.error)),
                        SizedBox(height: 2),
                        Text(s.issueReported!, style: TextStyle(fontSize: 10, color: Colors.red.shade900)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatusProgressHeader(Shipment s) {
    Color statusColor = AppColors.primary;
    String statusText = '';
    switch (s.status) {
      case ShipmentStatus.ready:
        statusColor = Colors.blue.shade700;
        statusText = 'جاهز للشحن والتسليم';
        break;
      case ShipmentStatus.loaded:
        statusColor = Colors.indigo;
        statusText = 'تم التحميل للناقل';
        break;
      case ShipmentStatus.pickedUp:
        statusColor = Colors.orange;
        statusText = 'تم تسليم الشحنة للسائق';
        break;
      case ShipmentStatus.inTransit:
        statusColor = Colors.orange.shade700;
        statusText = 'الشحنة في الطريق';
        break;
      case ShipmentStatus.arrived:
        statusColor = Colors.teal;
        statusText = 'وصلت الشحنة موقع الفحص';
        break;
      case ShipmentStatus.delivered:
        statusColor = Colors.green;
        statusText = 'تم تسليم الشحنة بالكامل';
        break;
      case ShipmentStatus.paymentPending:
        statusColor = Colors.purple;
        statusText = 'بانتظار الإفراج المالي';
        break;
      case ShipmentStatus.completed:
        statusColor = Colors.green.shade800;
        statusText = 'الشحنة مكتملة ومسواة مالياً';
        break;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.all(Radius.circular(16)),
        boxShadow: [BoxShadow(color: Color(0x05000000), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                statusText,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: statusColor),
              ),
              Text(
                '${(s.progress * 100).toInt()}%',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: statusColor),
              ),
            ],
          ),
          SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: s.progress,
              color: statusColor,
              backgroundColor: AppColors.surfaceContainerLow,
              minHeight: 6,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'التحديث الأخير: ${s.lastUpdate}',
            style: TextStyle(fontSize: 10, color: AppColors.outline, fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({required String title, required IconData icon, required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.all(Radius.circular(16)),
        boxShadow: [BoxShadow(color: Color(0x05000000), blurRadius: 10)],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 20),
              SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.onSurface),
              ),
            ],
          ),
          SizedBox(height: 12),
          Divider(height: 1, color: AppColors.surfaceContainerLow),
          SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isBold = false, bool isPrimary = false, bool isWarning = false, bool isLink = false}) {
    Color valueColor = AppColors.onSurface;
    if (isPrimary) valueColor = AppColors.primary;
    if (isWarning) valueColor = AppColors.error;
    if (isLink) valueColor = const Color(0xFF0040E0);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 11, color: AppColors.outline),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isBold || isLink ? FontWeight.bold : FontWeight.w600,
              color: valueColor,
              decoration: isLink ? TextDecoration.underline : TextDecoration.none,
            ),
          ),
        ],
      ),
    );
  }
}