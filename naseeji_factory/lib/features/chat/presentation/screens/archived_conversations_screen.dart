import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/widgets/reusable_widgets.dart';
import '../providers/chat_provider.dart';
import '../widgets/archived_conversations_widgets.dart';

class ArchivedConversationsScreen extends ConsumerWidget {
  const ArchivedConversationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allConversations = ref.watch(chatNotifierProvider);
    final notifier = ref.read(chatNotifierProvider.notifier);

    final archived = allConversations.where((c) => c.isArchived).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('الأرشيف والمحادثات المؤرشفة'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: archived.isEmpty
            ? const EmptyState(
                icon: Icons.archive_outlined,
                title: 'الأرشيف فارغ تماماً',
                description: 'المحادثات التي تقوم بأرشفتها من قائمة الخيارات ستظهر هنا للرجوع إليها لاحقاً.',
              )
            : ListView.separated(
                padding: const EdgeInsets.all(16.0),
                itemCount: archived.length,
                separatorBuilder: (context, index) => AppSpacing.hMD,
                itemBuilder: (context, index) {
                  final conv = archived[index];
                  return ArchivedConversationCardWidget(
                    conversation: conv,
                    onUnarchive: () {
                      notifier.toggleArchive(conv.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('تم استعادة المحادثة من الأرشيف.')),
                      );
                    },
                    onDelete: () {
                      notifier.deleteConversation(conv.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('تم حذف المحادثة بشكل نهائي.')),
                      );
                    },
                  );
                },
              ),
      ),
    );
  }
}
