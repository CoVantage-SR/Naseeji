import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_factory/core/theme/app_colors.dart';
import '../../domain/entities/conversation.dart';
import '../controllers/messages_controller.dart';

class ChatSettingsScreen extends ConsumerStatefulWidget {
  final String conversationId;

  const ChatSettingsScreen({super.key, required this.conversationId});

  @override
  ConsumerState<ChatSettingsScreen> createState() => _ChatSettingsScreenState();
}

class _ChatSettingsScreenState extends ConsumerState<ChatSettingsScreen> {
  Conversation? _conversation;

  // Local state for notifications and privacy settings (mocked & interactive)
  bool _enableNotifications = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;

  bool _readReceipts = true;
  bool _onlineStatus = true;
  bool _typingIndicator = true;

  @override
  void initState() {
    super.initState();
    _loadConversation();
  }

  void _loadConversation() {
    final stateAsync = ref.read(messagesControllerProvider);
    stateAsync.whenData((state) {
      final conv = state.conversations.where((c) => c.id == widget.conversationId).firstOrNull;
      if (mounted && conv != null) {
        setState(() {
          _conversation = conv;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(messagesControllerProvider, (prev, next) {
      next.whenData((state) {
        final conv = state.conversations.where((c) => c.id == widget.conversationId).firstOrNull;
        if (mounted && conv != null) {
          setState(() => _conversation = conv);
        }
      });
    });

    final conv = _conversation;
    if (conv == null) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0.5,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.onSurface),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'تفاصيل المحادثة',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Theme.of(context).colorScheme.onSurface),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            // Company Header card
            _buildCompanyHeader(conv),
            SizedBox(height: 16),

            // Group: Conversation Settings
            _buildSectionHeader('المحادثة'),
            _buildGroupCard([
              _buildSettingTile(
                icon: Icons.volume_off_outlined,
                label: 'كتم الإشعارات',
                trailing: Text(conv.isMuted ? 'مكتوم' : 'نشط', style: TextStyle(color: conv.isMuted ? Colors.red : Colors.green, fontSize: 12, fontWeight: FontWeight.bold)),
                onTap: () => _showMuteDurationsSheet(context, conv),
              ),
              _buildSettingTile(
                icon: Icons.push_pin_outlined,
                label: 'تثبيت المحادثة',
                trailing: Switch(
                  value: conv.isPinned,
                  activeTrackColor: AppColors.primary,
                  onChanged: (val) async {
                    final success = await ref.read(messagesControllerProvider.notifier).pinConversation(conv.id, val);
                    if (!context.mounted) return;
                    if (!success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('تم الوصول للحد الأقصى للمحادثات المثبتة (٣ محادثات)')),
                      );
                    }
                  },
                ),
              ),
              _buildSettingTile(
                icon: Icons.archive_outlined,
                label: 'أرشفة المحادثة',
                onTap: () => _confirmArchive(context, conv),
              ),
              _buildSettingTile(
                icon: Icons.delete_outline,
                label: 'حذف المحادثة',
                labelColor: Colors.red,
                iconColor: Colors.red,
                onTap: () => _confirmDelete(context, conv),
              ),
              _buildSettingTile(
                icon: conv.isBlocked ? Icons.lock_open : Icons.block,
                label: conv.isBlocked ? 'إلغاء حظر العميل' : 'حظر العميل المشتري',
                labelColor: conv.isBlocked ? Colors.green : Colors.red,
                iconColor: conv.isBlocked ? Colors.green : Colors.red,
                onTap: () => _confirmBlock(context, conv),
              ),
            ]),
            SizedBox(height: 16),

            // Group: Media
            _buildSectionHeader('المرفقات والوسائط المشتركة'),
            _buildGroupCard([
              _buildSettingTile(
                icon: Icons.image_outlined,
                label: 'الصور المشتركة',
                onTap: () => context.push('/messages/chat/${conv.id}/attachments'),
              ),
              _buildSettingTile(
                icon: Icons.videocam_outlined,
                label: 'الفيديوهات المشتركة',
                onTap: () => context.push('/messages/chat/${conv.id}/attachments'),
              ),
              _buildSettingTile(
                icon: Icons.folder_open_outlined,
                label: 'الملفات والمستندات',
                onTap: () => context.push('/messages/chat/${conv.id}/attachments'),
              ),
              _buildSettingTile(
                icon: Icons.picture_as_pdf_outlined,
                label: 'ملفات PDF',
                onTap: () => context.push('/messages/chat/${conv.id}/attachments'),
              ),
            ]),
            SizedBox(height: 16),

            // Group: Business Info
            _buildSectionHeader('الأعمال والمعاملات'),
            _buildGroupCard([
              _buildSettingTile(
                icon: Icons.assignment_outlined,
                label: 'عرض طلب RFQ المرتبط',
                onTap: () => context.push('/rfq-details?rfqId=${conv.rfqNumber ?? "8820"}'),
              ),
              _buildSettingTile(
                icon: Icons.inventory_2_outlined,
                label: 'عرض تفاصيل الطلب والشحنة',
                onTap: () => context.push('/orders/order-center?rfqId=${conv.rfqNumber ?? "8820"}'),
              ),
              _buildSettingTile(
                icon: Icons.history_outlined,
                label: 'سجل مراجعات العروض المالية',
                onTap: () => context.push('/messages/chat/${conv.id}/quotation-history'),
              ),
              _buildSettingTile(
                icon: Icons.timeline_outlined,
                label: 'الخط الزمني للمفاوضات',
                onTap: () => context.push('/messages/chat/${conv.id}/timeline'),
              ),
            ]),
            SizedBox(height: 16),

            // Group: Notification Settings
            _buildSectionHeader('تفضيلات الإشعارات للمحادثة'),
            _buildGroupCard([
              _buildSettingTile(
                icon: Icons.notifications_active_outlined,
                label: 'تفعيل إشعارات الرسائل',
                trailing: Switch(
                  value: _enableNotifications,
                  activeTrackColor: AppColors.primary,
                  onChanged: (val) => setState(() => _enableNotifications = val),
                ),
              ),
              _buildSettingTile(
                icon: Icons.volume_up_outlined,
                label: 'الصوت ونغمة التنبيه',
                trailing: Switch(
                  value: _soundEnabled,
                  activeTrackColor: AppColors.primary,
                  onChanged: _enableNotifications ? (val) => setState(() => _soundEnabled = val) : null,
                ),
              ),
              _buildSettingTile(
                icon: Icons.vibration,
                label: 'الاهتزاز',
                trailing: Switch(
                  value: _vibrationEnabled,
                  activeTrackColor: AppColors.primary,
                  onChanged: _enableNotifications ? (val) => setState(() => _vibrationEnabled = val) : null,
                ),
              ),
            ]),
            SizedBox(height: 16),

            // Group: Privacy Settings
            _buildSectionHeader('الخصوصية والظهور'),
            _buildGroupCard([
              _buildSettingTile(
                icon: Icons.done_all,
                label: 'مؤشرات قراءة الرسائل (Read Receipts)',
                trailing: Switch(
                  value: _readReceipts,
                  activeTrackColor: AppColors.primary,
                  onChanged: (val) => setState(() => _readReceipts = val),
                ),
              ),
              _buildSettingTile(
                icon: Icons.visibility_outlined,
                label: 'حالة النشاط (متصل الآن)',
                trailing: Switch(
                  value: _onlineStatus,
                  activeTrackColor: AppColors.primary,
                  onChanged: (val) => setState(() => _onlineStatus = val),
                ),
              ),
              _buildSettingTile(
                icon: Icons.edit_note,
                label: 'مؤشر جاري الكتابة...',
                trailing: Switch(
                  value: _typingIndicator,
                  activeTrackColor: AppColors.primary,
                  onChanged: (val) => setState(() => _typingIndicator = val),
                ),
              ),
            ]),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildCompanyHeader(Conversation conv) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  color: Color(conv.companyLogoBgColorValue),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    conv.companyLogoText,
                    style: TextStyle(color: Theme.of(context).colorScheme.surface, fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                ),
              ),
              if (conv.isOnline)
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    border: Border.all(color: Theme.of(context).colorScheme.surface, width: 2),
                  ),
                ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                conv.companyName,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Theme.of(context).colorScheme.onSurface),
              ),
              if (conv.isVerified) ...[
                SizedBox(width: 4),
                const Icon(Icons.verified, size: 16, color: AppColors.primary),
              ],
            ],
          ),
          SizedBox(height: 4),
          Text(
            conv.isOnline ? 'نشط الآن' : 'غير متصل',
            style: TextStyle(fontSize: 12, color: conv.isOnline ? Colors.green : AppColors.outline),
          ),
          if (conv.rfqNumber != null) ...[
            SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerLow, borderRadius: BorderRadius.circular(20)),
              child: Text(
                'طلب الشراء: ${conv.rfqNumber}',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(right: 8, bottom: 8, top: 4),
      alignment: Alignment.centerRight,
      child: Text(
        title,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.outline),
      ),
    );
  }

  Widget _buildGroupCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        children: List.generate(children.length, (i) {
          if (i == children.length - 1) return children[i];
          return Column(
            children: [
              children[i],
              const Divider(height: 1, color: Color(0xFFF1F1F5), indent: 48),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String label,
    Color labelColor = AppColors.onSurface,
    Color iconColor = AppColors.primary,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      dense: true,
      onTap: onTap,
      leading: Icon(icon, color: iconColor, size: 20),
      title: Text(
        label,
        textAlign: TextAlign.right,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: labelColor),
      ),
      trailing: trailing ?? (onTap != null ? const Icon(Icons.arrow_back_ios, size: 12, color: AppColors.outline) : null),
    );
  }

  void _showMuteDurationsSheet(BuildContext context, Conversation conv) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('كتم إشعارات المحادثة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              SizedBox(height: 16),
              _buildDurationOption('٨ ساعات', const Duration(hours: 8), conv),
              _buildDurationOption('٢٤ ساعة', const Duration(days: 1), conv),
              _buildDurationOption('٧ أيام', const Duration(days: 7), conv),
              _buildDurationOption('٣٠ يوم', const Duration(days: 30), conv),
              _buildDurationOption('حتى أقوم بإعادة تفعيلها', null, conv),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDurationOption(String label, Duration? duration, Conversation conv) {
    return ListTile(
      title: Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
      onTap: () {
        ref.read(messagesControllerProvider.notifier).muteConversationForDuration(conv.id, duration);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تم كتم إشعارات المحادثة لـ $label')),
        );
      },
    );
  }

  void _confirmArchive(BuildContext context, Conversation conv) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('أرشفة المحادثة', textAlign: TextAlign.right),
        content: Text('هل تريد نقل هذه المحادثة إلى الأرشيف؟ لن تظهر في قائمة المحادثات النشطة.', textAlign: TextAlign.right),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('إلغاء')),
          ElevatedButton(
            onPressed: () {
              ref.read(messagesControllerProvider.notifier).archiveConversation(conv.id);
              Navigator.pop(ctx);
              context.pop(); // Go back from settings screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تمت أرشفة المحادثة بنجاح')),
              );
            },
            child: Text('أرشفة'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, Conversation conv) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('حذف المحادثة نهائياً', textAlign: TextAlign.right),
        content: Text('هل تريد حذف هذه المحادثة من جهازك؟ لن يؤدي هذا إلى حذفها لدى الطرف الآخر.', textAlign: TextAlign.right),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('إلغاء')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              ref.read(messagesControllerProvider.notifier).deleteConversation(conv.id);
              Navigator.pop(ctx);
              context.go('/messages'); // Go to main messages screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم حذف المحادثة')),
              );
            },
            child: Text('حذف', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _confirmBlock(BuildContext context, Conversation conv) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(conv.isBlocked ? 'إلغاء حظر العميل' : 'حظر العميل المشتري', textAlign: TextAlign.right),
        content: Text(
          conv.isBlocked
              ? 'هل تريد إلغاء حظر هذا العميل واستئناف التواصل والتبادل التجاري معه؟'
              : 'هل أنت متأكد من حظر هذا العميل؟ لن تتمكن من إرسال رسائل أو مشاركة عروض أسعار أو ملفات معه.',
          textAlign: TextAlign.right,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('إلغاء')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: conv.isBlocked ? Colors.green : Colors.red),
            onPressed: () {
              ref.read(messagesControllerProvider.notifier).blockUser(conv.id, !conv.isBlocked);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(conv.isBlocked ? 'تم إلغاء حظر العميل' : 'تم حظر العميل بنجاح')),
              );
            },
            child: Text(conv.isBlocked ? 'إلغاء الحظر' : 'تأكيد الحظر', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}


