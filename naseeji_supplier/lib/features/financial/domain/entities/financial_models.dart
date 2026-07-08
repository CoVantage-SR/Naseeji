import 'package:flutter/material.dart';

enum TransactionType {
  paymentReceived,
  paymentPending,
  withdrawal,
  refund,
  platformCommission,
  advertisingFee,
  subscriptionFee,
  manualAdjustment,
  tax,
  shippingFee,
}

enum TransactionStatus {
  completed,
  pending,
  failed,
}

enum PaymentStatus {
  all,
  pending,
  processing,
  released,
  failed,
  refunded,
}

enum InvoiceStatus {
  paid,
  pending,
  overdue,
  cancelled,
}

enum WithdrawalStatus {
  pending,
  approved,
  rejected,
  completed,
}

enum EscrowStage {
  paymentReceived,
  moneyHeld,
  shipmentDelivered,
  factoryInspection,
  factoryApproval,
  paymentReleased,
}

class FinancialDashboardData {
  final double currentBalance;
  final double pendingBalance;
  final double availableBalance;
  final double frozenBalance;
  final double totalRevenue;
  final double monthlyRevenue;
  final double pendingPayments;
  final double completedPayments;
  final double outstandingInvoices;
  final double platformFees;
  final double netProfit;
  final double healthIndicator; // 0.0 to 1.0

  const FinancialDashboardData({
    required this.currentBalance,
    required this.pendingBalance,
    required this.availableBalance,
    required this.frozenBalance,
    required this.totalRevenue,
    required this.monthlyRevenue,
    required this.pendingPayments,
    required this.completedPayments,
    required this.outstandingInvoices,
    required this.platformFees,
    required this.netProfit,
    required this.healthIndicator,
  });
}

class FinancialTransaction {
  final String id;
  final String orderNumber;
  final String agreementNumber;
  final String factoryName;
  final TransactionType type;
  final double amount;
  final String currency;
  final TransactionStatus status;
  final String paymentMethod;
  final String referenceNumber;
  final DateTime createdDate;
  final DateTime? completedDate;

  const FinancialTransaction({
    required this.id,
    required this.orderNumber,
    required this.agreementNumber,
    required this.factoryName,
    required this.type,
    required this.amount,
    required this.currency,
    required this.status,
    required this.paymentMethod,
    required this.referenceNumber,
    required this.createdDate,
    this.completedDate,
  });
}

class SupplierPayment {
  final String paymentNumber;
  final String factoryName;
  final String orderNumber;
  final double amount;
  final String method;
  final PaymentStatus status;
  final DateTime releaseDate;
  final String? receiptUrl;

  const SupplierPayment({
    required this.paymentNumber,
    required this.factoryName,
    required this.orderNumber,
    required this.amount,
    required this.method,
    required this.status,
    required this.releaseDate,
    this.receiptUrl,
  });
}

class WalletData {
  final double availableBalance;
  final double pendingBalance;
  final double frozenBalance;
  final double totalEarnings;
  final double lifetimeRevenue;
  final double platformCredit;

  const WalletData({
    required this.availableBalance,
    required this.pendingBalance,
    required this.frozenBalance,
    required this.totalEarnings,
    required this.lifetimeRevenue,
    required this.platformCredit,
  });
}

class WithdrawalRequest {
  final String id;
  final String method;
  final double amount;
  final String bankName;
  final String iban;
  final String accountHolder;
  final String? notes;
  final WithdrawalStatus status;
  final DateTime createdDate;
  final DateTime? completedDate;

  const WithdrawalRequest({
    required this.id,
    required this.method,
    required this.amount,
    required this.bankName,
    required this.iban,
    required this.accountHolder,
    this.notes,
    required this.status,
    required this.createdDate,
    this.completedDate,
  });

  WithdrawalRequest copyWith({
    String? id,
    String? method,
    double? amount,
    String? bankName,
    String? iban,
    String? accountHolder,
    String? notes,
    WithdrawalStatus? status,
    DateTime? createdDate,
    DateTime? completedDate,
  }) {
    return WithdrawalRequest(
      id: id ?? this.id,
      method: method ?? this.method,
      amount: amount ?? this.amount,
      bankName: bankName ?? this.bankName,
      iban: iban ?? this.iban,
      accountHolder: accountHolder ?? this.accountHolder,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      createdDate: createdDate ?? this.createdDate,
      completedDate: completedDate ?? this.completedDate,
    );
  }
}

class InvoiceItem {
  final String name;
  final int quantity;
  final double unitPrice;
  final String unit;

  const InvoiceItem({
    required this.name,
    required this.quantity,
    required this.unitPrice,
    required this.unit,
  });
}

class SupplierInvoice {
  final String invoiceNumber;
  final String factoryName;
  final String orderNumber;
  final String agreementNumber;
  final DateTime invoiceDate;
  final DateTime dueDate;
  final double subtotal;
  final double tax;
  final double shipping;
  final double discount;
  final double grandTotal;
  final InvoiceStatus status;
  final List<InvoiceItem> items;
  final List<FinancialTransaction> paymentHistory;
  final List<String> attachments;

