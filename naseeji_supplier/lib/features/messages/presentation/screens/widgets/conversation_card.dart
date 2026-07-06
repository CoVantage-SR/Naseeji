import 'package:flutter/material.dart';
import '../../../domain/entities/conversation.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';

class ConversationCard extends StatelessWidget {
  final Conversation conversation;
  final VoidCallback onTap;

  const ConversationCard({
    super.key,
    required this.conversation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasUnread = conversation.unreadCount > 0;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        color: hasUnread ? AppColors.primary.withValues(alpha: 0.03) : Colors.white,
        child: Row(
          children: [
            // Avatar + online badge
            Stack(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Color(conversation.companyLogoBgColorValue),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      conversation.companyLogoText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                if (conversation.isOnline)
                  Positioned(
                    bottom: 2,
                    right: 2,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Flexible(
                              child: Text(
                                conversation.companyName,
                                style: TextStyle(
                                  fontWeight: hasUnread ? FontWeight.bold : FontWeight.w600,
                                  fontSize: 14,
                                  color: AppColors.onSurface,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (conversation.isVerified)
                              const Padding(
                                padding: EdgeInsets.only(left: 4),
                                child: Icon(Icons.verified, size: 14, color: AppColors.primary),
                              ),
                            if (conversation.isMuted)
                              const Padding(
                                padding: EdgeInsets.only(left: 4),
                                child: Icon(Icons.volume_off, size: 13, color: AppColors.outline),
                              ),
                          ],
                        ),
                      ),
                      Text(
                        conversation.lastTime,
                        style: TextStyle(
                          fontSize: 11,
                          color: hasUnread ? AppColors.primary : AppColors.outline,
                          fontWeight: hasUnread ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  // RFQ / Order tags
                  if (conversation.rfqNumber != null || conversation.orderNumber != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          if (conversation.rfqNumber != null)
                            _TagChip(
                              label: conversation.rfqNumber!,
                              color: AppColors.primary,
                            ),
                          if (conversation.rfqNumber != null && conversation.orderNumber != null)
                            const SizedBox(width: 4),
                          if (conversation.orderNumber != null)
                            _TagChip(
                              label: conversation.orderNumber!,
                              color: AppColors.secondary,
                            ),
                          if (conversation.currentStatus != null)
                            Padding(
                              padding: const EdgeInsets.only(right: 6),
                              child: _StatusBadge(status: conversation.currentStatus!),
                            ),
                        ],
                      ),
                    ),
                  Row(
                    children: [
                      Expanded(
                        child: conversation.isTyping
                            ? const Text(
                                'يكتب...',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.secondary,
                                  fontStyle: FontStyle.italic,
                                ),
                              )
                            : Text(
                                conversation.lastMessage,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: hasUnread ? AppColors.onSurface : AppColors.outline,
                                  fontWeight: hasUnread ? FontWeight.w500 : FontWeight.normal,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                      ),
                      Row(
                        children: [
                          if (conversation.hasAttachment)
                            const Icon(Icons.attach_file, size: 13, color: AppColors.outline),
                          if (conversation.priority == MessagePriority.urgent)
                            const Padding(
                              padding: EdgeInsets.only(right: 4),
                              child: Icon(Icons.priority_high, size: 13, color: Colors.red),
                            ),
                          if (hasUnread)
                            Container(
                              margin: const EdgeInsets.only(right: 4),
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                conversation.unreadCount > 99 ? '99+' : '${conversation.unreadCount}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
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

class _TagChip extends StatelessWidget {
  final String label;
  final Color color;

  const _TagChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 9, color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Text(
        status,
        style: TextStyle(fontSize: 9, color: Colors.orange.shade800, fontWeight: FontWeight.w600),
      ),
    );
  }
}
