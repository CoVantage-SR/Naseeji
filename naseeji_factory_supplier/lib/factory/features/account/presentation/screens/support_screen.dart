import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../domain/entities/account_entities.dart';
import '../providers/account_provider.dart';

class SupportScreen extends ConsumerWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tickets = ref.watch(supportTicketsProvider);
    final isDark = context.theme.brightness == Brightness.dark;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSecondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    return Scaffold(
      appBar: AppBar(
        title: const Text('الدعم الفني والخدمات'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          physics: const BouncingScrollPhysics(),
          children: [
            // Quick Channels Grid
            Text('قنوات التواصل المباشر', style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 15)),
            AppSpacing.hSM,
            Row(
              children: [
                Expanded(
                  child: _channelCard(
                    context,
                    icon: Icons.chat_rounded,
                    title: 'محادثة مباشرة Live Chat',
                    color: AppColors.primary,
                    onTap: () {
                      context.push('/chat');
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _channelCard(
                    context,
                    icon: Icons.support_agent_rounded,
                    title: 'مراسلة واتساب WhatsApp',
                    color: const Color(0xFF10B981),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('جاري الانتقال لواتساب الدعم الفني +201012345678...')),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _channelCard(
                    context,
                    icon: Icons.phone_in_talk_rounded,
                    title: 'اتصال هاتفي',
                    color: AppColors.info,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('جاري الاتصال برقم الخط الساخن: 19888')),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _channelCard(
                    context,
                    icon: Icons.email_rounded,
                    title: 'البريد الإلكتروني',
                    color: AppColors.secondary,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('البريد: support@naseeji.com')),
                      );
                    },
                  ),
                ),
              ],
            ),

            AppSpacing.hLG,

            // Support Tickets Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('تذاكر الدعم الفني', style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 15)),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: AppRadius.rSM),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  ),
                  icon: const Icon(Icons.add_rounded, size: 16),
                  label: const Text('تذكرة جديدة', style: TextStyle(fontSize: 12)),
                  onPressed: () => _showCreateTicketSheet(context, ref),
                ),
              ],
            ),
            AppSpacing.hSM,

            if (tickets.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text('لا توجد تذاكر دعم حالية.', style: TextStyle(color: textSecondary)),
                ),
              )
            else
              ...tickets.map((tck) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Material(
                    color: surface,
                    borderRadius: AppRadius.rMD,
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.rMD,
                      side: BorderSide(color: border),
                    ),
                    child: ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _statusColor(tck.status).withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.confirmation_number_outlined, color: _statusColor(tck.status), size: 20),
                    ),
                    title: Text(tck.subject, style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 13)),
                    subtitle: Text('${tck.id} • ${tck.category} • ${tck.createdAt}', style: TextStyle(color: textSecondary, fontSize: 11)),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: _statusColor(tck.status).withValues(alpha: 0.1),
                            borderRadius: AppRadius.rRound,
                          ),
                          child: Text(
                            tck.status,
                            style: TextStyle(color: _statusColor(tck.status), fontWeight: FontWeight.bold, fontSize: 10),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text('${tck.messagesCount} ردود', style: const TextStyle(fontSize: 9, color: Colors.grey)),
                      ],
                    ),
                    onTap: () => _showTicketDetailsModal(context, tck),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }

  Widget _channelCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    final isDark = context.theme.brightness == Brightness.dark;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;

    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.rMD,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: surface, borderRadius: AppRadius.rMD, border: Border.all(color: border)),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: AppRadius.rSM),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'جديد':
        return AppColors.info;
      case 'قيد المعالجة':
        return AppColors.warning;
      case 'مغلقة':
        return AppColors.success;
      default:
        return AppColors.primary;
    }
  }

  void _showCreateTicketSheet(BuildContext context, WidgetRef ref) {
    final subjectController = TextEditingController();
    final detailsController = TextEditingController();
    String category = 'المالية والفواتير';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: EdgeInsets.fromLTRB(16, 20, 16, MediaQuery.of(context).viewInsets.bottom + 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('إنشاء تذكرة دعم جديدة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            TextField(controller: subjectController, decoration: const InputDecoration(labelText: 'موضوع التذكرة')),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              initialValue: category,
              decoration: const InputDecoration(labelText: 'فئة المشكلة'),
              items: const [
                DropdownMenuItem(value: 'المالية والفواتير', child: Text('المالية والفواتير')),
                DropdownMenuItem(value: 'البيانات والمستندات', child: Text('البيانات والمستندات')),
                DropdownMenuItem(value: 'الصفقات والشحن', child: Text('الصفقات والشحن')),
                DropdownMenuItem(value: 'مشكلة تقنية بالتطبيق', child: Text('مشكلة تقنية بالتطبيق')),
              ],
              onChanged: (val) => category = val ?? 'المالية والفواتير',
            ),
            const SizedBox(height: 10),
            TextField(controller: detailsController, maxLines: 3, decoration: const InputDecoration(labelText: 'تفاصيل الاستفسار أو المشكلة')),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.rMD),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () {
                  if (subjectController.text.isNotEmpty) {
                    ref.read(accountNotifierProvider.notifier).createSupportTicket(
                          subjectController.text,
                          category,
                          detailsController.text,
                        );
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم إنشاء تذكرة الدعم بنجاح!')),
                    );
                  }
                },
                child: const Text('إرسال التذكرة'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTicketDetailsModal(BuildContext context, SupportTicketEntity ticket) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(ticket.id, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primary)),
                Text(ticket.status, style: TextStyle(color: _statusColor(ticket.status), fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            Text(ticket.subject, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 4),
            Text('الفئة: ${ticket.category} • إنشاء: ${ticket.createdAt}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),
            const Text('آخر الردود من الدعم الفني:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.05), borderRadius: AppRadius.rSM),
              child: const Text('أهلاً بك، جارٍ مراجعة واستيفاء المستندات المطلوبة وسيتم الإفادة بالتحديث خلال 24 ساعة.', style: TextStyle(fontSize: 12)),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}



