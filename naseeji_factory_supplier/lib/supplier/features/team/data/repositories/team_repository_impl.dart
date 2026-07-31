import '../../domain/entities/team_member_model.dart';
import '../../domain/entities/team_activity_log.dart';
import '../datasources/team_mock_database.dart';

abstract class TeamRepository {
  List<TeamMemberModel> getMembers({
    String? searchQuery,
    MemberStatus? statusFilter,
    MemberRoleCategory? roleFilter,
  });

  TeamMemberModel? getMemberById(String id);

  bool addMember(TeamMemberModel member);

  bool updateMember(TeamMemberModel member);

  bool deleteMember(String id);

  bool toggleMemberStatus(String id, MemberStatus newStatus);

  List<TeamActivityLog> getActivityLogs({String? memberId});

  int get memberLimit;
  int get currentCount;
  bool get canAddMember;
}

class TeamRepositoryImpl implements TeamRepository {
  final TeamMockDatabase _db = TeamMockDatabase();

  @override
  List<TeamMemberModel> getMembers({
    String? searchQuery,
    MemberStatus? statusFilter,
    MemberRoleCategory? roleFilter,
  }) {
    var result = List<TeamMemberModel>.from(_db.teamMembers);

    if (statusFilter != null) {
      result = result.where((m) => m.status == statusFilter).toList();
    }

    if (roleFilter != null) {
      result = result.where((m) => m.roleCategory == roleFilter).toList();
    }

    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      final q = searchQuery.toLowerCase().trim();
      result = result.where((m) =>
          m.name.toLowerCase().contains(q) ||
          m.roleTitle.toLowerCase().contains(q) ||
          m.department.toLowerCase().contains(q) ||
          m.email.toLowerCase().contains(q)).toList();
    }

    return result;
  }

  @override
  TeamMemberModel? getMemberById(String id) {
    try {
      return _db.teamMembers.firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  bool addMember(TeamMemberModel member) => _db.addMember(member);

  @override
  bool updateMember(TeamMemberModel member) => _db.updateMember(member);

  @override
  bool deleteMember(String id) => _db.deleteMember(id);

  @override
  bool toggleMemberStatus(String id, MemberStatus newStatus) => _db.toggleMemberStatus(id, newStatus);

  @override
  List<TeamActivityLog> getActivityLogs({String? memberId}) {
    if (memberId != null) {
      return _db.activityLogs.where((l) => l.memberId == memberId).toList();
    }
    return _db.activityLogs;
  }

  @override
  int get memberLimit => _db.planMemberLimit;

  @override
  int get currentCount => _db.teamMembers.length;

  @override
  bool get canAddMember => _db.teamMembers.length < _db.planMemberLimit;
}



