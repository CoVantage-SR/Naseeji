import 'package:flutter/material.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import 'package:naseeji_supplier/features/profile/domain/entities/supplier_profile.dart';

class PaymentsTabView extends StatelessWidget {
  final SupplierProfile profile;

  const PaymentsTabView({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E1EF)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('طرق الدفع والتسهيلات الائتمانية والعملات المقبولة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF006B5F))),
            SizedBox(height: 12),
            _buildRowItem('العملات المقبولة لسداد المستندات', 'ريال سعودي (SAR) • دولار أمريكي (USD)'),
            _buildRowItem('طرق السداد المعتمدة', 'تحويل بنكي مباشر • دفع ضامن (Escrow) • شيكات معتمدة'),
            _buildRowItem('أجل السداد المعتمد (Credit terms)', 'Net 30 أيام • دفعة مقدمة 30% مع تأمين الشحنة'),
            _buildRowItem('الحساب البنكي الرئيسي للمورد', 'البنك الأهلي السعودي SNB - آيبان SA90000001234567890'),
          ],
        ),
      ),
    );
  }

  Widget _buildRowItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(child: Text(value, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold), textAlign: TextAlign.left)),
          SizedBox(width: 10),
          Text('$label:', style: TextStyle(fontSize: 10, color: AppColors.outline)),
        ],
      ),
    );
  }
}
