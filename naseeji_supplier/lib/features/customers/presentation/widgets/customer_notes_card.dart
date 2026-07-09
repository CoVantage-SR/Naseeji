import 'package:flutter/material.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../../domain/entities/customer_model.dart';

class CustomerNotesCard extends StatelessWidget {
  final CustomerNote note;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onTogglePin;

  const CustomerNotesCard({
    super.key,
    required this.note,
    this.onEdit,
    this.onDelete,
    this.onTogglePin,
  });

  @override
  Widget build(BuildContext context) {
    final priorityData = _getPriorityData();
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: note.isPinned ? AppColors.primary.withValues(alpha: 0.4) : const Color(0xFFE2E1EF),
          width: note.isPinned ? 1 : 0.5,
        ),
        boxShadow: const [BoxShadow(color: Color(0x06000000), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
            decoration: BoxDecoration(
              color: note.isPinned ? AppColors.primary.withValues(alpha: 0.05) : Colors.transparent,
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(14), topRight: Radius.circular(14)),
            ),
            child: Row(
              children: [
                if (note.isPinned)
                  Padding(
                    padding: EdgeInsets.only(left: 6),
                    child: Icon(Icons.push_pin, size: 13, color: AppColors.primary),
                  ),
                Expanded(
                  child: Text(
                    note.title,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Theme.of(context).colorScheme.onSurface),
                  ),
                ),
                // Priority badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: priorityData.$2.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    priorityData.$1,
                    style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: priorityData.$2),
                  ),
                ),
                SizedBox(width: 4),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, size: 18, color: AppColors.outline),
                  onSelected: (v) {
                    if (v == 'edit') onEdit?.call();
                    if (v == 'delete') onDelete?.call();
                    if (v == 'pin') onTogglePin?.call();
                  },
                  itemBuilder: (_) => [
                    PopupMenuItem(value: 'pin', child: Row(children: [Icon(note.isPinned ? Icons.push_pin_outlined : Icons.push_pin, size: 14), SizedBox(width: 8), Text(note.isPinned ? 'إلغاء التثبيت' : 'تثبيت')])),
                    const PopupMenuItem(value: 'edit', child: Row(children: [Icon(Icons.edit_outlined, size: 14), SizedBox(width: 8), Text('تعديل')])),
                    const PopupMenuItem(value: 'delete', child: Row(children: [Icon(Icons.delete_outline, size: 14, color: AppColors.error), SizedBox(width: 8), Text('حذف', style: TextStyle(color: AppColors.error))])),
                  ],
                ),
              ],
            ),
          ),
          Divider(height: 1, color: AppColors.surfaceContainerLow),
          // Body
          Padding(
            padding: const EdgeInsets.all(14),
            child: Text(
              note.description,
              style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant, height: 1.5),
            ),
          ),
          // Footer
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
            child: Row(
              children: [
                const Icon(Icons.calendar_today_outlined, size: 10, color: AppColors.outline),
                SizedBox(width: 4),
                Text('أُنشئت: ${note.createdDate}', style: TextStyle(fontSize: 9, color: AppColors.outline)),
                if (note.updatedDate != note.createdDate) ...[
                  SizedBox(width: 10),
                  const Icon(Icons.update, size: 10, color: AppColors.outline),
                  SizedBox(width: 4),
                  Text('عُدّلت: ${note.updatedDate}', style: TextStyle(fontSize: 9, color: AppColors.outline)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  (String, Color) _getPriorityData() {
    switch (note.priority) {
      case 'high': return ('عالية', AppColors.error);
      case 'low': return ('منخفضة', Colors.green);
      default: return ('متوسطة', const Color(0xFFFFB800));
    }
  }
}