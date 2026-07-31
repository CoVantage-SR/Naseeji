class DealTimelineStep {
  final int stepIndex;
  final String title;
  final String? subtitle;
  final bool isCompleted;
  final bool isCurrent;
  final DateTime? completedAt;

  const DealTimelineStep({
    required this.stepIndex,
    required this.title,
    this.subtitle,
    required this.isCompleted,
    required this.isCurrent,
    this.completedAt,
  });
}

class DealTimelineModel {
  final int currentStepIndex;
  final List<DealTimelineStep> steps;

  const DealTimelineModel({
    required this.currentStepIndex,
    required this.steps,
  });
}
