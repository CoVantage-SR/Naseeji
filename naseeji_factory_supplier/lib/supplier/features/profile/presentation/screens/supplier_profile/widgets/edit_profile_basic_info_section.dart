import 'package:flutter/material.dart';

class EditProfileBasicInfoSection extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController tradeNameController;
  final TextEditingController businessTypeController;
  final TextEditingController descriptionController;
  final TextEditingController establishedYearController;
  final TextEditingController employeesController;
  final TextEditingController monthlyCapacityController;
  final TextEditingController warehouseCapacityController;

  const EditProfileBasicInfoSection({
    super.key,
    required this.nameController,
    required this.tradeNameController,
    required this.businessTypeController,
    required this.descriptionController,
    required this.establishedYearController,
    required this.employeesController,
    required this.monthlyCapacityController,
    required this.warehouseCapacityController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E1EF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text('معلومات الشركة الأساسية', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          SizedBox(height: 12),
          _buildTextField('اسم المنشأة بالعربية *', nameController, isRequired: true),
          SizedBox(height: 10),
          _buildTextField('الاسم التجاري المعتمد', tradeNameController),
          SizedBox(height: 10),
          _buildTextField('نوع النشاط التجاري *', businessTypeController, isRequired: true),
          SizedBox(height: 10),
          _buildTextField('وصف تفصيلي للمنشأة *', descriptionController, maxLines: 3, isRequired: true),
          SizedBox(height: 10),
          _buildTextField('سنة التأسيس', establishedYearController, keyboardType: TextInputType.number),
          SizedBox(height: 10),
          _buildTextField('عدد الموظفين الحاليين', employeesController, keyboardType: TextInputType.number),
          SizedBox(height: 10),
          _buildTextField('القدرة الإنتاجية الشهرية', monthlyCapacityController),
          SizedBox(height: 10),
          _buildTextField('المساحة الإجمالية للمستودعات', warehouseCapacityController),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController ctrl, {
    bool isRequired = false,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: TextFormField(
        controller: ctrl,
        maxLines: maxLines,
        keyboardType: keyboardType,
        validator: (value) {
          if (isRequired && (value == null || value.trim().isEmpty)) {
            return 'هذا الحقل مطلوب ولا يمكن تركه فارغاً.';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(fontSize: 11, color: Colors.grey.shade600),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          alignLabelWithHint: true,
        ),
        style: TextStyle(fontSize: 12),
      ),
    );
  }
}



