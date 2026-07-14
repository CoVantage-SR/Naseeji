import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/reusable_widgets.dart';
import '../providers/rfq_provider.dart';

/// 1. RFQCardWidget
class RFQCardWidget extends StatelessWidget {
  final RFQ rfq;
  final VoidCallback onTap;

  const RFQCardWidget({
    super.key,
    required this.rfq,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    String statusText;
    switch (rfq.status) {
      case 'open':
        statusColor = AppColors.info;
        statusText = 'مفتوح';
        break;
      case 'negotiation':
        statusColor = AppColors.secondary;
        statusText = 'تفاوض';
        break;
      case 'approved':
        statusColor = AppColors.success;
        statusText = 'موافق عليه';
        break;
      case 'rejected':
        statusColor = AppColors.error;
        statusText = 'مرفوض / ملغي';
        break;
      case 'expired':
      default:
        statusColor = Colors.grey;
        statusText = 'منتهي الصلاحية';
        break;
    }

    Color priorityColor;
    String priorityText;
    switch (rfq.priority) {
      case 'high':
        priorityColor = AppColors.error;
        priorityText = 'عالي الأهمية ⚡';
        break;
      case 'medium':
        priorityColor = AppColors.secondary;
        priorityText = 'متوسط';
        break;
      case 'low':
      default:
        priorityColor = AppColors.info;
        priorityText = 'منخفض';
        break;
    }

    return PrimaryCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                rfq.id,
                style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 13),
              ),
              Row(
                children: [
                  StatusChip(label: priorityText, color: priorityColor),
                  const SizedBox(width: 6),
                  StatusChip(label: statusText, color: statusColor),
                ],
              ),
            ],
          ),
          AppSpacing.hSM,
          Text(
            rfq.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'التصنيف: ${rfq.category}',
            style: const TextStyle(color: Colors.grey, fontSize: 11),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem('الموردين المدعوين', '${rfq.invitedSuppliersCount} مورد'),
              _buildStatItem('العروض المستلمة', '${rfq.receivedQuotesCount} عرض', isHighlighted: rfq.receivedQuotesCount > 0),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'تاريخ الإنشاء: ${rfq.createdDate}',
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
              Text(
                'ينتهي: ${rfq.expiryDate}',
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, {bool isHighlighted = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isHighlighted ? AppColors.success : null,
          ),
        ),
      ],
    );
  }
}

/// 2. FloatingCreateRFQButton
class FloatingCreateRFQButton extends StatelessWidget {
  final VoidCallback onTap;

  const FloatingCreateRFQButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: onTap,
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      icon: const Icon(Icons.add_rounded),
      label: const Text('طلب عرض سعر جديد (RFQ)'),
      shape: RoundedRectangleBorder(borderRadius: AppRadius.rLG),
    );
  }
}
