import 'package:flutter/material.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../../domain/entities/agreement_model.dart';

class AgreementComparisonTable extends StatelessWidget {
  final B2BAgreement agreement;

  const AgreementComparisonTable({super.key, required this.agreement});

  @override
  Widget build(BuildContext context) {
    final prod = agreement.product;
    final pay = agreement.payment;
    final del = agreement.delivery;
    final prd = agreement.production;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        boxShadow: const [BoxShadow(color: Color(0x05000000), blurRadius: 10)],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green.shade100),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildMetricColumn('إجمالي قيمة الصفقة', '${prod.totalPrice} ${prod.currency}', Colors.green.shade800),
                _buildMetricColumn('نسبة الدفعة المقدمة', '${pay.advancePercentage}%', Colors.blue.shade800),
              ],
            ),
          ),
          const SizedBox(height: 16),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 16,
              headingRowHeight: 36,
              dataRowMinHeight: 32,
              dataRowMaxHeight: 48,
              columns: const [
                DataColumn(label: Text('المواصفة / البند', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
                DataColumn(label: Text('القيمة المعتمدة بالاتفاق', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.green))),
              ],
              rows: [
                _buildRow('اسم المنتج والاسم العلمي', prod.name),
                _buildRow('الكمية الإجمالية', '${prod.quantity} ${prod.unit}'),
                _buildRow('سعر الوحدة', '${prod.unitPrice} ${prod.currency}'),
                _buildRow('الإجمالي', '${prod.totalPrice} ${prod.currency}'),
                _buildRow('مدة الإنتاج والتصنيع', prd.productionDuration),
                _buildRow('موعد جاهزية الطلب', prd.readyDate),
                _buildRow('طريقة الدفع', pay.method),
                _buildRow('الدفعة المقدمة', '${pay.advanceAmount} ${pay.currency}'),
                _buildRow('مكان الاستلام', del.pickupLocation),
                _buildRow('موعد جاهزية الشحنة', del.shipmentReadyDate),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricColumn(String title, String val, Color valColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 9, color: AppColors.outline, fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(val, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: valColor)),
      ],
    );
  }

  DataRow _buildRow(String spec, String val) {
    return DataRow(
      cells: [
        DataCell(Text(spec, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10))),
        DataCell(Text(val, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.green))),
      ],
    );
  }
}
