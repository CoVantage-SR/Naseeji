import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/enums/user_role.dart';
import '../../domain/usecases/save_account_type_usecase.dart';
import '../providers/choose_account_state.dart';

class ChooseAccountController extends StateNotifier<ChooseAccountState> {
  final SaveAccountTypeUseCase _saveAccountTypeUseCase;

  ChooseAccountController(this._saveAccountTypeUseCase)
      : super(const ChooseAccountState(selectedAccountType: UserRole.factory));

  void selectFactory() {
    state = state.copyWith(selectedAccountType: UserRole.factory, errorMessage: null);
  }

  void selectSupplier() {
    state = state.copyWith(selectedAccountType: UserRole.supplier, errorMessage: null);
  }

  void selectAccountType(UserRole role) {
    state = state.copyWith(selectedAccountType: role, errorMessage: null);
  }

  Future<bool> continueSelection() async {
    final selectedRole = state.selectedAccountType;
    if (selectedRole == null) {
      state = state.copyWith(errorMessage: 'يرجى اختيار نوع الحساب للمتابعة');
      return false;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final success = await _saveAccountTypeUseCase.execute(selectedRole);
      state = state.copyWith(isLoading: false);
      return success;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }
}
