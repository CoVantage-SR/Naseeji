import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:naseeji_factory/core/mock/mock_data.dart';
import '../../domain/entities/conversation.dart';
import '../../domain/entities/business_message.dart';
import '../../domain/entities/support_ticket.dart';
import '../../domain/entities/message_attachment.dart';
import '../../domain/entities/timeline_stage.dart';
import '../../domain/repositories/messages_repository.dart';

part 'messages_repository_impl.g.dart';

@riverpod
MessagesRepository messagesRepository(MessagesRepositoryRef ref) {
  return MessagesRepositoryImpl();
}

class MessagesRepositoryImpl implements MessagesRepository {
  @override
  Future<List<Conversation>> getConversations() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return MockDatabase.getConversationsDomain();
  }

  @override
  Future<List<BusinessMessage>> getMessages(String conversationId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final ws = MockDatabase.getDealWorkspace(conversationId);
    return ws.messages;
  }

  @override
  Future<void> sendMessage(String conversationId, BusinessMessage message) async {
    MockDatabase.addMessage(
      dealId: conversationId,
      text: message.content,
      senderId: message.senderId,
      senderName: message.senderName,
      isMe: message.isOutgoing,
    );
  }

  @override
  Future<void> markAsRead(String conversationId) async {
    final idx = MockDatabase.chats.indexWhere((c) => c.id == conversationId || c.dealId == conversationId);
    if (idx != -1) {
      final old = MockDatabase.chats[idx];
      MockDatabase.chats[idx] = old;
    }
  }

  @override
  Future<void> pinConversation(String conversationId, bool pinned) async {}

  @override
  Future<void> muteConversation(String conversationId, bool muted) async {}

  @override
  Future<void> archiveConversation(String conversationId) async {}

  @override
  Future<void> restoreConversation(String conversationId) async {}

  @override
  Future<void> deleteConversation(String conversationId) async {
    MockDatabase.chats.removeWhere((c) => c.id == conversationId || c.dealId == conversationId);
  }

  @override
  Future<SupportTicket?> getSupportTicket(String ticketId) async {
    return null;
  }

  @override
  Future<void> closeTicket(String ticketId) async {}

  @override
  Future<void> rateTicket(String ticketId, int rating) async {}

  @override
  Future<List<MessageAttachment>> getAttachments(String conversationId) async {
    return [];
  }

  @override
  Future<List<BusinessMessage>> searchMessages(String conversationId, String query) async {
    final ws = MockDatabase.getDealWorkspace(conversationId);
    final q = query.toLowerCase();
    return ws.messages.where((m) => m.text.toLowerCase().contains(q)).toList();
  }

  @override
  Future<List<BusinessMessage>> getAllQuotationCards(String conversationId) async {
    return [];
  }

  @override
  Future<void> blockUser(String conversationId, bool blocked) async {}

  @override
  Future<void> muteConversationForDuration(String conversationId, Duration? duration) async {}

  @override
  Future<List<TimelineStage>> getTimelineStages(String conversationId) async {
    final ws = MockDatabase.getDealWorkspace(conversationId);
    return ws.timeline.steps
        .map((s) => TimelineStage(
              label: s.title,
              icon: Icons.check_circle_outline,
              timestamp: '2026-07-23',
              user: 'مستثمر / مورد',
              notes: s.subtitle,
              isCompleted: s.isCompleted,
              isActive: s.isCurrent,
            ))
        .toList();
  }

  @override
  Future<void> updateTimelineStage(
    String conversationId,
    String stageLabel, {
    required String timestamp,
    required String user,
    String? notes,
    bool? isActive,
    bool? isCompleted,
  }) async {}
}


