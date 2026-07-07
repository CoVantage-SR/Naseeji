import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/business_chat_controller.dart';
import '../../../domain/entities/business_message.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import 'quotation_card.dart';
import 'counter_offer_card.dart';
import 'agreement_card.dart';
import 'production_card.dart';
import 'shipment_card.dart';
import 'delivery_card.dart';
import 'payment_card.dart';

class ChatMessageBubble extends ConsumerWidget {
  final BusinessMessage message;
  final String? conversationId;
  final VoidCallback? onDelete;
  final Function(String emoji)? onReact;

  const ChatMessageBubble({
    super.key,
    required this.message,
    this.conversationId,
    this.onDelete,
    this.onReact,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (message.isDeleted) {
      return _DeletedBubble(isOutgoing: message.isOutgoing);
    }

    // Route business card types
    switch (message.type) {
      case MessageType.quotationCard:
        return _BubbleWrapper(
          isOutgoing: message.isOutgoing,
          time: message.time,
          readStatus: message.readStatus,
          child: QuotationCard(
            data: message.cardData ?? {},
            onAccept: () => _handleAccept(context, ref, message),
            onCounterOffer: () => _handleCounterOffer(context, ref, message),
            onViewDetails: () => _handleViewDetails(context, message),
          ),
        );
      case MessageType.counterOfferCard:
        return _BubbleWrapper(
          isOutgoing: message.isOutgoing,
          time: message.time,
          readStatus: message.readStatus,
          child: CounterOfferCard(data: message.cardData ?? {}),
        );
      case MessageType.agreementCard:
        return _BubbleWrapper(
          isOutgoing: message.isOutgoing,
          time: message.time,
          readStatus: message.readStatus,
          child: AgreementCard(data: message.cardData ?? {}),
        );
      case MessageType.productionCard:
        return _BubbleWrapper(
          isOutgoing: message.isOutgoing,
          time: message.time,
          readStatus: message.readStatus,
          child: ProductionCard(data: message.cardData ?? {}),
        );
      case MessageType.shipmentCard:
        return _BubbleWrapper(
          isOutgoing: message.isOutgoing,
          time: message.time,
          readStatus: message.readStatus,
          child: ShipmentCard(data: message.cardData ?? {}),
        );
      case MessageType.deliveryCard:
        return _BubbleWrapper(
          isOutgoing: message.isOutgoing,
          time: message.time,
          readStatus: message.readStatus,
          child: DeliveryCard(data: message.cardData ?? {}),
        );
      case MessageType.paymentCard:
        return _BubbleWrapper(
          isOutgoing: message.isOutgoing,
          time: message.time,
          readStatus: message.readStatus,
          child: PaymentCard(data: message.cardData ?? {}),
        );
      case MessageType.timelineEvent:
        return _TimelineEventBubble(message: message);
      default:
        return _TextBubble(message: message, onDelete: onDelete, onReact: onReact);
    }
  }

  void _handleAccept(BuildContext context, WidgetRef ref, BusinessMessage message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('قبول عرض السعر', textAlign: TextAlign.right),
        content: const Text('هل أنت متأكد من قبول هذا العرض المالي وتوقيع الاتفاقية؟', textAlign: TextAlign.right),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(businessChatControllerProvider(conversationId ?? 'conv_001').notifier).acceptQuotation(message.id);
            },
            child: const Text('موافق وقبول'),
          ),
        ],
      ),
    );
  }

  void _handleCounterOffer(BuildContext context, WidgetRef ref, BusinessMessage message) {
    final priceCtrl = TextEditingController();
    final reasonCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تقديم عرض مضاد', textAlign: TextAlign.right),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: priceCtrl,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.right,
              decoration: const InputDecoration(labelText: 'السعر المقترح للوحدة (ر.س)'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: reasonCtrl,
              textAlign: TextAlign.right,
              decoration: const InputDecoration(labelText: 'سبب تقديم العرض المضاد'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () {
              final price = priceCtrl.text.trim();
              final reason = reasonCtrl.text.trim();
              if (price.isNotEmpty && reason.isNotEmpty) {
                Navigator.pop(ctx);
                ref.read(businessChatControllerProvider(conversationId ?? 'conv_001').notifier).sendCounterOfferCard(
                  counterPrice: price,
                  currentPrice: message.cardData?['unitPrice'] ?? '12.00',
                  reason: reason,
                );
              }
            },
            child: const Text('إرسال العرض'),
          ),
        ],
      ),
    );
  }

  void _handleViewDetails(BuildContext context, BusinessMessage message) {
    final data = message.cardData ?? {};
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('تفاصيل وثيقة عرض السعر', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.primary)),
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 10),
              _buildDetailRow('اسم المنتج المقترن', data['productName'] ?? 'خيوط غزل القطن الفاخر'),
              _buildDetailRow('الكمية الإجمالية', '${data['quantity'] ?? '--'}'),
              _buildDetailRow('سعر الوحدة المعروض', '${data['unitPrice'] ?? '--'} ر.س'),
              _buildDetailRow('القيمة الإجمالية التقديرية', '${data['totalPrice'] ?? '--'}'),
              _buildDetailRow('طريقة السداد والشروط', data['paymentTerms'] ?? '--'),
              _buildDetailRow('فترة صلاحية العرض', data['validUntil'] ?? '--'),
              _buildDetailRow('مدة الإنتاج والشحن المقدرة', data['deliveryDays'] ?? '--'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                child: const Text('إغلاق المعاينة'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: AppColors.outline)),
          Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
        ],
      ),
    );
  }
}

