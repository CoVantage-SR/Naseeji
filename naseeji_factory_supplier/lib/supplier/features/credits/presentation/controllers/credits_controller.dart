import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/supplier_credits.dart';
import '../../domain/entities/credit_package.dart';
import '../../domain/repositories/credits_repository.dart';
import '../widgets/insufficient_credits_dialog.dart';
import 'credit_manager.dart';

final creditsControllerProvider =
    StateNotifierProvider<CreditsController, AsyncValue<SupplierCredits>>((ref) {
  final repository = ref.watch(creditsRepositoryProvider);
  return CreditsController(repository);
});

class CreditsController extends StateNotifier<AsyncValue<SupplierCredits>> {
  final CreditsRepository _repository;
  final String _supplierId = 'sup_1';

  CreditsController(this._repository) : super(const AsyncValue.loading()) {
    loadCredits();
  }

  Future<void> loadCredits() async {
    state = const AsyncValue.loading();
    try {
      final credits = await _repository.getCredits(_supplierId);
      state = AsyncValue.data(credits);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> checkAndGrantWelcomePackage(BuildContext context) async {
    final current = state.valueOrNull;
    if (current == null || !current.welcomeCreditsGranted) {
      final updated = await _repository.grantWelcomeCredits(_supplierId);
      state = AsyncValue.data(updated);
    }
  }

  Future<bool> tryConsumeForProduct(BuildContext context) async {
    final current = state.valueOrNull ?? await _repository.getCredits(_supplierId);

    if (current.creditsBalance >= 5) {
      final updated = await _repository.consumeCredits(
        supplierId: _supplierId,
        operation: 'إضافة منتج',
        amount: 5,
      );
      state = AsyncValue.data(updated);
      return true;
    }

    if (context.mounted) {
      showDialog(
        context: context,
        builder: (_) => InsufficientCreditsDialog(
          requiredCredits: 5,
          availableCredits: current.creditsBalance,
          operationName: 'إضافة منتج',
          onBuyCredits: () => Navigator.of(context).pop(),
        ),
      );
    }
    return false;
  }

  Future<bool> tryConsumeForVideo(BuildContext context) async {
    final current = state.valueOrNull ?? await _repository.getCredits(_supplierId);

    if (current.creditsBalance >= 10) {
      final updated = await _repository.consumeCredits(
        supplierId: _supplierId,
        operation: 'إضافة فيديو منتج',
        amount: 10,
      );
      state = AsyncValue.data(updated);
      return true;
    }

    if (context.mounted) {
      showDialog(
        context: context,
        builder: (_) => InsufficientCreditsDialog(
          requiredCredits: 10,
          availableCredits: current.creditsBalance,
          operationName: 'إضافة فيديو منتج',
          onBuyCredits: () => Navigator.of(context).pop(),
        ),
      );
    }
    return false;
  }

  Future<void> requestBlueVerification() async {
    final result = await _repository.requestBlueVerification(_supplierId);
    state = AsyncValue.data(result);
  }

  Future<bool> tryApproveBlueVerification(BuildContext context) async {
    final current = state.valueOrNull ?? await _repository.getCredits(_supplierId);

    if (current.creditsBalance >= 35) {
      final result = await _repository.requestBlueVerification(_supplierId);
      state = AsyncValue.data(result);
      return true;
    }

    if (context.mounted) {
      showDialog(
        context: context,
        builder: (_) => InsufficientCreditsDialog(
          requiredCredits: 35,
          availableCredits: current.creditsBalance,
          operationName: 'طلب التوثيق الزرقاء',
          onBuyCredits: () => Navigator.of(context).pop(),
        ),
      );
    }
    return false;
  }

  Future<void> buyCredits(BuildContext context, CreditPackage package) async {
    final result = await _repository.buyCreditPackage(_supplierId, package);
    state = AsyncValue.data(result);
  }
}
