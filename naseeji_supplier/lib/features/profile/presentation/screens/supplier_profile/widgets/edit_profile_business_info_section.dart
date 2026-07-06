import 'package:flutter/material.dart';

class EditProfileBusinessInfoSection extends StatelessWidget {
  final TextEditingController crController;
  final TextEditingController taxController;
  final TextEditingController licenseController;
  final TextEditingController experienceController;
  final TextEditingController moqController;
  final TextEditingController prodTimeController;

  const EditProfileBusinessInfoSection({
    super.key,
    required this.crController,
    required this.taxController,
    required this.licenseController,
    required this.experienceController,
    required this.moqController,
    required this.prodTimeController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E1EF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text('البيانات الرسمية والحد الأدنى للطلب', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 12),
          _buildTextField('رقم السجل التجاري الرسمي', crController, keyboardType: TextInputType.number),
          const SizedBox(height: 10),
          _buildTextField('الرقم الضريبي المعتمد', taxController, keyboardType: TextInputType.number),
          const SizedBox(height: 10),
          _buildTextField('رقم رخصة البلدية / التراخيص الصناعية', licenseController),
          const SizedBox(height: 10),
          _buildTextField('سنوات الخبرة الإجمالية في المجال', experienceController, keyboardType: TextInputType.number),
          const SizedBox(height: 10),
          _buildTextField('الحد الأدنى للطلب (MOQ) بالوحدات', moqController, keyboardType: TextInputType.number),
          const SizedBox(height: 10),
          _buildTextField('متوسط مدة التجهيز والإنتاج بالعادة', prodTimeController),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController ctrl, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: TextFormField(
        controller: ctrl,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(fontSize: 11, color: Colors.grey.shade600),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
        style: const TextStyle(fontSize: 12),
      ),
    );
  }
}
