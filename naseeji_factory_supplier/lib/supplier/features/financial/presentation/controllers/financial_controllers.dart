import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/financial_models.dart';
import '../../data/repositories/financial_repository_impl.dart';

part 'financial_controllers.g.dart';

@riverpod
class FinancialDashboardController extends _$FinancialDashboardController {
  @override
  FutureOr<FinancialDashboardData> build() async {
    final repo = ref.watch(financialRepositoryProvider);
    return repo.getDashboardData();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(financialRepositoryProvider);
      return repo.getDashboardData();
    });
  }
}

@riverpod
class FinancialTransactionsController extends _$FinancialTransactionsController {
  @override
  FutureOr<List<FinancialTransaction>> build() async {
    final repo = ref.watch(financialRepositoryProvider);
    return repo.getTransactions();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(financialRepositoryProvider);
      return repo.getTransactions();
    });
  }
}

@riverpod
class FinancialPaymentsController extends _$FinancialPaymentsController {
  @override
  FutureOr<List<SupplierPayment>> build() async {
    final repo = ref.watch(financialRepositoryProvider);
    return repo.getPayments();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(financialRepositoryProvider);
      return repo.getPayments();
    });
  }
}

@riverpod
class FinancialWalletController extends _$FinancialWalletController {
  @override
  FutureOr<WalletData> build() async {
    final repo = ref.watch(financialRepositoryProvider);
    return repo.getWalletData();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(financialRepositoryProvider);
      return repo.getWalletData();
    });
  }
}

@riverpod
class FinancialWithdrawalsController extends _$FinancialWithdrawalsController {
  @override
  FutureOr<List<WithdrawalRequest>> build() async {
    final repo = ref.watch(financialRepositoryProvider);
    return repo.getWithdrawals();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(financialRepositoryProvider);
      return repo.getWithdrawals();
    });
  }

  Future<void> requestWithdrawal({
    required String method,
    required double amount,
    required String bankName,
    required String iban,
    required String accountHolder,
    String? notes,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(financialRepositoryProvider);
      final request = WithdrawalRequest(
        id: '', // Will be assigned by repo
        method: method,
        amount: amount,
        bankName: bankName,
        iban: iban,
        accountHolder: accountHolder,
        notes: notes,
        status: WithdrawalStatus.pending,
        createdDate: DateTime.now(),
      );
      await repo.requestWithdrawal(request);
      
      // Refresh dashboard data as well
      ref.invalidate(financialDashboardControllerProvider);
      ref.invalidate(financialWalletControllerProvider);
      ref.invalidate(financialTransactionsControllerProvider);
      
      return repo.getWithdrawals();
    });
  }

  Future<void> cancelWithdrawal(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(financialRepositoryProvider);
      await repo.cancelWithdrawal(id);
      
      ref.invalidate(financialDashboardControllerProvider);
      ref.invalidate(financialWalletControllerProvider);
      ref.invalidate(financialTransactionsControllerProvider);
      
      return repo.getWithdrawals();
    });
  }
}

@riverpod
class FinancialInvoicesController extends _$FinancialInvoicesController {
  @override
  FutureOr<List<SupplierInvoice>> build() async {
    final repo = ref.watch(financialRepositoryProvider);
    return repo.getInvoices();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(financialRepositoryProvider);
      return repo.getInvoices();
    });
  }
}

@riverpod
class FinancialAnalyticsController extends _$FinancialAnalyticsController {
  @override
  FutureOr<FinancialAnalyticsData> build() async {
    final repo = ref.watch(financialRepositoryProvider);
    return repo.getAnalytics();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(financialRepositoryProvider);
      return repo.getAnalytics();
    });
  }
}

@riverpod
class FinancialTaxCenterController extends _$FinancialTaxCenterController {
  @override
  FutureOr<TaxCenterData> build() async {
    final repo = ref.watch(financialRepositoryProvider);
    return repo.getTaxData();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(financialRepositoryProvider);
      return repo.getTaxData();
    });
  }
}

@riverpod
class FinancialPaymentMethodsController extends _$FinancialPaymentMethodsController {
  @override
  FutureOr<List<PaymentMethod>> build() async {
    final repo = ref.watch(financialRepositoryProvider);
    return repo.getPaymentMethods();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(financialRepositoryProvider);
      return repo.getPaymentMethods();
    });
  }

  Future<void> addMethod(PaymentMethod method) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(financialRepositoryProvider);
      await repo.addPaymentMethod(method);
      return repo.getPaymentMethods();
    });
  }

  Future<void> deleteMethod(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(financialRepositoryProvider);
      await repo.deletePaymentMethod(id);
      return repo.getPaymentMethods();
    });
  }

  Future<void> setDefault(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(financialRepositoryProvider);
      await repo.setDefaultPaymentMethod(id);
      return repo.getPaymentMethods();
    });
  }

  Future<void> verifyMethod(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(financialRepositoryProvider);
      await repo.verifyPaymentMethod(id);
      return repo.getPaymentMethods();
    });
  }
}

@riverpod
class FinancialRefundsController extends _$FinancialRefundsController {
  @override
  FutureOr<List<RefundRequest>> build() async {
    final repo = ref.watch(financialRepositoryProvider);
    return repo.getRefunds();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(financialRepositoryProvider);
      return repo.getRefunds();
    });
  }
}

@riverpod
class FinancialReportsController extends _$FinancialReportsController {
  @override
  FutureOr<List<FinancialReport>> build() async {
    final repo = ref.watch(financialRepositoryProvider);
    return repo.getReports();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(financialRepositoryProvider);
      return repo.getReports();
    });
  }
}

@riverpod
class EscrowTrackingController extends _$EscrowTrackingController {
  @override
  FutureOr<EscrowTracking> build(String orderNumber) async {
    final repo = ref.watch(financialRepositoryProvider);
    return repo.getEscrowTracking(orderNumber);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(financialRepositoryProvider);
      return repo.getEscrowTracking(orderNumber);
    });
  }
}

