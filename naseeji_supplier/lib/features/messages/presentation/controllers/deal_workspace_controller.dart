import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/deal_workspace_model.dart';
import '../../domain/entities/deal_status_enum.dart';
import '../../domain/services/content_moderation_service.dart';
import '../../domain/repositories/deal_workspace_repository.dart';
import '../../data/datasources/deal_workspace_remote_datasource.dart';
import '../../data/repositories/deal_workspace_repository_impl.dart';

final dealWorkspaceRepositoryProvider = Provider<DealWorkspaceRepository>((ref) {
  return DealWorkspaceRepositoryImpl(
    datasource: DealWorkspaceRemoteDatasourceImpl(),
  );
});

class DealWorkspaceState {
  final bool isLoading;
  final String? errorMessage;
  final DealWorkspaceModel? workspace;
  final int activeTabIndex; // 0: المحادثة, 1: عرض السعر, 2: الاتفاق, 3: الملفات, 4: الخط الزمني
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

    // 1. Run Security Content Moderation Check
    final check = moderationService.moderate(text);
    if (check.isProhibited) {
      state = state.copyWith(moderationResult: check);
      return false; // Block sending
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

  Future<bool> submitCounterOffer(double newUnitPrice, int quantity) async {
    if (state.workspace == null) return false;
    state = state.copyWith(isLoading: true);
    try {
      await repository.sendCounterOffer(
        dealId: dealId,
        newUnitPrice: newUnitPrice,
        quantity: quantity,
      );
      await loadWorkspace();
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false);
      return false;
    }
  }

  Future<void> acceptQuotation() async {
    if (state.workspace == null) return;
    await repository.updateDealStatus(dealId, DealStatus.agreed);
    await loadWorkspace();
  }

  Future<void> rejectQuotation() async {
    if (state.workspace == null) return;
    await repository.updateDealStatus(dealId, DealStatus.negotiating);
    await loadWorkspace();
  }
}

final dealWorkspaceControllerProvider = StateNotifierProvider.family<DealWorkspaceController, DealWorkspaceState, String>((ref, dealId) {
  final repo = ref.watch(dealWorkspaceRepositoryProvider);
  return DealWorkspaceController(
    repository: repo,
    moderationService: ContentModerationService(),
    dealId: dealId,
  );
});
