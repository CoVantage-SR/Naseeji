import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naseeji_factory/supplier/features/messages/domain/entities/deal_workspace_model.dart';
import 'package:naseeji_factory/supplier/features/messages/domain/entities/deal_quotation_model.dart';
import 'package:naseeji_factory/supplier/features/messages/domain/entities/deal_agreement_model.dart';
import 'package:naseeji_factory/supplier/features/messages/domain/entities/deal_file_model.dart';
import 'package:naseeji_factory/supplier/features/messages/domain/entities/deal_timeline_model.dart';
import 'package:naseeji_factory/supplier/features/messages/domain/entities/business_message.dart';
import 'package:naseeji_factory/supplier/features/messages/domain/services/content_moderation_service.dart';
import 'package:naseeji_factory/supplier/features/messages/domain/repositories/deal_workspace_repository.dart';
import 'package:naseeji_factory/supplier/features/messages/data/datasources/deal_workspace_remote_datasource.dart';
import 'package:naseeji_factory/supplier/features/messages/data/repositories/deal_workspace_repository_impl.dart';

final dealWorkspaceRepositoryProvider = Provider<DealWorkspaceRepository>((ref) {
  return DealWorkspaceRepositoryImpl(
    datasource: DealWorkspaceRemoteDatasourceImpl(),
  );
});

class DealWorkspaceState {
  final bool isLoading;
  final String? errorMessage;
  final DealWorkspaceModel? workspace;
  final int activeTabIndex;
  final ContentModerationResult moderationResult;
  final String searchQuery;

  const DealWorkspaceState({
    this.isLoading = true,
    this.errorMessage,
    this.workspace,
    this.activeTabIndex = 0,
    this.moderationResult = ContentModerationResult.clean,
    this.searchQuery = '',
  });

