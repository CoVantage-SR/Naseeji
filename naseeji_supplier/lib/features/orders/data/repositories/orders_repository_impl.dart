import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/rfq_details.dart';
import '../../domain/entities/rfq_stats.dart';
import '../../domain/entities/rfq_item.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/entities/offer_details.dart';
import '../../domain/entities/offer_approved.dart';
import '../../domain/entities/offer_rejected.dart';
import '../../domain/repositories/orders_repository.dart';

part 'orders_repository_impl.g.dart';

class OrdersRepositoryImpl implements OrdersRepository {
  @override
  Future<RfqStats> getRfqStats() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return const RfqStats(
      newRequests: 12,
      awaitingResponse: 5,
      underNegotiation: 8,
      approvedToday: 4,
    );
  }

  @override
  Future<List<RfqItem>> getRfqItems() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return const [
      RfqItem(
        companyName: 'مصنع الرياض للملابس',
        rfqNumber: 'RFQ-8820',
        material: 'Cotton 100%',
        status: 'جديد',
        statusColorValue: 0xFF0040E0,
        statusBgColorValue: 0xFFE8F0FE,
        quantity: '5,000 م',
        location: 'الرياض، SA',
        dateLabel: 'تاريخ الطلب',
        dateValue: 'منذ ساعتين',
        logoText: 'RC',
        logoBgColorValue: 0xFF0040E0,
        actionButtonText: 'تقديم عرض',
        actionButtonColorValue: 0xFF0040E0,
        actionButtonTextColorValue: 0xFFFFFFFF,
        hasIconButton: true,
        iconButtonIconType: 'more',
      ),
      RfqItem(
        companyName: 'حلول جدة للنسيج',
        rfqNumber: 'RFQ-8794',
        material: 'Polyester Silk Blend',
        status: 'تفاوض',
        statusColorValue: 0xFFEA580C,
        statusBgColorValue: 0xFFFFEDD5,
        quantity: '12,500 م',
        location: 'جدة، SA',
        dateLabel: 'تاريخ الطلب',
        dateValue: 'منذ 5 ساعات',
        logoText: 'JT',
        logoBgColorValue: 0xFF006B5F,
        actionButtonText: 'متابعة العرض',
        actionButtonColorValue: 0xFF0040E0,
        actionButtonTextColorValue: 0xFF0040E0,
        actionButtonIsOutlined: true,
        hasIconButton: true,
        iconButtonIconType: 'chat',
      ),
      RfqItem(
        companyName: 'مصنع الدمام للملابس',
        rfqNumber: 'RFQ-8710',
        material: 'Organic Linen',
        status: 'في الانتظار',
        statusColorValue: 0xFF8B5CF6,
        statusBgColorValue: 0xFFF3E8FF,
        quantity: '3,200 م',
        location: 'الدمام، SA',
        dateLabel: 'تاريخ الطلب',
        dateValue: 'أمس، 04:30 م',
        logoText: 'DC',
        logoBgColorValue: 0xFF4B5563,
        actionButtonText: 'تم إرسال العرض',
        actionButtonColorValue: 0xFF9CA3AF,
        actionButtonTextColorValue: 0xFF4B5563,
        actionButtonIsOutlined: true,
        hasIconButton: false,
      ),
      RfqItem(
        companyName: 'شركة الأزياء الموحدة',
        rfqNumber: 'RFQ-8655',
        material: 'Wool Blend',
        status: 'تمت الموافقة',
        statusColorValue: 0xFF16A34A,
        statusBgColorValue: 0xFFDCFCE7,
        quantity: '8,000 م',
        location: 'المدينة، SA',
        dateLabel: 'تاريخ الموافقة',
        dateValue: 'اليوم، 10:15 ص',
        logoText: 'UF',
        logoBgColorValue: 0xFFD97706,
        actionButtonText: 'بدء الإنتاج',
        actionButtonColorValue: 0xFF006B5F,
        actionButtonTextColorValue: 0xFFFFFFFF,
        hasIconButton: false,
      ),
      RfqItem(
        companyName: 'مصنع الشرقية للخيوط',
        rfqNumber: 'RFQ-8510',
        material: 'Nylon Waterproof',
        status: 'مرفوض',
        statusColorValue: 0xFFDC2626,
        statusBgColorValue: 0xFFFEE2E2,
        quantity: '15,000 م',
        location: 'الخبر، SA',
        dateLabel: 'تاريخ الرفض',
        dateValue: 'منذ يومين',
        logoText: 'EF',
        logoBgColorValue: 0xFFDC2626,
        actionButtonText: 'عرض سبب الرفض',
        actionButtonColorValue: 0xFFDC2626,
        actionButtonTextColorValue: 0xFFFFFFFF,
        hasIconButton: false,
      ),
    ];
  }

  @override
  Future<RfqDetails> getRfqDetails(String rfqId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return const RfqDetails(
      rfqId: 'NAS-2024-0892',
      companyName: 'الشركة المتحدة للنسيج الذكي',
      contactPerson: 'سارة أحمد',
      status: 'مورد معتمد',
      fabricType: 'قطن 100% (Cotton)',
      quantity: '5,000 متر',
      color: 'Indigo',
      weight: 'GSM 180',
      quality: 'Premium',
      packagingMethod: 'لفات (Rolls) مع غطاء حماية مزدوج',
      deliveryDestination: 'مستودعات الشركة - مدينة الرياض',
      notes: 'نحن بحاجة إلى متانة عالية وقدرة ممتازة على التنفس لضمان جودة استثنائية لمجموعة الصيف القادمة. يرجى التركيز على ثبات اللون تحت أشعة الشمس.',
    );
  }

  @override
  Future<List<ChatMessage>> getChatMessages(String rfqId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return const [
      ChatMessage(
        senderName: 'الشركة المتحدة للنسيج الذكي',
        senderAvatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=100&q=80',
        content: '',
        time: '09:10 ص',
        isOutgoing: true,
        imageAttachments: [
          'https://images.unsplash.com/photo-1544816155-12df9643f363?auto=format&fit=crop&w=150&q=80',
          'https://images.unsplash.com/photo-1596461404969-9ae70f2830c1?auto=format&fit=crop&w=150&q=80',
        ],
      ),
      ChatMessage(
        senderName: 'الشركة المتحدة للنسيج الذكي',
        senderAvatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=100&q=80',
        content: 'هذه هي العينات المتاحة لدينا بجودة 180 جرام. متوفرة بألوان متعددة.',
        time: '09:15 ص',
        isOutgoing: true,
      ),
      ChatMessage(
        senderName: 'الشركة المتحدة للنسيج الذكي',
        senderAvatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=100&q=80',
        content: '',
        time: '09:20 ص',
        isOutgoing: true,
        pdfName: 'Quotation_RFQ8820.pdf',
        pdfSize: '1.2 MB • عرض السعر المبدئي',
      ),
      ChatMessage(
        senderName: 'مصنع الأقمشة المتطور',
        senderAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=100&q=80',
        content: '',
        time: '09:30 ص',
        isOutgoing: false,
        priceUpdateOld: 15.00,
        priceUpdateNew: 13.50,
        priceUpdateDesc: 'تم تعديل السعر بناء على الكمية المطلوبة (5000 متر).',
      ),
    ];
  }

  @override
  Future<OfferDetails> getOfferDetails(String rfqId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return const OfferDetails(
      rfqId: '8710',
      statusLabel: 'في انتظار الموافقة',
      statusDescription: 'طلبك قيد المراجعة حالياً من قبل قسم الإنتاج في مصنع نسيجك.',
      lastSeen: 'منذ 5 دقائق',
      sentTimeAgo: 'ساعة واحدة',
      factoryImage: 'https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?auto=format&fit=crop&w=350&q=80',
      factoryLabel: 'مصنع نسيجك - وحدة الإنتاج رقم 4',
      phases: [
        OfferPhase(
          title: 'إرسال العرض',
          description: 'تم إرسال عرض السعر والتفاصيل الفنية بنجاح.',
          time: '10:45 AM',
          isCompleted: true,
        ),
        OfferPhase(
          title: 'تمت المشاهدة',
          description: 'قام مدير المصنع بفتح ومراجعة وثيقة العرض.',
          time: '11:30 AM',
          isCompleted: true,
        ),
        OfferPhase(
          title: 'قيد المراجعة',
          description: 'يتم الآن دراسة الجدول الزمني للإنتاج وتوفر المواد.',
          time: 'الآن',
          isActive: true,
          showSpinner: true,
          showPill: true,
        ),
        OfferPhase(
          title: 'الموافقة النهائية',
          description: 'المرحلة الأخيرة لإصدار أمر الشراء الرسمي.',
          time: 'قريباً',
          isFuture: true,
        ),
      ],
    );
  }

  @override
  Future<OfferApproved> getOfferApproved(String rfqId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return const OfferApproved(
      rfqId: '8842',
      meterPrice: '120 ر.س / م',
      totalPrice: '600,000 ر.س',
      deliveryDate: '20 يوليو',
      paymentMethodTitle: 'طريقة الدفع',
      paymentMethodDesc: 'تحويل بنكي مباشر - المصرف الراجحي - شركة نسيجي',
      fabricTextureImage: 'https://images.unsplash.com/photo-1596461404969-9ae70f2830c1?auto=format&fit=crop&w=350&q=80',
      fabricTextureLabel: 'خامات نسيج مختارة بعناية',
    );
  }

  @override
  Future<OfferRejected> getOfferRejected(String rfqId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return const OfferRejected(
      rfqId: '8510',
      factoryNotes: 'The unit price is higher than our budget for this project. We are looking for a supplier who can offer a more competitive rate for the high-volume production phase starting next quarter.',
      standardsImage: 'https://images.unsplash.com/photo-1576086213369-97a306d36557?auto=format&fit=crop&w=350&q=80',
      standardsLabel: 'معايير نسيجي للجودة والابتكار',
      suggestedChanges: [
        SuggestedChange(
          text: 'خفض سعر الوحدة بنسبة 15%\nللمنافسة مع العروض الحالية في السوق',
          iconTag: 'trending_down',
        ),
        SuggestedChange(
          text: 'تقليص مدة التوريد\nالمصنع يفضل التسليم خلال 10 أيام عمل',
          iconTag: 'access_time',
        ),
        SuggestedChange(
          text: 'إرفاق شهادات الجودة (ISO)\nلتعزيز موثوقية الخامات المستخدمة',
          iconTag: 'verified',
        ),
      ],
    );
  }
}

@riverpod
OrdersRepository ordersRepository(OrdersRepositoryRef ref) {
  return OrdersRepositoryImpl();
}
