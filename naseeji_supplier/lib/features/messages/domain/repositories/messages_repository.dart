import '../entities/conversation.dart';
import '../entities/business_message.dart';
import '../entities/support_ticket.dart';
import '../entities/message_attachment.dart';

abstract class MessagesRepository {
  Future<List<Conversation>> getConversations();
  Future<List<BusinessMessage>> getMessages(String conversationId);
  Future<void> sendMessage(String conversationId, BusinessMessage message);
  Future<void> markAsRead(String conversationId);
  Future<void> pinConversation(String conversationId, bool pinned);
  Future<void> muteConversation(String conversationId, bool muted);
  Future<void> archiveConversation(String conversationId);
  Future<void> deleteConversation(String conversationId);
  Future<SupportTicket?> getSupportTicket(String ticketId);
  Future<void> closeTicket(String ticketId);
  Future<void> rateTicket(String ticketId, int rating);
  Future<List<MessageAttachment>> getAttachments(String conversationId);
  Future<List<BusinessMessage>> searchMessages(String conversationId, String query);
  Future<List<BusinessMessage>> getAllQuotationCards(String conversationId);
}
