import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../orders/presentation/providers/orders_provider.dart';

part 'quality_provider.g.dart';

class QualityCategoryRating {
  final String category;
  final int rating; // 1 to 5
  final String comment;

  QualityCategoryRating({
    required this.category,
    required this.rating,
    required this.comment,
  });

  QualityCategoryRating copyWith({
    int? rating,
    String? comment,
  }) {
    return QualityCategoryRating(
      category: category,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
    );
  }
}

class QualityInspectionState {
  final Map<String, bool> receiptChecklist;
  final List<QualityCategoryRating> categoryRatings;
  final Map<String, bool> qualityChecklist;
  final String notes;

  QualityInspectionState({
    required this.receiptChecklist,
    required this.categoryRatings,
    required this.qualityChecklist,
    required this.notes,
  });

  QualityInspectionState copyWith({
    Map<String, bool>? receiptChecklist,
    List<QualityCategoryRating>? categoryRatings,
    Map<String, bool>? qualityChecklist,
    String? notes,
  }) {
    return QualityInspectionState(
      receiptChecklist: receiptChecklist ?? this.receiptChecklist,
      categoryRatings: categoryRatings ?? this.categoryRatings,
      qualityChecklist: qualityChecklist ?? this.qualityChecklist,
      notes: notes ?? this.notes,
    );
  }

  double get overallScore {
    if (categoryRatings.isEmpty) return 0.0;
    final total = categoryRatings.fold<int>(0, (sum, item) => sum + item.rating);
    return (total / (categoryRatings.length * 5)) * 100;
  }

  String get scoreRatingText {
    final score = overallScore;
    if (score >= 90) return 'ممتاز (Excellent)';
    if (score >= 75) return 'جيد (Good)';
    if (score >= 50) return 'مقبول (Fair)';
    return 'ضعيف (Poor)';
  }
}

@riverpod
class QualityNotifier extends _$QualityNotifier {
  Map<String, QualityInspectionState> build() {
    return {};
  }

  QualityInspectionState getOrCreateState(String orderId) {
    if (!state.containsKey(orderId)) {
      final newState = QualityInspectionState(
        receiptChecklist: {
          'الكمية مطابقة للطلب': false,
          'التغليف سليم وغير ممزق': false,
          'لا توجد أضرار ظاهرة': false,
          'المنتج يطابق المواصفات الفنية': false,
          'الشحنة مكتملة الملحقات': false,
        },
        categoryRatings: [
          QualityCategoryRating(category: 'جودة المنتج (Product Quality)', rating: 5, comment: ''),
          QualityCategoryRating(category: 'جودة المواد الخام (Material Quality)', rating: 5, comment: ''),
          QualityCategoryRating(category: 'دقة الألوان والصبغة (Color Accuracy)', rating: 5, comment: ''),
          QualityCategoryRating(category: 'الأبعاد والمقاسات (Dimensions)', rating: 5, comment: ''),
          QualityCategoryRating(category: 'التشطيب والإنهاء (Finishing)', rating: 5, comment: ''),
          QualityCategoryRating(category: 'جودة التغليف والتعبئة (Packaging)', rating: 5, comment: ''),
          QualityCategoryRating(category: 'المستندات والشهادات (Documentation)', rating: 5, comment: ''),
        ],
        qualityChecklist: {
          'مطابق للمواصفات القياسية': false,
          'مطابق للعينات المعتمدة': false,
          'مطابق للاتفاق المبرم': false,
          'مطابق للصور المرفقة': false,
        },
        notes: '',
      );
      state = {...state, orderId: newState};
    }
    return state[orderId]!;
  }

  void updateReceiptChecklist(String orderId, String item, bool value) {
    final currentState = getOrCreateState(orderId);
    final updatedChecklist = Map<String, bool>.from(currentState.receiptChecklist);
    updatedChecklist[item] = value;

    state = {
      ...state,
      orderId: currentState.copyWith(receiptChecklist: updatedChecklist),
    };
  }

  void updateCategoryRating(String orderId, String category, int rating, {String? comment}) {
    final currentState = getOrCreateState(orderId);
    final updatedRatings = currentState.categoryRatings.map((item) {
      if (item.category == category) {
        return item.copyWith(
          rating: rating,
          comment: comment ?? item.comment,
        );
      }
      return item;
    }).toList();

    state = {
      ...state,
      orderId: currentState.copyWith(categoryRatings: updatedRatings),
    };
  }

  void updateQualityChecklist(String orderId, String item, bool value) {
    final currentState = getOrCreateState(orderId);
    final updatedChecklist = Map<String, bool>.from(currentState.qualityChecklist);
    updatedChecklist[item] = value;

    state = {
      ...state,
      orderId: currentState.copyWith(qualityChecklist: updatedChecklist),
    };
  }

  void updateNotes(String orderId, String notes) {
    final currentState = getOrCreateState(orderId);
    state = {
      ...state,
      orderId: currentState.copyWith(notes: notes),
    };
  }

  // Business Action 1: Confirm Receipt
  void confirmReceipt(String orderId) {
    // Updates order status to 'delivered' and adds timeline item
    ref.read(ordersNotifierProvider.notifier).confirmDelivery(orderId);
  }

