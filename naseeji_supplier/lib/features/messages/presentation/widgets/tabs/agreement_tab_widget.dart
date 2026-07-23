import 'package:flutter/material.dart';
import 'package:naseeji_supplier/features/messages/domain/entities/deal_agreement_model.dart';

class AgreementTabWidget extends StatelessWidget {
  final DealAgreementModel? agreement;

  const AgreementTabWidget({super.key, this.agreement});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (agreement == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.assignment_late_outlined, size: 54, color: colorScheme.outline),
              const SizedBox(height: 12),
              Text(
                'لم يتم إنشاء عقد الاتفاق بعد',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'يتم إنشاء عقد الاتفاق الإلكتروني تلقائياً فور قبول المصنع لأحدث نسخة من عرض السعر داخل قسم التفاوض 🤝.',
                style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant, height: 1.4),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    final agr = agreement!;

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
                    'رقم العقد الموثق: ${agr.agreementId}',
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
                      agr.status,
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

          _buildInfoRow(context, label: 'إجمالي السعر النهائي:', value: '${agr.finalTotalPrice.toStringAsFixed(0)} ${agr.currency}'),
          const SizedBox(height: 8),
          _buildInfoRow(context, label: 'الكمية النهائية المتفق عليها:', value: '${agr.finalQuantity} وحدة'),
          const SizedBox(height: 8),
          _buildInfoRow(context, label: 'موعد التسليم المقرر:', value: agr.deliveryDate),
          const SizedBox(height: 8),
          _buildInfoRow(context, label: 'مكان الاستلام المحدد:', value: agr.pickupLocation),
          const SizedBox(height: 8),
          _buildInfoRow(context, label: 'طريقة الدفع والتسديد:', value: agr.paymentMethod),
          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: _buildApprovalBadge(
                  label: 'اعتماد المورد',
                  isApproved: agr.isApprovedBySupplier,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildApprovalBadge(
                  label: 'اعتماد المصنع',
                  isApproved: agr.isApprovedByFactory,
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
