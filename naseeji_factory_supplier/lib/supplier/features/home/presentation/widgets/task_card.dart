import 'package:flutter/material.dart';
import 'package:naseeji_factory/supplier/features/dashboard/domain/entities/task_item_model.dart';

enum TaskStatusType {
  urgent,
  negotiation,
  ready,
  completed,
  waiting,
}

class TaskCard extends StatelessWidget {
  final TaskItemModel task;
  final VoidCallback onAction;

  const TaskCard({
    super.key,
    required this.task,
    required this.onAction,
  });

  TaskStatusType _getTaskStatusType() {
    switch (task.priority) {
      case TaskPriority.urgent:
        return TaskStatusType.urgent;
      case TaskPriority.today:
        if (task.title.contains('تفاوض') || (task.description?.contains('مضاد') ?? false)) {
          return TaskStatusType.negotiation;
        } else if (task.title.contains('شحن') || task.title.contains('تسليم')) {
          return TaskStatusType.ready;
        }
        return TaskStatusType.waiting;
      case TaskPriority.waiting:
        return TaskStatusType.waiting;
      case TaskPriority.informational:
        return TaskStatusType.completed;
    }
  }

  Color _getStatusColor(TaskStatusType type) {
    switch (type) {
      case TaskStatusType.urgent:
        return const Color(0xFFDC2626); // Red
      case TaskStatusType.negotiation:
        return const Color(0xFFEA580C); // Orange
      case TaskStatusType.ready:
        return const Color(0xFF16A34A); // Green
      case TaskStatusType.completed:
        return const Color(0xFF2563EB); // Blue
      case TaskStatusType.waiting:
        return const Color(0xFFD97706); // Amber
    }
  }

  Color _getStatusBgColor(TaskStatusType type) {
    switch (type) {
      case TaskStatusType.urgent:
        return const Color(0xFFFEF2F2);
      case TaskStatusType.negotiation:
        return const Color(0xFFFFF7ED);
      case TaskStatusType.ready:
        return const Color(0xFFF0FDF4);
      case TaskStatusType.completed:
        return const Color(0xFFEFF6FF);
      case TaskStatusType.waiting:
        return const Color(0xFFFFFBEB);
    }
  }

  String _getStatusLabel(TaskStatusType type) {
    switch (type) {
      case TaskStatusType.urgent:
        return 'عاجل';
      case TaskStatusType.negotiation:
        return 'يحتاج تفاوض';
      case TaskStatusType.ready:
        return 'جاهز للشحن 🚚';
      case TaskStatusType.completed:
        return 'مكتمل ✅';
      case TaskStatusType.waiting:
        return 'بانتظار المصنع ⏳';
    }
  }

  @override
  Widget build(BuildContext context) {
    final type = _getTaskStatusType();
    final accentColor = _getStatusColor(type);
    final statusBgColor = _getStatusBgColor(type);
    final statusLabel = _getStatusLabel(type);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border(
          right: BorderSide(color: accentColor, width: 4.5), // Right accent bar in RTL
          top: const BorderSide(color: Color(0xFFE2E8F0)),
          left: const BorderSide(color: Color(0xFFE2E8F0)),
          bottom: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── 1. Top Header Row: Building Icon + Title + Priority Tag ───────
          Row(
            children: [
              // Building Circle Icon (Far Right in RTL)
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: Color(0xFFEFF6FF),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.apartment_rounded,
                  color: Color(0xFF2563EB),
                  size: 18,
                ),
              ),

              const SizedBox(width: 8),

              // Task Title
              Expanded(
                child: Text(
                  task.title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              const SizedBox(width: 6),

              // Status Tag Badge (Far Left in RTL)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: statusBgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  statusLabel,
                  style: TextStyle(
                    color: accentColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          // ─── 2. Middle Row: Task Description (If present) ─────────────────
          if (task.description != null && task.description!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              task.description!,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF475569),
                height: 1.3,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],

          const SizedBox(height: 10),

          // ─── 3. Bottom Row: Time Indicator (Right) & Action Button (Left) ─
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Time Indicator (Right in RTL)
              Row(
                children: [
                  const Icon(
                    Icons.access_time_rounded,
                    size: 13,
                    color: Color(0xFF64748B),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    task.deadlineFormatted,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF64748B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

              // Action Button (Left in RTL)
              Material(
                color: accentColor,
                borderRadius: BorderRadius.circular(8),
                child: InkWell(
                  onTap: onAction,
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.arrow_back_ios_new_rounded, size: 10, color: Colors.white),
                        const SizedBox(width: 4),
                        Text(
                          task.actionLabel,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

