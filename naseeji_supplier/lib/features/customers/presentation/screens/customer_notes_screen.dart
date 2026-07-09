import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../controllers/customers_controller.dart';
import '../../domain/entities/customer_model.dart';
import '../widgets/customer_notes_card.dart';

class CustomerNotesScreen extends ConsumerStatefulWidget {
  final String customerId;

  const CustomerNotesScreen({super.key, required this.customerId});

  @override
  ConsumerState<CustomerNotesScreen> createState() => _CustomerNotesScreenState();
}

class _CustomerNotesScreenState extends ConsumerState<CustomerNotesScreen> {
  @override
  Widget build(BuildContext context) {
    final stateAsync = ref.watch(customersControllerProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          centerTitle: true,
          title: const Text('الملاحظات الخاصة', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 16)),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: AppColors.onSurfaceVariant),
            onPressed: () => context.pop(),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _showNoteDialog(context, null),
          backgroundColor: AppColors.primary,
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text('ملاحظة جديدة', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        body: stateAsync.when(
          loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
          error: (e, _) => Center(child: Text('خطأ: $e')),
          data: (customers) {
            final idx = customers.indexWhere((c) => c.id == widget.customerId);
            if (idx == -1) return const Center(child: Text('العميل غير موجود'));
            final customer = customers[idx];

            final pinned = customer.notes.where((n) => n.isPinned).toList();
            final others = customer.notes.where((n) => !n.isPinned).toList()
              ..sort((a, b) => b.updatedDate.compareTo(a.updatedDate));

            final allNotes = [...pinned, ...others];

            if (allNotes.isEmpty) {
              return const Center(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.note_alt_outlined, size: 56, color: AppColors.outlineVariant),
                  SizedBox(height: 12),
                  Text('لا توجد ملاحظات خاصة بعد', style: TextStyle(color: AppColors.outline, fontSize: 13)),
                  SizedBox(height: 6),
                  Text('اضغط على "ملاحظة جديدة" لإضافة أولى ملاحظاتك', style: TextStyle(color: AppColors.outlineVariant, fontSize: 11)),
                ]),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              itemCount: allNotes.length,
              itemBuilder: (_, i) {
                final note = allNotes[i];
                return CustomerNotesCard(
                  note: note,
                  onEdit: () => _showNoteDialog(context, note),
                  onDelete: () => _confirmDelete(context, note, widget.customerId),
                  onTogglePin: () => ref.read(customersControllerProvider.notifier).pinNote(widget.customerId, note.id, !note.isPinned),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _showNoteDialog(BuildContext context, CustomerNote? existing) {
    final titleCtrl = TextEditingController(text: existing?.title ?? '');
    final bodyCtrl = TextEditingController(text: existing?.description ?? '');
    String priority = existing?.priority ?? 'medium';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: Text(existing == null ? 'ملاحظة جديدة' : 'تعديل الملاحظة', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            content: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleCtrl,
                    decoration: const InputDecoration(labelText: 'عنوان الملاحظة', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: bodyCtrl,
                    maxLines: 4,
                    decoration: const InputDecoration(labelText: 'محتوى الملاحظة', border: OutlineInputBorder(), alignLabelWithHint: true),
                  ),
                  const SizedBox(height: 12),
                  Row(children: [
                    const Text('الأولوية: ', style: TextStyle(fontSize: 12)),
                    const SizedBox(width: 8),
                    _priorityChip('عالية', 'high', priority, AppColors.error, setDialogState, (v) => priority = v),
                    const SizedBox(width: 6),
                    _priorityChip('متوسطة', 'medium', priority, const Color(0xFFFFB800), setDialogState, (v) => priority = v),
                    const SizedBox(width: 6),
                    _priorityChip('منخفضة', 'low', priority, Colors.green, setDialogState, (v) => priority = v),
                  ]),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
              ElevatedButton(
                onPressed: () {
                  if (titleCtrl.text.isEmpty) return;
                  final now = DateTime.now().toString().split(' ')[0];
                  final controller = ref.read(customersControllerProvider.notifier);
                  if (existing == null) {
                    final note = CustomerNote(
                      id: 'note_${DateTime.now().millisecondsSinceEpoch}',
                      title: titleCtrl.text,
                      description: bodyCtrl.text,
                      priority: priority,
                      createdDate: now,
                      updatedDate: now,
                    );
                    controller.addNote(widget.customerId, note);
                  } else {
                    controller.updateNote(widget.customerId, existing.copyWith(
                      title: titleCtrl.text,
                      description: bodyCtrl.text,
                      priority: priority,
                      updatedDate: now,
                    ));
                  }
                  Navigator.pop(ctx);
                },
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                child: Text(existing == null ? 'إضافة' : 'حفظ', style: const TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _priorityChip(String label, String value, String current, Color color, StateSetter setDialogState, void Function(String) onSelect) {
    final isSelected = current == value;
    return GestureDetector(
      onTap: () => setDialogState(() => onSelect(value)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color, width: isSelected ? 1 : 0.5),
        ),
        child: Text(label, style: TextStyle(fontSize: 10, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: color)),
      ),
    );
  }

  void _confirmDelete(BuildContext context, CustomerNote note, String customerId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('حذف الملاحظة', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text('هل تريد حذف الملاحظة "${note.title}"؟ لا يمكن التراجع عن هذا الإجراء.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () {
              ref.read(customersControllerProvider.notifier).deleteNote(customerId, note.id);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('حذف', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
