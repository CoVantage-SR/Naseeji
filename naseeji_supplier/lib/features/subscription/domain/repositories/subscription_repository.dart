import 'package:naseeji_supplier/core/mock/subscription_mock.dart';

abstract class SubscriptionRepository {
  Future<SubscriptionModel> getSubscription();
  Future<List<SubscriptionPlanMock>> getPlans();
  Future<List<SubscriptionInvoiceMock>> getInvoices();
  Future<List<SubscriptionHistoryMock>> getHistory();
  Future<bool> upgradePlan(SubscriptionPlanMock plan);
  Future<bool> renewSubscription();
  Future<String?> validateAddProduct();
  Future<String?> validateMediaUpload({required String type, required int currentCount});
}
