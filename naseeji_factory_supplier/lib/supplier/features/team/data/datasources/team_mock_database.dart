import 'package:flutter/material.dart';
import '../../domain/entities/team_member_model.dart';
import '../../domain/entities/team_permissions.dart';
import '../../domain/entities/team_activity_log.dart';

class TeamMockDatabase {
  static final TeamMockDatabase _instance = TeamMockDatabase._internal();
  factory TeamMockDatabase() => _instance;
  TeamMockDatabase._internal();

  final List<TeamMemberModel> _teamMembers = [
    // 1. Mohamed Ahmed (Factory Manager)
    TeamMemberModel(
      id: 'mem-001',
      name: 'محمد أحمد',
      email: 'mohamed.ahmed@gulf-factory.com',
      phone: '+20 101 234 5678',
      avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=300&q=80',
      roleTitle: 'مدير المصنع',
      roleCategory: MemberRoleCategory.manager,
      department: 'الإدارة العامة',
      status: MemberStatus.active,
      lastLoginText: 'اليوم، 10:30 ص',
      joinedDate: DateTime(2024, 1, 15),
      roleIcon: Icons.shield_outlined,
      roleIconColor: const Color(0xFF2563EB),
      roleBgColor: const Color(0xFFEFF6FF),
      permissions: TeamPermissions.fullAccess(),
      isOwner: true,
    ),

    // 2. Ahmed Mahmoud (Sales Manager)
    TeamMemberModel(
      id: 'mem-002',
      name: 'أحمد محمود',
      email: 'ahmed.mahmoud@gulf-factory.com',
      phone: '+20 100 987 6543',
      avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=300&q=80',
      roleTitle: 'مسؤول المبيعات',
      roleCategory: MemberRoleCategory.manager,
      department: 'المبيعات والتسويق',
      status: MemberStatus.active,
      lastLoginText: 'أمس، 04:15 م',
      joinedDate: DateTime(2024, 3, 10),
      roleIcon: Icons.bar_chart_rounded,
      roleIconColor: const Color(0xFF059669),
      roleBgColor: const Color(0xFFECFDF5),
      permissions: TeamPermissions.sales(),
    ),

    // 3. Sara Mohamed (Production Supervisor - Pending)
    TeamMemberModel(
      id: 'mem-003',
      name: 'سارة محمد',
      email: 'sara.mohamed@gulf-factory.com',
      phone: '+20 112 345 6789',
      avatarUrl: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?auto=format&fit=crop&w=300&q=80',
      roleTitle: 'مشرف الإنتاج',
      roleCategory: MemberRoleCategory.supervisor,
      department: 'الإنتاج والجودة',
      status: MemberStatus.pending,
      lastLoginText: 'لم يسجل دخول',
      joinedDate: DateTime(2024, 5, 20),
      roleIcon: Icons.precision_manufacturing_outlined,
      roleIconColor: const Color(0xFFEA580C),
      roleBgColor: const Color(0xFFFFF7ED),
      permissions: TeamPermissions.production(),
    ),

    // 4. Ali Hassan (Inventory Officer)
    TeamMemberModel(
      id: 'mem-004',
      name: 'علي حسن',
      email: 'ali.hassan@gulf-factory.com',
      phone: '+20 109 676 5432',
      avatarUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=300&q=80',
      roleTitle: 'مسؤول المخزون',
      roleCategory: MemberRoleCategory.employee,
      department: 'المخازن واللوجستيات',
      status: MemberStatus.active,
      lastLoginText: '2 مايو 2025',
      joinedDate: DateTime(2024, 2, 1),
      roleIcon: Icons.inventory_2_outlined,
      roleIconColor: const Color(0xFF9333EA),
      roleBgColor: const Color(0xFFF3E8FF),
      permissions: TeamPermissions.inventory(),
    ),

    // 5. Ehab Khaled (Financial Accountant - Inactive)
    TeamMemberModel(
      id: 'mem-005',
      name: 'إيهاب خالد',
      email: 'ehab.khaled@gulf-factory.com',
      phone: '+20 115 678 9012',
      avatarUrl: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?auto=format&fit=crop&w=300&q=80',
      roleTitle: 'محاسب مالى',
      roleCategory: MemberRoleCategory.employee,
      department: 'الحسابات والمالية',
      status: MemberStatus.inactive,
      lastLoginText: 'لم يسجل دخول منذ 20 يوم',
      joinedDate: DateTime(2024, 4, 12),
      roleIcon: Icons.account_balance_wallet_outlined,
      roleIconColor: const Color(0xFF2563EB),
      roleBgColor: const Color(0xFFEFF6FF),
      permissions: TeamPermissions.finance(),
    ),
  ];

