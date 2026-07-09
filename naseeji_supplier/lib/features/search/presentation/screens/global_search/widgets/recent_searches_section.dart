import 'package:flutter/material.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';

class RecentSearchesSection extends StatelessWidget {
  const RecentSearchesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> recentSearches = [
      'نسيج قطني فاخر',
      'طلب #89021',
      'مصنع الشرقية للغزل',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {},
              child: Text(
                'مسح الكل',
                style: TextStyle(color: Color(0xFF0040E0), fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              'عمليات البحث الأخيرة',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        ...recentSearches.map((search) => _buildRecentSearchItem(context, search)),
      ],
    );
  }

  Widget _buildRecentSearchItem(BuildContext context, String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(Icons.history, color: AppColors.outline, size: 18),
          Text(
            text,
            style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.onSurface),
          ),
        ],
      ),
    );
  }
}
