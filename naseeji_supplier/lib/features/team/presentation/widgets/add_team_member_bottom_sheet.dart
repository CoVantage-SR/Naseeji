import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/team_member_model.dart';
import '../../domain/entities/team_permissions.dart';
import '../providers/team_providers.dart';
import 'upgrade_plan_dialog.dart';

class AddTeamMemberBottomSheet extends ConsumerStatefulWidget {
  const AddTeamMemberBottomSheet({super.key});

  @override
  ConsumerState<AddTeamMemberBottomSheet> createState() => _AddTeamMemberBottomSheetState();
}

class _AddTeamMemberBottomSheetState extends ConsumerState<AddTeamMemberBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _roleTitleCtrl = TextEditingController(text: 'مسؤول المبيعات');
  final _departmentCtrl = TextEditingController(text: 'المبيعات والتسويق');

  MemberRoleCategory _selectedCategory = MemberRoleCategory.employee;
  String _permissionPreset = 'المبيعات';

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _roleTitleCtrl.dispose();
    _departmentCtrl.dispose();
    super.dispose();
  }

  TeamPermissions _getPermissionsFromPreset(String preset) {
    switch (preset) {
      case 'المبيعات':
        return TeamPermissions.sales();
      case 'الإنتاج':
        return TeamPermissions.production();
      case 'المخزون':
        return TeamPermissions.inventory();
      case 'المالية':
        return TeamPermissions.finance();
      default:
        return TeamPermissions.fullAccess();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          top: 16,
          left: 16,
          right: 16,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.person_add_alt_1_rounded, color: Color(0xFF2563EB), size: 22),
                        SizedBox(width: 8),
                        Text(
                          'دعوة عضو جديد للفريق',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded, color: Color(0xFF9CA3AF)),
                    ),
                  ],
                ),
                const Divider(height: 1, color: Color(0xFFF3F4F6)),
                const SizedBox(height: 14),

                // Name
                _buildTextField(
                  controller: _nameCtrl,
                  label: 'الاسم بالكامل',
                  hint: 'أدخل اسم الموظف',
                  icon: Icons.person_outline_rounded,
                  validator: (v) => v == null || v.trim().isEmpty ? 'برجاء أدخل الاسم' : null,
                ),
                const SizedBox(height: 10),

                // Email
                _buildTextField(
                  controller: _emailCtrl,
                  label: 'البريد الإلكتروني',
                  hint: 'employee@gulf-factory.com',
                  icon: Icons.mail_outline_rounded,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) => v == null || !v.contains('@') ? 'برجاء أدخل بريد إلكتروني صحيح' : null,
                ),
                const SizedBox(height: 10),

                // Phone
                _buildTextField(
                  controller: _phoneCtrl,
                  label: 'رقم الهاتف الداخلي / الجوال',
                  hint: '+20 100 000 0000',
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 10),

                // Role Title & Department
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: _roleTitleCtrl,
                        label: 'المسمى الوظيفي',
                        hint: 'مثال: مشرف إنتاج',
                        icon: Icons.badge_outlined,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildTextField(
                        controller: _departmentCtrl,
                        label: 'القسم',
                        hint: 'مثال: المبيعات',
                        icon: Icons.apartment_rounded,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Preset Permissions Dropdown
                const Text(
                  'حزمة الصلاحيات الممنوحة',
                  style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF374151)),
                ),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  value: _permissionPreset,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'المبيعات', child: Text('صلاحيات المبيعات والتفاوض', style: TextStyle(fontSize: 12))),
                    DropdownMenuItem(value: 'الإنتاج', child: Text('صلاحيات الإنتاج والتصنيع', style: TextStyle(fontSize: 12))),
                    DropdownMenuItem(value: 'المخزون', child: Text('صلاحيات المخازن والتوريد', style: TextStyle(fontSize: 12))),
                    DropdownMenuItem(value: 'المالية', child: Text('صلاحيات المالية والفواتير', style: TextStyle(fontSize: 12))),
                    DropdownMenuItem(value: 'الكل', child: Text('صلاحيات كاملة (مدير)', style: TextStyle(fontSize: 12))),
                  ],
                  onChanged: (val) {
                    if (val != null) setState(() => _permissionPreset = val);
                  },
                ),

                const SizedBox(height: 20),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: _submit,
                    icon: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                    label: const Text(
                      'إرسال الدعوة',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF374151)),
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          style: const TextStyle(fontSize: 12, color: Color(0xFF111827)),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(fontSize: 11.5, color: Color(0xFF9CA3AF)),
            prefixIcon: Icon(icon, size: 18, color: const Color(0xFF6B7280)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
          ),
        ),
      ],
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final repo = ref.read(teamRepositoryProvider);
    if (!repo.canAddMember) {
      Navigator.pop(context);
      showDialog(context: context, builder: (_) => const UpgradePlanDialog());
      return;
    }

    final newMember = TeamMemberModel(
      id: 'mem-${DateTime.now().millisecondsSinceEpoch}',
      name: _nameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      phone: _phoneCtrl.text.trim().isNotEmpty ? _phoneCtrl.text.trim() : '+20 100 000 0000',
      avatarUrl: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=300&q=80',
      roleTitle: _roleTitleCtrl.text.trim(),
      roleCategory: _selectedCategory,
      department: _departmentCtrl.text.trim(),
      status: MemberStatus.pending,
      lastLoginText: 'لم يسجل دخول',
      joinedDate: DateTime.now(),
      roleIcon: Icons.badge_outlined,
      roleIconColor: const Color(0xFF2563EB),
      roleBgColor: const Color(0xFFEFF6FF),
      permissions: _getPermissionsFromPreset(_permissionPreset),
    );

    final notifier = ref.read(teamMembersNotifierProvider.notifier);
    notifier.addMember(newMember);

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم إرسال دعوة الانضمام بنجاح إلى ${newMember.name}'),
        backgroundColor: const Color(0xFF16A34A),
      ),
    );
  }
}
