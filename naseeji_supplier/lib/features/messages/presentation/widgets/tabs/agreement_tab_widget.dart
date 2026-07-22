import 'package:flutter/material.dart';
import 'package:naseeji_supplier/features/messages/domain/entities/deal_agreement_model.dart';

class AgreementTabWidget extends StatelessWidget {
  final DealAgreementModel agreement;

  const AgreementTabWidget({super.key, required this.agreement});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'وثيقة الاتفاق النهائي المعتمدة',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'رقم العقد الموثق: ${agreement.agreementId}',
                    style: TextStyle(fontSize: 11, color: colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.shade300),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.verified_rounded, size: 14, color: Colors.green.shade800),
                    const SizedBox(width: 4),
                    Text(
                      agreement.status,
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.green.shade900),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.green.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.gavel_rounded, color: Colors.green.shade900, size: 24),
                    const SizedBox(width: 8),
                    Text(
                      'المصادقة والضمان القانوني بالمنصة',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.green.shade900),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'تمت الموافقة على كافة الشروط والأسعار والمواعيد أدناه. يتم تفعيل الإنتاج والتسليم فور السداد في الحساب الضامن.',
                  style: TextStyle(fontSize: 12, color: Colors.green.shade900, height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          _buildInfoRow(context, label: 'إجمالي السعر النهائي:', value: '${agreement.finalTotalPrice.toStringAsFixed(0)} ${agreement.currency}'),
          const SizedBox(height: 8),
          _buildInfoRow(context, label: 'الكمية النهائية المتفق عليها:', value: '${agreement.finalQuantity} وحدة'),
          const SizedBox(height: 8),
          _buildInfoRow(context, label: 'موعد التسليم المقرر:', value: agreement.deliveryDate),
          const SizedBox(height: 8),
          _buildInfoRow(context, label: 'مكان الاستلام المحدد:', value: agreement.pickupLocation),
          const SizedBox(height: 8),
          _buildInfoRow(context, label: 'طريقة الدفع والتسديد:', value: agreement.paymentMethod),
          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: _buildApprovalBadge(
                  label: 'اعتماد المورد',
                  isApproved: agreement.isApprovedBySupplier,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildApprovalBadge(
                  label: 'اعتماد المصنع',
                  isApproved: agreement.isApprovedByFactory,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, {required String label, required String value}) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: colorScheme.outline)),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApprovalBadge({required String label, required bool isApproved}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: isApproved ? Colors.green.shade50 : Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isApproved ? Colors.green.shade300 : Colors.orange.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isApproved ? Icons.check_circle_rounded : Icons.pending_rounded,
            size: 16,
            color: isApproved ? Colors.green.shade800 : Colors.orange.shade900,
          ),
          const SizedBox(width: 6),
          Text(
            '$label: ${isApproved ? "معتمد 🟢" : "قيد التوقيع ⏳"}',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: isApproved ? Colors.green.shade900 : Colors.orange.shade900,
            ),
          ),
        ],
      ),
    );
  }
}
