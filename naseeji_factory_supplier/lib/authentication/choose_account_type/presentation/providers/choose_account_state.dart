import '../../../shared/enums/user_role.dart';

class ChooseAccountState {
  final UserRole? selectedAccountType;
  final bool isLoading;
  final String? errorMessage;

  const ChooseAccountState({
    this.selectedAccountType,
    this.isLoading = false,
    this.errorMessage,
  });

  ChooseAccountState copyWith({
    UserRole? selectedAccountType,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ChooseAccountState(
      selectedAccountType: selectedAccountType ?? this.selectedAccountType,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}
