import '../entities/financial_models.dart';

abstract class FinancialRepository {
  Future<FinancialDashboardData> getDashboardData();
  Future<List<FinancialTransaction>> getTransactions();
  Future<List<SupplierPayment>> getPayments();
  Future<WalletData> getWalletData();
  Future<List<WithdrawalRequest>> getWithdrawals();
  Future<void> requestWithdrawal(WithdrawalRequest request);
  Future<void> cancelWithdrawal(String id);
  Future<List<SupplierInvoice>> getInvoices();
  Future<List<RefundRequest>> getRefunds();
  Future<EscrowTracking> getEscrowTracking(String orderNumber);
  Future<FinancialAnalyticsData> getAnalytics();
  Future<TaxCenterData> getTaxData();
  Future<List<PaymentMethod>> getPaymentMethods();
  Future<void> addPaymentMethod(PaymentMethod method);
  Future<void> deletePaymentMethod(String id);
  Future<void> setDefaultPaymentMethod(String id);
  Future<void> verifyPaymentMethod(String id);
  Future<List<FinancialReport>> getReports();
}

