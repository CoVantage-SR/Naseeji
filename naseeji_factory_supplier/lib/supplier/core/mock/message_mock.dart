import '../../features/messages/domain/entities/business_message.dart';

class MessageMock {
  final String id;
  final String dealId;
  final String senderId;
  final String senderName;
  final String text;
  final DateTime timestamp;
  final bool isMe;
  final bool isSystemNotification;

  const MessageMock({
    required this.id,
    required this.dealId,
    required this.senderId,
    required this.senderName,
    required this.text,
    required this.timestamp,
    required this.isMe,
    this.isSystemNotification = false,
  });

  BusinessMessage toDomain() {
    return BusinessMessage.create(
      id: id,
      senderId: senderId,
      senderName: senderName,
      text: text,
      timestamp: timestamp,
      isMe: isMe,
      isSystemNotification: isSystemNotification,
    );
  }

  static final sampleMessages = [
    MessageMock(
      id: 'msg-sys-0',
      dealId: 'DEAL-101',
      senderId: 'system',
      senderName: 'النظام',
      text: 'تم إنشاء الصفقة تلقائياً بناءً على طلب عرض السعر RFQ-1025',
      timestamp: DateTime.now().subtract(const Duration(hours: 6)),
      isMe: false,
      isSystemNotification: true,
    ),
    MessageMock(
      id: 'msg-1',
      dealId: 'DEAL-101',
      senderId: 'factory-1',
      senderName: 'شركة النسيج الحديثة',
      text: 'السلام عليكم، استلمنا مواصفات خيوط غزل القطن الممشط ونرغب في طلب 10,000 كجم.',
      timestamp: DateTime.now().subtract(const Duration(hours: 5, minutes: 30)),
      isMe: false,
    ),
    MessageMock(
      id: 'msg-sys-1',
      dealId: 'DEAL-101',
      senderId: 'system',
      senderName: 'النظام',
      text: 'تم إرسال عرض السعر الإصدار رقم 1 (Version 1) بقيمة 450,000 ج.م',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      isMe: false,
      isSystemNotification: true,
    ),
    MessageMock(
      id: 'msg-sys-2',
      dealId: 'DEAL-101',
      senderId: 'system',
      senderName: 'النظام',
      text: 'طلب المصنع تعديل العرض (السعر وميعاد التسليم)',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      isMe: false,
      isSystemNotification: true,
    ),
    MessageMock(
      id: 'msg-sys-3',
      dealId: 'DEAL-101',
      senderId: 'system',
      senderName: 'النظام',
      text: 'تم تعديل العرض وإرسال الإصدار رقم 2 (Version 2) بقيمة 430,000 ج.م',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      isMe: false,
      isSystemNotification: true,
    ),
    MessageMock(
      id: 'msg-3',
      dealId: 'DEAL-101',
      senderId: 'factory-1',
      senderName: 'شركة النسيج الحديثة',
      text: 'العرض الجديد مناسب جداً، جاري اعتماده والموافقة للبدء في إجراءات العقد 🟢',
      timestamp: DateTime.now().subtract(const Duration(minutes: 25)),
      isMe: false,
    ),
  ];
}



