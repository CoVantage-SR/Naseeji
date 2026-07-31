import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/reusable_widgets.dart';
import '../providers/chat_provider.dart';

/// 1. ConversationCardWidget
class ConversationCardWidget extends StatelessWidget {
  final Conversation conversation;
  final VoidCallback onTap;
  final VoidCallback onPinToggle;
  final VoidCallback onMuteToggle;
  final VoidCallback onArchiveToggle;
  final VoidCallback onDelete;

  const ConversationCardWidget({
    super.key,
    required this.conversation,
    required this.onTap,
    required this.onPinToggle,
    required this.onMuteToggle,
    required this.onArchiveToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;

    Color statusColor;
    String statusText;
    switch (conversation.negotiationStatus) {
      case 'agreed':
        statusColor = AppColors.success;
        statusText = 'تم الاتفاق وعقد الصفقة';
        break;
      case 'rejected':
        statusColor = AppColors.error;
        statusText = 'مرفوض / مغلق';
        break;
      case 'negotiating':
        statusColor = AppColors.secondary;
        statusText = 'جولة تفاوض نشطة';
        break;
      case 'open':
      default:
        statusColor = AppColors.info;
        statusText = 'تواصل أولي';
        break;
    }

    return Dismissible(
      key: Key('conv_dismiss_${conversation.id}'),
      background: Container(
        color: AppColors.primary,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(conversation.isPinned ? Icons.pin_drop_rounded : Icons.pin_invoke_rounded, color: Colors.white),
            const SizedBox(width: 8),
            Text(conversation.isPinned ? 'إلغاء التثبيت' : 'تثبيت المحادثة', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
          ],
        ),
      ),
      secondaryBackground: Container(
        color: AppColors.error,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.centerLeft,
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('حذف', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
            SizedBox(width: 8),
            Icon(Icons.delete_forever_rounded, color: Colors.white),
          ],
        ),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          onPinToggle();
          return false;
        } else if (direction == DismissDirection.endToStart) {
          onDelete();
          return true;
        }
        return false;
      },
      child: PrimaryCard(
        onTap: onTap,
        color: conversation.isPinned
            ? AppColors.primary.withValues(alpha: isDark ? 0.04 : 0.02)
            : null,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                SupplierAvatar(name: conversation.supplierName, size: 48),
                if (conversation.isVerified)
                  const Positioned(
                    bottom: -2,
                    left: -2,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 8,
                      child: Icon(Icons.verified_rounded, color: AppColors.success, size: 14),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          conversation.supplierName,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        conversation.lastMessageTime,
                        style: const TextStyle(fontSize: 9, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          conversation.lastMessage,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11,
                            color: conversation.unreadCount > 0
                                ? context.colorScheme.onSurface
                                : Colors.grey,
                            fontWeight: conversation.unreadCount > 0
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (conversation.lastNegotiatedPrice > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.1),
                            borderRadius: AppRadius.rRound,
                          ),
                          child: Text(
                            '${conversation.lastNegotiatedPrice.toInt()} ج.م',
                            style: TextStyle(
                              color: statusColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 9,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'حالة التفاوض: $statusText',
                        style: TextStyle(fontSize: 9, color: statusColor, fontWeight: FontWeight.w600),
                      ),
                      Row(
                        children: [
                          if (conversation.isMuted)
                            const Icon(Icons.volume_off_rounded, color: Colors.grey, size: 14),
                          if (conversation.isPinned) ...[
                            if (conversation.isMuted) const SizedBox(width: 4),
                            const Icon(Icons.push_pin_rounded, color: AppColors.primary, size: 14),
                          ],
                          if (conversation.unreadCount > 0) ...[
                            if (conversation.isMuted || conversation.isPinned) const SizedBox(width: 6),
                            UnreadBadgeWidget(count: conversation.unreadCount),
                          ],
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 2. UnreadBadgeWidget
class UnreadBadgeWidget extends StatelessWidget {
  final int count;

  const UnreadBadgeWidget({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: const BoxDecoration(
        color: AppColors.error,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        count.toString(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 8,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}



