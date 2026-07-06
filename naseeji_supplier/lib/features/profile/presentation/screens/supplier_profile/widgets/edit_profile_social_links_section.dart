import 'package:flutter/material.dart';

class EditProfileSocialLinksSection extends StatelessWidget {
  final TextEditingController fbController;
  final TextEditingController instaController;
  final TextEditingController linkedinController;
  final TextEditingController xController;
  final TextEditingController youtubeController;

  const EditProfileSocialLinksSection({
    super.key,
    required this.fbController,
    required this.instaController,
    required this.linkedinController,
    required this.xController,
    required this.youtubeController,
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
          const Text('الروابط الاجتماعية والمهنية للشركة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 12),
          _buildTextField('صفحة فيسبوك للنشاط', fbController, isUrl: true),
          const SizedBox(height: 10),
          _buildTextField('رابط الإنستغرام لاستعراض الكتالوجات', instaController, isUrl: true),
          const SizedBox(height: 10),
          _buildTextField('الحساب المهني لينكد إن (LinkedIn)', linkedinController, isUrl: true),
          const SizedBox(height: 10),
          _buildTextField('حساب إكس (X / تويتر سابقاً)', xController, isUrl: true),
          const SizedBox(height: 10),
          _buildTextField('قناة يوتيوب لعروض خطوط الإنتاج والآلات', youtubeController, isUrl: true),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController ctrl, {
    bool isUrl = false,
  }) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: TextFormField(
        controller: ctrl,
        validator: (value) {
          if (value != null && value.trim().isNotEmpty && isUrl) {
            final urlRegex = RegExp(r'^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$');
            if (!urlRegex.hasMatch(value.trim())) {
              return 'يرجى إدخال رابط أو عنوان URL صالح.';
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
        style: const TextStyle(fontSize: 12),
      ),
    );
  }
}
