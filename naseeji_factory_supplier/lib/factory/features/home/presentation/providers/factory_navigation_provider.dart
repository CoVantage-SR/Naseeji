import 'package:flutter_riverpod/flutter_riverpod.dart';

class NavigationState {
  final int selectedIndex;
  final int rfqBadgeCount;
  final int dealsBadgeCount;

  const NavigationState({
    this.selectedIndex = 0,
    this.rfqBadgeCount = 3,
    this.dealsBadgeCount = 2,
  });

  NavigationState copyWith({
    int? selectedIndex,
    int? rfqBadgeCount,
    int? dealsBadgeCount,
  }) {
    return NavigationState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      rfqBadgeCount: rfqBadgeCount ?? this.rfqBadgeCount,
      dealsBadgeCount: dealsBadgeCount ?? this.dealsBadgeCount,
    );
  }
}

class FactoryNavigationNotifier extends StateNotifier<NavigationState> {
  FactoryNavigationNotifier() : super(const NavigationState());

  void setIndex(int index) {
    state = state.copyWith(selectedIndex: index);
  }

  void updateRfqBadge(int count) {
    state = state.copyWith(rfqBadgeCount: count);
  }

  void updateDealsBadge(int count) {
    state = state.copyWith(dealsBadgeCount: count);
  }
}

final factoryNavigationProvider = StateNotifierProvider<FactoryNavigationNotifier, NavigationState>((ref) {
  return FactoryNavigationNotifier();
});



