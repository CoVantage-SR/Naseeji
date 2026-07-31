import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naseeji_factory/supplier/core/mock/subscription_mock.dart';
import '../../domain/repositories/subscription_repository.dart';
import '../../data/datasources/subscription_remote_datasource.dart';
import '../../data/repositories/subscription_repository_impl.dart';

final subscriptionRepositoryProvider = Provider<SubscriptionRepository>((ref) {
  return SubscriptionRepositoryImpl(
    datasource: SubscriptionRemoteDatasourceImpl(),
  );
});

class SubscriptionState {
  final bool isLoading;
  final SubscriptionModel? subscription;
  final List<SubscriptionPlanMock> plans;
  final List<SubscriptionInvoiceMock> invoices;
  final List<SubscriptionHistoryMock> history;
  final String? errorMessage;

  const SubscriptionState({
    this.isLoading = false,
    this.subscription,
    this.plans = const [],
    this.invoices = const [],
    this.history = const [],
    this.errorMessage,
  });

  SubscriptionState copyWith({
    bool? isLoading,
    SubscriptionModel? subscription,
    List<SubscriptionPlanMock>? plans,
    List<SubscriptionInvoiceMock>? invoices,
    List<SubscriptionHistoryMock>? history,
    String? errorMessage,
  }) {
    return SubscriptionState(
      isLoading: isLoading ?? this.isLoading,
      subscription: subscription ?? this.subscription,
      plans: plans ?? this.plans,
      invoices: invoices ?? this.invoices,
      history: history ?? this.history,
      errorMessage: errorMessage,
    );
  }
}

class SubscriptionController extends StateNotifier<SubscriptionState> {
  final SubscriptionRepository repository;

  SubscriptionController({required this.repository}) : super(const SubscriptionState()) {
    loadSubscriptionData();
  }

  Future<void> loadSubscriptionData() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final sub = await repository.getSubscription();
      final plans = await repository.getPlans();
      final invs = await repository.getInvoices();
      final hist = await repository.getHistory();

      state = state.copyWith(
        isLoading: false,
        subscription: sub,
        plans: plans,
        invoices: invs,
        history: hist,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'تعذر تحميل بيانات الاشتراك',
      );
    }
  }

  Future<bool> upgradePlan(SubscriptionPlanMock newPlan) async {
    state = state.copyWith(isLoading: true);
    final success = await repository.upgradePlan(newPlan);
    await loadSubscriptionData();
    return success;
  }

  Future<bool> renewSubscription() async {
    state = state.copyWith(isLoading: true);
    final success = await repository.renewSubscription();
    await loadSubscriptionData();
    return success;
  }

  Future<String?> validateAddProduct() async {
    return repository.validateAddProduct();
  }

  Future<String?> validateMediaUpload({required String type, required int currentCount}) async {
    return repository.validateMediaUpload(type: type, currentCount: currentCount);
  }
}

final subscriptionControllerProvider = StateNotifierProvider<SubscriptionController, SubscriptionState>((ref) {
  final repo = ref.watch(subscriptionRepositoryProvider);
  return SubscriptionController(repository: repo);
});

// Derived Providers for Reactive Rebuilding
final currentSubscriptionProvider = Provider<SubscriptionModel?>((ref) {
  final state = ref.watch(subscriptionControllerProvider);
  return state.subscription;
});

final subscriptionPlansProvider = Provider<List<SubscriptionPlanMock>>((ref) {
  final state = ref.watch(subscriptionControllerProvider);
  return state.plans;
});

