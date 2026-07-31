// ignore_for_file: unnecessary_underscores

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_factory/core/theme/app_colors.dart';
import '../../domain/entities/conversation.dart';
import '../controllers/messages_controller.dart';
import 'widgets/conversation_card.dart';

class ArchivedChatsScreen extends ConsumerWidget {
  const ArchivedChatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateAsync = ref.watch(messagesControllerProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0.5,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.onSurface),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'المحادثات المؤرشفة',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Theme.of(context).colorScheme.onSurface),
        ),
        centerTitle: true,
      ),
      body: stateAsync.when(
        loading: () => Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (e, _) => Center(child: Text('خطأ: $e')),
        data: (state) {
          // Filter for archived conversations
          final archived = state.conversations
              .where((c) => c.status == ConversationStatus.archived)
              .toList();

          if (archived.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.archive_outlined, size: 64, color: AppColors.outlineVariant),
                  SizedBox(height: 16),
                  Text(
                    'لا توجد محادثات مؤرشفة',
                    style: TextStyle(fontSize: 14, color: AppColors.outline, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'المحادثات التي تقوم بأرشفتها ستظهر هنا.',
                    style: TextStyle(fontSize: 12, color: AppColors.outline),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 12),
            itemCount: archived.length,
            separatorBuilder: (_, __) => const Divider(height: 1, indent: 80),
            itemBuilder: (context, index) {
              final conv = archived[index];
              return Dismissible(
                key: ValueKey(conv.id),
                direction: DismissDirection.horizontal,
                background: Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 20),
                  color: Colors.green.shade600,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.unarchive_outlined, color: Colors.white),
                      Text('استعادة', style: TextStyle(color: Theme.of(context).colorScheme.surface, fontSize: 11, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                secondaryBackground: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  color: Colors.red.shade700,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.delete_forever_outlined, color: Colors.white),
                      Text('حذف نهائي', style: TextStyle(color: Theme.of(context).colorScheme.surface, fontSize: 11, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                confirmDismiss: (direction) async {
                  if (direction == DismissDirection.startToEnd) {
                    // Swipe right -> Restore
                    await ref.read(messagesControllerProvider.notifier).restoreConversation(conv.id);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('تمت استعادة محادثة ${conv.companyName}')),
                      );
                    }
                    return true;
                  } else {
                    // Swipe left -> Delete permanently
                    final confirm = await _showDeleteConfirmDialog(context, conv.companyName);
                    if (confirm) {
                      await ref.read(messagesControllerProvider.notifier).deleteConversation(conv.id);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('تم حذف محادثة ${conv.companyName} نهائياً')),
                        );
                      }
                      return true;
                    }
                    return false;
                  }
                },
                child: ConversationCard(
                  conversation: conv,
                  onTap: () {
                    if (conv.type == ConversationType.support) {
                      context.push('/messages/support/${conv.id}');
                    } else {
                      context.push('/messages/chat/${conv.id}');
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<bool> _showDeleteConfirmDialog(BuildContext context, String companyName) async {
    return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('حذف محادثة مؤرشفة', textAlign: TextAlign.right),
            content: Text(
              'هل أنت متأكد من حذف محادثة $companyName نهائياً وبشكل دائم؟ لا يمكن التراجع عن هذا الإجراء.',
              textAlign: TextAlign.right,
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text('إلغاء')),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () => Navigator.pop(ctx, true),
                child: Text('حذف نهائي', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ) ??
        false;
  }
}


