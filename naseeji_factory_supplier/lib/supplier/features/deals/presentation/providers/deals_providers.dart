import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/deals_repository_impl.dart';
import '../../domain/entities/deal_model.dart';
import '../../domain/services/deal_service.dart';
import '../../domain/services/quotation_service.dart';
import '../../domain/services/negotiation_service.dart';
import '../../domain/services/agreement_service.dart';
import '../../domain/services/production_service.dart';
import '../../domain/services/delivery_service.dart';
import '../../domain/services/quality_service.dart';
import '../../domain/services/payment_service.dart';

// Single Repository Provider
final dealsRepositoryProvider = Provider<DealsRepository>((ref) {
  return DealsRepositoryImpl();
});

// Domain Services Providers
final dealServiceProvider = Provider<DealService>((ref) {
  return DealService(ref.watch(dealsRepositoryProvider));
});

final quotationServiceProvider = Provider<QuotationService>((ref) {
  return QuotationService(ref.watch(dealsRepositoryProvider));
});

final negotiationServiceProvider = Provider<NegotiationService>((ref) {
  return NegotiationService(ref.watch(dealsRepositoryProvider));
});

final agreementServiceProvider = Provider<AgreementService>((ref) {
  return AgreementService(ref.watch(dealsRepositoryProvider));
});

final productionServiceProvider = Provider<ProductionService>((ref) {
  return ProductionService(ref.watch(dealsRepositoryProvider));
});

final deliveryServiceProvider = Provider<DeliveryService>((ref) {
  return DeliveryService(ref.watch(dealsRepositoryProvider));
});

final qualityServiceProvider = Provider<QualityService>((ref) {
  return QualityService(ref.watch(dealsRepositoryProvider));
});

final paymentServiceProvider = Provider<PaymentService>((ref) {
  return PaymentService(ref.watch(dealsRepositoryProvider));
});

// State Filters
final dealStatusFilterProvider = StateProvider<DealStatus?>((ref) => null);
final dealSearchQueryProvider = StateProvider<String>((ref) => '');
final onlyActionRequiredProvider = StateProvider<bool>((ref) => false);

// 1. dealsProvider
final dealsProvider = FutureProvider<List<DealModel>>((ref) async {
  final service = ref.watch(dealServiceProvider);
  final status = ref.watch(dealStatusFilterProvider);
  final query = ref.watch(dealSearchQueryProvider);
  final actionOnly = ref.watch(onlyActionRequiredProvider);

  return service.getDeals(
    statusFilter: status,
    searchQuery: query,
    onlyActionRequired: actionOnly,
  );
});

// 2. dealDetailsProvider
final dealDetailsProvider = FutureProvider.family<DealModel, String>((ref, dealId) async {
  final service = ref.watch(dealServiceProvider);
  return service.getDealById(dealId);
});

// 3. dealStatusProvider
final dealStatusProvider = Provider.family<DealStatus, String>((ref, dealId) {
  final dealAsync = ref.watch(dealDetailsProvider(dealId));
  return dealAsync.maybeWhen(
    data: (d) => d.status,
    orElse: () => DealStatus.newDeal,
  );
});

// 4. quotationProvider
final quotationProvider = Provider.family<QuotationData?, String>((ref, dealId) {
  final dealAsync = ref.watch(dealDetailsProvider(dealId));
  return dealAsync.maybeWhen(
    data: (d) => d.quotation,
    orElse: () => null,
  );
});

// 5. negotiationProvider
final negotiationProvider = Provider.family<NegotiationData?, String>((ref, dealId) {
  final dealAsync = ref.watch(dealDetailsProvider(dealId));
  return dealAsync.maybeWhen(
    data: (d) => d.negotiation,
    orElse: () => null,
  );
});

// 6. agreementProvider
final agreementProvider = Provider.family<AgreementData?, String>((ref, dealId) {
  final dealAsync = ref.watch(dealDetailsProvider(dealId));
  return dealAsync.maybeWhen(
    data: (d) => d.agreement,
    orElse: () => null,
  );
});

// 7. productionProvider
final productionProvider = Provider.family<ProductionData?, String>((ref, dealId) {
  final dealAsync = ref.watch(dealDetailsProvider(dealId));
  return dealAsync.maybeWhen(
    data: (d) => d.production,
    orElse: () => null,
  );
});

// 8. deliveryProvider
final deliveryProvider = Provider.family<DeliveryData?, String>((ref, dealId) {
  final dealAsync = ref.watch(dealDetailsProvider(dealId));
  return dealAsync.maybeWhen(
    data: (d) => d.delivery,
    orElse: () => null,
  );
});

// 9. qualityProvider
final qualityProvider = Provider.family<QualityData?, String>((ref, dealId) {
  final dealAsync = ref.watch(dealDetailsProvider(dealId));
  return dealAsync.maybeWhen(
    data: (d) => d.quality,
    orElse: () => null,
  );
});

// 10. paymentProvider
final paymentProvider = Provider.family<PaymentData?, String>((ref, dealId) {
  final dealAsync = ref.watch(dealDetailsProvider(dealId));
  return dealAsync.maybeWhen(
    data: (d) => d.payment,
    orElse: () => null,
  );
});