class _TextBubble extends StatelessWidget {
  final BusinessMessage message;
  final VoidCallback? onDelete;
  final Function(String emoji)? onReact;

  const _TextBubble({required this.message, this.onDelete, this.onReact});

  @override
  Widget build(BuildContext context) {
    final isOut = message.isOutgoing;
    return GestureDetector(
      onLongPress: () => _showContextMenu(context),
      child: Padding(
        padding: EdgeInsets.only(
          left: isOut ? 60 : 16,
          right: isOut ? 16 : 60,
          top: 3,
          bottom: 3,
        ),
        child: Column(
          crossAxisAlignment: isOut ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (message.replyToContent != null)
              Container(
                margin: const EdgeInsets.only(bottom: 4),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isOut ? Colors.white.withValues(alpha: 0.3) : AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(8),
                  border: Border(
                    right: BorderSide(
                      color: isOut ? Colors.white : AppColors.primary,
                      width: 3,
                    ),
                  ),
                ),
                child: Text(
                  message.replyToContent!,
                  style: const TextStyle(fontSize: 11, color: AppColors.outline),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isOut ? null : Colors.white,
                gradient: isOut
                    ? LinearGradient(
                        colors: [
                          AppColors.primary,
                          AppColors.primary.withValues(alpha: 0.85),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(isOut ? 20 : 4),
                  bottomRight: Radius.circular(isOut ? 4 : 20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: (isOut ? AppColors.primary : Colors.black).withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    message.content,
                    style: TextStyle(
                      fontSize: 14,
                      color: isOut ? Colors.white : AppColors.onSurface,
                      height: 1.4,
                    ),
                  ),
                  if (message.isEdited)
                    Text(
                      'تم التعديل',
                      style: TextStyle(
                        fontSize: 10,
                        color: isOut ? Colors.white54 : AppColors.outline,
                      ),
                    ),
                ],
              ),
            ),
            if (message.reaction != null)
              Container(
                margin: const EdgeInsets.only(top: 2),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.outlineVariant),
                ),
                child: Text(message.reaction!, style: const TextStyle(fontSize: 14)),
              ),
            const SizedBox(height: 2),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message.time,
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColors.outline.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (isOut) ...[
                  const SizedBox(width: 4),
                  Icon(
                    message.readStatus == ReadStatus.read
                        ? Icons.done_all
                        : message.readStatus == ReadStatus.delivered
                            ? Icons.done_all
                            : Icons.done,
                    size: 13,
                    color: message.readStatus == ReadStatus.read
                        ? Colors.blue
                        : AppColors.outline.withValues(alpha: 0.6),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showContextMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Reactions row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: ['👍', '❤️', '😂', '😮', '😢', '🙏'].map((e) => InkWell(
                onTap: () {
                  onReact?.call(e);
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(e, style: const TextStyle(fontSize: 26)),
                ),
              )).toList(),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.copy_outlined, color: AppColors.primary),
              title: const Text('نسخ'),
              onTap: () {
                Clipboard.setData(ClipboardData(text: message.content));
                Navigator.pop(context);
              },
            ),
            if (message.isOutgoing)
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: const Text('حذف الرسالة', style: TextStyle(color: Colors.red)),
                onTap: () {
                  onDelete?.call();
                  Navigator.pop(context);
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _BubbleWrapper extends StatelessWidget {
  final bool isOutgoing;
  final String time;
  final ReadStatus readStatus;
  final Widget child;

  const _BubbleWrapper({
    required this.isOutgoing,
    required this.time,
    required this.readStatus,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Column(
        crossAxisAlignment: isOutgoing ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          child,
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(time, style: const TextStyle(fontSize: 10, color: AppColors.outline)),
              if (isOutgoing) ...[
                const SizedBox(width: 4),
                Icon(
                  readStatus == ReadStatus.read ? Icons.done_all : Icons.done,
                  size: 13,
                  color: readStatus == ReadStatus.read ? AppColors.secondary : AppColors.outline,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _DeletedBubble extends StatelessWidget {
  final bool isOutgoing;
  const _DeletedBubble({required this.isOutgoing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: isOutgoing ? 60 : 16,
        right: isOutgoing ? 16 : 60,
        top: 3,
        bottom: 3,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.block, size: 14, color: AppColors.outline),
            SizedBox(width: 6),
            Text(
              'تم حذف هذه الرسالة',
              style: TextStyle(fontSize: 13, color: AppColors.outline, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimelineEventBubble extends StatelessWidget {
  final BusinessMessage message;
  const _TimelineEventBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.info_outline, size: 12, color: AppColors.primary),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  message.content,
                  style: const TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                message.time,
                style: const TextStyle(fontSize: 10, color: AppColors.outline),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
