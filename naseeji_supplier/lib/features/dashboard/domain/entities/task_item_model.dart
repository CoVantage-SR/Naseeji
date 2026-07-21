enum TaskPriority {
  urgent, // 🔴 Urgent (Critical/Overdue)
  today, // 🟠 Needs action today
  waiting, // 🟡 Waiting on buyer/third party
  informational, // 🟢 Actionable ready / completed notice
}

class TaskItemModel {
  final String id;
  final String title;
  final String? description;
  final TaskPriority priority;
  final String statusLabel;
  final String actionLabel;
  final String actionRoute;
  final String deadlineFormatted;
  final DateTime createdAt;

  const TaskItemModel({
    required this.id,
    required this.title,
    this.description,
    required this.priority,
    required this.statusLabel,
    required this.actionLabel,
    required this.actionRoute,
    required this.deadlineFormatted,
    required this.createdAt,
  });
}
