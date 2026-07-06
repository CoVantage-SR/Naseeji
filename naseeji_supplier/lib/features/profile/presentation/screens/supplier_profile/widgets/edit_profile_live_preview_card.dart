import 'package:flutter/material.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';

class EditProfileLivePreviewCard extends StatelessWidget {
  final String companyName;
  final String city;
  final String description;
  final List<String> categories;
  final String logoUrl;

  const EditProfileLivePreviewCard({
    super.key,
    required this.companyName,
    required this.city,
    required this.description,
    required this.categories,
    required this.logoUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F4FE),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF0040E0).withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.remove_red_eye_outlined, size: 14, color: Color(0xFF0040E0)),
              const Text(
                'معاينة حية (B2B Preview Card)',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF0040E0)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 2)),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        companyName.isEmpty ? 'مصنع توريد نسيج' : companyName,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        textAlign: TextAlign.end,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(city.isEmpty ? 'الموقع' : city, style: const TextStyle(fontSize: 10, color: AppColors.outline)),
                          const SizedBox(width: 4),
                          const Icon(Icons.location_on_outlined, size: 10, color: AppColors.outline),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        description.isEmpty ? 'لم يتم إضافة نبذة مختصرة عن المصنع بعد.' : description,
                        style: const TextStyle(fontSize: 9, color: AppColors.onSurfaceVariant, height: 1.3),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        alignment: WrapAlignment.end,
                        children: categories.map((cat) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: const Color(0xFFF1F4FE), borderRadius: BorderRadius.circular(4)),
                          child: Text(cat, style: const TextStyle(color: Color(0xFF0040E0), fontSize: 8)),
                        )).toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    shape: BoxShape.circle,
                    image: logoUrl.isNotEmpty ? DecorationImage(image: NetworkImage(logoUrl), fit: BoxFit.cover) : null,
                  ),
                  child: logoUrl.isEmpty ? const Icon(Icons.business, size: 20, color: Colors.grey) : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
