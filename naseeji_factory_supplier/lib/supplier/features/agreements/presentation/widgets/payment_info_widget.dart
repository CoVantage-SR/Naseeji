import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/agreement_model.dart';

class PaymentInfoWidget extends StatelessWidget {
  final PaymentInfo payment;

  const PaymentInfoWidget({super.key, required this.payment});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
          ),
        ],
        border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.payment_outlined, color: AppColors.primary, size: 18),
              const SizedBox(width: 8),
              Text(
                'القسم الثالث: شروط وبنود الدفع',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(height: 1),
          const SizedBox(height: 12),

          _buildRowItem(context, label: 'طريقة الدفع المعتمدة:', value: payment.method, isBold: true),
          const SizedBox(height: 8),
          _buildRowItem(context, label: 'نسبة الدفعة المقدمة:', value: '${payment.advancePercentage}% من الإجمالي'),
          const SizedBox(height: 8),
          _buildRowItem(
            context,
            label: 'قيمة الدفعة المقدمة:',
            value: '${payment.advanceAmount} ${payment.currency}',
            isPrimary: true,
          ),
          const SizedBox(height: 8),
          _buildRowItem(context, label: 'موعد سداد الدفعة:', value: payment.paymentDueDate),
          const SizedBox(height: 8),
          _buildRowItem(
            context,
            label: 'المبلغ المتبقي المؤجل:',
            value: '${payment.remainingAmount} ${payment.currency}',
            isWarning: true,
          ),
        ],
      ),
    );
  }

  Widget _buildRowItem(
    BuildContext context, {
    required String label,
    required String value,
    bool isBold = false,
    bool isPrimary = false,
    bool isWarning = false,
  }) {
    final theme = Theme.of(context);
    Color color = theme.colorScheme.onSurface;
    if (isPrimary) color = AppColors.primary;
    if (isWarning) color = const Color(0xFFD97706); // Amber/Orange

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.outline,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: isBold || isPrimary || isWarning ? FontWeight.bold : FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}


