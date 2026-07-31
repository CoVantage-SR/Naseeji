class ProductLifecycleStep {
  final int stepIndex;
  final String title;
  final String? subtitle;
  final bool isCompleted;
  final bool isCurrent;
  final DateTime? completedAt;

  const ProductLifecycleStep({
    required this.stepIndex,
    required this.title,
    this.subtitle,
    required this.isCompleted,
    required this.isCurrent,
    this.completedAt,
  });
}

class ProductLifecycleModel {
  final int currentStepIndex;
  final List<ProductLifecycleStep> steps;

  const ProductLifecycleModel({
    required this.currentStepIndex,
    required this.steps,
  });

  double get progressPercentage => steps.isEmpty ? 0.0 : ((currentStepIndex + 1) / steps.length).clamp(0.0, 1.0);
}

