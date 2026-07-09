import 'package:flutter/material.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../../domain/entities/quotation_model.dart';

class QuotationPriceCard extends StatelessWidget {
  final QuotationModel quotation;

  const QuotationPriceCard({super.key, required this.quotation});

  @override
  Widget build(BuildContext context) {
    final subtotal = quotation.supplierUnitPrice * quotation.quantity;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.all(Radius.circular(16)),
        boxShadow: [BoxShadow(color: Color(0x05000000), blurRadius: 10)],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.monetization_on_outlined, color: AppColors.primary, size: 18),
              SizedBox(width: 8),
              Text(
                'تفاصيل التكاليف والمالية اللوجستية',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Theme.of(context).colorScheme.onSurface),
              ),
            ],
          ),
          SizedBox(height: 10),
          const Divider(height: 1, color: Theme.of(context).colorScheme.surfaceContainerLow),
          SizedBox(height: 8),
          
          _buildDetailRow('السعر المطلوب للمصنع', '${quotation.originalRequestedPrice.toStringAsFixed(2)} ${quotation.currency}'),
          _buildDetailRow('سعر وحدة المورد المقترح', '${quotation.supplierUnitPrice.toStringAsFixed(2)} ${quotation.currency}', isPrimary: true),
          _buildDetailRow('الكمية المطلوبة', '${quotation.quantity.toInt()} ${quotation.unit}'),
          _buildDetailRow('قيمة المنسوجات الكلي (المجموع الفرعي)', '${subtotal.toStringAsFixed(2)} ${quotation.currency}'),
          _buildDetailRow('خصم خاص للكمية', '- ${quotation.discount.toStringAsFixed(2)} ${quotation.currency}', isWarning: true),
          _buildDetailRow('ضريبة القيمة المضافة (١٥٪)', '${quotation.taxes.toStringAsFixed(2)} ${quotation.currency}'),
          _buildDetailRow('رسوم الشحن اللوجستي والتسليم', '${quotation.shippingCost.toStringAsFixed(2)} ${quotation.currency}'),
          if (quotation.additionalCharges > 0)
            _buildDetailRow('رسوم إضافية', '${quotation.additionalCharges.toStringAsFixed(2)} ${quotation.currency}'),
          
          const Divider(height: 16),
          
          _buildDetailRow(
            'المجموع الكلي لعرض السعر',
            '${quotation.grandTotal.toStringAsFixed(2)} ${quotation.currency}',
            isBold: true,
            isPrimary: true,
          ),
          SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green.shade100, width: 0.5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.trending_up, color: Colors.green, size: 14),
                    SizedBox(width: 4),
                    Text('هامش الربح المتوقع للمورد:', style: TextStyle(fontSize: 10, color: Colors.green, fontWeight: FontWeight.bold)),
                  ],
                ),
                Text(
                  '${quotation.expectedProfitMargin.toStringAsFixed(1)}%',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.green),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isBold = false, bool isPrimary = false, bool isWarning = false}) {
    Color valueColor = Theme.of(context).colorScheme.onSurface;
    if (isPrimary) valueColor = AppColors.primary;
    if (isWarning) valueColor = AppColors.error;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(fontSize: 10, color: AppColors.outline),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
                color: valueColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
