import 'package:naseeji_supplier/core/mock/subscription_mock.dart';
import '../../domain/repositories/subscription_repository.dart';
import '../datasources/subscription_remote_datasource.dart';

class SubscriptionRepositoryImpl implements SubscriptionRepository {
  final SubscriptionRemoteDatasource datasource;

  SubscriptionRepositoryImpl({required this.datasource});

  @override
  Future<SubscriptionModel> getSubscription() => datasource.fetchSubscription();

  @override
  Future<List<SubscriptionPlanMock>> getPlans() => datasource.fetchPlans();

  @override
  Future<List<SubscriptionInvoiceMock>> getInvoices() => datasource.fetchInvoices();

  @override
  Future<List<SubscriptionHistoryMock>> getHistory() => datasource.fetchHistory();

  @override
  Future<bool> upgradePlan(SubscriptionPlanMock plan) => datasource.upgradePlan(plan);

  @override
  Future<bool> renewSubscription() => datasource.renewSubscription();

  @override
  Future<String?> validateAddProduct() => datasource.validateAddProduct();

  @override
  Future<String?> validateMediaUpload({required String type, required int currentCount}) =>
      datasource.validateMediaUpload(type: type, currentCount: currentCount);
}
