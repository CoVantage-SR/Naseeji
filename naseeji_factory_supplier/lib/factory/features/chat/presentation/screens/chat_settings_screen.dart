import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/reusable_widgets.dart';
import '../providers/chat_provider.dart';
import '../widgets/chat_settings_widgets.dart';

class ChatSettingsScreen extends ConsumerWidget {
  final String conversationId;

  const ChatSettingsScreen({super.key, required this.conversationId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conversation = ref.watch(chatNotifierProvider.notifier).getConversationById(conversationId);
    final notifier = ref.read(chatNotifierProvider.notifier);

    if (conversation == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('المحادثة غير موجودة.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('إعدادات المحادثة'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Supplier Summary header
              PrimaryCard(
                child: Row(
                  children: [
                    SupplierAvatar(name: conversation.supplierName, size: 44),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            conversation.supplierName,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                          Text(
                            'رقم طلب السعر المرفق: ${conversation.rfqId}',
                            style: const TextStyle(color: Colors.grey, fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              AppSpacing.hMD,
              // Settings list
              PrimaryCard(
                child: Column(
                  children: [
                    SwitchListTile(
                      value: conversation.isPinned,
                      onChanged: (_) => notifier.togglePin(conversationId),
                      activeThumbColor: AppColors.primary,
                      secondary: const Icon(Icons.push_pin_outlined, color: AppColors.primary),
                      title: const Text('تثبيت المحادثة في الأعلى', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                    const Divider(),
                    SwitchListTile(
                      value: conversation.isMuted,
                      onChanged: (_) => notifier.toggleMute(conversationId),
                      activeThumbColor: AppColors.primary,
                      secondary: const Icon(Icons.volume_off_outlined, color: AppColors.primary),
                      title: const Text('كتم الإشعارات للرسائل الجديدة', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.archive_outlined, color: AppColors.primary),
                      title: const Text('أرشفة المحادثة', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      trailing: const Icon(Icons.arrow_back_ios_new_rounded, size: 14, color: Colors.grey),
                      onTap: () {
                        notifier.toggleArchive(conversationId);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('تم نقل المحادثة للأرشيف.')),
                        );
                        context.go('/chat');
                      },
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.folder_shared_outlined, color: AppColors.primary),
                      title: const Text('عرض كافة الملفات المشتركة', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      trailing: const Icon(Icons.arrow_back_ios_new_rounded, size: 14, color: Colors.grey),
                      onTap: () => context.push('/chat/$conversationId/files'),
                    ),
                  ],
                ),
              ),
              AppSpacing.hLG,
              // Danger zone
              DangerZoneWidget(
                isBlocked: conversation.isBlocked,
                onBlockSupplier: () {
                  notifier.blockSupplier(conversationId);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(conversation.isBlocked ? 'تم إلغاء حظر المورد.' : 'تم حظر المورد.')),
                  );
                },
                onDeleteChat: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('حذف سجل المحادثة؟', style: TextStyle(fontWeight: FontWeight.bold)),
                        content: const Text('أنت بصدد حذف كافة الرسائل والاتفاقيات والملفات المشتركة بشكل نهائي. لا يمكن التراجع عن هذا الإجراء.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('تراجع'),
                          ),
                          TextButton(
                            onPressed: () {
                              notifier.deleteConversation(conversationId);
                              Navigator.of(context).pop();
                              context.go('/chat');
                            },
                            child: const Text('تأكيد الحذف', style: TextStyle(color: AppColors.error)),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}


