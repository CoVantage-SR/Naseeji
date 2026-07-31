import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/extensions/context_extensions.dart';
import '../../../../../../core/widgets/reusable_widgets.dart';
import '../providers/quotations_provider.dart';

/// 1. PriceInformationWidget
class PriceInformationWidget extends StatelessWidget {
  final Quotation quotation;

  const PriceInformationWidget({super.key, required this.quotation});

  @override
  Widget build(BuildContext context) {
    return PrimaryCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'معلومات السعر والحد الأدنى للطلب',
            style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary),
          ),
          const SizedBox(height: 6),
          const Divider(),
          const SizedBox(height: 8),
          _buildRow('السعر المعروض للوحدة', '${quotation.quotedPricePerUnit.toInt()} ${quotation.currency}'),
          _buildRow('الحد الأدنى للطلب (MOQ)', '${quotation.moq} وحدة'),
          _buildRow('تاريخ تقديم العرض', quotation.offerDate),
          _buildRow('صلاحية العرض حتى', quotation.validUntil),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.left,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

/// 2. DeliveryInformationWidget
class DeliveryInformationWidget extends StatelessWidget {
  final Quotation quotation;

  const DeliveryInformationWidget({super.key, required this.quotation});

  @override
  Widget build(BuildContext context) {
    return PrimaryCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'شروط التسليم والضمان والتغليف',
            style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          const Divider(),
          const SizedBox(height: 8),
          _buildRow('زمن تحضير الخامات بالمخازن', '${quotation.prepTimeDays} أيام عمل'),
          _buildRow('زمن الشحن والتوصيل المتوقع', '${quotation.shippingTimeDays} أيام'),
          _buildRow('مدة الضمان المقدمة', quotation.warranty),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.left,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

/// 3. PaymentInformationWidget
class PaymentInformationWidget extends StatelessWidget {
  final Quotation quotation;

  const PaymentInformationWidget({super.key, required this.quotation});

  @override
  Widget build(BuildContext context) {
    return PrimaryCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'شروط الدفع والتسوية',
            style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            quotation.paymentMethod,
            style: const TextStyle(fontSize: 12, height: 1.4),
          ),
        ],
      ),
    );
  }
}
