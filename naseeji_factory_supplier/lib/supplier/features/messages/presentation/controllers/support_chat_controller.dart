import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/support_ticket.dart';
import '../../domain/entities/business_message.dart';
import '../../data/repositories/messages_repository_impl.dart';

part 'support_chat_controller.g.dart';

@riverpod
class SupportChatController extends _$SupportChatController {
  @override
  FutureOr<SupportTicket?> build(String ticketId) async {
    final repo = ref.watch(messagesRepositoryProvider);
    return repo.getSupportTicket(ticketId);
  }

  Future<void> sendMessage(String text) async {
    final ticket = state.valueOrNull;
    if (ticket == null) return;
    final newMsg = BusinessMessage(
      id: 'smsg_${DateTime.now().millisecondsSinceEpoch}',
      senderId: 'supplier',
      senderName: 'مورد نسيجي',
      senderAvatar: '',
      content: text,
      time: _formatTime(),
      isOutgoing: true,
      type: MessageType.text,
      readStatus: ReadStatus.sent,
    );
    state = AsyncValue.data(
      ticket.copyWith(
        messages: [...ticket.messages, newMsg],
        lastUpdated: 'الآن',
      ),
    );
  }

  Future<void> closeTicket() async {
    final ticket = state.valueOrNull;
    if (ticket == null) return;
    final repo = ref.read(messagesRepositoryProvider);
    await repo.closeTicket(ticket.ticketId);
    state = AsyncValue.data(ticket.copyWith(status: TicketStatus.closed));
  }

  Future<void> rateTicket(int rating) async {
    final ticket = state.valueOrNull;
    if (ticket == null) return;
    final repo = ref.read(messagesRepositoryProvider);
    await repo.rateTicket(ticket.ticketId, rating);
    state = AsyncValue.data(ticket.copyWith(ratingGiven: rating));
  }

  String _formatTime() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }
}



