import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'bootstrap_service.dart';
import 'bootstrap_state.dart';

final bootstrapServiceProvider =
    StateNotifierProvider<BootstrapService, BootstrapState>((ref) {
  return BootstrapService();
});
