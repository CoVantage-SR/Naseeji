import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/supplier_credits.dart';
import '../../domain/entities/credit_package.dart';
import '../../domain/repositories/credits_repository.dart';
import '../../domain/services/credit_service.dart';
import '../../data/repositories/credits_repository_impl.dart';
import '../widgets/insufficient_credits_dialog.dart';

final creditServiceProvider = Provider<CreditService>((ref) {
  return CreditService();
});

final creditsRepositoryProvider = Provider<CreditsRepository>((ref) {
  final service = ref.watch(creditServiceProvider);
  return CreditsRepositoryImpl(creditService: service);
});

final creditManagerProvider =
    StateNotifierProvider<CreditManagerNotifier, AsyncValue<SupplierCredits>>((ref) {
  final repo = ref.watch(creditsRepositoryProvider);
  return CreditManagerNotifier(repo);
});

class CreditManagerNotifier extends StateNotifier<AsyncValue<SupplierCredits>> {
  final CreditsRepository _repository;
  final String _currentSupplierId = 'sup_1';

  CreditManagerNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadCredits();
  }

  Future<void> loadCredits() async {
    state = const AsyncValue.loading();
    try {
      final credits = await _repository.getCredits(_currentSupplierId);
      state = AsyncValue.data(credits);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  int get currentBalance {
    return state.value?.creditsBalance ?? 0;
  }

  bool get isBlueVerified {
    return state.value?.isBlueVerified ?? false;
  }

  /// Core Credit Manager Guard:
  /// 1. Checks balance.
  /// 2. If insufficient, shows InsufficientCreditsDialog and returns false.
  /// 3. Executes operation.
  /// 4. DEDUCTS credits ONLY IF operation succeeds.
  /// 5. Does NOT deduct if operation fails.
  Future<bool> executeWithCreditsGuard({
    required BuildContext context,
    required String operationName,
    required int requiredCredits,
    required Future<bool> Function() onExecuteOperation,
  }) async {
    final balance = currentBalance;

    if (balance < requiredCredits) {
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (_) => InsufficientCreditsDialog(
            requiredCredits: requiredCredits,
            availableCredits: balance,
            operationName: operationName,
            onBuyCredits: () {
              Navigator.of(context).pop();
              context.push('/supplier/buy-credits');
            },
          ),
        );
      }
      return false;
    }

    // Execute server operation first
    try {
      final success = await onExecuteOperation();
      if (success) {
        // Deduct credits only AFTER successful operation
        final updated = await _repository.consumeCredits(
          supplierId: _currentSupplierId,
          operation: operationName,
          amount: requiredCredits,
        );
        state = AsyncValue.data(updated);
        return true;
      }
      return false;
    } catch (e) {
      // Operation failed -> NO credits deducted
      rethrow;
    }
  }

  Future<bool> requestBlueVerification(BuildContext context) async {
    return executeWithCreditsGuard(
      context: context,
      operationName: 'طلب التوثيق الزرقاء',
      requiredCredits: 35,
      onExecuteOperation: () async {
        await Future.delayed(const Duration(milliseconds: 300));
        return true;
      },
    );
  }

  Future<bool> buyPackage(CreditPackage package) async {
    try {
      final updated = await _repository.buyCreditPackage(_currentSupplierId, package);
      state = AsyncValue.data(updated);
      return true;
    } catch (e) {
      return false;
    }
  }
}
