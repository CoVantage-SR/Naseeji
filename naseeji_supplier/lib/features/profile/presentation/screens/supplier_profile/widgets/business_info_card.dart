import 'package:flutter/material.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';

class BusinessInfoCard extends StatelessWidget {
  final String location;

  const BusinessInfoCard({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'معلومات العمل',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 16),

          // Location
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'الموقع',
                      style: TextStyle(fontSize: 11, color: AppColors.outline),
                    ),
                    Text(
                      location,
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.onSurface),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12),
              _buildIconWrapper(Icons.location_on_outlined),
            ],
          ),
          SizedBox(height: 16),

          // Experience
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'الخبرة',
                      style: TextStyle(fontSize: 11, color: AppColors.outline),
                    ),
                    Text(
                      '15 عاماً في قطاع النسيج',
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.onSurface),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12),
              _buildIconWrapper(Icons.history),
            ],
          ),
          SizedBox(height: 16),

          // Categories
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'الفئات',
                      style: TextStyle(fontSize: 11, color: AppColors.outline),
                    ),
                    SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _buildTag('ألياف ذكية'),
                        SizedBox(width: 6),
                        _buildTag('قطن طبيعي'),
                        SizedBox(width: 6),
                        _buildTag('حرير'),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12),
              _buildIconWrapper(Icons.category_outlined),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIconWrapper(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: AppColors.primary, size: 20),
    );
  }

  Widget _buildTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFECEFF1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant),
      ),
    );
  }
}