import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/team_member_model.dart';
import '../../domain/entities/team_activity_log.dart';
import '../../data/repositories/team_repository_impl.dart';

final teamRepositoryProvider = Provider<TeamRepository>((ref) {
  return TeamRepositoryImpl();
});

final teamSearchQueryProvider = StateProvider<String>((ref) => '');

final teamStatusFilterProvider = StateProvider<MemberStatus?>((ref) => null);

final teamRoleFilterProvider = StateProvider<MemberRoleCategory?>((ref) => null);

class TeamMembersNotifier extends StateNotifier<List<TeamMemberModel>> {
  final TeamRepository _repository;
  final Ref _ref;

  TeamMembersNotifier(this._repository, this._ref) : super([]) {
    refresh();
  }

  void refresh() {
    final query = _ref.watch(teamSearchQueryProvider);
    final status = _ref.watch(teamStatusFilterProvider);
    final role = _ref.watch(teamRoleFilterProvider);

    state = _repository.getMembers(
      searchQuery: query,
      statusFilter: status,
      roleFilter: role,
    );
  }

  bool addMember(TeamMemberModel member) {
    final success = _repository.addMember(member);
    if (success) {
      refresh();
    }
    return success;
  }

  bool updateMember(TeamMemberModel member) {
    final success = _repository.updateMember(member);
    if (success) {
      refresh();
    }
    return success;
  }

  bool deleteMember(String id) {
    final success = _repository.deleteMember(id);
    if (success) {
      refresh();
    }
    return success;
  }

  bool toggleMemberStatus(String id, MemberStatus newStatus) {
    final success = _repository.toggleMemberStatus(id, newStatus);
    if (success) {
      refresh();
    }
    return success;
  }
}

final teamMembersNotifierProvider = StateNotifierProvider<TeamMembersNotifier, List<TeamMemberModel>>((ref) {
  final repo = ref.watch(teamRepositoryProvider);
  return TeamMembersNotifier(repo, ref);
});

final teamActivityLogsProvider = Provider.family<List<TeamActivityLog>, String?>((ref, memberId) {
  final repo = ref.watch(teamRepositoryProvider);
  // Depend on teamMembersNotifierProvider so logs update on team changes
  ref.watch(teamMembersNotifierProvider);
  return repo.getActivityLogs(memberId: memberId);
});


