import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/conversation.dart';
import '../../data/repositories/messages_repository_impl.dart';

part 'messages_controller.g.dart';

enum MessagesFilter { all, business, support, unread }

class MessagesViewState {
  final List<Conversation> conversations;
  final MessagesFilter activeFilter;

  const MessagesViewState({
    required this.conversations,
    required this.activeFilter,
  });

  List<Conversation> get pinned => conversations.where((c) => c.isPinned).toList();

  List<Conversation> get unpinned => conversations.where((c) => !c.isPinned).toList();

  int get unreadCount => conversations.fold(0, (sum, c) => sum + c.unreadCount);
}

@riverpod
class MessagesController extends _$MessagesController {
  @override
  FutureOr<MessagesViewState> build() async {
    final repo = ref.watch(messagesRepositoryProvider);
    final conversations = await repo.getConversations();
    return MessagesViewState(
      conversations: conversations,
      activeFilter: MessagesFilter.all,
    );
  }

  List<Conversation> filterConversations(
    List<Conversation> conversations,
    MessagesFilter filter,
    String searchQuery,
  ) {
    var result = conversations.where((c) => c.status != ConversationStatus.archived).toList();
    switch (filter) {
      case MessagesFilter.business:
        result = result.where((c) => c.type == ConversationType.business).toList();
        break;
      case MessagesFilter.support:
        result = result.where((c) => c.type == ConversationType.support).toList();
        break;
      case MessagesFilter.unread:
        result = result.where((c) => c.unreadCount > 0).toList();
        break;
      case MessagesFilter.all:
        break;
    }
    if (searchQuery.isNotEmpty) {
      final q = searchQuery.toLowerCase();
      result = result.where((c) =>
        c.companyName.contains(q) ||
        (c.rfqNumber?.toLowerCase().contains(q) ?? false) ||
        (c.orderNumber?.toLowerCase().contains(q) ?? false) ||
        c.lastMessage.contains(q)
      ).toList();
    }
    return result;
  }

  Future<void> markAsRead(String conversationId) async {
    final repo = ref.read(messagesRepositoryProvider);
    await repo.markAsRead(conversationId);
    ref.invalidateSelf();
  }

  Future<bool> pinConversation(String conversationId, bool pinned) async {
    if (pinned) {
      final current = state.valueOrNull?.conversations ?? [];
      final pinnedCount = current.where((c) => c.isPinned).length;
      if (pinnedCount >= 3) {
        return false; // Limit of 3 pinned chats reached
      }
    }
    final repo = ref.read(messagesRepositoryProvider);
    await repo.pinConversation(conversationId, pinned);
    ref.invalidateSelf();
    return true;
  }

  Future<void> muteConversation(String conversationId, bool muted) async {
    final repo = ref.read(messagesRepositoryProvider);
    await repo.muteConversation(conversationId, muted);
    ref.invalidateSelf();
  }

  Future<void> muteConversationForDuration(String conversationId, Duration? duration) async {
    final repo = ref.read(messagesRepositoryProvider);
    await repo.muteConversationForDuration(conversationId, duration);
    ref.invalidateSelf();
  }

  Future<void> blockUser(String conversationId, bool blocked) async {
    final repo = ref.read(messagesRepositoryProvider);
    await repo.blockUser(conversationId, blocked);
    ref.invalidateSelf();
  }

  Future<void> archiveConversation(String conversationId) async {
    // Optimistic update to remove it from the list (or set status)
    final current = state.valueOrNull;
    if (current != null) {
      state = AsyncData(MessagesViewState(
        conversations: current.conversations.where((c) => c.id != conversationId).toList(),
        activeFilter: current.activeFilter,
      ));
    }
    final repo = ref.read(messagesRepositoryProvider);
    await repo.archiveConversation(conversationId);
    ref.invalidateSelf();
  }

  Future<void> deleteConversation(String conversationId) async {
    // Optimistic update to immediately remove from UI
    final current = state.valueOrNull;
    if (current != null) {
      state = AsyncData(MessagesViewState(
        conversations: current.conversations.where((c) => c.id != conversationId).toList(),
        activeFilter: current.activeFilter,
      ));
    }
    final repo = ref.read(messagesRepositoryProvider);
    await repo.deleteConversation(conversationId);
    // Do not invalidate immediately, to let the UI settle
  }
}
