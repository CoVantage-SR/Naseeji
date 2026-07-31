class FinanceOverviewModel {
  final double pendingPayments;
  final double escrowBalance;
  final double releasedPayments;
  final double monthlyRevenue;
  final double outstandingInvoices;
  final String currency;

  const FinanceOverviewModel({
    required this.pendingPayments,
    required this.escrowBalance,
    required this.releasedPayments,
    required this.monthlyRevenue,
    required this.outstandingInvoices,
    this.currency = 'ج.م',
  });
}


