import 'package:flutter/material.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../../domain/entities/agreement_model.dart';

class AgreementComparisonTable extends StatelessWidget {
  final B2BAgreement agreement;

  const AgreementComparisonTable({super.key, required this.agreement});

  @override
  Widget build(BuildContext context) {
    final rfq = agreement.rfqData;
    final quote = agreement.firstQuoteData;
    final counter = agreement.counterOfferData;
    final finalAg = agreement.finalAgreementData;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(16)),
        boxShadow: [BoxShadow(color: Color(0x05000000), blurRadius: 10)],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Metrics summary banner
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.green.shade100)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildMetricColumn('الوفر المالي للمشروع', '${agreement.savingsAmount.toStringAsFixed(0)} ر.س', Colors.green.shade800),
                _buildMetricColumn('نسبة نجاح التفاوض', '${agreement.negotiationSuccessPercent}%', Colors.blue.shade800),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            agreement.savingsDifference,
            style: const TextStyle(fontSize: 10, fontStyle: FontStyle.italic, color: AppColors.outline),
          ),
          const SizedBox(height: 16),

          // Side-by-side table scroll view
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 16,
              headingRowHeight: 36,
              dataRowMinHeight: 32,
              dataRowMaxHeight: 48,
              columns: const [
                DataColumn(label: Text('المواصفات', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
                DataColumn(label: Text('طلب الشراء (RFQ)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.blue))),
                DataColumn(label: Text('العرض الأول', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.indigo))),
                DataColumn(label: Text('العرض المقابل', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.orange))),
                DataColumn(label: Text('الاتفاق النهائي', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.green))),
              ],
              rows: [
                _buildRow('سعر الوحدة', rfq.unitPrice, quote.unitPrice, counter.unitPrice, finalAg.unitPrice, hasChange: true),
                _buildRow('الكمية المطلوبة', rfq.quantity, quote.quantity, counter.quantity, finalAg.quantity),
                _buildRow('الحد الأدنى (MOQ)', rfq.moq, quote.moq, counter.moq, finalAg.moq, hasChange: true),
                _buildRow('زمن التوريد والرحلة', rfq.deliveryTime, quote.deliveryTime, counter.deliveryTime, finalAg.deliveryTime, hasChange: true),
                _buildRow('طريقة الدفع والضمان', rfq.paymentMethod, quote.paymentMethod, counter.paymentMethod, finalAg.paymentMethod),
                _buildRow('شروط الشحن والناقل', rfq.shippingTerms, quote.shippingTerms, counter.shippingTerms, finalAg.shippingTerms),
                _buildRow('الضرائب والرسوم', rfq.taxes, quote.taxes, counter.taxes, finalAg.taxes),
                _buildRow('الخصومات والعلاوات', rfq.discount, quote.discount, counter.discount, finalAg.discount, hasChange: true),
                _buildRow('صلاحية العرض والاتفاق', rfq.validity, quote.validity, counter.validity, finalAg.validity),
                _buildRow('مدة التجهيز بالمصنع', rfq.preparationTime, quote.preparationTime, counter.preparationTime, finalAg.preparationTime),
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
        Text(val, style: TextStyle(fontSize: 16, fontWeight: FontWeight.black, color: valColor)),
      ],
    );
  }

  DataRow _buildRow(String spec, String rfq, String quote, String counter, String finalAg, {bool hasChange = false}) {
    return DataRow(
      color: WidgetStateProperty.resolveWith<Color?>((states) {
        if (hasChange) return Colors.green.withValues(alpha: 0.03);
        return null;
      }),
      cells: [
        DataCell(Text(spec, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10))),
        DataCell(Text(rfq, style: const TextStyle(fontSize: 10))),
        DataCell(Text(quote, style: const TextStyle(fontSize: 10))),
        DataCell(Text(counter, style: const TextStyle(fontSize: 10))),
        DataCell(Text(finalAg, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.green))),
      ],
    );
  }
}
