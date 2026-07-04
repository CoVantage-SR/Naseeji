import 'package:flutter/material.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';

class AnalyticsFilterRow extends StatelessWidget {
  const AnalyticsFilterRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // PDF button
        ElevatedButton.icon(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0040E0),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            elevation: 0,
            minimumSize: const Size(60, 40),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          icon: const Icon(Icons.picture_as_pdf, size: 16),
          label: const Text('PDF', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(width: 8),
        // Excel button
        ElevatedButton.icon(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF006B5F),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            elevation: 0,
            minimumSize: const Size(60, 40),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          icon: const Icon(Icons.download, size: 16),
          label: const Text('Excel', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(width: 8),
        // Dropdown selector
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.5)),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.keyboard_arrow_down, color: AppColors.outline, size: 18),
                Text('هذا الشهر', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
