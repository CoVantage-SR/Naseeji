import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/reusable_widgets.dart';

class FileCardWidget extends StatelessWidget {
  final String fileName;
  final String size;
  final String date;
  final VoidCallback onView;

  const FileCardWidget({
    super.key,
    required this.fileName,
    required this.size,
    required this.date,
    required this.onView,
  });

  @override
  Widget build(BuildContext context) {
    return PrimaryCard(
      child: Row(
        children: [
          const Icon(Icons.insert_drive_file_outlined, color: AppColors.primary, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileName,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '$size • $date',
                  style: const TextStyle(color: Colors.grey, fontSize: 9),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.open_in_new_rounded, size: 18),
            onPressed: onView,
          ),
        ],
      ),
    );
  }
}
