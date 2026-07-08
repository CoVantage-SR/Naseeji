// ignore_for_file: prefer_const_declarations

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/financial_models.dart';
import '../../domain/repositories/financial_repository.dart';

part 'financial_repository_impl.g.dart';

class FinancialRepositoryImpl implements FinancialRepository {
  // Static state to persist changes across provider rebuilds
  static const double _currentBalance = 62680.0;
  static final double _pendingBalance = 12450.0;
  static double _availableBalance = 45230.0;
  static final double _frozenBalance = 5000.0;
  static final double _totalRevenue = 154800.0;
  static final double _monthlyRevenue = 32400.0;
  static final double _pendingPaymentsCount = 3.0;
  static final double _completedPaymentsCount = 45.0;
  static final double _outstandingInvoicesSum = 8200.0;
  static final double _platformFeesSum = 11400.0;
  static final double _netProfitSum = 128400.0;

  static final List<FinancialTransaction> _transactions = [
    FinancialTransaction(
      id: 'TXN-9021',
      orderNumber: 'ORD-5541',
      agreementNumber: 'AGR-8802',
      factoryName: 'مصنع نسيج الرياض',
      type: TransactionType.paymentReceived,
      amount: 14500.0,
      currency: 'ر.س',
      status: TransactionStatus.completed,
      paymentMethod: 'مدى',
      referenceNumber: 'REF-7729831',
      createdDate: DateTime.now().subtract(const Duration(hours: 3)),
      completedDate: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    FinancialTransaction(
      id: 'TXN-9020',
      orderNumber: 'ORD-5539',
      agreementNumber: 'AGR-8801',
      factoryName: 'مصنع الأمل للمنسوجات',
      type: TransactionType.paymentPending,
      amount: 6200.0,
      currency: 'ر.س',
      status: TransactionStatus.pending,
      paymentMethod: 'تحويل بنكي',
      referenceNumber: 'REF-7729800',
      createdDate: DateTime.now().subtract(const Duration(hours: 20)),
    ),
    FinancialTransaction(
      id: 'TXN-9019',
      orderNumber: 'WTH-0042',
      agreementNumber: '',
      factoryName: 'حساب المورد البنكي',
      type: TransactionType.withdrawal,
      amount: -12000.0,
      currency: 'ر.س',
      status: TransactionStatus.completed,
      paymentMethod: 'تحويل بنكي',
      referenceNumber: 'REF-7729110',
      createdDate: DateTime.now().subtract(const Duration(days: 2)),
      completedDate: DateTime.now().subtract(const Duration(days: 2, hours: 4)),
    ),
    FinancialTransaction(
      id: 'TXN-9018',
      orderNumber: 'ORD-5510',
      agreementNumber: 'AGR-8742',
      factoryName: 'مصنع النسيج الذكي',
      type: TransactionType.platformCommission,
      amount: -725.0,
      currency: 'ر.س',
      status: TransactionStatus.completed,
      paymentMethod: 'خصم تلقائي',
      referenceNumber: 'REF-7728901',
      createdDate: DateTime.now().subtract(const Duration(days: 3)),
      completedDate: DateTime.now().subtract(const Duration(days: 3)),
    ),
    FinancialTransaction(
      id: 'TXN-9017',
      orderNumber: 'ORD-5510',
      agreementNumber: 'AGR-8742',
      factoryName: 'مصنع النسيج الذكي',
      type: TransactionType.shippingFee,
      amount: -350.0,
      currency: 'ر.س',
      status: TransactionStatus.completed,
      paymentMethod: 'خصم تلقائي',
      referenceNumber: 'REF-7728902',
      createdDate: DateTime.now().subtract(const Duration(days: 3)),
      completedDate: DateTime.now().subtract(const Duration(days: 3)),
    ),
    FinancialTransaction(
      id: 'TXN-9016',
      orderNumber: 'ORD-5488',
      agreementNumber: 'AGR-8650',
      factoryName: 'شركة مصانع الخليج',
      type: TransactionType.refund,
      amount: -4500.0,
      currency: 'ر.س',
      status: TransactionStatus.completed,
      paymentMethod: 'فيزا',
      referenceNumber: 'REF-7728612',
      createdDate: DateTime.now().subtract(const Duration(days: 5)),
      completedDate: DateTime.now().subtract(const Duration(days: 4, hours: 22)),
    ),
    FinancialTransaction(
      id: 'TXN-9015',
      orderNumber: 'AD-9921',
      agreementNumber: '',
      factoryName: 'إعلانات نسيجي المروجة',
      type: TransactionType.advertisingFee,
      amount: -500.0,
      currency: 'ر.س',
      status: TransactionStatus.completed,
      paymentMethod: 'محفظة نسيجي',
      referenceNumber: 'REF-7728001',
      createdDate: DateTime.now().subtract(const Duration(days: 7)),
      completedDate: DateTime.now().subtract(const Duration(days: 7)),
    ),
    FinancialTransaction(
      id: 'TXN-9014',
      orderNumber: 'SUB-2026',
      agreementNumber: '',
      factoryName: 'اشتراك الباقة الفضية للموردين',
      type: TransactionType.subscriptionFee,
      amount: -1500.0,
      currency: 'ر.س',
      status: TransactionStatus.completed,
      paymentMethod: 'محفظة نسيجي',
      referenceNumber: 'REF-7727192',
      createdDate: DateTime.now().subtract(const Duration(days: 15)),
      completedDate: DateTime.now().subtract(const Duration(days: 15)),
    ),
  ];

  static final List<SupplierPayment> _payments = [
    SupplierPayment(
      paymentNumber: 'PAY-8921',
      factoryName: 'مصنع نسيج الرياض',
      orderNumber: 'ORD-5541',
      amount: 14500.0,
      method: 'مدى',
      status: PaymentStatus.released,
      releaseDate: DateTime.now().subtract(const Duration(hours: 3)),
      receiptUrl: 'https://naseeji.com/receipts/pay-8921.pdf',
    ),
    SupplierPayment(
      paymentNumber: 'PAY-8920',
      factoryName: 'مصنع الأمل للمنسوجات',
      orderNumber: 'ORD-5539',
      amount: 6200.0,
      method: 'تحويل بنكي',
      status: PaymentStatus.processing,
      releaseDate: DateTime.now().add(const Duration(days: 2)),
    ),
    SupplierPayment(
      paymentNumber: 'PAY-8919',
      factoryName: 'مصنع الأقمشة المتحدة',
      orderNumber: 'ORD-5530',
      amount: 8900.0,
      method: 'فيزا',
      status: PaymentStatus.pending,
      releaseDate: DateTime.now().add(const Duration(days: 4)),
    ),
    SupplierPayment(
      paymentNumber: 'PAY-8918',
      factoryName: 'شركة مصانع الخليج',
      orderNumber: 'ORD-5488',
      amount: 4500.0,
      method: 'فيزا',
      status: PaymentStatus.refunded,
      releaseDate: DateTime.now().subtract(const Duration(days: 4)),
      receiptUrl: 'https://naseeji.com/receipts/pay-8918.pdf',
    ),
    SupplierPayment(
      paymentNumber: 'PAY-8917',
      factoryName: 'مصنع النسيج الذكي',
      orderNumber: 'ORD-5510',
      amount: 12450.0,
      method: 'مدى',
      status: PaymentStatus.failed,
      releaseDate: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];

  static final List<WithdrawalRequest> _withdrawals = [
    WithdrawalRequest(
      id: 'WTH-0043',
      method: 'تحويل بنكي',
      amount: 5000.0,
      bankName: 'مصرف الراجحي',
      iban: 'SA8080000000012345678902',
      accountHolder: 'مؤسسة نسيج الوطن للتجارة',
      notes: 'تحويل دوري للأرباح',
      status: WithdrawalStatus.pending,
      createdDate: DateTime.now().subtract(const Duration(hours: 12)),
    ),
    WithdrawalRequest(
      id: 'WTH-0042',
      method: 'تحويل بنكي',
      amount: 12000.0,
      bankName: 'مصرف الراجحي',
      iban: 'SA8080000000012345678902',
      accountHolder: 'مؤسسة نسيج الوطن للتجارة',
      status: WithdrawalStatus.completed,
      createdDate: DateTime.now().subtract(const Duration(days: 2)),
      completedDate: DateTime.now().subtract(const Duration(days: 2, hours: 4)),
    ),
    WithdrawalRequest(
      id: 'WTH-0041',
      method: 'محفظة رقمية (InstaPay)',
      amount: 3500.0,
      bankName: 'InstaPay Wallet',
      iban: 'naseeji@instapay',
      accountHolder: 'مؤسسة نسيج الوطن',
      status: WithdrawalStatus.completed,
      createdDate: DateTime.now().subtract(const Duration(days: 7)),
      completedDate: DateTime.now().subtract(const Duration(days: 7, hours: 1)),
    ),
    WithdrawalRequest(
      id: 'WTH-0040',
      method: 'تحويل بنكي',
      amount: 15000.0,
      bankName: 'البنك الأهلي السعودي',
      iban: 'SA2030000000098765432101',
      accountHolder: 'مؤسسة نسيج الوطن للتجارة',
      status: WithdrawalStatus.rejected,
      notes: 'الاسم غير متطابق مع الحساب البنكي المربوط',
      createdDate: DateTime.now().subtract(const Duration(days: 10)),
      completedDate: DateTime.now().subtract(const Duration(days: 9)),
    ),
  ];

  static final List<SupplierInvoice> _invoices = [
    SupplierInvoice(
      invoiceNumber: 'INV-2026-0045',
      factoryName: 'مصنع نسيج الرياض',
      orderNumber: 'ORD-5541',
      agreementNumber: 'AGR-8802',
      invoiceDate: DateTime.now().subtract(const Duration(days: 1)),
      dueDate: DateTime.now().add(const Duration(days: 14)),
      subtotal: 13000.0,
      tax: 1950.0, // 15% VAT
      shipping: 350.0,
      discount: 800.0,
      grandTotal: 14500.0,
      status: InvoiceStatus.paid,
      items: [
        const InvoiceItem(name: 'قماش كتان بيج ممتاز', quantity: 300, unitPrice: 30.0, unit: 'متر'),
        const InvoiceItem(name: 'قماش قطن مصري أبيض', quantity: 200, unitPrice: 20.0, unit: 'متر'),
      ],
      paymentHistory: [
        FinancialTransaction(
          id: 'TXN-9021',
          orderNumber: 'ORD-5541',
          agreementNumber: 'AGR-8802',
          factoryName: 'مصنع نسيج الرياض',
          type: TransactionType.paymentReceived,
          amount: 14500.0,
          currency: 'ر.س',
          status: TransactionStatus.completed,
          paymentMethod: 'مدى',
          referenceNumber: 'REF-7729831',
          createdDate: DateTime.now().subtract(const Duration(hours: 3)),
          completedDate: DateTime.now().subtract(const Duration(hours: 3)),
        ),
      ],
      attachments: ['INV-2026-0045-signed.pdf', 'Customs-Doc.pdf'],
    ),
    SupplierInvoice(
      invoiceNumber: 'INV-2026-0044',
      factoryName: 'مصنع الأمل للمنسوجات',
      orderNumber: 'ORD-5539',
      agreementNumber: 'AGR-8801',
      invoiceDate: DateTime.now().subtract(const Duration(days: 3)),
      dueDate: DateTime.now().add(const Duration(days: 10)),
      subtotal: 5500.0,
      tax: 825.0,
      shipping: 200.0,
      discount: 325.0,
      grandTotal: 6200.0,
      status: InvoiceStatus.pending,
      items: [
        const InvoiceItem(name: 'خيوط بوليستر عالية القوة', quantity: 50, unitPrice: 110.0, unit: 'بكرة'),
      ],
      paymentHistory: [],
      attachments: ['INV-2026-0044.pdf'],
    ),
    SupplierInvoice(
      invoiceNumber: 'INV-2026-0043',
      factoryName: 'شركة مصانع الخليج',
      orderNumber: 'ORD-5488',
      agreementNumber: 'AGR-8650',
      invoiceDate: DateTime.now().subtract(const Duration(days: 12)),
      dueDate: DateTime.now().subtract(const Duration(days: 2)),
      subtotal: 4000.0,
      tax: 600.0,
      shipping: 150.0,
      discount: 250.0,
      grandTotal: 4500.0,
      status: InvoiceStatus.cancelled,
      items: [
        const InvoiceItem(name: 'قماش صوف شتوي ثقيل', quantity: 80, unitPrice: 50.0, unit: 'متر'),
      ],
      paymentHistory: [],
      attachments: [],
    ),
    SupplierInvoice(
      invoiceNumber: 'INV-2026-0042',
      factoryName: 'مصنع الأقمشة المتحدة',
      orderNumber: 'ORD-5470',
      agreementNumber: 'AGR-8599',
      invoiceDate: DateTime.now().subtract(const Duration(days: 45)),
      dueDate: DateTime.now().subtract(const Duration(days: 30)),
      subtotal: 7500.0,
      tax: 1125.0,
      shipping: 300.0,
      discount: 725.0,
      grandTotal: 8200.0,
      status: InvoiceStatus.overdue,
      items: [
        const InvoiceItem(name: 'حرير كريب فاخر ملون', quantity: 150, unitPrice: 50.0, unit: 'متر'),
      ],
      paymentHistory: [],
      attachments: ['INV-2026-0042.pdf'],
    ),
  ];

  static final List<RefundRequest> _refunds = [
    RefundRequest(
      refundNumber: 'REF-1102',
      orderNumber: 'ORD-5488',
      reason: 'وجود عيوب تصنيعية في أطراف قماش الصوف المستلم وخلاف للمواصفات المتفق عليها.',
      amount: 4500.0,
      status: 'Completed',
      createdDate: DateTime.now().subtract(const Duration(days: 6)),
      completedDate: DateTime.now().subtract(const Duration(days: 4)),
      attachments: ['inspection_report.pdf', 'photo_defect_1.jpg'],
    ),
    RefundRequest(
      refundNumber: 'REF-1103',
      orderNumber: 'ORD-5521',
      reason: 'تأخير في تسليم الشحنة لأكثر من ١٠ أيام مما أدى إلى إلغاء خط الإنتاج الخاص بالمصنع.',
      amount: 3200.0,
      status: 'Pending',
      createdDate: DateTime.now().subtract(const Duration(days: 1)),
      attachments: ['delay_complaint.pdf'],
    ),
  ];

  static final List<PaymentMethod> _methods = [
    const PaymentMethod(
      id: 'MET-001',
      type: 'bank_account',
      title: 'الحساب الرئيسي - الراجحي',
      subtitle: 'مصرف الراجحي',
      accountHolder: 'مؤسسة نسيج الوطن للتجارة',
      identifier: 'SA8080000000012345678902',
      isDefault: true,
      isVerified: true,
    ),
    const PaymentMethod(
      id: 'MET-002',
      type: 'bank_account',
      title: 'الحساب الاحتياطي - الأهلي',
      subtitle: 'البنك الأهلي السعودي',
      accountHolder: 'مؤسسة نسيج الوطن للتجارة',
      identifier: 'SA2030000000098765432101',
      isDefault: false,
      isVerified: true,
    ),
    const PaymentMethod(
      id: 'MET-003',
      type: 'instapay',
      title: 'محفظة InstaPay الرقمية',
      subtitle: 'InstaPay Wallet',
      accountHolder: 'مؤسسة نسيج الوطن',
      identifier: 'naseeji@instapay',
      isDefault: false,
      isVerified: true,
    ),
    const PaymentMethod(
      id: 'MET-004',
      type: 'digital_wallet',
      title: 'محفظة STC Pay رقمية',
      subtitle: 'STC Pay',
      accountHolder: 'إبراهيم ناصر العتيبي',
      identifier: '0555555555',
      isDefault: false,
      isVerified: false,
    ),
  ];

  static final List<FinancialReport> _reports = [
    FinancialReport(
      id: 'REP-001',
      title: 'تقرير المبيعات والربحية الربع السنوي Q1 2026',
      type: 'Sales Report',
      createdDate: DateTime.now().subtract(const Duration(days: 5)),
      size: '2.4 MB',
    ),
    FinancialReport(
      id: 'REP-002',
      title: 'التقرير الضريبي التفصيلي وضريبة القيمة المضافة لعام 2025',
      type: 'Tax Report',
      createdDate: DateTime.now().subtract(const Duration(days: 15)),
      size: '4.8 MB',
    ),
    FinancialReport(
      id: 'REP-003',
      title: 'تقرير التدفقات النقدية وعمليات سحب الرصيد لشهر يونيو 2026',
      type: 'Withdrawal Report',
      createdDate: DateTime.now().subtract(const Duration(days: 8)),
      size: '1.2 MB',
    ),
  ];

  @override
  Future<FinancialDashboardData> getDashboardData() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return FinancialDashboardData(
      currentBalance: _currentBalance,
      pendingBalance: _pendingBalance,
      availableBalance: _availableBalance,
      frozenBalance: _frozenBalance,
      totalRevenue: _totalRevenue,
      monthlyRevenue: _monthlyRevenue,
      pendingPayments: _pendingPaymentsCount,
      completedPayments: _completedPaymentsCount,
      outstandingInvoices: _outstandingInvoicesSum,
      platformFees: _platformFeesSum,
      netProfit: _netProfitSum,
      healthIndicator: 0.94,
    );
  }

  @override
  Future<List<FinancialTransaction>> getTransactions() async {
    await Future.delayed(const Duration(milliseconds: 350));
    return List.from(_transactions);
  }

  @override
  Future<List<SupplierPayment>> getPayments() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_payments);
  }

  @override
  Future<WalletData> getWalletData() async {
    await Future.delayed(const Duration(milliseconds: 250));
    return WalletData(
      availableBalance: _availableBalance,
      pendingBalance: _pendingBalance,
      frozenBalance: _frozenBalance,
      totalEarnings: _netProfitSum,
      lifetimeRevenue: _totalRevenue,
      platformCredit: 1200.0,
    );
  }

  @override
  Future<List<WithdrawalRequest>> getWithdrawals() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_withdrawals);
  }

  @override
  Future<void> requestWithdrawal(WithdrawalRequest request) async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (request.amount > _availableBalance) {
      throw Exception('الرصيد المتاح غير كافٍ لإتمام عملية السحب');
    }
    
    // Deduct from available, add to pending/frozen/current balances
    _availableBalance -= request.amount;
    
    final newRequest = request.copyWith(
      id: 'WTH-00${_withdrawals.length + 40}',
      createdDate: DateTime.now(),
    );
    _withdrawals.insert(0, newRequest);
    
    // Log as a transaction
    _transactions.insert(
      0,
      FinancialTransaction(
        id: 'TXN-90${_transactions.length + 10}',
        orderNumber: newRequest.id,
        agreementNumber: '',
        factoryName: 'سحب رصيد (${newRequest.method})',
        type: TransactionType.withdrawal,
        amount: -newRequest.amount,
        currency: 'ر.س',
        status: TransactionStatus.pending,
        paymentMethod: newRequest.method,
        referenceNumber: 'REF-PENDING',
        createdDate: DateTime.now(),
      ),
    );
  }

  @override
  Future<void> cancelWithdrawal(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _withdrawals.indexWhere((w) => w.id == id);
    if (index != -1 && _withdrawals[index].status == WithdrawalStatus.pending) {
      final request = _withdrawals[index];
      _withdrawals[index] = request.copyWith(status: WithdrawalStatus.rejected);
      
      // Return funds to available balance
      _availableBalance += request.amount;
      
      // Update transaction status
      final tIndex = _transactions.indexWhere((t) => t.orderNumber == id);
      if (tIndex != -1) {
        _transactions[tIndex] = FinancialTransaction(
          id: _transactions[tIndex].id,
          orderNumber: _transactions[tIndex].orderNumber,
          agreementNumber: '',
          factoryName: _transactions[tIndex].factoryName,
          type: _transactions[tIndex].type,
          amount: _transactions[tIndex].amount,
          currency: _transactions[tIndex].currency,
          status: TransactionStatus.failed,
          paymentMethod: _transactions[tIndex].paymentMethod,
          referenceNumber: 'REF-CANCELLED',
          createdDate: _transactions[tIndex].createdDate,
          completedDate: DateTime.now(),
        );
      }
    }
  }

  @override
  Future<List<SupplierInvoice>> getInvoices() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_invoices);
  }

  @override
  Future<List<RefundRequest>> getRefunds() async {
    await Future.delayed(const Duration(milliseconds: 250));
    return List.from(_refunds);
  }

  @override
  Future<EscrowTracking> getEscrowTracking(String orderNumber) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // Find some payments or default
    return EscrowTracking(
      orderNumber: orderNumber,
      escrowAmount: 12450.0,
      heldAmount: 12450.0,
      releaseDate: DateTime.now().add(const Duration(days: 3)),
      currentStage: EscrowStage.shipmentDelivered,
      reasonForHold: 'بانتظار فحص الشحنة والموافقة الفنية من قبل إدارة المصنع (فترة الفحص ٧٢ ساعة)',
    );
  }

  @override
  Future<FinancialAnalyticsData> getAnalytics() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return FinancialAnalyticsData(
      totalRevenue: _totalRevenue,
      netProfit: _netProfitSum,
      averageOrderValue: 8400.0,
      averagePaymentTime: 4.2,
      profitMargin: 82.5, // 128400 / 154800
      repeatCustomerRevenue: 48500.0,
      revenueTrend: [
        {'month': 'يناير', 'value': 22000.0},
        {'month': 'فبراير', 'value': 28000.0},
        {'month': 'مارس', 'value': 25000.0},
        {'month': 'أبريل', 'value': 31000.0},
        {'month': 'مايو', 'value': 29000.0},
        {'month': 'يونيو', 'value': _monthlyRevenue},
      ],
      profitTrend: [
        {'month': 'يناير', 'value': 18000.0},
        {'month': 'فبراير', 'value': 23000.0},
        {'month': 'مارس', 'value': 21000.0},
        {'month': 'أبريل', 'value': 26000.0},
        {'month': 'مايو', 'value': 24000.0},
        {'month': 'يونيو', 'value': _monthlyRevenue * 0.82},
      ],
      cashFlow: [
        {'day': 'السبت', 'inflow': 5000.0, 'outflow': 1200.0},
        {'day': 'الأحد', 'inflow': 12000.0, 'outflow': 0.0},
        {'day': 'الاثنين', 'inflow': 4500.0, 'outflow': 3500.0},
        {'day': 'الثلاثاء', 'inflow': 8000.0, 'outflow': 1500.0},
        {'day': 'الأربعاء', 'inflow': 3000.0, 'outflow': 5000.0},
        {'day': 'الخميس', 'inflow': 15000.0, 'outflow': 2000.0},
        {'day': 'الجمعة', 'inflow': 0.0, 'outflow': 0.0},
      ],
      revenueByProduct: [
        {'product': 'كتان فاخر', 'value': 45.0, 'color': 0xFF0040E0},
        {'product': 'قطن طبيعي', 'value': 30.0, 'color': 0xFF009688},
        {'product': 'خيوط بوليستر', 'value': 15.0, 'color': 0xFFFF9800},
        {'product': 'حرير كريب', 'value': 10.0, 'color': 0xFFE91E63},
      ],
      revenueByCustomer: [
        {'customer': 'مصنع نسيج الرياض', 'value': 62000.0},
        {'customer': 'مصنع الأمل للمنسوجات', 'value': 45200.0},
        {'customer': 'شركة مصانع الخليج', 'value': 28500.0},
        {'customer': 'آخرون', 'value': 19100.0},
      ],
      monthlyComparison: [
        {'label': 'الشهر الحالي', 'revenue': _monthlyRevenue, 'expenses': 5800.0},
        {'label': 'الشهر الماضي', 'revenue': 29000.0, 'expenses': 4900.0},
      ],
      revenueGrowth: 11.7,
      profitGrowth: 8.5,
      averageSettlementTime: 3.5,
      collectionRate: 94.2,
      refundRate: 2.8,
      paymentSuccessRate: 98.5,
    );
  }

  @override
  Future<TaxCenterData> getTaxData() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return TaxCenterData(
      taxRegistrationNumber: '300982173300003',
      vatPercentage: 15.0,
      collectedVat: 23220.0, // 15% of total revenue
      paidVat: 4890.0,
      outstandingVat: 18330.0,
      reports: [
        {'period': 'الربع الأول 2026', 'vat': 4890.0, 'status': 'مقدم تم السداد'},
        {'period': 'الربع الثاني 2026', 'vat': 7230.0, 'status': 'مستحق الدفع'},
      ],
      documents: [
        {'name': 'شهادة التسجيل في ضريبة القيمة المضافة.pdf', 'date': '2025-01-10'},
        {'name': 'موافقة الإعفاء الضريبي للشحنات التصديرية.pdf', 'date': '2025-05-18'},
      ],
    );
  }

  @override
  Future<List<PaymentMethod>> getPaymentMethods() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.from(_methods);
  }

  @override
  Future<void> addPaymentMethod(PaymentMethod method) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final newMethod = method.copyWith(
      id: 'MET-00${_methods.length + 1}',
      isDefault: _methods.isEmpty ? true : false,
      isVerified: false,
    );
    _methods.add(newMethod);
  }

  @override
  Future<void> deletePaymentMethod(String id) async {
    await Future.delayed(const Duration(milliseconds: 400));
    _methods.removeWhere((m) => m.id == id);
  }

  @override
  Future<void> setDefaultPaymentMethod(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    for (int i = 0; i < _methods.length; i++) {
      if (_methods[i].id == id) {
        _methods[i] = _methods[i].copyWith(isDefault: true);
      } else {
        _methods[i] = _methods[i].copyWith(isDefault: false);
      }
    }
  }

  @override
  Future<void> verifyPaymentMethod(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _methods.indexWhere((m) => m.id == id);
    if (index != -1) {
      _methods[index] = _methods[index].copyWith(isVerified: true);
    }
  }

  @override
  Future<List<FinancialReport>> getReports() async {
    await Future.delayed(const Duration(milliseconds: 250));
    return List.from(_reports);
  }
}

@riverpod
FinancialRepository financialRepository(FinancialRepositoryRef ref) {
  return FinancialRepositoryImpl();
}
