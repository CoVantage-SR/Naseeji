import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/team_member_model.dart';
import '../../domain/entities/team_permissions.dart';
import '../../domain/entities/team_activity_log.dart';
import '../providers/team_providers.dart';

class TeamMemberDetailsScreen extends ConsumerStatefulWidget {
  final String memberId;

  const TeamMemberDetailsScreen({super.key, required this.memberId});

  @override
  ConsumerState<TeamMemberDetailsScreen> createState() => _TeamMemberDetailsScreenState();
}

class _TeamMemberDetailsScreenState extends ConsumerState<TeamMemberDetailsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(teamRepositoryProvider);
    // Watch notifier so any updates rebuild this screen
    ref.watch(teamMembersNotifierProvider);
    final member = repo.getMemberById(widget.memberId);
    final activityLogs = ref.watch(teamActivityLogsProvider(widget.memberId));

    if (member == null) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(title: const Text('تفاصيل العضو')),
          body: const Center(child: Text('العضو غير موجود')),
        ),
      );
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FAFB),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF111827)),
            onPressed: () => context.pop(),
          ),
          title: Text(
            member.name,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
          ),
          actions: [
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert_rounded, color: Color(0xFF4B5563)),
              onSelected: (action) => _handleAction(action, member),
              itemBuilder: (context) => [
                if (!member.isOwner)
                  PopupMenuItem(
                    value: member.status == MemberStatus.active ? 'deactivate' : 'activate',
                    child: Text(member.status == MemberStatus.active ? 'تعطيل الحساب' : 'تفعيل الحساب'),
                  ),
                if (member.status == MemberStatus.pending)
                  const PopupMenuItem(value: 'resend', child: Text('إعادة إرسال الدعوة')),
                if (!member.isOwner)
                  const PopupMenuItem(value: 'delete', child: Text('حذف العضو', style: TextStyle(color: Colors.red))),
              ],
            ),
          ],
        ),
        body: Column(
          children: [
            // 1. Basic Info Header Card
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Column(
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image.network(
                          member.avatarUrl,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 60,
                            height: 60,
                            color: const Color(0xFFEFF6FF),
                            child: const Icon(Icons.person_rounded, color: Color(0xFF2563EB), size: 30),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  member.name,
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
                                ),
                                if (member.isOwner) ...[
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEFF6FF),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Text('المالك الرئيسي', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF2563EB))),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 3),
                            Text(member.roleTitle, style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280), fontWeight: FontWeight.w500)),
                            const SizedBox(height: 2),
                            Text('${member.department} • ${member.email}', style: const TextStyle(fontSize: 11, color: Color(0xFF9CA3AF))),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: member.status.bgColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          member.status.titleAr,
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: member.status.color),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Tab Bar
            Container(
              color: Colors.white,
              child: TabBar(
                controller: _tabController,
                labelColor: const Color(0xFF2563EB),
                unselectedLabelColor: const Color(0xFF6B7280),
                indicatorColor: const Color(0xFF2563EB),
                tabs: const [
                  Tab(text: 'مصفوفة الصلاحيات'),
                  Tab(text: 'سجل النشاط'),
                ],
              ),
            ),

            // Tab Views
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Tab 1: Permissions Matrix
                  _buildPermissionsMatrix(member),
                  // Tab 2: Activity Log Timeline
                  _buildActivityLogsTimeline(activityLogs),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionsMatrix(TeamMemberModel member) {
    final p = member.permissions;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildPermissionSection(member, 'قسم المنتجات والمخزون', Icons.inventory_2_outlined, [
            _PermissionToggle('عرض قائمة المنتجات', p.viewProducts, (v) => _updatePerm(member, p.copyWith(viewProducts: v))),
            _PermissionToggle('إضافة منتج جديد', p.addProduct, (v) => _updatePerm(member, p.copyWith(addProduct: v))),
            _PermissionToggle('تعديل أسعار وبيانات المنتجات', p.editProduct, (v) => _updatePerm(member, p.copyWith(editProduct: v))),
            _PermissionToggle('حذف المنتجات', p.deleteProduct, (v) => _updatePerm(member, p.copyWith(deleteProduct: v))),
            _PermissionToggle('إدارة الكميات والمخزون', p.manageInventory, (v) => _updatePerm(member, p.copyWith(manageInventory: v))),
          ]),
          const SizedBox(height: 12),
          _buildPermissionSection(member, 'قسم الصفقات والعروض', Icons.handshake_outlined, [
            _PermissionToggle('عرض كافة الصفقات', p.viewDeals, (v) => _updatePerm(member, p.copyWith(viewDeals: v))),
            _PermissionToggle('استقبال وإرسال عروض السعر (RFQ)', p.manageRfq, (v) => _updatePerm(member, p.copyWith(manageRfq: v))),
            _PermissionToggle('التفاوض المباشر مع المصانع', p.negotiate, (v) => _updatePerm(member, p.copyWith(negotiate: v))),
            _PermissionToggle('توقيع واعتماد العقود والاتفاقيات', p.signAgreement, (v) => _updatePerm(member, p.copyWith(signAgreement: v))),
          ]),
          const SizedBox(height: 12),
          _buildPermissionSection(member, 'قسم المحادثات والملفات', Icons.chat_bubble_outline_rounded, [
            _PermissionToggle('قراءة المحادثات والرسائل', p.readMessages, (v) => _updatePerm(member, p.copyWith(readMessages: v))),
            _PermissionToggle('إرسال وتداول الرسائل', p.sendMessages, (v) => _updatePerm(member, p.copyWith(sendMessages: v))),
            _PermissionToggle('تحميل وإرفاق المستندات والملفات', p.manageFiles, (v) => _updatePerm(member, p.copyWith(manageFiles: v))),
          ]),
          const SizedBox(height: 12),
          _buildPermissionSection(member, 'قسم الإنتاج والتصنيع', Icons.precision_manufacturing_outlined, [
            _PermissionToggle('بدء عمليات التصنيع', p.startProduction, (v) => _updatePerm(member, p.copyWith(startProduction: v))),
            _PermissionToggle('تحديث نسبة الإنجاز والإنتاج', p.updateProgress, (v) => _updatePerm(member, p.copyWith(updateProgress: v))),
            _PermissionToggle('إنهاء واختبار الجودة', p.finishProduction, (v) => _updatePerm(member, p.copyWith(finishProduction: v))),
          ]),
          const SizedBox(height: 12),
          _buildPermissionSection(member, 'قسم الشحن والتسليم', Icons.local_shipping_outlined, [
            _PermissionToggle('إدارة وتجهيز الشحنات', p.manageDelivery, (v) => _updatePerm(member, p.copyWith(manageDelivery: v))),
            _PermissionToggle('تحديث حالة الشحن والتسليم', p.updateDeliveryStatus, (v) => _updatePerm(member, p.copyWith(updateDeliveryStatus: v))),
            _PermissionToggle('تأكيد الاستلام النهائي', p.confirmDelivery, (v) => _updatePerm(member, p.copyWith(confirmDelivery: v))),
          ]),
          const SizedBox(height: 12),
          _buildPermissionSection(member, 'قسم المالية والفواتير', Icons.account_balance_wallet_outlined, [
            _PermissionToggle('عرض المدفوعات والمستحقات', p.viewPayments, (v) => _updatePerm(member, p.copyWith(viewPayments: v))),
            _PermissionToggle('إصدار وإدارة الفواتير', p.manageInvoices, (v) => _updatePerm(member, p.copyWith(manageInvoices: v))),
          ]),
          const SizedBox(height: 12),
          _buildPermissionSection(member, 'قسم الإدارة والصلاحيات', Icons.admin_panel_settings_outlined, [
            _PermissionToggle('إدارة أعضاء فريق العمل', p.manageEmployees, (v) => _updatePerm(member, p.copyWith(manageEmployees: v))),
            _PermissionToggle('إدارة اشتراك المنشأة والباقات', p.manageSubscription, (v) => _updatePerm(member, p.copyWith(manageSubscription: v))),
            _PermissionToggle('تعديل البيانات الأساسية للشركة', p.manageCompanyData, (v) => _updatePerm(member, p.copyWith(manageCompanyData: v))),
          ]),
        ],
      ),
    );
  }

  Widget _buildPermissionSection(TeamMemberModel member, String title, IconData icon, List<_PermissionToggle> toggles) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Icon(icon, size: 18, color: const Color(0xFF2563EB)),
                  const SizedBox(width: 8),
                  Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFF3F4F6)),
            ...toggles.map((t) => SwitchListTile(
                  value: t.value,
                  activeTrackColor: const Color(0xFFBFDBFE),
                  onChanged: member.isOwner ? null : t.onChanged, // Owner permissions locked
                  title: Text(t.title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF374151))),
                  dense: true,
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityLogsTimeline(List<TeamActivityLog> logs) {
    if (logs.isEmpty) {
      return const Center(child: Text('لا يوجد سجل نشاط متاح لهذا العضو'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: logs.length,
      itemBuilder: (context, index) {
        final item = logs[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEFF6FF),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.history_rounded, size: 18, color: Color(0xFF2563EB)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.action, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                      const SizedBox(height: 2),
                      Text(item.description, style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
                    ],
                  ),
                ),
                Text(item.formattedTime, style: const TextStyle(fontSize: 10, color: Color(0xFF9CA3AF))),
              ],
            ),
          ),
        );
      },
    );
  }

  void _updatePerm(TeamMemberModel member, TeamPermissions newPerms) {
    final notifier = ref.read(teamMembersNotifierProvider.notifier);
    notifier.updateMember(member.copyWith(permissions: newPerms));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم تحديث الصلاحيات بنجاح')),
    );
  }

  void _handleAction(String action, TeamMemberModel member) {
    final notifier = ref.read(teamMembersNotifierProvider.notifier);
    if (action == 'deactivate') {
      notifier.toggleMemberStatus(member.id, MemberStatus.inactive);
    } else if (action == 'activate') {
      notifier.toggleMemberStatus(member.id, MemberStatus.active);
    } else if (action == 'resend') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تمت إعادة إرسال الدعوة إلى ${member.email}')));
    } else if (action == 'delete') {
      notifier.deleteMember(member.id);
      context.pop();
    }
  }
}

class _PermissionToggle {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _PermissionToggle(this.title, this.value, this.onChanged);
}
