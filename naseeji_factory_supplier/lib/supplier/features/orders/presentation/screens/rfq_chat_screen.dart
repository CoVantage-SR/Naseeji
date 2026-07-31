import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naseeji_factory/core/theme/app_colors.dart';
import '../controllers/rfq_chat_controller.dart';
import 'widgets/rfq_chat_widgets.dart';

class RfqChatScreen extends ConsumerStatefulWidget {
  final String rfqId;

  const RfqChatScreen({super.key, required this.rfqId});

  @override
  ConsumerState<RfqChatScreen> createState() => _RfqChatScreenState();
}

class _RfqChatScreenState extends ConsumerState<RfqChatScreen> {
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _handleSendMessage() {
    final text = _messageController.text.trim();
    if (text.isNotEmpty) {
      ref.read(rfqChatControllerProvider(widget.rfqId).notifier).sendMessage(text);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final messagesAsync = ref.watch(rfqChatControllerProvider(widget.rfqId));

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: const ChatAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          RfqChatInfoBar(rfqId: widget.rfqId),
          Expanded(
            child: messagesAsync.when(
              loading: () => Center(child: CircularProgressIndicator(color: AppColors.primary)),
              error: (err, stack) => Center(child: Text('خطأ: $err')),
              data: (messages) {
                return ChatMessagesList(messages: messages, rfqId: widget.rfqId);
              },
            ),
          ),
          Container(
            color: Theme.of(context).colorScheme.surface,
            padding: const EdgeInsets.only(top: 8, bottom: 12),
            child: Column(
              children: [
                SuggestedRepliesBar(
                  replies: const ['عرض السعر الجديد', 'متوفر الآن', 'تم التعديل'],
                  onReplyTap: (replyText) {
                    ref.read(rfqChatControllerProvider(widget.rfqId).notifier).sendMessage(replyText);
                  },
                ),
                SizedBox(height: 8),
                ChatInputField(
                  controller: _messageController,
                  onSend: _handleSendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



