import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import 'widgets/timeline_event_tile.dart';

class ChatTimelineScreen extends StatelessWidget {
  final String conversationId;

  const ChatTimelineScreen({super.key, required this.conversationId});

  static const List<_TimelineStage> _stages = [
    _TimelineStage(
      label: 'طلب عرض (RFQ)',
      icon: Icons.request_quote_outlined,
      timestamp: '2024-07-01 09:00',
      user: 'مصنع الرياض للملابس',
      notes: 'طلب 5,000 متر قطن 100% — RFQ-8820',
      isCompleted: true,
    ),
    _TimelineStage(
      label: 'تقديم عرض أسعار',
      icon: Icons.price_check_outlined,
      timestamp: '2024-07-01 09:30',
      user: 'مورد نسيجي',
      notes: 'تقديم العرض الأول بسعر 12.50 ر.س/م',
      isCompleted: true,
    ),
    _TimelineStage(
      label: 'عرض مضاد',
      icon: Icons.swap_horiz,
      timestamp: '2024-07-01 10:00',
      user: 'مصنع الرياض للملابس',
      notes: 'طلب تخفيض إلى 11.80 ر.س/م',
      isCompleted: true,
    ),
    _TimelineStage(
      label: 'تعديل العرض',
      icon: Icons.edit_outlined,
      timestamp: '2024-07-01 11:00',
      user: 'مورد نسيجي',
      notes: 'تعديل العرض إلى 12.00 ر.س/م — مقبول',
      isCompleted: true,
    ),
    _TimelineStage(
      label: 'الاتفاق النهائي',
      icon: Icons.handshake_outlined,
      timestamp: '2024-07-01 11:30',
      user: 'كلا الطرفين',
      notes: 'توقيع الاتفاقية — ORD-2241 تم إنشاؤه',
      isCompleted: true,
    ),
    _TimelineStage(
      label: 'التصنيع',
      icon: Icons.factory_outlined,
      timestamp: '2024-07-03 08:00',
      user: 'مورد نسيجي',
      notes: 'بدء الإنتاج — 65% مكتمل',
      isActive: true,
    ),
    _TimelineStage(
      label: 'الشحن',
      icon: Icons.local_shipping_outlined,
      timestamp: '--',
      user: '--',
    ),
    _TimelineStage(
      label: 'الاستلام',
      icon: Icons.inventory_2_outlined,
      timestamp: '--',
      user: '--',
    ),
    _TimelineStage(
      label: 'الدفع',
      icon: Icons.payments_outlined,
      timestamp: '--',
      user: '--',
    ),
    _TimelineStage(
      label: 'مكتمل',
      icon: Icons.check_circle_outline,
      timestamp: '--',
      user: '--',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
        title: const Text('الخط الزمني', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.share_outlined), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: List.generate(_stages.length, (i) {
            final stage = _stages[i];
            return TimelineEventTile(
              stage: stage.label,
              timestamp: stage.timestamp,
              user: stage.user,
              notes: stage.notes,
              isActive: stage.isActive,
              isCompleted: stage.isCompleted,
              icon: stage.icon,
              isLast: i == _stages.length - 1,
            );
          }),
        ),
      ),
    );
  }
}

class _TimelineStage {
  final String label;
  final IconData icon;
  final String timestamp;
  final String user;
  final String? notes;
  final bool isActive;
  final bool isCompleted;

  const _TimelineStage({
    required this.label,
    required this.icon,
    required this.timestamp,
    required this.user,
    this.notes,
    this.isActive = false,
    this.isCompleted = false,
  });
}