  const SupplierInvoice({
    required this.invoiceNumber,
    required this.factoryName,
    required this.orderNumber,
    required this.agreementNumber,
    required this.invoiceDate,
    required this.dueDate,
    required this.subtotal,
    required this.tax,
    required this.shipping,
    required this.discount,
    required this.grandTotal,
    required this.status,
    required this.items,
    required this.paymentHistory,
    required this.attachments,
  });
}

class RefundRequest {
  final String refundNumber;
  final String orderNumber;
  final String reason;
  final double amount;
  final String status; // Pending, Approved, Rejected, Completed
  final DateTime createdDate;
  final DateTime? completedDate;
  final List<String> attachments;

  const RefundRequest({
    required this.refundNumber,
    required this.orderNumber,
    required this.reason,
    required this.amount,
    required this.status,
    required this.createdDate,
    this.completedDate,
    required this.attachments,
  });
}

class EscrowTracking {
  final String orderNumber;
  final double escrowAmount;
  final double heldAmount;
  final DateTime? releaseDate;
  final EscrowStage currentStage;
  final String? reasonForHold;

  const EscrowTracking({
    required this.orderNumber,
    required this.escrowAmount,
    required this.heldAmount,
    this.releaseDate,
    required this.currentStage,
    this.reasonForHold,
  });

  EscrowTracking copyWith({
    String? orderNumber,
    double? escrowAmount,
    double? heldAmount,
    DateTime? releaseDate,
    EscrowStage? currentStage,
    String? reasonForHold,
  }) {
    return EscrowTracking(
      orderNumber: orderNumber ?? this.orderNumber,
      escrowAmount: escrowAmount ?? this.escrowAmount,
      heldAmount: heldAmount ?? this.heldAmount,
      releaseDate: releaseDate ?? this.releaseDate,
      currentStage: currentStage ?? this.currentStage,
      reasonForHold: reasonForHold ?? this.reasonForHold,
    );
  }
}

class FinancialAnalyticsData {
  final double totalRevenue;
  final double netProfit;
  final double averageOrderValue;
  final double averagePaymentTime; // in days
  final double profitMargin; // percentage (e.g. 28.4)
  final double repeatCustomerRevenue;
  final List<Map<String, dynamic>> revenueTrend;
  final List<Map<String, dynamic>> profitTrend;
  final List<Map<String, dynamic>> cashFlow;
  final List<Map<String, dynamic>> revenueByProduct;
  final List<Map<String, dynamic>> revenueByCustomer;
  final List<Map<String, dynamic>> monthlyComparison;

  // KPIs
  final double revenueGrowth; // percentage
  final double profitGrowth; // percentage
  final double averageSettlementTime; // in days
  final double collectionRate; // percentage
  final double refundRate; // percentage
  final double paymentSuccessRate; // percentage

  const FinancialAnalyticsData({
    required this.totalRevenue,
    required this.netProfit,
    required this.averageOrderValue,
    required this.averagePaymentTime,
    required this.profitMargin,
    required this.repeatCustomerRevenue,
    required this.revenueTrend,
    required this.profitTrend,
    required this.cashFlow,
    required this.revenueByProduct,
    required this.revenueByCustomer,
    required this.monthlyComparison,
    required this.revenueGrowth,
    required this.profitGrowth,
    required this.averageSettlementTime,
    required this.collectionRate,
    required this.refundRate,
    required this.paymentSuccessRate,
  });
}

class TaxCenterData {
  final String taxRegistrationNumber;
  final double vatPercentage;
  final double collectedVat;
  final double paidVat;
  final double outstandingVat;
  final List<Map<String, dynamic>> reports;
  final List<Map<String, dynamic>> documents;

  const TaxCenterData({
    required this.taxRegistrationNumber,
    required this.vatPercentage,
    required this.collectedVat,
    required this.paidVat,
    required this.outstandingVat,
    required this.reports,
    required this.documents,
  });
}

class PaymentMethod {
  final String id;
  final String type; // bank_account, instapay, digital_wallet, wire, cheque
  final String title; // Account name or number
  final String subtitle; // Bank name or wallet ID
  final String accountHolder;
  final String identifier; // IBAN or username or phone
  final bool isDefault;
  final bool isVerified;

  const PaymentMethod({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.accountHolder,
    required this.identifier,
    required this.isDefault,
    required this.isVerified,
  });

  PaymentMethod copyWith({
    String? id,
    String? type,
    String? title,
    String? subtitle,
    String? accountHolder,
    String? identifier,
    bool? isDefault,
    bool? isVerified,
  }) {
    return PaymentMethod(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      accountHolder: accountHolder ?? this.accountHolder,
      identifier: identifier ?? this.identifier,
      isDefault: isDefault ?? this.isDefault,
      isVerified: isVerified ?? this.isVerified,
    );
  }
}

class FinancialReport {
  final String id;
  final String title;
  final String type;
  final DateTime createdDate;
  final String size;

  const FinancialReport({
    required this.id,
    required this.title,
    required this.type,
    required this.createdDate,
    required this.size,
  });
}
