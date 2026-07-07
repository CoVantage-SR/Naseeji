import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/business_message.dart';
import '../../data/repositories/messages_repository_impl.dart';
import '../../../orders/data/repositories/orders_repository_impl.dart';
import '../../../orders/domain/entities/activity_log.dart';

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

  Future<void> sendQuotationCard({
    required String productName,
    required String quantity,
    required String unitPrice,
    required String totalPrice,
    required String deliveryTime,
    required String paymentMethod,
    required String expiration,
  }) async {
    final currentMessages = state.valueOrNull ?? [];
    final newMsg = BusinessMessage(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      senderId: 'supplier',
      senderName: 'مورد نسيجي',
      senderAvatar: '',
      content: 'تم تقديم عرض سعر رسمي للمصنع بقيمة $totalPrice ر.س',
      time: _formatTime(),
      isOutgoing: true,
      type: MessageType.quotationCard,
      readStatus: ReadStatus.sent,
      cardData: {
        'productName': productName,
        'quantity': quantity,
        'unitPrice': unitPrice,
        'totalPrice': totalPrice,
        'deliveryDays': deliveryTime,
        'paymentTerms': paymentMethod,
        'validUntil': expiration,
        'status': 'pending',
        'version': 'V1',
      },
    );
    state = AsyncValue.data([...currentMessages, newMsg]);

    final repo = ref.read(messagesRepositoryProvider);
    await repo.sendMessage(conversationId, newMsg);

    // Update the timeline stages
    await repo.updateTimelineStage(
      conversationId,
      'تقديم عرض أسعار',
      timestamp: _formatFullTime(),
      user: 'مورد نسيجي',
      notes: 'تقديم عرض أسعار رسمي بقيمة $totalPrice ر.س لـ $productName',
      isCompleted: true,
      isActive: false,
    );
    await repo.updateTimelineStage(
      conversationId,
      'عرض مضاد',
      timestamp: '--',
      user: '--',
      isActive: true,
    );

    // Update Activity Log
    final ordersRepo = ref.read(ordersRepositoryProvider);
    final rfqId = _getRfqIdFromConvId(conversationId);
    await ordersRepo.addActivityLogItem(
      rfqId,
      ActivityLogItem(
        iconTag: 'verified',
        user: 'مورد نسيجي',
        action: 'تقديم عرض أسعار رسمي بقيمة $totalPrice ر.س لـ $productName',
        date: _formatDate(),
        time: _formatTimeLabel(),
        device: 'تطبيق الجوال',
        status: 'مكتمل',
      ),
    );
  }

  Future<void> sendCounterOfferCard({
    required String counterPrice,
    required String currentPrice,
    required String reason,
  }) async {
    final currentMessages = state.valueOrNull ?? [];
    final newMsg = BusinessMessage(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      senderId: 'factory_001',
      senderName: 'مصنع المشتري',
      senderAvatar: '',
      content: 'تقديم عرض مضاد بقيمة $counterPrice ر.س',
      time: _formatTime(),
      isOutgoing: false,
      type: MessageType.counterOfferCard,
      readStatus: ReadStatus.sent,
      cardData: {
        'counterPrice': counterPrice,
        'currentPrice': currentPrice,
        'reason': reason,
        'status': 'pending',
      },
    );
    state = AsyncValue.data([...currentMessages, newMsg]);

    final repo = ref.read(messagesRepositoryProvider);
    await repo.sendMessage(conversationId, newMsg);

    // Update timeline stage
    await repo.updateTimelineStage(
      conversationId,
      'عرض مضاد',
      timestamp: _formatFullTime(),
      user: 'مصنع المشتري',
      notes: 'طلب تخفيض السعر إلى $counterPrice ر.س بسبب: $reason',
      isCompleted: true,
      isActive: false,
    );
    await repo.updateTimelineStage(
      conversationId,
      'تعديل العرض',
      timestamp: '--',
      user: '--',
      isActive: true,
    );

    // Update Activity Log
    final ordersRepo = ref.read(ordersRepositoryProvider);
    final rfqId = _getRfqIdFromConvId(conversationId);
    await ordersRepo.addActivityLogItem(
      rfqId,
      ActivityLogItem(
        iconTag: 'verified',
        user: 'مصنع المشتري',
        action: 'تقديم عرض مضاد بقيمة $counterPrice ر.س',
        date: _formatDate(),
        time: _formatTimeLabel(),
        device: 'تطبيق المشتري',
        status: 'مكتمل',
      ),
    );
  }

  Future<void> acceptQuotation(String messageId) async {
    final currentMessages = state.valueOrNull ?? [];
    final repo = ref.read(messagesRepositoryProvider);
    
    final updatedMessages = currentMessages.map((m) {
      if (m.id == messageId) {
        final newCardData = Map<String, dynamic>.from(m.cardData ?? {});
        newCardData['status'] = 'accepted';
        return BusinessMessage(
          id: m.id,
          senderId: m.senderId,
          senderName: m.senderName,
          senderAvatar: m.senderAvatar,
          content: 'تم قبول عرض السعر',
          time: m.time,
          isOutgoing: m.isOutgoing,
          type: m.type,
          readStatus: m.readStatus,
          attachmentUrls: m.attachmentUrls,
          replyToId: m.replyToId,
          replyToContent: m.replyToContent,
          cardData: newCardData,
          reaction: '✅',
          isDeleted: m.isDeleted,
          isEdited: m.isEdited,
        );
      }
      return m;
    }).toList();

    // After accepting the quotation, send the agreement card:
    final agreementMsg = BusinessMessage(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      senderId: 'supplier',
      senderName: 'مورد نسيجي',
      senderAvatar: '',
      content: 'الاتفاق النهائي وعقد الشراء',
      time: _formatTime(),
      isOutgoing: true,
      type: MessageType.agreementCard,
      readStatus: ReadStatus.sent,
      cardData: const {
        'finalPrice': '12.00',
        'quantity': '5,000 م',
        'deliveryDate': '2026-07-25',
        'paymentMethod': 'تحويل بنكي ضامن Escrow',
        'status': 'confirmed',
        'orderNumber': 'ORD-2241',
      },
    );

    state = AsyncValue.data([...updatedMessages, agreementMsg]);
    
    // Also notify repo to update
    await repo.sendMessage(conversationId, agreementMsg);

    // Update timeline stages
    await repo.updateTimelineStage(
      conversationId,
      'تعديل العرض',
      timestamp: _formatFullTime(),
      user: 'مورد نسيجي',
      notes: 'تعديل العرض النهائي والموافقة',
      isCompleted: true,
      isActive: false,
    );
    await repo.updateTimelineStage(
      conversationId,
      'الاتفاق النهائي',
      timestamp: _formatFullTime(),
      user: 'كلا الطرفين',
      notes: 'تم توقيع الاتفاقية رسميًا وإنشاء الطلب رقم ORD-2241',
      isCompleted: true,
      isActive: false,
    );
    await repo.updateTimelineStage(
      conversationId,
      'التصنيع',
      timestamp: _formatFullTime(),
      user: 'مورد نسيجي',
      notes: 'بدء الإنتاج الفعلي وتجهيز الأقمشة',
      isCompleted: false,
      isActive: true,
    );

    // Update Activity Log
    final ordersRepo = ref.read(ordersRepositoryProvider);
    final rfqId = _getRfqIdFromConvId(conversationId);
    await ordersRepo.addActivityLogItem(
      rfqId,
      ActivityLogItem(
        iconTag: 'verified',
        user: 'النظام',
        action: 'توقيع الاتفاقية النهائية وإنشاء طلب الشراء ORD-2241',
        date: _formatDate(),
        time: _formatTimeLabel(),
        device: 'عقد ذكي',
        status: 'مكتمل',
      ),
    );
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

  String _formatDate() {
    final now = DateTime.now();
    final y = now.year;
    final m = now.month.toString().padLeft(2, '0');
    final d = now.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  String _formatFullTime() {
    final now = DateTime.now();
    final y = now.year;
    final m = now.month.toString().padLeft(2, '0');
    final d = now.day.toString().padLeft(2, '0');
    final timeStr = _formatTime();
    return '$y-$m-$d $timeStr';
  }

  String _formatTimeLabel() {
    final now = DateTime.now();
    final h = now.hour;
    final m = now.minute.toString().padLeft(2, '0');
    final period = h >= 12 ? 'م' : 'ص';
    final displayHour = h > 12 ? h - 12 : (h == 0 ? 12 : h);
    return '$displayHour:$m $period';
  }

  String _getRfqIdFromConvId(String convId) {
    if (convId == 'conv_001') return 'RFQ-8820';
    if (convId == 'conv_002') return 'RFQ-8794';
    if (convId == 'conv_003') return 'RFQ-8710';
    return 'RFQ-8820';
  }
}
