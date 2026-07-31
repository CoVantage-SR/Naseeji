import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/reusable_widgets.dart';
import '../providers/chat_provider.dart';

class ArchivedConversationCardWidget extends StatelessWidget {
  final Conversation conversation;
  final VoidCallback onUnarchive;
  final VoidCallback onDelete;

  const ArchivedConversationCardWidget({
    super.key,
    required this.conversation,
    required this.onUnarchive,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return PrimaryCard(
      child: Row(
        children: [
          SupplierAvatar(name: conversation.supplierName, size: 40),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  conversation.supplierName,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                Text(
                  'آخر رسالة: ${conversation.lastMessage}',
                  style: const TextStyle(color: Colors.grey, fontSize: 10),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.unarchive_rounded, color: AppColors.primary, size: 18),
            tooltip: 'إلغاء الأرشفة',
            onPressed: onUnarchive,
          ),
          IconButton(
            icon: const Icon(Icons.delete_forever_rounded, color: AppColors.error, size: 18),
            tooltip: 'حذف نهائي',
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}

