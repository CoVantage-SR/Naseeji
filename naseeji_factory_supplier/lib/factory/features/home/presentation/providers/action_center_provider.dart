import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/home_entities.dart';
import 'home_repository_provider.dart';

part 'action_center_provider.g.dart';

@riverpod
Future<List<ActionCenterAlert>> actionCenter(ActionCenterRef ref) {
  return ref.watch(homeRepositoryProvider).getActionCenterAlerts();
}

