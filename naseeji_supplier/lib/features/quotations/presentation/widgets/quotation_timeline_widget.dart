import 'package:flutter/material.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../../domain/entities/quotation_model.dart';

class QuotationTimelineWidget extends StatelessWidget {
  final List<QuotationTimelineStep> steps;

  const QuotationTimelineWidget({super.key, required this.steps});

  @override
  Widget build(BuildContext context) {
    if (steps.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('لا يوجد سجل أحداث بعد لهذا العرض.', style: TextStyle(fontSize: 10, color: AppColors.outline)),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.all(Radius.circular(16)),
        boxShadow: [BoxShadow(color: Color(0x05000000), blurRadius: 10)],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.timeline_outlined, color: AppColors.primary, size: 18),
              SizedBox(width: 8),
              Text(
                'الخط الزمني لمسار العرض والقرارات',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Theme.of(context).colorScheme.onSurface),
              ),
            ],
          ),
          SizedBox(height: 16),
          
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: steps.length,
            itemBuilder: (context, index) {
              final step = steps[index];
              final isLast = index == steps.length - 1;
              return _buildTimelineItem(context, step, isLast);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(BuildContext context, QuotationTimelineStep step, bool isLast) {
    final bool isCompleted = step.status == 'مكتمل' || step.status == 'مقبول ومعتمد' || step.status == 'مقبول';
    final Color dotColor = isCompleted ? Colors.green : (step.status == 'مرفوض' ? Colors.red : AppColors.primary);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Left side: Line & Dot indicator
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: dotColor.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                  border: Border.all(color: dotColor, width: 2),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: const Color(0xFFE2E1EF),
                  ),
                ),
            ],
          ),
          SizedBox(width: 12),
          
          // Right side: Content card
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          step.title,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Theme.of(context).colorScheme.onSurface),
                        ),
                      ),
                      Text(
                        '${step.date} • ${step.time}',
                        style: TextStyle(fontSize: 8, color: AppColors.outline),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.person_outline, size: 10, color: AppColors.outline),
                      SizedBox(width: 4),
                      Text(
                        'المسؤول: ${step.responsibleUser}',
                        style: TextStyle(fontSize: 8, color: AppColors.outline),
                      ),
                      SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: dotColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          step.status,
                          style: TextStyle(fontSize: 7, fontWeight: FontWeight.bold, color: dotColor),
                        ),
                      ),
                    ],
                  ),
                  if (step.notes.isNotEmpty) ...[
                    SizedBox(height: 6),
                    Text(
                      step.notes,
                      style: TextStyle(fontSize: 9, color: Theme.of(context).colorScheme.onSurfaceVariant, height: 1.3),
                    ),
                  ],
                  if (step.attachments.isNotEmpty) ...[
                    SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: step.attachments.map((filename) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: const Color(0xFFE2E1EF), width: 0.5),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.attach_file, color: AppColors.primary, size: 10),
                              SizedBox(width: 4),
                              Text(filename, style: TextStyle(fontSize: 8, color: AppColors.primary, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