  // Business Action 2: Approve Quality (Order Completed -> Supplier Payment Release)
  void approveQuality(String orderId) {
    final currentState = getOrCreateState(orderId);
    final score = currentState.overallScore.toInt();
    final rating = currentState.scoreRatingText;

    // We can update the orders status in ordersNotifierProvider
    final ordersNotifier = ref.read(ordersNotifierProvider.notifier);
    ordersNotifier.state = ordersNotifier.state.map((o) {
      if (o.id == orderId) {
        return o.copyWith(
          status: 'completed',
          progressPercentage: 100.0,
          currentLocation: 'المخازن الرئيسية لمصنع نسيجي',
          carrierStatus: 'تم فحص جودة الشحنة والموافقة عليها بنجاح بنسبة $score% ($rating)',
        );
      }
      return o;
    }).toList();

    // Add Timeline item
    ref.read(timelineNotifierProvider.notifier).addTimelineItem(
          orderId,
          stage: 'تم اعتماد فحص الجودة بنجاح',
          updatedBy: 'مفتش جودة نسيجي',
          notes: 'النتيجة الإجمالية للمطابقة: $score% ($rating). جاري الإفراج المالي للمورد بقيمة العقد.',
          attachments: ['تقرير_فحص_الجودة.pdf'],
        );
  }

  // Business Action 3: Open Issue / Report Problem
  void submitIssueReport(
    String orderId, {
    required String issueType,
    required String description,
    required List<String> evidenceFiles,
  }) {
    final ordersNotifier = ref.read(ordersNotifierProvider.notifier);
    ordersNotifier.state = ordersNotifier.state.map((o) {
      if (o.id == orderId) {
        return o.copyWith(
          status: 'disputed',
          progressPercentage: 100.0,
          carrierStatus: 'تحت النزاع - بلاغ عيوب جودة ($issueType)',
        );
      }
      return o;
    }).toList();

    // Add Timeline item
    ref.read(timelineNotifierProvider.notifier).addTimelineItem(
          orderId,
          stage: 'تم الإبلاغ عن مشكلة جودة وفتح نزاع',
          updatedBy: 'مفتش جودة نسيجي',
          notes: 'نوع المشكلة: $issueType - التفاصيل: $description',
          attachments: evidenceFiles.isNotEmpty ? evidenceFiles : ['صور_المخالفات_الفنية.jpg'],
        );
  }

  // Business Action 4: Reject Delivery
  void rejectDelivery(
    String orderId, {
    required String reason,
    required String comments,
    required List<String> evidenceFiles,
  }) {
    final ordersNotifier = ref.read(ordersNotifierProvider.notifier);
    ordersNotifier.state = ordersNotifier.state.map((o) {
      if (o.id == orderId) {
        return o.copyWith(
          status: 'rejected',
          progressPercentage: 0.0,
          carrierStatus: 'تم رفض الشحنة بالكامل وإعادتها للمورد',
        );
      }
      return o;
    }).toList();

    // Add Timeline item
    ref.read(timelineNotifierProvider.notifier).addTimelineItem(
          orderId,
          stage: 'تم رفض استلام الشحنة وإعادتها',
          updatedBy: 'إدارة مصنع نسيجي',
          notes: 'السبب: $reason - التفاصيل: $comments. تم فتح نزاع مالي تلقائي.',
          attachments: evidenceFiles.isNotEmpty ? evidenceFiles : ['مستند_إشعار_الرفض.pdf'],
        );
  }

  // Business Action 5: Submit Replacement Request
  void submitReplacementRequest(
    String orderId, {
    required String productName,
    required int quantity,
    required String reason,
    required String comments,
    required List<String> evidenceFiles,
    required String shippingAddress,
  }) {
    final ordersNotifier = ref.read(ordersNotifierProvider.notifier);
    ordersNotifier.state = ordersNotifier.state.map((o) {
      if (o.id == orderId) {
        return o.copyWith(
          status: 'replacementRequested',
          carrierStatus: 'قيد انتظار شحن المنتجات البديلة من المورد',
        );
      }
      return o;
    }).toList();

    // Add Timeline item
    ref.read(timelineNotifierProvider.notifier).addTimelineItem(
          orderId,
          stage: 'طلب استبدال منتجات تالفة/مخالفة',
          updatedBy: 'المهندس إبراهيم (المشتري)',
          notes: 'المنتج: $productName - الكمية: $quantity - السبب: $reason. عنوان الشحن: $shippingAddress',
          attachments: evidenceFiles.isNotEmpty ? evidenceFiles : ['تفاصيل_القطع_المستبدلة.jpg'],
        );
  }

  // Business Action 6: Submit Return Request
  void submitReturnRequest(
    String orderId, {
    required String productName,
    required int quantity,
    required String reason,
    required String refundMethod,
    required String comments,
    required List<String> evidenceFiles,
  }) {
    final ordersNotifier = ref.read(ordersNotifierProvider.notifier);
    ordersNotifier.state = ordersNotifier.state.map((o) {
      if (o.id == orderId) {
        return o.copyWith(
          status: 'returnRequested',
          carrierStatus: 'قيد مرتجع المبيعات - بانتظار رد المستحقات ($refundMethod)',
        );
      }
      return o;
    }).toList();

    // Add Timeline item
    ref.read(timelineNotifierProvider.notifier).addTimelineItem(
          orderId,
          stage: 'طلب إرجاع بضائع واسترداد الثمن',
          updatedBy: 'المهندس إبراهيم (المشتري)',
          notes: 'المنتج: $productName - الكمية: $quantity - السبب: $reason. طريقة الاسترداد المفضلة: $refundMethod',
          attachments: evidenceFiles.isNotEmpty ? evidenceFiles : ['مستندات_المرتجع.pdf'],
        );
  }
}
