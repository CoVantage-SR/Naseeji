import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../../domain/entities/conversation.dart';
import '../controllers/business_chat_controller.dart';
import '../controllers/messages_controller.dart';
import 'widgets/chat_message_bubble.dart';
import 'widgets/order_status_banner.dart';
import 'widgets/business_chat_input.dart';

class BusinessChatScreen extends ConsumerStatefulWidget {
  final String conversationId;

  const BusinessChatScreen({super.key, required this.conversationId});

  @override
  ConsumerState<BusinessChatScreen> createState() => _BusinessChatScreenState();
}

class _BusinessChatScreenState extends ConsumerState<BusinessChatScreen> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Conversation? _conversation;

  @override
  void initState() {
    super.initState();
    _loadConversation();
  }

  void _loadConversation() {
    final stateAsync = ref.read(messagesControllerProvider);
    stateAsync.whenData((state) {
      final conv = state.conversations.where((c) => c.id == widget.conversationId).firstOrNull;
      if (mounted) setState(() => _conversation = conv);
    });
  }

  @override
  void dispose() {
    _inputController.dispose();
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

  @override
  Widget build(BuildContext context) {
    final messagesAsync = ref.watch(businessChatControllerProvider(widget.conversationId));
    final conv = _conversation;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.onSurface),
          onPressed: () => context.pop(),
        ),
        title: Row(
          children: [
            if (conv != null) ...[
              Stack(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Color(conv.companyLogoBgColorValue),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        conv.companyLogoText,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                  ),
                  if (conv.isOnline)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1.5),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            conv.companyName,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.onSurface),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (conv.isVerified)
                          const Padding(
                            padding: EdgeInsets.only(left: 4),
                            child: Icon(Icons.verified, size: 13, color: AppColors.primary),
                          ),
                      ],
                    ),
                    Row(
                      children: [
                        if (conv.isOnline)
                          const Text('متاح الآن', style: TextStyle(fontSize: 10, color: Colors.green))
                        else
                          const Text('غير متاح', style: TextStyle(fontSize: 10, color: AppColors.outline)),
                        if (conv.rfqNumber != null) ...[
                          const Text(' · ', style: TextStyle(color: AppColors.outline, fontSize: 10)),
                          Text(conv.rfqNumber!, style: const TextStyle(fontSize: 10, color: AppColors.primary)),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.onSurface, size: 20),
            onPressed: () => context.push('/messages/search'),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: AppColors.onSurface, size: 20),
            onPressed: () => _showMoreMenu(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Order status pipeline
          if (conv?.currentStatus != null)
            OrderStatusBanner(currentStage: conv!.currentStatus!),
          // Messages list
          Expanded(
            child: messagesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
              error: (e, _) => Center(child: Text('خطأ: $e')),
              data: (messages) {
                _scrollToBottom();
                if (messages.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.chat_bubble_outline, size: 64, color: AppColors.outlineVariant),
                        SizedBox(height: 12),
                        Text('لا توجد رسائل بعد', style: TextStyle(color: AppColors.outline)),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: messages.length,
                  itemBuilder: (_, i) {
                    final msg = messages[i];
                    return ChatMessageBubble(
                      message: msg,
                      onDelete: () {
                        ref.read(businessChatControllerProvider(widget.conversationId).notifier).deleteMessage(msg.id);
                      },
                      onReact: (emoji) {
                        ref.read(businessChatControllerProvider(widget.conversationId).notifier).addReaction(msg.id, emoji);
                      },
                    );
                  },
                );
              },
            ),
          ),
          // Input
          BusinessChatInput(
            controller: _inputController,
            quickReplies: const ['بالتوفيق', 'سيتم المعالجة', 'يتم المراجعة', 'تم الاستلام'],
            onQuickReply: (text) {
              ref.read(businessChatControllerProvider(widget.conversationId).notifier).sendQuickReply(text);
              _scrollToBottom();
            },
            onSend: () {
              final text = _inputController.text.trim();
              if (text.isNotEmpty) {
                ref.read(businessChatControllerProvider(widget.conversationId).notifier).sendTextMessage(text);
                _inputController.clear();
                _scrollToBottom();
              }
            },
          ),
        ],
      ),
    );
  }

  void _showMoreMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.outlineVariant, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 8),
            _MenuItem(icon: Icons.timeline_outlined, label: 'الخط الزمني', color: AppColors.primary, onTap: () { Navigator.pop(context); context.push('/messages/chat/${widget.conversationId}/timeline'); }),
            _MenuItem(icon: Icons.history_outlined, label: 'سجل العروض', color: AppColors.secondary, onTap: () { Navigator.pop(context); context.push('/messages/chat/${widget.conversationId}/quotation-history'); }),
            _MenuItem(icon: Icons.attach_file, label: 'الملفات والمرفقات', color: Colors.purple, onTap: () { Navigator.pop(context); context.push('/messages/chat/${widget.conversationId}/attachments'); }),
            _MenuItem(icon: Icons.search, label: 'بحث في المحادثة', color: AppColors.onSurfaceVariant, onTap: () { Navigator.pop(context); context.push('/messages/search'); }),
            _MenuItem(icon: Icons.volume_off_outlined, label: 'كتم الإشعارات', color: AppColors.outline, onTap: () => Navigator.pop(context)),
            _MenuItem(icon: Icons.flag_outlined, label: 'إبلاغ', color: Colors.red, onTap: () => Navigator.pop(context)),
          ],
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _MenuItem({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(label, textAlign: TextAlign.right, style: TextStyle(color: color == AppColors.outline ? AppColors.onSurface : color)),
      onTap: onTap,
    );
  }
}
