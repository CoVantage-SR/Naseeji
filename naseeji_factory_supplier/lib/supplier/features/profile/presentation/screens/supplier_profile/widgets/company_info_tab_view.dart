import 'package:flutter/material.dart';
import 'package:naseeji_factory/supplier/core/theme/app_colors.dart';
import 'package:naseeji_factory/supplier/features/profile/domain/entities/supplier_profile.dart';

class CompanyInfoTabView extends StatelessWidget {
  final SupplierProfile profile;

  const CompanyInfoTabView({super.key, required this.profile});

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
            Text('المعلومات القانونية والتجارية للمنشأة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF0040E0))),
            SizedBox(height: 12),
            _buildRowItem('الاسم التجاري المعتمد', profile.companyName),
            _buildRowItem('رقم السجل التجاري (CR)', '1010998822 (نشط)'),
            _buildRowItem('رقم التسجيل الضريبي (VAT)', '300998877110003'),
            _buildRowItem('نوع النشاط التجاري', 'جهة تصنيع وتوريد جملة'),
            _buildRowItem('المساحة الإجمالية للمصنع', '12,500 متر مربع'),
            _buildRowItem('عدد العمال والموظفين الفنيين', '250+ فني خياطة ونسيج'),
            _buildRowItem('الطاقة الإنتاجية الشهرية', '150,000 متر طولي'),
            _buildRowItem('موقع المنشأة وعنوان الإدارة', 'شارع الصناعية، الرياض، SA'),
            _buildRowItem('الموقع الإلكتروني', 'www.naseejitex.com'),
            _buildRowItem('رقم الهاتف للتواصل', profile.phone),
            _buildRowItem('البريد الإلكتروني للطلبات', profile.email),
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

