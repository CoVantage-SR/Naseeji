import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_factory/supplier/features/deals/domain/entities/deal_model.dart';
import 'package:naseeji_factory/supplier/features/deals/presentation/controllers/deals_controller.dart';
import 'package:naseeji_factory/supplier/features/deals/presentation/providers/deals_providers.dart';
import 'package:naseeji_factory/supplier/features/messages/presentation/controllers/deal_workspace_controller.dart';

class QuickActionsWidget extends ConsumerWidget {
  final DealModel deal;

  const QuickActionsWidget({super.key, required this.deal});

  void _showSubmitQuotationSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _SubmitQuotationModal(
        deal: deal,
        onSubmit: ({
          required double unitPrice,
          required int quantity,
          required String productionLeadTime,
          required String validityPeriod,
          required String paymentTerms,
          required String deliveryTerms,
          String? notes,
        }) async {
          final workspaceController = ref.read(dealWorkspaceControllerProvider(deal.id).notifier);
          final success = await workspaceController.submitNewOfferVersion(
            unitPrice: unitPrice,
            quantity: quantity,
            productionLeadTime: productionLeadTime,
            validityPeriod: validityPeriod,
            paymentTerms: paymentTerms,
            deliveryTerms: deliveryTerms,
            notes: notes,
          );

          await ref.read(dealsControllerProvider.notifier).sendQuotation(
            dealId: deal.id,
            unitPrice: unitPrice,
            quantity: quantity,
            productionDays: 7,
            paymentTerms: paymentTerms,
            notes: notes,
          );
          ref.read(dealsControllerProvider.notifier).updateDealStatus(deal.id, DealStatus.quotationSent);
          ref.invalidate(dealDetailsProvider(deal.id));
          ref.invalidate(dealsProvider);

          if (context.mounted) {
            if (success) {
              showDialog(
                context: context,
                builder: (ctx) => _InAppNotificationDialog(
                  title: 'إشعار جديد: تم إرسال العرض V1 🔔',
                  message:
                      'تم تسجيل وإرسال عرض السعر الأول للمصنع (${deal.factoryInfo.name}) بقيمة ${(unitPrice * quantity).toStringAsFixed(0)} ج.م.\n\nالصفقة الآن في حالة: (في انتظار مراجعة ورد المصنع ⏳). سينفتح مركز التفاوض والشات فور طلب المصنع للتعديل.',
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('حدث خطأ أثناء إرسال عرض السعر'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        },
      ),
    );
  }

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
            offset: const Offset(0, -3),
          ),
        ],
        border: Border(
          top: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.4)),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Chat Icon Shortcut Button
            InkWell(
              onTap: () {
                if (deal.status == DealStatus.newDeal || deal.status == DealStatus.waitingSupplierReview) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('يرجى تقديم عرض السعر الأول (V1) أولاً للبدء في الصفقة 📄'),
                    ),
                  );
                } else if (deal.status == DealStatus.quotationSent) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('عرض السعر مرسل وفي انتظار المصنع ⏳ الشات يتفعل عند طلب المصنع للتعديل.'),
                    ),
                  );
                } else {
                  context.push('/messages/chat?dealId=${deal.id}');
                }
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.forum_outlined,
                  color: colorScheme.primary,
                  size: 22,
                ),
              ),
            ),
            const SizedBox(width: 10),

            // Primary Action Button
            Expanded(
              child: _buildPrimaryActionButton(context, ref),
            ),
            const SizedBox(width: 10),

            // More Options Popup Menu
            Container(
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(12),
              ),
              child: PopupMenuButton<String>(
                icon: Icon(Icons.more_vert_rounded, color: colorScheme.onSurface, size: 22),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                onSelected: (action) => _handleAction(context, ref, action),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'open_chat',
                    child: Row(
                      children: [
                        Icon(Icons.chat_rounded, color: Color(0xFF006B5F), size: 18),
                        SizedBox(width: 8),
                        Text('الانتقال إلى المحادثة المباشرة 💬'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(value: 'contact_support', child: Text('الدعم الفني والنزاعات')),
                  const PopupMenuItem(value: 'download_pdf', child: Text('تحميل وثيقة الصفقة PDF')),
                  const PopupMenuItem(
                    value: 'cancel_deal',
                    child: Text('إلغاء الصفقة', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
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
          onPressed: () => _showSubmitQuotationSheet(context, ref),
          icon: const Icon(Icons.send_rounded, size: 18),
          label: const Text(
            'تقديم عرض السعر الأول (V1)',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: Colors.white,
            minimumSize: const Size(0, 48),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 1,
          ),
        );

      case DealStatus.quotationSent:
        return ElevatedButton.icon(
          onPressed: () async {
            // Trigger simulation: Factory sends a counter offer to start negotiation
            final controller = ref.read(dealWorkspaceControllerProvider(deal.id).notifier);
            await controller.sendFactoryCounterOffer(
              unitPrice: 42.0,
              quantity: 10000,
              productionLeadTime: '٥ أيام عمل',
              paymentTerms: '٤٠٪ مقدم + ٦٠٪ عند الاستلام بالضمين',
              deliveryTerms: 'تسليم بمستودع المصنع',
              notes: 'طلب المصنع تخفيض سعر الكجم إلى 42 ج.م وتقليل مدة التسليم إلى 5 أيام.',
            );
            ref.read(dealsControllerProvider.notifier).updateDealStatus(deal.id, DealStatus.negotiation);
            ref.invalidate(dealDetailsProvider(deal.id));

            if (context.mounted) {
              showDialog(
                context: context,
                builder: (ctx) => _InAppNotificationDialog(
                  title: 'إشعار جديد: طلب تعديل المصنع 💬',
                  message:
                      'قام المصنع (${deal.factoryInfo.name}) بطلب تعديل العرض على السعر والكمية والخصم!\n\nتم فتح مركز المفاوضات والشات للمورد بنجاح.',
                ),
              ).then((_) {
                if (context.mounted) {
                  context.push('/messages/chat?dealId=${deal.id}');
                }
              });
            }
          },
          icon: const Icon(Icons.hourglass_bottom_rounded, size: 18),
          label: const Text(
            'في انتظار طلب تفاوض المصنع ⏳ (انقر للمحاكاة)',
            style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber.shade800,
            foregroundColor: Colors.white,
            minimumSize: const Size(0, 48),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );

      case DealStatus.negotiation:
        return ElevatedButton.icon(
          onPressed: () => context.push('/messages/chat?dealId=${deal.id}'),
          icon: const Icon(Icons.rule_folder_outlined, size: 18),
          label: const Text(
            'الرد على طلب تعديل المصنع',
            style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple.shade700,
            foregroundColor: Colors.white,
            minimumSize: const Size(0, 48),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );

      case DealStatus.agreementPending:
        return ElevatedButton.icon(
          onPressed: () {
            ref.read(dealsControllerProvider.notifier).signAgreement(deal.id);
            context.push('/messages/chat?dealId=${deal.id}');
          },
          icon: const Icon(Icons.draw_rounded, size: 18),
          label: const Text(
            'توقيع العقد الإلكتروني ✍️',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green.shade700,
            foregroundColor: Colors.white,
            minimumSize: const Size(0, 48),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );

      case DealStatus.signed:
        return ElevatedButton.icon(
          onPressed: () {
            ref.read(dealsControllerProvider.notifier).updateDealStatus(deal.id, DealStatus.production);
            context.push('/messages/chat?dealId=${deal.id}');
          },
          icon: const Icon(Icons.precision_manufacturing_outlined, size: 18),
          label: const Text(
            'بدء خطوط الإنتاج 🏭',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF06B6D4),
            foregroundColor: Colors.white,
            minimumSize: const Size(0, 48),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );

      case DealStatus.production:
        return ElevatedButton.icon(
          onPressed: () => context.push('/messages/chat?dealId=${deal.id}'),
          icon: const Icon(Icons.sync_rounded, size: 18),
          label: const Text(
            'تحديث نسب الإنتاج والتصنيع',
            style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: Colors.white,
            minimumSize: const Size(0, 48),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );

      case DealStatus.readyForDelivery:
        return ElevatedButton.icon(
          onPressed: () => context.push('/messages/chat?dealId=${deal.id}'),
          icon: const Icon(Icons.local_shipping_outlined, size: 18),
          label: const Text(
            'تحديد بيانات وتسليم الشحنة',
            style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF14B8A6),
            foregroundColor: Colors.white,
            minimumSize: const Size(0, 48),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );

      case DealStatus.delivering:
        return ElevatedButton.icon(
          onPressed: () {
            ref.read(dealsControllerProvider.notifier).updateDealStatus(deal.id, DealStatus.qualityInspection);
            context.push('/messages/chat?dealId=${deal.id}');
          },
          icon: const Icon(Icons.fact_check_outlined, size: 18),
          label: const Text(
            'تأكيد الوصول وبدء الفحص',
            style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFEAB308),
            foregroundColor: Colors.black,
            minimumSize: const Size(0, 48),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );

      case DealStatus.qualityInspection:
        return ElevatedButton.icon(
          onPressed: () => context.push('/messages/chat?dealId=${deal.id}'),
          icon: const Icon(Icons.check_circle_outline, size: 18),
          label: const Text(
            'مراجعة نتائج الجودة المعملية',
            style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            minimumSize: const Size(0, 48),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );

      case DealStatus.paymentPending:
        return ElevatedButton.icon(
          onPressed: () {
            ref.read(dealsControllerProvider.notifier).releasePayment(deal.id);
            context.push('/messages/chat?dealId=${deal.id}');
          },
          icon: const Icon(Icons.account_balance_wallet_outlined, size: 18),
          label: const Text(
            'الإفراج عن الدفعة للمحفظة 💰',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green.shade800,
            foregroundColor: Colors.white,
            minimumSize: const Size(0, 48),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );

      case DealStatus.completed:
        return OutlinedButton.icon(
          onPressed: () => context.push('/messages/chat?dealId=${deal.id}'),
          icon: const Icon(Icons.star_outline_rounded, size: 18),
          label: const Text('تقييم المصنع ⭐', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(0, 48),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );

      case DealStatus.cancelled:
      case DealStatus.dispute:
        return OutlinedButton.icon(
          onPressed: () => context.push('/messages/chat?dealId=${deal.id}'),
          icon: const Icon(Icons.gavel_outlined, size: 18),
          label: const Text('متابعة قسم النزاعات', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(0, 48),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
    }
  }

  void _handleAction(BuildContext context, WidgetRef ref, String action) {
    if (action == 'open_chat') {
      context.push('/messages/chat?dealId=${deal.id}');
    } else if (action == 'cancel_deal') {
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

// ─── System In-App Notification Alert Dialog ─────────────────────────────────
class _InAppNotificationDialog extends StatelessWidget {
  final String title;
  final String message;

  const _InAppNotificationDialog({
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.notifications_active_rounded, color: Colors.green.shade700, size: 32),
              ),
              const SizedBox(height: 14),
              Text(
                title,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                message,
                style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant, height: 1.4),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(0, 44),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('موافق (إغلاق الإشعار)'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Modal Sheet for Submitting Quotation V1 / New Version ─────────────────
class _SubmitQuotationModal extends StatefulWidget {
  final DealModel deal;
  final Function({
    required double unitPrice,
    required int quantity,
    required String productionLeadTime,
    required String validityPeriod,
    required String paymentTerms,
    required String deliveryTerms,
    String? notes,
  }) onSubmit;

  const _SubmitQuotationModal({
    required this.deal,
    required this.onSubmit,
  });

  @override
  State<_SubmitQuotationModal> createState() => _SubmitQuotationModalState();
}

class _SubmitQuotationModalState extends State<_SubmitQuotationModal> {
  late final TextEditingController _priceCtrl;
  late final TextEditingController _qtyCtrl;
  late final TextEditingController _leadTimeCtrl;
  late final TextEditingController _validityCtrl;
  late final TextEditingController _paymentCtrl;
  late final TextEditingController _deliveryCtrl;
  late final TextEditingController _notesCtrl;

  @override
  void initState() {
    super.initState();
    _priceCtrl = TextEditingController(text: widget.deal.product.unitPrice.toStringAsFixed(0));
    _qtyCtrl = TextEditingController(text: widget.deal.product.quantity.toString());
    _leadTimeCtrl = TextEditingController(text: '٧ أيام عمل');
    _validityCtrl = TextEditingController(text: '١٥ يوم من تاريخ العرض');
    _paymentCtrl = TextEditingController(text: '٥٠٪ دفعة مقدمة + ٥٠٪ عند الاستلام بالحساب الضامن');
    _deliveryCtrl = TextEditingController(text: 'تسليم بمستودع المصنع مباشرة');
    _notesCtrl = TextEditingController(text: 'العرض شامل التعبئة والتغليف واختبارات الجودة ISO.');
  }

  @override
  void dispose() {
    _priceCtrl.dispose();
    _qtyCtrl.dispose();
    _leadTimeCtrl.dispose();
    _validityCtrl.dispose();
    _paymentCtrl.dispose();
    _deliveryCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.request_quote_outlined, color: colorScheme.primary, size: 22),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'تقديم عرض السعر الأول (Quotation V1)',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'أدخل بنود عرض السعر لطلب المصنع (${widget.deal.factoryInfo.name}). سيتم إرساله رسمياً وبدء الصفقة.',
                style: TextStyle(fontSize: 11, color: colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _priceCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'سعر الوحدة (ج.م)',
                        prefixIcon: Icon(Icons.sell_outlined, size: 18),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _qtyCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'الكمية الإجمالية',
                        prefixIcon: Icon(Icons.shopping_bag_outlined, size: 18),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _leadTimeCtrl,
                      decoration: const InputDecoration(
                        labelText: 'مدة الإنتاج والتصنيع',
                        prefixIcon: Icon(Icons.timer_outlined, size: 18),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _validityCtrl,
                      decoration: const InputDecoration(
                        labelText: 'مدة صلاحية العرض',
                        prefixIcon: Icon(Icons.event_available_outlined, size: 18),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              TextField(
                controller: _paymentCtrl,
                decoration: const InputDecoration(
                  labelText: 'طريقة وشروط الدفع',
                  prefixIcon: Icon(Icons.payment_outlined, size: 18),
                ),
              ),
              const SizedBox(height: 10),

              TextField(
                controller: _deliveryCtrl,
                decoration: const InputDecoration(
                  labelText: 'طريقة ومكان التسليم',
                  prefixIcon: Icon(Icons.local_shipping_outlined, size: 18),
                ),
              ),
              const SizedBox(height: 10),

              TextField(
                controller: _notesCtrl,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'ملاحظات وشروط إضافية للمصنع',
                  prefixIcon: Icon(Icons.note_alt_outlined, size: 18),
                ),
              ),
              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    final price = double.tryParse(_priceCtrl.text) ?? widget.deal.product.unitPrice;
                    final qty = int.tryParse(_qtyCtrl.text) ?? widget.deal.product.quantity;

                    Navigator.pop(context);

                    widget.onSubmit(
                      unitPrice: price,
                      quantity: qty,
                      productionLeadTime: _leadTimeCtrl.text.trim(),
                      validityPeriod: _validityCtrl.text.trim(),
                      paymentTerms: _paymentCtrl.text.trim(),
                      deliveryTerms: _deliveryCtrl.text.trim(),
                      notes: _notesCtrl.text.trim(),
                    );
                  },
                  icon: const Icon(Icons.send_rounded, size: 18),
                  label: const Text('اعتماد وإرسال عرض السعر الأول (V1)'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(0, 46),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



