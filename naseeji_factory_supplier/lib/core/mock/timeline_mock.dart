import '../../features/messages/domain/entities/deal_timeline_model.dart';

class TimelineMock {
  final String dealId;
  final int currentStepIndex;
  final List<DealTimelineStep> steps;

  const TimelineMock({
    required this.dealId,
    required this.currentStepIndex,
    required this.steps,
  });

  DealTimelineModel toDomain() {
    return DealTimelineModel(
      currentStepIndex: currentStepIndex,
      steps: steps,
    );
  }

  static final sampleTimeline = TimelineMock(
    dealId: 'DEAL-101',
    currentStepIndex: 2,
    steps: const [
      DealTimelineStep(stepIndex: 0, title: 'تم إنشاء الصفقة', subtitle: 'استلام RFQ-1025 من المصنع', isCompleted: true, isCurrent: false),
      DealTimelineStep(stepIndex: 1, title: 'تم إرسال عرض السعر V1', subtitle: 'تقديم عرض سعر 45 جنيه/كجم', isCompleted: true, isCurrent: false),
      DealTimelineStep(stepIndex: 2, title: 'تم تعديل العرض V2', subtitle: 'تقديم عرض جديد 43 جنيه/كجم', isCompleted: true, isCurrent: true),
      DealTimelineStep(stepIndex: 3, title: 'تم قبول العرض', isCompleted: false, isCurrent: false),
      DealTimelineStep(stepIndex: 4, title: 'تم إنشاء الاتفاق والعقد', isCompleted: false, isCurrent: false),
      DealTimelineStep(stepIndex: 5, title: 'بدأ الإنتاج والتصنيع', isCompleted: false, isCurrent: false),
      DealTimelineStep(stepIndex: 6, title: 'تم التسليم للمصنع', isCompleted: false, isCurrent: false),
      DealTimelineStep(stepIndex: 7, title: 'تم قبول الجودة المعملية', isCompleted: false, isCurrent: false),
      DealTimelineStep(stepIndex: 8, title: 'تم تحويل المستحقات (Escrow)', isCompleted: false, isCurrent: false),
    ],
  );
}


