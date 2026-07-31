import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/reusable_widgets.dart';
import '../providers/chat_provider.dart';

/// 1. OrderStatusCardWidget
class OrderStatusCardWidget extends StatelessWidget {
  final Conversation conversation;

  const OrderStatusCardWidget({super.key, required this.conversation});

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    String statusText;
    switch (conversation.negotiationStatus) {
      case 'agreed':
        statusColor = AppColors.success;
        statusText = 'تم الاتفاق النهائي';
        break;
      case 'rejected':
        statusColor = AppColors.error;
        statusText = 'مغلق / مرفوض';
        break;
      case 'negotiating':
        statusColor = AppColors.secondary;
        statusText = 'قيد التفاوض';
        break;
      case 'open':
      default:
        statusColor = AppColors.info;
        statusText = 'تواصل أولي';
        break;
    }

    return PrimaryCard(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.request_quote_rounded, color: statusColor, size: 20),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'طلب عرض السعر: ${conversation.rfqId}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                  ),
                  if (conversation.orderId != null)
                    Text(
                      'أمر الشراء: ${conversation.orderId}',
                      style: const TextStyle(color: Colors.grey, fontSize: 9),
                    )
                  else
                    const Text(
                      'لم يتحول لأمر شراء بعد',
                      style: TextStyle(color: Colors.grey, fontSize: 9),
                    ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              StatusChip(label: statusText, color: statusColor),
              if (conversation.lastNegotiatedPrice > 0) ...[
                const SizedBox(width: 6),
                Text(
                  '${conversation.lastNegotiatedPrice.toInt()} ج.م',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: statusColor),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

/// 2. NegotiationTimelineWidget
class NegotiationTimelineWidget extends StatelessWidget {
  final String status;
  final bool hasOrderId;

  const NegotiationTimelineWidget({
    super.key,
    required this.status,
    required this.hasOrderId,
  });

  @override
  Widget build(BuildContext context) {
    final steps = [
      {'title': 'طلب السعر', 'done': true},
      {'title': 'عروض المورد', 'done': true},
      {'title': 'مفاوضات', 'done': status == 'negotiating' || status == 'agreed'},
      {'title': 'اتفاق', 'done': status == 'agreed'},
      {'title': 'إنتاج', 'done': hasOrderId},
    ];

    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      alignment: Alignment.center,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: steps.length,
        separatorBuilder: (context, index) => Container(
          width: 20,
          height: 2,
          color: (steps[index]['done'] as bool) && (steps[index + 1]['done'] as bool)
              ? AppColors.success
              : Colors.grey.shade300,
          margin: const EdgeInsets.only(top: 15),
        ),
        itemBuilder: (context, index) {
          final step = steps[index];
          final done = step['done'] as bool;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: done ? AppColors.success : Colors.grey.shade200,
                child: done
                    ? const Icon(Icons.check_rounded, color: Colors.white, size: 12)
                    : Text(
                        '${index + 1}',
                        style: const TextStyle(fontSize: 10, color: Colors.grey),
                      ),
              ),
              const SizedBox(height: 4),
              Text(
                step['title'] as String,
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: done ? FontWeight.bold : FontWeight.normal,
                  color: done ? AppColors.success : Colors.grey,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// 3. MessageBubbleWidget
class MessageBubbleWidget extends StatelessWidget {
  final Message message;
  final VoidCallback onAcceptQuotation;
  final VoidCallback onRejectQuotation;
  final VoidCallback onEditQuotation;

  const MessageBubbleWidget({
    super.key,
    required this.message,
    required this.onAcceptQuotation,
    required this.onRejectQuotation,
    required this.onEditQuotation,
  });

  @override
  Widget build(BuildContext context) {
    final isMe = message.senderType == 'factory';
    final isSys = message.senderType == 'system';
    final isDark = context.theme.brightness == Brightness.dark;

    if (isSys) {
      return Center(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.grey.withValues(alpha: 0.1),
            borderRadius: AppRadius.rRound,
          ),
          child: Text(
            message.content,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    if (message.type == 'quotation') {
      return _buildQuotationCard(context);
    }

    final bubbleBg = isMe
        ? AppColors.primary
        : (isDark ? AppColors.borderDark : Colors.grey.shade100);

    final textColor = isMe
        ? Colors.white
        : context.colorScheme.onSurface;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
            decoration: BoxDecoration(
              color: bubbleBg,
              borderRadius: BorderRadius.only(
                topLeft: AppRadius.rMD.topLeft,
                topRight: AppRadius.rMD.topRight,
                bottomLeft: isMe ? AppRadius.rMD.bottomLeft : Radius.zero,
                bottomRight: isMe ? Radius.zero : AppRadius.rMD.bottomRight,
              ),
            ),
            child: Text(
              message.content,
              style: TextStyle(color: textColor, fontSize: 12, height: 1.4),
            ),
          ),
          const SizedBox(height: 2),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Text(
              message.time,
              style: const TextStyle(color: Colors.grey, fontSize: 8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuotationCard(BuildContext context) {
    final isMe = message.senderType == 'factory';

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: 0.04),
        borderRadius: AppRadius.rLG,
        border: Border.all(color: AppColors.secondary.withValues(alpha: 0.2), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'عرض سعر فني - إصدار #${message.quotationVersion}',
                style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.secondary, fontSize: 12),
              ),
              const Icon(Icons.request_quote_rounded, color: AppColors.secondary, size: 20),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(),
          const SizedBox(height: 8),
          _buildItem('سعر الوحدة المقترح', '${message.quotationPrice?.toInt()} ج.م'),
          _buildItem('الحد الأدنى للطلب (MOQ)', '${message.quotationMoq} وحدة'),
          _buildItem('زمن التجهيز والشحن', '${message.quotationPrepDays} أيام تجهيز + ${message.quotationShippingDays} شحن'),
          _buildItem('شروط السداد والدفع', message.quotationPayment ?? 'غير محدد'),
          _buildItem('ضمان الجودة والتغطية', message.quotationWarranty ?? 'غير محدد'),
          _buildItem('العرض ساري حتى تاريخ', message.quotationExpiry ?? 'غير محدد'),
          if (message.quotationNotes != null && message.quotationNotes!.isNotEmpty)
            _buildItem('ملاحظات المورد', message.quotationNotes!),
          const SizedBox(height: 12),
          if (!isMe)
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onRejectQuotation,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      side: const BorderSide(color: AppColors.error),
                      shape: RoundedRectangleBorder(borderRadius: AppRadius.rMD),
                    ),
                    child: const Text('رفض', style: TextStyle(fontSize: 11)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: onEditQuotation,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(borderRadius: AppRadius.rMD),
                    ),
                    child: const Text('مفاوضة وسعر بديل', style: TextStyle(fontSize: 10)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onAcceptQuotation,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: AppRadius.rMD),
                    ),
                    child: const Text('قبول واعتماد', style: TextStyle(fontSize: 11)),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.left,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }
}



