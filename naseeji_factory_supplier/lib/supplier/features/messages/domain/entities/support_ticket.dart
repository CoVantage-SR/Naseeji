import 'business_message.dart';

enum TicketPriority { low, medium, high, urgent }
enum TicketStatus { open, inProgress, resolved, closed }
enum TicketCategory { orders, payments, shipping, quality, technical, other }

class SupportTicket {
  final String ticketId;
  final String subject;
  final TicketCategory category;
  final TicketPriority priority;
  final TicketStatus status;
  final String agentName;
  final String agentAvatar;
  final String createdAt;
  final String lastUpdated;
  final List<BusinessMessage> messages;
  final int? ratingGiven;

  const SupportTicket({
    required this.ticketId,
    required this.subject,
    required this.category,
    required this.priority,
    required this.status,
    required this.agentName,
    required this.agentAvatar,
    required this.createdAt,
    required this.lastUpdated,
    required this.messages,
    this.ratingGiven,
  });

  String get categoryLabel {
    switch (category) {
      case TicketCategory.orders:    return 'الطلبات';
      case TicketCategory.payments:  return 'المدفوعات';
      case TicketCategory.shipping:  return 'الشحن';
      case TicketCategory.quality:   return 'الجودة';
      case TicketCategory.technical: return 'الدعم التقني';
      case TicketCategory.other:     return 'أخرى';
    }
  }

  String get priorityLabel {
    switch (priority) {
      case TicketPriority.low:    return 'منخفض';
      case TicketPriority.medium: return 'متوسط';
      case TicketPriority.high:   return 'عالي';
      case TicketPriority.urgent: return 'عاجل';
    }
  }

  String get statusLabel {
    switch (status) {
      case TicketStatus.open:       return 'مفتوح';
      case TicketStatus.inProgress: return 'جاري المعالجة';
      case TicketStatus.resolved:   return 'تم الحل';
      case TicketStatus.closed:     return 'مغلق';
    }
  }

  SupportTicket copyWith({
    TicketStatus? status,
    int? ratingGiven,
    List<BusinessMessage>? messages,
    String? lastUpdated,
  }) {
    return SupportTicket(
      ticketId: ticketId,
      subject: subject,
      category: category,
      priority: priority,
      status: status ?? this.status,
      agentName: agentName,
      agentAvatar: agentAvatar,
      createdAt: createdAt,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      messages: messages ?? this.messages,
      ratingGiven: ratingGiven ?? this.ratingGiven,
    );
  }
}

