import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naseeji_factory/core/constants/app_colors.dart';
import 'package:naseeji_factory/core/constants/app_radius.dart';
import '../../providers/chat_provider.dart';

class AttachmentMenuWidget extends ConsumerWidget {
  final String conversationId;
  final VoidCallback onSendQuotationTap;

  const AttachmentMenuWidget({
    super.key,
    required this.conversationId,
    required this.onSendQuotationTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'إرفاق ملف أو مستند',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildAttachmentItem(context, Icons.camera_alt_rounded, 'كاميرا', () {
                  Navigator.pop(context);
                  ref.read(messagesNotifierProvider.notifier).sendMessage(
                        conversationId,
                        'تم إرسال صورة من الكاميرا.',
                        type: 'image',
                      );
                }),
                _buildAttachmentItem(context, Icons.photo_library_rounded, 'المعرض', () {
                  Navigator.pop(context);
                  ref.read(messagesNotifierProvider.notifier).sendMessage(
                        conversationId,
                        'تم إرسال صورة من المعرض.',
                        type: 'image',
                      );
                }),
                _buildAttachmentItem(context, Icons.insert_drive_file_rounded, 'مستند PDF', () {
                  Navigator.pop(context);
                  ref.read(messagesNotifierProvider.notifier).sendMessage(
                        conversationId,
                        'المواصفات_الفنية_النهائية.pdf',
                        type: 'pdf',
                      );
                }),
                _buildAttachmentItem(context, Icons.request_quote_rounded, 'عرض سعر', () {
                  Navigator.pop(context);
                  onSendQuotationTap();
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentItem(BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.rMD,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}