  final List<TeamActivityLog> _activityLogs = [
    TeamActivityLog(
      id: 'log-001',
      memberId: 'mem-001',
      memberName: 'محمد أحمد',
      action: 'إضافة عضو جديد',
      description: 'قام بإرسال دعوة انضمام للمشرفة سارة محمد',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    TeamActivityLog(
      id: 'log-002',
      memberId: 'mem-002',
      memberName: 'أحمد محمود',
      action: 'الرد على RFQ',
      description: 'أرسل عرض سعر للمصنع بخصوص طلب قطن 100%',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    TeamActivityLog(
      id: 'log-003',
      memberId: 'mem-004',
      memberName: 'علي حسن',
      action: 'تحديث المخزون',
      description: 'تم إضافة 500 كجم غزل قطن ممشط للمستودع',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
    ),
    TeamActivityLog(
      id: 'log-004',
      memberId: 'mem-001',
      memberName: 'محمد أحمد',
      action: 'تغيير الصلاحيات',
      description: 'تعديل صلاحيات الوصول لقسم المالية للموظف إيهاب خالد',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  // Getters
  List<TeamMemberModel> get teamMembers => List.unmodifiable(_teamMembers);
  List<TeamActivityLog> get activityLogs => List.unmodifiable(_activityLogs);

  // Package subscription limits (Starter: 2, Professional: 10, Enterprise: Unlimited)
  final String currentPlan = 'Professional'; // Professional allows 10 members
  final int planMemberLimit = 10;

  // Actions
  bool addMember(TeamMemberModel member) {
    if (_teamMembers.length >= planMemberLimit) {
      return false; // Limit exceeded
    }
    _teamMembers.insert(0, member);
    _activityLogs.insert(
      0,
      TeamActivityLog(
        id: 'log-${DateTime.now().millisecondsSinceEpoch}',
        memberId: member.id,
        memberName: 'المدير',
        action: 'إرسال دعوة',
        description: 'تم إرسال دعوة انضمام إلى ${member.name} (${member.roleTitle})',
        timestamp: DateTime.now(),
      ),
    );
    return true;
  }

  bool updateMember(TeamMemberModel updatedMember) {
    final index = _teamMembers.indexWhere((m) => m.id == updatedMember.id);
    if (index != -1) {
      _teamMembers[index] = updatedMember;
      _activityLogs.insert(
        0,
        TeamActivityLog(
          id: 'log-${DateTime.now().millisecondsSinceEpoch}',
          memberId: updatedMember.id,
          memberName: updatedMember.name,
          action: 'تعديل البيانات والصلاحيات',
          description: 'تم تحديث بيانات وصلاحيات العضو ${updatedMember.name}',
          timestamp: DateTime.now(),
        ),
      );
      return true;
    }
    return false;
  }

  bool deleteMember(String memberId) {
    final member = _teamMembers.firstWhere((m) => m.id == memberId, orElse: () => _teamMembers.first);
    if (member.isOwner) {
      return false; // Cannot delete Owner
    }
    _teamMembers.removeWhere((m) => m.id == memberId);
    _activityLogs.insert(
      0,
      TeamActivityLog(
        id: 'log-${DateTime.now().millisecondsSinceEpoch}',
        memberId: memberId,
        memberName: 'المدير',
        action: 'حذف عضو',
        description: 'تم حذف العضو ${member.name} من فريق العمل',
        timestamp: DateTime.now(),
      ),
    );
    return true;
  }

  bool toggleMemberStatus(String memberId, MemberStatus newStatus) {
    final index = _teamMembers.indexWhere((m) => m.id == memberId);
    if (index != -1) {
      final old = _teamMembers[index];
      if (old.isOwner) return false;

      _teamMembers[index] = old.copyWith(status: newStatus);
      _activityLogs.insert(
        0,
        TeamActivityLog(
          id: 'log-${DateTime.now().millisecondsSinceEpoch}',
          memberId: memberId,
          memberName: old.name,
          action: 'تغيير الحالة',
          description: 'تم تغيير حالة العضو إلى ${newStatus.titleAr}',
          timestamp: DateTime.now(),
        ),
      );
      return true;
    }
    return false;
  }
}

