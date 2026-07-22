import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/entities/deal_model.dart';
import '../controllers/deals_controller.dart';

class QuickActionsWidget extends ConsumerWidget {
  final DealModel deal;

  const QuickActionsWidget({super.key, required this.deal});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
        border: Border(
          top: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: _buildPrimaryActionButton(context, ref),
            ),
            const SizedBox(width: 8),
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert_rounded, color: colorScheme.onSurface),
              onSelected: (action) => _handleAction(context, ref, action),
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'contact_support', child: Text('الدعم الفني والنزاعات')),
                const PopupMenuItem(value: 'download_pdf', child: Text('تحميل العقد PDF')),
                const PopupMenuItem(value: 'cancel_deal', child: Text('إلغاء الصفقة', style: TextStyle(color: Colors.red))),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrimaryActionButton(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    switch (deal.status) {
      case DealStatus.newDeal:
      case DealStatus.waitingSupplierReview:
        return ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.send_rounded, size: 16),
          label: const Text('تقديم عرض السعر الأول (Quotation)'),
          style: ElevatedButton.styleFrom(backgroundColor: colorScheme.primary, foregroundColor: Colors.white),
        );

      case DealStatus.negotiation:
        return ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.handshake_outlined, size: 16),
          label: const Text('الرد على عرض التفاوض المقابل'),
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8B5CF6), foregroundColor: Colors.white),
        );

      case DealStatus.agreementPending:
        return ElevatedButton.icon(
          onPressed: () => ref.read(dealsControllerProvider.notifier).signAgreement(deal.id),
          icon: const Icon(Icons.draw_rounded, size: 16),
          label: const Text('توقيع العقد الإلكتروني رسمياً ✍️'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade700, foregroundColor: Colors.white),
        );

      case DealStatus.signed:
        return ElevatedButton.icon(
          onPressed: () => ref.read(dealsControllerProvider.notifier).updateDealStatus(deal.id, DealStatus.production),
          icon: const Icon(Icons.precision_manufacturing_outlined, size: 16),
          label: const Text('البدء الفعلي لخطوط الإنتاج والتصنيع 🏭'),
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF06B6D4), foregroundColor: Colors.white),
        );

      case DealStatus.production:
        return ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.sync_rounded, size: 16),
          label: const Text('تحديث نسبة الإنجاز والإنتاج'),
          style: ElevatedButton.styleFrom(backgroundColor: colorScheme.primary, foregroundColor: Colors.white),
        );

      case DealStatus.readyForDelivery:
        return ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.local_shipping_outlined, size: 16),
          label: const Text('تحديد طريقة وتفاصيل التسليم'),
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF14B8A6), foregroundColor: Colors.white),
        );

      case DealStatus.delivering:
        return ElevatedButton.icon(
          onPressed: () => ref.read(dealsControllerProvider.notifier).updateDealStatus(deal.id, DealStatus.qualityInspection),
          icon: const Icon(Icons.fact_check_outlined, size: 16),
          label: const Text('تأكيد وصول الشحنة وبدء فحص الجودة'),
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEAB308), foregroundColor: Colors.black),
        );

      case DealStatus.qualityInspection:
        return ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.check_circle_outline, size: 16),
          label: const Text('مراجعة نتيجة الفحص والمعايرة المعملية'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
        );

      case DealStatus.paymentPending:
        return ElevatedButton.icon(
          onPressed: () => ref.read(dealsControllerProvider.notifier).releasePayment(deal.id),
          icon: const Icon(Icons.account_balance_wallet_outlined, size: 16),
          label: const Text('الإفراج عن الدفعة وتحويلها للمحفظة 💰'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade800, foregroundColor: Colors.white),
        );

      case DealStatus.completed:
        return OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.star_outline_rounded, size: 16),
          label: const Text('تقييم المصنع والمراجعة ⭐'),
        );

      case DealStatus.cancelled:
      case DealStatus.dispute:
        return OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.gavel_outlined, size: 16),
          label: const Text('متابعة قسم النزاعات'),
        );
    }
  }

  void _handleAction(BuildContext context, WidgetRef ref, String action) {
    if (action == 'cancel_deal') {
      ref.read(dealsControllerProvider.notifier).updateDealStatus(deal.id, DealStatus.cancelled);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم إلغاء الصفقة'), backgroundColor: Colors.red),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم تنفيذ الإجراء: $action')),
      );
    }
  }
}
