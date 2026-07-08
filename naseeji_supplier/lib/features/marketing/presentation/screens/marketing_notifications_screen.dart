import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import 'package:naseeji_supplier/core/widgets/general_widgets.dart';
import '../controllers/marketing_controllers.dart';
import '../../domain/entities/marketing_models.dart';

class MarketingNotificationsScreen extends ConsumerStatefulWidget {
  const MarketingNotificationsScreen({super.key});

  @override
  ConsumerState<MarketingNotificationsScreen> createState() => _MarketingNotificationsScreenState();
}

class _MarketingNotificationsScreenState extends ConsumerState<MarketingNotificationsScreen> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();

  String _selectedAudience = 'جميع المصانع';
  String _selectedType = 'عرض ترويجي خصم';

  final List<String> _audiences = [
    'جميع المصانع',
    'المصانع من فئة VIP',
    'عملاء الشراء السابقين',
    'المصانع التي تتابع الحساب',
    'المصانع المهتمة بمنتجات مشابهة',
    'المصانع التي تمتلك طلبات تسعير RFQ مفتوحة',
    'المصانع التي زارت صفحة المنتجات'
  ];

  final List<String> _types = [
    'عرض ترويجي خصم',
    'تخفيض عام',
    'إعلان منتج جديد',
    'إعادة توفر مخزون خام',
    'عرض محدود المدة',
    'حملة موسمية خاصة'
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  void _sendNotification() {
    if (_titleController.text.isEmpty || _bodyController.text.isEmpty) return;

    final notif = MarketingNotification(
      id: '',
      title: _titleController.text,
      body: _bodyController.text,
      audienceOption: _selectedAudience,
      notificationType: _selectedType,
      sentTime: DateTime.now(),
      sentCount: 150,
      clicks: 0,
      conversions: 0,
    );

    ref.read(marketingNotificationsControllerProvider.notifier).sendNotification(notif);

    _titleController.clear();
    _bodyController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم إرسال الإشعار الترويجي للمصانع المستهدفة بنجاح!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final notifsAsync = ref.watch(marketingNotificationsControllerProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          title: const Text(
            'بث إشعارات وعروض المصانع',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.onSurface),
          ),
          centerTitle: true,
        ),
        body: Material(
          color: const Color(0xFFF8F9FF),
          child: notifsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('خطأ: $e')),
            data: (notifs) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Broadcast Form
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            'بث إشعار ترويجي B2B جديد',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.onSurface),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Divider(color: AppColors.outlineVariant),
                          ),
                          CustomTextField(
                            controller: _titleController,
                            labelText: 'عنوان التنبيه الترويجي',
                            hintText: 'مثال: خصم حصري لمصانع الملابس الجاهزة على الأزرار',
                          ),
                          const SizedBox(height: 12),
                          CustomTextField(
                            controller: _bodyController,
                            labelText: 'نص الإشعار التفصيلي الموجه للمشترين',
                            hintText: 'اكتب تفاصيل العرض التنافسي أو الميزة الإعلانية...',
                            maxLines: 3,
                          ),
                          const SizedBox(height: 12),
                          const Text('شريحة المصانع المستهدفة بالبث', style: TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant)),
                          const SizedBox(height: 6),
                          DropdownButtonFormField<String>(
                            value: _selectedAudience,
                            items: _audiences.map((aud) {
                              return DropdownMenuItem<String>(
                                value: aud,
                                child: Text(aud, style: const TextStyle(fontSize: 12), textAlign: TextAlign.right),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) setState(() => _selectedAudience = val);
                            },
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text('نوع الإشعار الترويجي بث', style: TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant)),
                          const SizedBox(height: 6),
                          DropdownButtonFormField<String>(
                            value: _selectedType,
                            items: _types.map((type) {
                              return DropdownMenuItem<String>(
                                value: type,
                                child: Text(type, style: const TextStyle(fontSize: 12), textAlign: TextAlign.right),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) setState(() => _selectedType = val);
                            },
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 20),
                          PrimaryButton(
                            onPressed: _sendNotification,
                            text: 'إرسال وتوجيه الإشعار',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Sent Log list
                    const Text(
                      'سجل التنبيهات التسويقية التي تم بثها',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.onSurface),
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: 12),
                    ...notifs.map((notif) {
                      final dateStr = '${notif.sentTime.year}/${notif.sentTime.month.toString().padLeft(2, '0')}/${notif.sentTime.day.toString().padLeft(2, '0')} ${notif.sentTime.hour.toString().padLeft(2, '0')}:${notif.sentTime.minute.toString().padLeft(2, '0')}';
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF0040E0).withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    notif.notificationType,
                                    style: const TextStyle(fontSize: 8, color: Color(0xFF0040E0), fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Text(
                                  notif.title,
                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.onSurface),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              notif.body,
                              style: const TextStyle(fontSize: 10, color: AppColors.onSurfaceVariant),
                              textAlign: TextAlign.right,
                            ),
                            const SizedBox(height: 12),
                            const Divider(color: AppColors.outlineVariant),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('النقرات: ${notif.clicks} | التحويلات: ${notif.conversions}', style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.onSurfaceVariant)),
                                Text('شريحة: ${notif.audienceOption}', style: const TextStyle(fontSize: 9, color: AppColors.onSurfaceVariant)),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'تاريخ البث: $dateStr | إجمالي البث: ${notif.sentCount} مصنع',
                              style: const TextStyle(fontSize: 9, color: AppColors.onSurfaceVariant),
                              textAlign: TextAlign.right,
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
