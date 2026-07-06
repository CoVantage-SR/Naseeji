import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/chat_message.dart';
import '../../data/repositories/orders_repository_impl.dart';

part 'rfq_chat_controller.g.dart';

@riverpod
class RfqChatController extends _$RfqChatController {
  @override
  FutureOr<List<ChatMessage>> build(String rfqId) async {
    final repo = ref.watch(ordersRepositoryProvider);
    return repo.getChatMessages(rfqId);
  }

  void sendMessage(String text) {
    final currentVal = state.valueOrNull ?? [];
    final newMessage = ChatMessage(
      senderName: 'مورد نسيجي',
      senderAvatar: '',
      content: text,
      time: 'الآن',
      isOutgoing: true,
    );
    state = AsyncValue.data([...currentVal, newMessage]);
  }
}
