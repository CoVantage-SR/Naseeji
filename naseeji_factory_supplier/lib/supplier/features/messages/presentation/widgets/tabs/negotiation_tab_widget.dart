import 'package:flutter/material.dart';
import 'package:naseeji_factory/supplier/features/messages/domain/entities/deal_quotation_model.dart';
import 'negotiation_card_widget.dart';
import 'offer_history_widget.dart';
import 'request_modification_bottom_sheet.dart';

class NegotiationTabWidget extends StatelessWidget {
  final DealQuotationModel latestQuotation;
  final List<DealQuotationModel> quotationHistory;
  final VoidCallback onAccept;
  final VoidCallback onReject;
  final Function({
    required double unitPrice,
    required int quantity,
    required String productionLeadTime,
    required String validityPeriod,
    required String paymentTerms,
    required String deliveryTerms,
    DateTime? expectedDeliveryDate,
    String? notes,
  }) onSubmitNewVersion;
  final VoidCallback? onAskForClarification;
  final VoidCallback? onSimulateFactoryCounterOffer;

  const NegotiationTabWidget({
    super.key,
    required this.latestQuotation,
    required this.quotationHistory,
    required this.onAccept,
    required this.onReject,
    required this.onSubmitNewVersion,
    this.onAskForClarification,
    this.onSimulateFactoryCounterOffer,
  });

  void _showModificationBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => RequestModificationBottomSheet(
        currentQuotation: latestQuotation,
        onSubmitNewVersion: onSubmitNewVersion,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final isCounterOfferFromFactory =
        latestQuotation.createdByRole == 'المصنع' || latestQuotation.offerStatus == OfferStatus.counterOffer;

    final nextVersion = latestQuotation.versionNumber + 1;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Header
          Row(
            children: [
              Icon(Icons.handshake_outlined, color: colorScheme.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                'مركز المفاوضات وعروض الأسعار',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 13.5,
                ),
              ),
              const Spacer(),
              if (onSimulateFactoryCounterOffer != null && !isCounterOfferFromFactory)
                TextButton.icon(
                  onPressed: onSimulateFactoryCounterOffer,
                  icon: const Icon(Icons.bolt, size: 14, color: Colors.purple),
                  label: const Text(
                    'محاكاة: طلب تعديل المصنع',
                    style: TextStyle(fontSize: 10.5, color: Colors.purple, fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),

          // Current Offer Card
          NegotiationCardWidget(
            quotation: latestQuotation,
            isLatest: true,
          ),

          const SizedBox(height: 12),

          // ─── SUPPLIER ACTIONS BOX (4 BUTTONS ONLY) ───────────────────
          if (isCounterOfferFromFactory) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.purple.shade50.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.purple.shade200, width: 1.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.rule_folder_outlined, color: Colors.purple, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        'خيارات المورد للرد على طلب تعديل المصنع',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple.shade900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Button 1: Accept Counter Offer
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: onAccept,
                      icon: const Icon(Icons.check_circle_rounded, size: 16),
                      label: const Text('1. قبول عرض التعديل (Accept Counter Offer)'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade700,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(0, 40),
                        elevation: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Button 2: Reject Counter Offer
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: onReject,
                      icon: const Icon(Icons.cancel_rounded, size: 16),
                      label: const Text('2. رفض طلب التعديل (Reject Counter Offer)'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade700,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(0, 40),
                        elevation: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Button 3: Send Quotation V2 (Next Version)
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _showModificationBottomSheet(context),
                      icon: const Icon(Icons.send_rounded, size: 16),
                      label: Text('3. إرسال عرض سعر جديد (Send Quotation V$nextVersion)'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: colorScheme.primary,
                        side: BorderSide(color: colorScheme.primary, width: 1.2),
                        minimumSize: const Size(0, 40),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Button 4: Ask For Clarification
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: onAskForClarification,
                      icon: const Icon(Icons.chat_bubble_outline_rounded, size: 16),
                      label: const Text('4. طلب استيضاح في المحادثة (Ask For Clarification)'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.purple.shade900,
                        side: BorderSide(color: Colors.purple.shade300),
                        minimumSize: const Size(0, 40),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            // Status when Waiting for Factory
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.4)),
              ),
              child: Row(
                children: [
                  Icon(Icons.hourglass_bottom_rounded, color: Colors.orange.shade700, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'في انتظار مراجعة ورد المصنع ⏳',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: colorScheme.onSurface),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'المصنع يدرس عرض السعر المرفوع. لا يمكنك بدء تفاوض. ستصلك إشعارات فور طلب المصنع للتعديل.',
                          style: TextStyle(fontSize: 10.5, color: colorScheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 14),

          // Version History (Previous Versions)
          OfferHistoryWidget(quotationHistory: quotationHistory),
        ],
      ),
    );
  }
}



