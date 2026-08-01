import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'bootstrap_dependencies.dart';
import 'bootstrap_initializer.dart';
import 'bootstrap_state.dart';

class BootstrapService extends StateNotifier<BootstrapState> {
  BootstrapService() : super(const BootstrapState());

  Future<BootstrapDependencies?> initApp() async {
    state = state.copyWith(status: BootstrapStatus.initializing);
    try {
      final deps = await BootstrapInitializer.initialize();
      state = state.copyWith(status: BootstrapStatus.success);
      return deps;
    } catch (e) {
      state = state.copyWith(
        status: BootstrapStatus.failure,
        message: e.toString(),
      );
      return null;
    }
  }
}
