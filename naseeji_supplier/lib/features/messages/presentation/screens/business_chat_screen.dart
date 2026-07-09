import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../../domain/entities/conversation.dart';
import '../controllers/business_chat_controller.dart';
import '../controllers/messages_controller.dart';
import 'widgets/chat_message_bubble.dart';
import 'widgets/order_status_banner.dart';
import 'widgets/business_chat_input.dart';

class BusinessChatScreen extends ConsumerStatefulWidget {
  final String conversationId;

  const BusinessChatScreen({super.key, required this.conversationId});

  @override
  ConsumerState<BusinessChatScreen> createState() => _BusinessChatScreenState();
}

class _BusinessChatScreenState extends ConsumerState<BusinessChatScreen> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Conversation? _conversation;

  @override
  void initState() {
    super.initState();
    _loadConversation();
  }

  void _loadConversation() {
    final stateAsync = ref.read(messagesControllerProvider);
    stateAsync.whenData((state) {
      final conv = state.conversations.where((c) => c.id == widget.conversationId).firstOrNull;
      if (mounted) setState(() => _conversation = conv);
    });
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final messagesAsync = ref.watch(businessChatControllerProvider(widget.conversationId));
    final conv = _conversation;

    // Listen to repository updates
    ref.listen(messagesControllerProvider, (prev, next) {
      next.whenData((state) {
        final currentConv = state.conversations.where((c) => c.id == widget.conversationId).firstOrNull;
        if (mounted && currentConv != null) {
          setState(() => _conversation = currentConv);
        }
      });
    });

    final isBlocked = conv?.isBlocked ?? false;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.onSurface),
          onPressed: () => context.pop(),
        ),
        title: GestureDetector(
          onTap: () => context.push('/messages/chat/${widget.conversationId}/settings'),
          behavior: HitTestBehavior.opaque,
          child: Row(
            children: [
              if (conv != null) ...[
                Stack(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Color(conv.companyLogoBgColorValue),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          conv.companyLogoText,
                          style: TextStyle(color: Theme.of(context).colorScheme.surface, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                    ),
                    if (conv.isOnline)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                            border: Border.all(color: Theme.of(context).colorScheme.surface, width: 1.5),
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              conv.companyName,
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Theme.of(context).colorScheme.onSurface),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (conv.isVerified)
                            Padding(
                              padding: EdgeInsets.only(left: 4),
                              child: Icon(Icons.verified, size: 13, color: AppColors.primary),
                            ),
                        ],
                      ),
                      Row(
                        children: [
                          if (conv.isOnline)
                            Text('متاح الآن', style: TextStyle(fontSize: 10, color: Colors.green))
                          else
                            Text('غير متاح', style: TextStyle(fontSize: 10, color: AppColors.outline)),
                          if (conv.rfqNumber != null) ...[
                            Text(' · ', style: TextStyle(color: AppColors.outline, fontSize: 10)),
                            Text(conv.rfqNumber!, style: TextStyle(fontSize: 10, color: AppColors.primary)),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Theme.of(context).colorScheme.onSurface, size: 20),
            onPressed: () => _showMoreMenu(context, conv),
          ),
        ],
      ),
      body: Column(
        children: [
          // Business Action Cards below the AppBar
          if (conv != null) _buildBusinessActions(context, conv),

          // Blocked Status Banner
          if (isBlocked)
            Container(
              width: double.infinity,
              color: Colors.red.shade50,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: Row(
                children: [
                  const Icon(Icons.block, color: Colors.red, size: 16),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'المحادثة مغلقة بسبب الحظر. لا يمكنك إرسال رسائل أو مشاركة ملفات.',
                      textAlign: TextAlign.right,
                      style: TextStyle(color: Colors.red.shade900, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),

          // Order status pipeline
          if (conv?.currentStatus != null && !isBlocked)
            OrderStatusBanner(currentStage: conv!.currentStatus!),
          // Messages list
          Expanded(
            child: messagesAsync.when(
              loading: () => Center(child: CircularProgressIndicator(color: AppColors.primary)),
              error: (e, _) => Center(child: Text('خطأ: $e')),
              data: (messages) {
                _scrollToBottom();
                if (messages.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.chat_bubble_outline, size: 64, color: AppColors.outlineVariant),
                        SizedBox(height: 12),
                        Text('لا توجد رسائل بعد', style: TextStyle(color: AppColors.outline)),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: messages.length,
                  itemBuilder: (_, i) {
                    final msg = messages[i];
                    return ChatMessageBubble(
                      message: msg,
                      conversationId: widget.conversationId,
                      onDelete: isBlocked ? null : () {
                        ref.read(businessChatControllerProvider(widget.conversationId).notifier).deleteMessage(msg.id);
                      },
                      onReact: isBlocked ? null : (emoji) {
                        ref.read(businessChatControllerProvider(widget.conversationId).notifier).addReaction(msg.id, emoji);
                      },
                    );
                  },
                );
              },
            ),
          ),
          // Input
          BusinessChatInput(
            controller: _inputController,
            isBlocked: isBlocked,
            quickReplies: const ['بالتوفيق', 'سيتم المعالجة', 'يتم المراجعة', 'تم الاستلام'],
            onQuickReply: (text) {
              ref.read(businessChatControllerProvider(widget.conversationId).notifier).sendQuickReply(text);
              _scrollToBottom();
            },
            onSend: () {
              final text = _inputController.text.trim();
              if (text.isNotEmpty) {
                ref.read(businessChatControllerProvider(widget.conversationId).notifier).sendTextMessage(text);
                _inputController.clear();
                _scrollToBottom();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBusinessActions(BuildContext context, Conversation conv) {
    final double cardWidth = (MediaQuery.of(context).size.width - 48) / 4;
    return Container(
      color: Theme.of(context).colorScheme.surface,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildActionItem(
            icon: Icons.request_quote_outlined,
            label: 'إرسال عرض',
            color: const Color(0xFF0040E0),
            bgColor: const Color(0xFFEEF2FF),
            width: cardWidth,
            onTap: conv.isBlocked
                ? null
                : () => context.push('/orders/create-quotation?rfqId=${conv.rfqNumber ?? "8820"}&conversationId=${conv.id}'),
          ),
          _buildActionItem(
            icon: Icons.inventory_2_outlined,
            label: 'عرض الطلب',
            color: const Color(0xFF006B5F),
            bgColor: const Color(0xFFE6F4F1),
            width: cardWidth,
            onTap: () => context.push('/orders/order-center?rfqId=${conv.rfqNumber ?? "8820"}'),
          ),
          _buildActionItem(
            icon: Icons.timeline_outlined,
            label: 'الخط الزمني',
            color: const Color(0xFF993100),
            bgColor: const Color(0xFFFFF2EB),
            width: cardWidth,
            onTap: () => context.push('/messages/chat/${conv.id}/timeline'),
          ),
          _buildActionItem(
            icon: Icons.attach_file,
            label: 'الملفات',
            color: Colors.purple,
            bgColor: const Color(0xFFFAF5FF),
            width: cardWidth,
            onTap: () => context.push('/messages/chat/${conv.id}/attachments'),
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem({
    required IconData icon,
    required String label,
    required Color color,
    required Color bgColor,
    required double width,
    required VoidCallback? onTap,
  }) {
    final bool disabled = onTap == null;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Opacity(
        opacity: disabled ? 0.5 : 1.0,
        child: Container(
          width: width,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 20),
              SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  color: disabled ? AppColors.outline : color,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMoreMenu(BuildContext context, Conversation? conv) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.outlineVariant, borderRadius: BorderRadius.circular(2))),
              SizedBox(height: 8),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _MenuItem(icon: Icons.business_outlined, label: 'عرض الملف الشخصي للشركة', color: AppColors.primary, onTap: () { Navigator.pop(context); context.push('/profile/public-preview'); }),
                      _MenuItem(icon: Icons.inventory_2_outlined, label: 'عرض تفاصيل الطلب', color: AppColors.secondary, onTap: () { Navigator.pop(context); context.push('/orders/order-center?rfqId=${conv?.rfqNumber ?? "8820"}'); }),
                      _MenuItem(icon: Icons.search, label: 'البحث في المحادثة', color: Theme.of(context).colorScheme.onSurfaceVariant, onTap: () { Navigator.pop(context); context.push('/messages/search?conversationId=${widget.conversationId}'); }),
                      _MenuItem(icon: Icons.volume_off_outlined, label: 'كتم الإشعارات', color: AppColors.outline, onTap: () { Navigator.pop(context); if (conv != null) _showMuteDialog(context, conv); }),
                      _MenuItem(icon: Icons.push_pin_outlined, label: conv?.isPinned == true ? 'إلغاء التثبيت' : 'تثبيت المحادثة', color: AppColors.outline, onTap: () { Navigator.pop(context); if (conv != null) _togglePin(context, conv); }),
                      _MenuItem(icon: Icons.archive_outlined, label: 'أرشفة المحادثة', color: AppColors.outline, onTap: () { Navigator.pop(context); if (conv != null) _confirmArchive(context, conv); }),
                      _MenuItem(icon: Icons.block, label: conv?.isBlocked == true ? 'إلغاء حظر المستخدم' : 'حظر المستخدم', color: Colors.red, onTap: () { Navigator.pop(context); if (conv != null) _confirmBlock(context, conv); }),
                      _MenuItem(icon: Icons.delete_outline, label: 'حذف المحادثة', color: Colors.red, onTap: () { Navigator.pop(context); if (conv != null) _confirmDelete(context, conv); }),
                      _MenuItem(icon: Icons.flag_outlined, label: 'إبلاغ عن إساءة', color: Colors.red, onTap: () { Navigator.pop(context); if (conv != null) _showReportDialog(context, conv); }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMuteDialog(BuildContext context, Conversation conv) {
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
              ListTile(title: Text('٨ ساعات', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)), onTap: () => _applyMute(context, conv, const Duration(hours: 8), '٨ ساعات')),
              ListTile(title: Text('٢٤ ساعة', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)), onTap: () => _applyMute(context, conv, const Duration(days: 1), '٢٤ ساعة')),
              ListTile(title: Text('٧ أيام', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)), onTap: () => _applyMute(context, conv, const Duration(days: 7), '٧ أيام')),
              ListTile(title: Text('٣٠ يوم', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)), onTap: () => _applyMute(context, conv, const Duration(days: 30), '٣٠ يوم')),
              ListTile(title: Text('حتى أقوم بإعادة تفعيلها', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)), onTap: () => _applyMute(context, conv, null, 'تفعيل يدوي')),
            ],
          ),
        ),
      ),
    );
  }

  void _applyMute(BuildContext context, Conversation conv, Duration? duration, String label) {
    ref.read(messagesControllerProvider.notifier).muteConversationForDuration(conv.id, duration);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تم كتم المحادثة لـ $label')));
  }

  void _togglePin(BuildContext context, Conversation conv) async {
    final success = await ref.read(messagesControllerProvider.notifier).pinConversation(conv.id, !conv.isPinned);
    if (!context.mounted) return;
    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم الوصول للحد الأقصى للمحادثات المثبتة (٣ محادثات)')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(conv.isPinned ? 'تم إلغاء التثبيت' : 'تم تثبيت المحادثة بنجاح')));
    }
  }

  void _confirmArchive(BuildContext context, Conversation conv) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('أرشفة المحادثة', textAlign: TextAlign.right),
        content: Text('هل تريد نقل هذه المحادثة إلى الأرشيف؟', textAlign: TextAlign.right),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('إلغاء')),
          ElevatedButton(
            onPressed: () {
              ref.read(messagesControllerProvider.notifier).archiveConversation(conv.id);
              Navigator.pop(ctx);
              context.pop();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم نقل المحادثة إلى الأرشيف')));
            },
            child: Text('أرشفة'),
          ),
        ],
      ),
    );
  }

  void _confirmBlock(BuildContext context, Conversation conv) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(conv.isBlocked ? 'إلغاء الحظر' : 'تأكيد الحظر', textAlign: TextAlign.right),
        content: Text(
          conv.isBlocked ? 'هل تريد إلغاء حظر التواصل مع هذا المصنع؟' : 'عند حظر هذا المصنع، لن تتمكن من إرسال رسائل أو مشاركة ملفات أو عروض أسعار معه.',
          textAlign: TextAlign.right,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('إلغاء')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: conv.isBlocked ? Colors.green : Colors.red),
            onPressed: () {
              ref.read(messagesControllerProvider.notifier).blockUser(conv.id, !conv.isBlocked);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(conv.isBlocked ? 'تم إلغاء الحظر' : 'تم حظر العميل بنجاح')));
            },
            child: Text(conv.isBlocked ? 'تفعيل التواصل' : 'حظر العميل', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, Conversation conv) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('حذف المحادثة', textAlign: TextAlign.right),
        content: Text('هل تريد حذف هذه المحادثة من جهازك نهائياً؟ لن يتم حذفها لدى المصنع الآخر.', textAlign: TextAlign.right),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('إلغاء')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              ref.read(messagesControllerProvider.notifier).deleteConversation(conv.id);
              Navigator.pop(ctx);
              context.go('/messages');
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم حذف المحادثة')));
            },
            child: Text('حذف للكل', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showReportDialog(BuildContext context, Conversation conv) {
    final reasons = ['احتيال / معاملة مريبة', 'كلام غير لائق', 'انتحال صفة', 'أخرى'];
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('إبلاغ عن مستخدم', textAlign: TextAlign.right),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: reasons.map((r) => ListTile(
            title: Text(r, textAlign: TextAlign.right, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            onTap: () {
              Navigator.pop(ctx);
              showDialog(
                context: context,
                builder: (ctx2) => AlertDialog(
                  content: Text('تم استلام بلاغك بنجاح. سيقوم فريق المراجعة بمراجعته واتخاذ الإجراء اللازم.', textAlign: TextAlign.center),
                  actions: [TextButton(onPressed: () => Navigator.pop(ctx2), child: Text('موافق'))],
                ),
              );
            },
          )).toList(),
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _MenuItem({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(label, textAlign: TextAlign.right, style: TextStyle(color: color == AppColors.outline ? Theme.of(context).colorScheme.onSurface : color)),
      onTap: onTap,
    );
  }
}
