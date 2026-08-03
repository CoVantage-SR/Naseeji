import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/account_type.dart';
import '../../domain/usecases/select_account_type_usecase.dart';

class AccountTypeState extends Equatable {
  final AccountType selectedType;
  final bool isLoading;
  final String? errorMessage;

  const AccountTypeState({
    this.selectedType = AccountType.factory,
    this.isLoading = false,
    this.errorMessage,
  });

  AccountTypeState copyWith({
    AccountType? selectedType,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AccountTypeState(
      selectedType: selectedType ?? this.selectedType,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [selectedType, isLoading, errorMessage];
}

class AccountTypeController extends StateNotifier<AccountTypeState> {
  final SelectAccountTypeUseCase selectAccountTypeUseCase;

  AccountTypeController({
    required this.selectAccountTypeUseCase,
    AccountType initialType = AccountType.factory,
  }) : super(AccountTypeState(selectedType: initialType));

  void selectAccountType(AccountType type) {
    final result = selectAccountTypeUseCase.execute(type);
    state = state.copyWith(selectedType: result, errorMessage: null);
  }
}
