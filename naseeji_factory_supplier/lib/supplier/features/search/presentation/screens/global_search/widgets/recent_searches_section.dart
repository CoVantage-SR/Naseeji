import 'package:flutter/material.dart';
import 'package:naseeji_factory/core/theme/app_colors.dart';

class RecentSearchesSection extends StatelessWidget {
  const RecentSearchesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
                style: TextStyle(color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF0040E0), fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              'عمليات البحث الأخيرة',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...recentSearches.map((search) => _buildRecentSearchItem(context, search)),
      ],
    );
  }

  Widget _buildRecentSearchItem(BuildContext context, String text) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F3FD),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.history, color: isDark ? const Color(0xFF94A3B8) : AppColors.outline, size: 18),
          Text(
            text,
            style: TextStyle(fontSize: 13, color: isDark ? Colors.white : Theme.of(context).colorScheme.onSurface),
          ),
        ],
      ),
    );
  }
}


