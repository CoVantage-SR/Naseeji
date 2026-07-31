import 'package:flutter/material.dart';

class EditProfileAddressSection extends StatelessWidget {
  final TextEditingController countryController;
  final TextEditingController cityController;
  final TextEditingController addressController;
  final TextEditingController postalCodeController;
  final VoidCallback onCurrentLocationSelected;

  const EditProfileAddressSection({
    super.key,
    required this.countryController,
    required this.cityController,
    required this.addressController,
    required this.postalCodeController,
    required this.onCurrentLocationSelected,
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
          Text('موقع المنشأة وعناوين الفروع', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          SizedBox(height: 12),
          _buildTextField('الدولة *', countryController, isRequired: true),
          SizedBox(height: 10),
          _buildTextField('المدينة *', cityController, isRequired: true),
          SizedBox(height: 10),
          _buildTextField('العنوان التفصيلي للمقر الرئيسي', addressController),
          SizedBox(height: 10),
          _buildTextField('الرمز البريدي للمراسلات الورقية', postalCodeController, keyboardType: TextInputType.number),
          SizedBox(height: 16),
          // B2B Visual Map Preview component
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Stack(
              children: [
                // Visual Mock Map Graphic Representation
                Positioned.fill(
                  child: Opacity(
                    opacity: 0.85,
                    child: Image.network(
                      'https://images.unsplash.com/photo-1524661135-423995f22d0b?auto=format&fit=crop&w=400&q=80',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFF0040E0))),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.my_location, color: Color(0xFF0040E0), size: 12),
                        SizedBox(width: 6),
                        Text('تم تحديد الموقع الجغرافي للمصنع بدقة', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF0040E0))),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  right: 8,
                  bottom: 8,
                  child: SizedBox(
                    width: 140,
                    child: ElevatedButton.icon(
                      onPressed: onCurrentLocationSelected,
                      icon: const Icon(Icons.gps_fixed, size: 10, color: Color(0xFF0040E0)),
                      label: Text('تحديد الموقع الحالي', style: TextStyle(fontSize: 8, color: Color(0xFF0040E0), fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        elevation: 1,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController ctrl, {
    bool isRequired = false,
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


