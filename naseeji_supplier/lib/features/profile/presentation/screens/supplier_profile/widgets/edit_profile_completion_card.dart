import 'package:flutter/material.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';

class EditProfileCompletionCard extends StatelessWidget {
  final double completionRate;

  const EditProfileCompletionCard({super.key, required this.completionRate});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E1EF)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  'جاهزية الملف التعريفي',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.onSurface),
                ),
                const SizedBox(height: 4),
                Text(
                  'ملء كافة البيانات يزيد فرص ظهورك في محركات البحث للمصانع بنسبة 80%.',
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                  textAlign: TextAlign.end,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(
                  value: completionRate / 100,
                  strokeWidth: 5,
                  backgroundColor: Colors.grey.shade100,
                  color: completionRate > 80 ? Colors.green : const Color(0xFF0040E0),
                ),
              ),
              Text('${completionRate.toInt()}%', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }
}
