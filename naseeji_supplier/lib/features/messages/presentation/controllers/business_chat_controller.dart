import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/business_message.dart';
import '../../data/repositories/messages_repository_impl.dart';

part 'business_chat_controller.g.dart';

@riverpod
class BusinessChatController extends _$BusinessChatController {
  @override
  FutureOr<List<BusinessMessage>> build(String conversationId) async {
    final repo = ref.watch(messagesRepositoryProvider);
    await repo.markAsRead(conversationId);
    return repo.getMessages(conversationId);
  }

  Future<void> sendTextMessage(String text) async {
    final currentMessages = state.valueOrNull ?? [];
    final newMsg = BusinessMessage(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      senderId: 'supplier',
      senderName: 'مورد نسيجي',
      senderAvatar: '',
      content: text,
      time: _formatTime(),
      isOutgoing: true,
      type: MessageType.text,
      readStatus: ReadStatus.sent,
    );
    state = AsyncValue.data([...currentMessages, newMsg]);
    final repo = ref.read(messagesRepositoryProvider);
    await repo.sendMessage(conversationId, newMsg);
  }

  Future<void> sendQuickReply(String text) => sendTextMessage(text);

  Future<void> addReaction(String messageId, String emoji) {
    final currentMessages = state.valueOrNull ?? [];
    state = AsyncValue.data(
      currentMessages.map((m) => m.id == messageId ? m.copyWith(reaction: emoji) : m).toList(),
    );
    return Future.value();
  }

  Future<void> deleteMessage(String messageId) {
    final currentMessages = state.valueOrNull ?? [];
    state = AsyncValue.data(
      currentMessages.map((m) => m.id == messageId ? m.copyWith(isDeleted: true) : m).toList(),
    );
    return Future.value();
  }

  String _formatTime() {
    final now = DateTime.now();
    final h = now.hour.toString().padLeft(2, '0');
    final m = now.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}