  DealWorkspaceState copyWith({
    bool? isLoading,
    String? errorMessage,
    DealWorkspaceModel? workspace,
    int? activeTabIndex,
    ContentModerationResult? moderationResult,
    String? searchQuery,
  }) {
    return DealWorkspaceState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      workspace: workspace ?? this.workspace,
      activeTabIndex: activeTabIndex ?? this.activeTabIndex,
      moderationResult: moderationResult ?? this.moderationResult,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class DealWorkspaceController extends StateNotifier<DealWorkspaceState> {
  final DealWorkspaceRepository repository;
  final ContentModerationService moderationService;
  final String dealId;

  DealWorkspaceController({
    required this.repository,
    required this.moderationService,
    required this.dealId,
  }) : super(const DealWorkspaceState()) {
    loadWorkspace();
  }

  Future<void> loadWorkspace() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final ws = await repository.getDealWorkspace(dealId);
      state = state.copyWith(isLoading: false, workspace: ws);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: 'تعذر تحميل بيانات الصفقة');
    }
  }

  void setActiveTab(int index) {
    state = state.copyWith(activeTabIndex: index);
  }

  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void clearModerationWarning() {
    state = state.copyWith(moderationResult: ContentModerationResult.clean);
  }

  Future<bool> sendMessage(String text, {String? attachmentUrl}) async {
    if (state.workspace == null) return false;

    final check = moderationService.moderate(text);
    if (check.isProhibited) {
      state = state.copyWith(moderationResult: check);
      return false;
    }

    state = state.copyWith(moderationResult: ContentModerationResult.clean);

    try {
      final newMsg = await repository.sendMessage(
        dealId: dealId,
        text: text,
        attachmentUrl: attachmentUrl,
      );

      final updatedMsgs = List.of(state.workspace!.messages)..add(newMsg);
      state = state.copyWith(
        workspace: state.workspace!.copyWith(messages: updatedMsgs),
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> submitNewOfferVersion({
    required double unitPrice,
    required int quantity,
    required String productionLeadTime,
    required String validityPeriod,
    required String paymentTerms,
    required String deliveryTerms,
    DateTime? expectedDeliveryDate,
    String? notes,
  }) async {
    if (state.workspace == null) return false;

    // Moderate notes input
    if (notes != null && notes.isNotEmpty) {
      final check = moderationService.moderate(notes);
      if (check.isProhibited) {
        state = state.copyWith(moderationResult: check);
        return false;
      }
    }

    state = state.copyWith(isLoading: true);
    try {
      await repository.sendNewOfferVersion(
        dealId: dealId,
        unitPrice: unitPrice,
        quantity: quantity,
        productionLeadTime: productionLeadTime,
        validityPeriod: validityPeriod,
        paymentTerms: paymentTerms,
        deliveryTerms: deliveryTerms,
        expectedDeliveryDate: expectedDeliveryDate,
        notes: notes,
      );
      await loadWorkspace();
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false);
      return false;
    }
  }

  Future<void> acceptCounterOffer() async {
    if (state.workspace == null) return;
    state = state.copyWith(isLoading: true);
    await repository.acceptCounterOffer(dealId);
    await loadWorkspace();
  }

  Future<void> rejectCounterOffer() async {
    if (state.workspace == null) return;
    state = state.copyWith(isLoading: true);
    await repository.rejectCounterOffer(dealId);
    await loadWorkspace();
  }

  Future<void> sendFactoryCounterOffer({
    required double unitPrice,
    required int quantity,
    required String productionLeadTime,
    required String paymentTerms,
    required String deliveryTerms,
    String? notes,
  }) async {
    if (state.workspace == null) return;
    state = state.copyWith(isLoading: true);
    await repository.sendFactoryCounterOffer(
      dealId: dealId,
      unitPrice: unitPrice,
      quantity: quantity,
      productionLeadTime: productionLeadTime,
      paymentTerms: paymentTerms,
      deliveryTerms: deliveryTerms,
      notes: notes,
    );
    await loadWorkspace();
  }

  Future<void> acceptQuotation() async {
    if (state.workspace == null) return;
    state = state.copyWith(isLoading: true);
    await repository.acceptQuotation(dealId);
    await loadWorkspace();
  }

  Future<void> rejectQuotation() async {
    if (state.workspace == null) return;
    state = state.copyWith(isLoading: true);
    await repository.rejectQuotation(dealId);
    await loadWorkspace();
  }
}

// ─── Single Source of Truth Primary Deal Provider ─────────────────────────
final dealProvider = StateNotifierProvider.family<DealWorkspaceController, DealWorkspaceState, String>((ref, dealId) {
  final repo = ref.watch(dealWorkspaceRepositoryProvider);
  return DealWorkspaceController(
    repository: repo,
    moderationService: ContentModerationService(),
    dealId: dealId,
  );
});

// Alias for dealWorkspaceControllerProvider to maintain backward compatibility
final dealWorkspaceControllerProvider = dealProvider;

// ─── Derived Reactive Slice Providers (Zero Duplicate Models) ──────────────
final dealChatProvider = Provider.family<List<BusinessMessage>, String>((ref, dealId) {
  final state = ref.watch(dealProvider(dealId));
  return state.workspace?.messages ?? const [];
});

final negotiationProvider = Provider.family<List<DealQuotationModel>, String>((ref, dealId) {
  final state = ref.watch(dealProvider(dealId));
  return state.workspace?.quotationHistory ?? const [];
});

final agreementProvider = Provider.family<DealAgreementModel?, String>((ref, dealId) {
  final state = ref.watch(dealProvider(dealId));
  return state.workspace?.finalAgreement;
});

final timelineProvider = Provider.family<DealTimelineModel?, String>((ref, dealId) {
  final state = ref.watch(dealProvider(dealId));
  return state.workspace?.timeline;
});

final filesProvider = Provider.family<List<DealFileModel>, String>((ref, dealId) {
  final state = ref.watch(dealProvider(dealId));
  return state.workspace?.files ?? const [];
});


