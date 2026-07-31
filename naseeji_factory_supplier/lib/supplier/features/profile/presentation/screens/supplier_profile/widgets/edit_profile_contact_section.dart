import 'package:flutter/material.dart';

class EditProfileContactSection extends StatelessWidget {
  final TextEditingController contactPersonController;
  final TextEditingController phoneController;
  final TextEditingController whatsappController;
  final TextEditingController emailController;
  final TextEditingController websiteController;
  final TextEditingController businessHoursController;

  const EditProfileContactSection({
    super.key,
    required this.contactPersonController,
    required this.phoneController,
    required this.whatsappController,
    required this.emailController,
    required this.websiteController,
    required this.businessHoursController,
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
          Text('بيانات الاتصال والتواصل', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          SizedBox(height: 12),
          _buildTextField('مسؤول التواصل الرئيسي', contactPersonController),
          SizedBox(height: 10),
          _buildTextField('رقم الهاتف الرسمي للتواصل *', phoneController, isRequired: true, keyboardType: TextInputType.phone),
          SizedBox(height: 10),
          _buildTextField('رقم الواتساب للطلبات العاجلة', whatsappController, keyboardType: TextInputType.phone),
          SizedBox(height: 10),
          _buildTextField('البريد الإلكتروني المعتمد *', emailController, isRequired: true, keyboardType: TextInputType.emailAddress, isEmail: true),
          SizedBox(height: 10),
          _buildTextField('الموقع الإلكتروني للمنشأة', websiteController, isUrl: true),
          SizedBox(height: 10),
          _buildTextField('أوقات وساعات العمل الرسمية', businessHoursController),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController ctrl, {
    bool isRequired = false,
    bool isEmail = false,
    bool isUrl = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: TextFormField(
        controller: ctrl,
        keyboardType: keyboardType,
        validator: (value) {
          if (isRequired && (value == null || value.trim().isEmpty)) {
            return 'هذا الحقل مطلوب ولا يمكن تركه فارغاً.';
          }
          if (value != null && value.trim().isNotEmpty) {
            if (isEmail) {
              final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
              if (!emailRegex.hasMatch(value.trim())) {
                return 'يرجى إدخال بريد إلكتروني رسمي وصحيح للشركة.';
              }
            }
            if (isUrl) {
              final urlRegex = RegExp(r'^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$');
              if (!urlRegex.hasMatch(value.trim())) {
                return 'يرجى إدخال رابط أو عنوان URL صالح.';
              }
            }
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(fontSize: 11, color: Colors.grey.shade600),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
        style: TextStyle(fontSize: 12),
      ),
    );
  }
}



