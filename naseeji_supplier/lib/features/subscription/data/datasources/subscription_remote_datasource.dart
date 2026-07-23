import 'package:naseeji_supplier/core/mock/mock_data.dart';
import 'package:naseeji_supplier/core/mock/subscription_mock.dart';

abstract class SubscriptionRemoteDatasource {
  Future<SubscriptionModel> fetchSubscription();
  Future<List<SubscriptionPlanMock>> fetchPlans();
  Future<List<SubscriptionInvoiceMock>> fetchInvoices();
  Future<List<SubscriptionHistoryMock>> fetchHistory();
  Future<bool> upgradePlan(SubscriptionPlanMock plan);
  Future<bool> renewSubscription();
  Future<String?> validateAddProduct();
  Future<String?> validateMediaUpload({required String type, required int currentCount});
}

class SubscriptionRemoteDatasourceImpl implements SubscriptionRemoteDatasource {
  @override
  Future<SubscriptionModel> fetchSubscription() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return MockDatabase.getCurrentSubscription();
  }

  @override
  Future<List<SubscriptionPlanMock>> fetchPlans() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return MockDatabase.subscriptionPlans;
  }

  @override
  Future<List<SubscriptionInvoiceMock>> fetchInvoices() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return MockDatabase.subscriptionInvoices;
  }

  @override
  Future<List<SubscriptionHistoryMock>> fetchHistory() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return MockDatabase.subscriptionHistory;
  }

  @override
  Future<bool> upgradePlan(SubscriptionPlanMock plan) async {
    await Future.delayed(const Duration(milliseconds: 150));
    MockDatabase.upgradeSubscriptionPlan(plan);
    return true;
  }

  @override
  Future<bool> renewSubscription() async {
    await Future.delayed(const Duration(milliseconds: 150));
    MockDatabase.renewSubscription();
    return true;
  }

  @override
  Future<String?> validateAddProduct() async {
    return MockDatabase.validateAddProductLimits();
  }

  @override
  Future<String?> validateMediaUpload({required String type, required int currentCount}) async {
    return MockDatabase.validateMediaLimits(type: type, currentCount: currentCount);
  }
}
