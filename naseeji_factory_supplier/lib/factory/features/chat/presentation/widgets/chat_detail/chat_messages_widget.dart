import 'package:flutter/material.dart';
import '../../providers/chat_provider.dart';
import '../chat_detail_widgets.dart';

class ChatMessagesWidget extends StatelessWidget {
  final ScrollController scrollController;
  final List<Message> messages;
  final Function(Message) onEditQuotation;
  final VoidCallback onAcceptQuotation;
  final VoidCallback onRejectQuotation;

  const ChatMessagesWidget({
    super.key,
    required this.scrollController,
    required this.messages,
    required this.onEditQuotation,
    required this.onAcceptQuotation,
    required this.onRejectQuotation,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final msg = messages[index];
        return MessageBubbleWidget(
          message: msg,
          onAcceptQuotation: onAcceptQuotation,
          onRejectQuotation: onRejectQuotation,
          onEditQuotation: () => onEditQuotation(msg),
        );
      },
    );
  }
}



