import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/credits_repository_impl.dart';
import '../../domain/entities/supplier_credits.dart';
import '../../domain/repositories/credits_repository.dart';
import '../widgets/insufficient_credits_dialog.dart';
import '../widgets/welcome_credits_dialog.dart';

final creditsRepositoryProvider = Provider<CreditsRepository>((ref) {
  return CreditsRepositoryImpl();
});

class CreditsController extends StateNotifier<AsyncValue<SupplierCredits>> {
  final CreditsRepository _repository;

  CreditsController(this._repository) : super(const AsyncValue.loading()) {
    loadCredits();
  }

  Future<void> loadCredits() async {
    state = const AsyncValue.loading();
    try {
      final credits = await _repository.getCredits();
      state = AsyncValue.data(credits);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> checkAndGrantWelcomePackage(BuildContext context) async {
    final current = state.valueOrNull;
    if (current == null || !current.welcomeCreditsGranted) {
      final updated = await _repository.grantWelcomePackage();
      state = AsyncValue.data(updated);
      if (context.mounted) {
        WelcomeCreditsDialog.show(context);
      }
    }
  }

  Future<bool> tryConsumeForProduct(BuildContext context) async {
    final current = state.valueOrNull ?? await _repository.getCredits();

    if (current.freeProductsRemaining > 0) {
      final result = await _repository.consumeForProduct();
      if (result != null) {
        state = AsyncValue.data(result);
        return true;
      }
    } else if (current.creditsBalance >= 5) {
      final result = await _repository.consumeForProduct();
      if (result != null) {
        state = AsyncValue.data(result);
        return true;
      }
    }

    if (context.mounted) {
      InsufficientCreditsDialog.show(
        context,
        requiredActionName: 'نشر منتج جديد',
        requiredCredits: 5,
      );
    }
    return false;
  }

  Future<bool> tryConsumeForVideo(BuildContext context) async {
    final current = state.valueOrNull ?? await _repository.getCredits();

    if (current.creditsBalance >= 10) {
      final result = await _repository.consumeForVideo();
      if (result != null) {
        state = AsyncValue.data(result);
        return true;
      }
    }

    if (context.mounted) {
      InsufficientCreditsDialog.show(
        context,
        requiredActionName: 'رفع فيديو تعريفي',
        requiredCredits: 10,
      );
    }
    return false;
  }

  Future<void> requestBlueVerification() async {
    final result = await _repository.requestBlueVerification();
    state = AsyncValue.data(result);
  }

  Future<bool> tryApproveBlueVerification(BuildContext context) async {
    final current = state.valueOrNull ?? await _repository.getCredits();

    if (current.creditsBalance >= 35) {
      final result = await _repository.approveBlueVerification();
      if (result != null) {
        state = AsyncValue.data(result);
        return true;
      }
    }

    if (context.mounted) {
      InsufficientCreditsDialog.show(
        context,
        requiredActionName: 'اعتماد التوثيق الأزرق',
        requiredCredits: 35,
      );
    }
    return false;
  }

  Future<void> buyCredits(BuildContext context, int count) async {
    final result = await _repository.buyCredits(count);
    state = AsyncValue.data(result);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم شراء $count رصيد بنجاح! رصيدك الحالي: ${result.creditsBalance} رصيد 🎉'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}

final creditsControllerProvider =
    StateNotifierProvider<CreditsController, AsyncValue<SupplierCredits>>(
        (ref) {
  final repository = ref.watch(creditsRepositoryProvider);
  return CreditsController(repository);
});
