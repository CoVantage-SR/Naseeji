import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../../domain/entities/support_ticket.dart';
import '../controllers/support_chat_controller.dart';
import 'widgets/chat_message_bubble.dart';
import 'widgets/business_chat_input.dart';

class SupportChatScreen extends ConsumerStatefulWidget {
  final String ticketId;

  const SupportChatScreen({super.key, required this.ticketId});

  @override
  ConsumerState<SupportChatScreen> createState() => _SupportChatScreenState();
}

class _SupportChatScreenState extends ConsumerState<SupportChatScreen> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  int _pendingRating = 0;

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
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ticketAsync = ref.watch(supportChatControllerProvider(widget.ticketId));

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.onSurface),
          onPressed: () => context.pop(),
        ),
        title: Text('دعم نسيجي', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Theme.of(context).colorScheme.onSurface)),
        centerTitle: true,
      ),
      body: ticketAsync.when(
        loading: () => Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (e, _) => Center(child: Text('خطأ: $e')),
        data: (ticket) {
          if (ticket == null) {
            return Center(child: Text('لم يتم العثور على التذكرة'));
          }
          _scrollToBottom();
          return Column(
            children: [
              _TicketHeader(ticket: ticket),
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: ticket.messages.length,
                  itemBuilder: (_, i) => ChatMessageBubble(message: ticket.messages[i]),
                ),
              ),
              // Rating & close row (for open tickets)
              if (ticket.status != TicketStatus.closed)
                _ActionBar(
                  ticket: ticket,
                  pendingRating: _pendingRating,
                  onRatingChanged: (r) => setState(() => _pendingRating = r),
                  onClose: () async {
                    await ref.read(supportChatControllerProvider(widget.ticketId).notifier).closeTicket();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('تم إغلاق التذكرة'), backgroundColor: AppColors.secondary),
                      );
                    }
                  },
                  onRate: (rating) {
                    ref.read(supportChatControllerProvider(widget.ticketId).notifier).rateTicket(rating);
                  },
                ),
              BusinessChatInput(
                controller: _inputController,
                quickReplies: const ['شكراً', 'تم الفهم', 'هل تحتاج مزيداً من المعلومات؟'],
                onQuickReply: (text) {
                  ref.read(supportChatControllerProvider(widget.ticketId).notifier).sendMessage(text);
                  _scrollToBottom();
                },
                onSend: () {
                  final text = _inputController.text.trim();
                  if (text.isNotEmpty) {
                    ref.read(supportChatControllerProvider(widget.ticketId).notifier).sendMessage(text);
                    _inputController.clear();
                    _scrollToBottom();
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class _TicketHeader extends StatelessWidget {
  final SupportTicket ticket;
  const _TicketHeader({required this.ticket});

  Color get _priorityColor {
    switch (ticket.priority) {
      case TicketPriority.urgent: return Colors.red;
      case TicketPriority.high: return Colors.orange;
      case TicketPriority.medium: return Colors.amber;
      case TicketPriority.low: return AppColors.secondary;
    }
  }

  Color get _statusColor {
    switch (ticket.status) {
      case TicketStatus.open: return AppColors.primary;
      case TicketStatus.inProgress: return Colors.orange;
      case TicketStatus.resolved: return AppColors.secondary;
      case TicketStatus.closed: return AppColors.outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              // Status & Priority badges
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(ticket.statusLabel, style: TextStyle(fontSize: 11, color: _statusColor, fontWeight: FontWeight.bold)),
              ),
              SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _priorityColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(ticket.priorityLabel, style: TextStyle(fontSize: 11, color: _priorityColor, fontWeight: FontWeight.bold)),
              ),
              const Spacer(),
              // Agent
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(ticket.agentName, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                      Text('وكيل الدعم', style: TextStyle(fontSize: 10, color: AppColors.outline)),
                    ],
                  ),
                  SizedBox(width: 8),
                  const CircleAvatar(radius: 18, backgroundColor: AppColors.primary, child: Icon(Icons.headset_mic, color: Theme.of(context).colorScheme.surface, size: 16)),
                ],
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(ticket.lastUpdated, style: TextStyle(fontSize: 10, color: AppColors.outline)),
              Row(
                children: [
                  Text(
                    ticket.subject,
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                  ),
                  SizedBox(width: 8),
                  Text(
                    ticket.ticketId,
                    style: TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Icon(Icons.category_outlined, size: 12, color: AppColors.outline),
              SizedBox(width: 4),
              Text(ticket.categoryLabel, style: TextStyle(fontSize: 11, color: AppColors.outline)),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionBar extends StatelessWidget {
  final SupportTicket ticket;
  final int pendingRating;
  final Function(int) onRatingChanged;
  final VoidCallback onClose;
  final Function(int) onRate;

  const _ActionBar({
    required this.ticket,
    required this.pendingRating,
    required this.onRatingChanged,
    required this.onClose,
    required this.onRate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          // Rating stars
          Row(
            children: List.generate(5, (i) => GestureDetector(
              onTap: () {
                onRatingChanged(i + 1);
                onRate(i + 1);
              },
              child: Icon(
                i < pendingRating ? Icons.star : Icons.star_border,
                color: Colors.amber,
                size: 22,
              ),
            )),
          ),
          const Spacer(),
          // Close ticket
          SizedBox(
            height: 36,
            child: OutlinedButton.icon(
              onPressed: onClose,
              icon: const Icon(Icons.check_circle_outline, size: 16),
              label: Text('إغلاق التذكرة', style: TextStyle(fontSize: 12)),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.secondary,
                side: const BorderSide(color: AppColors.secondary),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
