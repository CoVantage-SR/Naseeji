import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/widgets/reusable_widgets.dart';
import '../providers/chat_provider.dart';
import '../widgets/chat_detail/attachment_menu_widget.dart';
import '../widgets/chat_detail/chat_messages_widget.dart';
import '../widgets/chat_detail/message_input_widget.dart';
import '../widgets/chat_detail_widgets.dart';
import 'edit_quotation_sheet.dart';
import 'send_quotation_sheet.dart';

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
        return AttachmentMenuWidget(
          conversationId: widget.conversationId,
          onSendQuotationTap: () => _openSendQuotationSheet(context),
        );
      },
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
              child: ChatMessagesWidget(
                scrollController: _scrollController,
                messages: messages,
                onEditQuotation: (msg) => _openEditQuotationSheet(context, msg),
                onAcceptQuotation: () => context.push('/rfq/quotation/QTE-101/approve'),
                onRejectQuotation: () => context.push('/rfq/quotation/QTE-101/reject'),
              ),
            ),
            MessageInputWidget(
              controller: _messageController,
              onSend: _sendMessage,
              onAttachmentTap: () => _showAttachmentMenu(context),
            ),
          ],
        ),
      ),
    );
  }
}
