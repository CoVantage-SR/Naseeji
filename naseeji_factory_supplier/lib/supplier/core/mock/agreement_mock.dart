import '../../features/messages/domain/entities/deal_agreement_model.dart';

class AgreementMock {
  final String agreementId;
  final String dealId;
  final double finalTotalPrice;
  final String currency;
  final int finalQuantity;
  final String deliveryDate;
  final String pickupLocation;
  final String paymentMethod;
  final String status;
  final bool isApprovedBySupplier;
  final bool isApprovedByFactory;
  final DateTime approvedAt;

  const AgreementMock({
    required this.agreementId,
    required this.dealId,
    required this.finalTotalPrice,
    this.currency = 'ج.م',
    required this.finalQuantity,
    required this.deliveryDate,
    required this.pickupLocation,
    required this.paymentMethod,
    required this.status,
    required this.isApprovedBySupplier,
    required this.isApprovedByFactory,
    required this.approvedAt,
  });

  DealAgreementModel toDomain() {
    return DealAgreementModel(
      agreementId: agreementId,
      finalTotalPrice: finalTotalPrice,
      currency: currency,
      finalQuantity: finalQuantity,
      deliveryDate: deliveryDate,
      pickupLocation: pickupLocation,
      paymentMethod: paymentMethod,
      status: status,
      isApprovedBySupplier: isApprovedBySupplier,
      isApprovedByFactory: isApprovedByFactory,
      approvedAt: approvedAt,
    );
  }

  static final sampleAgreements = [
    AgreementMock(
      agreementId: 'AGR-9920',
      dealId: 'DEAL-101',
      finalTotalPrice: 430000.0,
      finalQuantity: 10000,
      deliveryDate: '٢٨ يوليو ٢٠٢٦',
      pickupLocation: 'مخزن المحلة الكبرى - المنطقة الصناعية الأولى',
      paymentMethod: 'نظام الدفع الضامن المنفذ عبر المنصة (Escrow)',
      status: 'بانتظار الاعتماد النهائي من المصنع 🟢',
      isApprovedBySupplier: true,
      isApprovedByFactory: false,
      approvedAt: DateTime.now().subtract(const Duration(hours: 1)),
    ),
  ];
}


