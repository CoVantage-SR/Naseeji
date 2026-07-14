import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/reusable_widgets.dart';
import '../providers/chat_provider.dart';
import '../widgets/chat_detail_widgets.dart';
import 'send_quotation_sheet.dart';
import 'edit_quotation_sheet.dart';

class ChatDetailScreen extends ConsumerStatefulWidget {
  final String conversationId;

  const ChatDetailScreen({super.key, required this.conversationId});

  @override
  ConsumerState<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends ConsumerState<ChatDetailScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isNotEmpty) {
      ref.read(messagesNotifierProvider.notifier).sendMessage(
            widget.conversationId,
            text,
          );
      _messageController.clear();
      _scrollToBottom();
    }
  }

  void _showAttachmentMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.rLG),
      builder: (context) {
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
                            widget.conversationId,
                            'تم إرسال صورة من الكاميرا.',
                            type: 'image',
                          );
                    }),
                    _buildAttachmentItem(context, Icons.photo_library_rounded, 'المعرض', () {
                      Navigator.pop(context);
                      ref.read(messagesNotifierProvider.notifier).sendMessage(
                            widget.conversationId,
                            'تم إرسال صورة من المعرض.',
                            type: 'image',
                          );
                    }),
                    _buildAttachmentItem(context, Icons.insert_drive_file_rounded, 'مستند PDF', () {
                      Navigator.pop(context);
                      ref.read(messagesNotifierProvider.notifier).sendMessage(
                            widget.conversationId,
                            'المواصفات_الفنية_النهائية.pdf',
                            type: 'pdf',
                          );
                    }),
                    _buildAttachmentItem(context, Icons.request_quote_rounded, 'عرض سعر', () {
                      Navigator.pop(context);
                      _openSendQuotationSheet(context);
                    }),
                  ],
                ),
              ],
            ),
          ),
        );
      },
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

  void _openSendQuotationSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.rLG),
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SendQuotationSheet(conversationId: widget.conversationId),
      ),
    ).then((_) => _scrollToBottom());
  }

  void _openEditQuotationSheet(BuildContext context, Message quoteMsg) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.rLG),
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: EditQuotationSheet(
          conversationId: widget.conversationId,
          quoteMessage: quoteMsg,
        ),
      ),
    ).then((_) => _scrollToBottom());
  }

  @override
  Widget build(BuildContext context) {
    final conversation = ref.watch(chatNotifierProvider.notifier).getConversationById(widget.conversationId);
    final messages = ref.watch(messagesNotifierProvider)[widget.conversationId] ?? [];

    if (conversation == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('المحادثة غير موجودة.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SupplierAvatar(name: conversation.supplierName, size: 36),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          conversation.supplierName,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (conversation.isVerified) ...[
                        const SizedBox(width: 2),
                        const Icon(Icons.verified_rounded, color: AppColors.success, size: 12),
                      ],
                    ],
                  ),
                  const Text('نشط الآن', style: TextStyle(color: AppColors.success, fontSize: 8)),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline_rounded),
            onPressed: () => context.push('/chat/${conversation.id}/summary'),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/chat/${conversation.id}/settings'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            OrderStatusCardWidget(conversation: conversation),
            NegotiationTimelineWidget(
              status: conversation.negotiationStatus,
              hasOrderId: conversation.orderId != null,
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final msg = messages[index];
                  return MessageBubbleWidget(
                    message: msg,
                    onAcceptQuotation: () {
                      context.push('/rfq/quotation/QTE-101/approve');
                    },
                    onRejectQuotation: () {
                      context.push('/rfq/quotation/QTE-101/reject');
                    },
                    onEditQuotation: () {
                      _openEditQuotationSheet(context, msg);
                    },
                  );
                },
              ),
            ),
            // Bottom composer
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                border: const Border(top: BorderSide(color: Colors.grey, width: 0.2)),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline_rounded, color: AppColors.primary),
                    onPressed: () => _showAttachmentMenu(context),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? AppColors.borderDark
                            : Colors.grey.shade100,
                        borderRadius: AppRadius.rLG,
                      ),
                      child: TextField(
                        controller: _messageController,
                        maxLines: null,
                        decoration: const InputDecoration(
                          hintText: 'اكتب رسالة هنا للاتفاق والمفاوضة...',
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    icon: const Icon(Icons.send_rounded, color: AppColors.primary),
                    onPressed: _sendMessage,
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
