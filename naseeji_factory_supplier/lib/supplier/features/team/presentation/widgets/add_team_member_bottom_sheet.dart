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
  final _passwordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final MemberRoleCategory _selectedCategory = MemberRoleCategory.employee;
  String _permissionPreset = 'المبيعات';

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _roleTitleCtrl.dispose();
    _departmentCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          top: 16,
          left: 16,
          right: 16,
        ),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
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
                    Row(
                      children: [
                        Icon(Icons.person_add_alt_1_rounded, color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB), size: 22),
                        const SizedBox(width: 8),
                        Text(
                          'دعوة عضو جديد وإنشاء الحساب',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF111827)),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.close_rounded, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF9CA3AF)),
                    ),
                  ],
                ),
                Divider(height: 1, color: isDark ? const Color(0xFF334155) : const Color(0xFFF3F4F6)),
                const SizedBox(height: 14),

                // Name
                _buildTextField(
                  controller: _nameCtrl,
                  label: 'الاسم بالكامل',
                  hint: 'أدخل اسم الموظف',
                  icon: Icons.person_outline_rounded,
                  validator: (v) => v == null || v.trim().isEmpty ? 'برجاء أدخل الاسم' : null,
                  isDark: isDark,
                ),
                const SizedBox(height: 10),

                // Email
                _buildTextField(
                  controller: _emailCtrl,
                  label: 'البريد الإلكتروني الحساب',
                  hint: 'employee@gulf-factory.com',
                  icon: Icons.mail_outline_rounded,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) => v == null || !v.contains('@') ? 'برجاء أدخل بريد إلكتروني صحيح' : null,
                  isDark: isDark,
                ),
                const SizedBox(height: 10),

                // Phone
                _buildTextField(
                  controller: _phoneCtrl,
                  label: 'رقم الهاتف الداخلي / الجوال',
                  hint: '+20 100 000 0000',
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  isDark: isDark,
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
                        isDark: isDark,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildTextField(
                        controller: _departmentCtrl,
                        label: 'القسم',
                        hint: 'مثال: المبيعات',
                        icon: Icons.apartment_rounded,
                        isDark: isDark,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Password & Confirm Password Fields
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: _passwordCtrl,
                        label: 'كلمة مرور الحساب',
                        hint: '••••••••',
                        icon: Icons.lock_outline_rounded,
                        obscureText: _obscurePassword,
                        isDark: isDark,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                            size: 18,
                            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280),
                          ),
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'أدخل كلمة المرور';
                          if (v.trim().length < 6) return 'يجب 6 أحرف على الأقل';
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildTextField(
                        controller: _confirmPasswordCtrl,
                        label: 'تأكيد كلمة المرور',
                        hint: '••••••••',
                        icon: Icons.lock_clock_outlined,
                        obscureText: _obscureConfirmPassword,
                        isDark: isDark,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                            size: 18,
                            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280),
                          ),
                          onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                        ),
                        validator: (v) {
                          if (v != _passwordCtrl.text) return 'كلمة المرور غير متطابقة';
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Preset Permissions Dropdown
                Text(
                  'حزمة الصلاحيات الممنوحة',
                  style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF374151)),
                ),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  initialValue: _permissionPreset,
                  style: TextStyle(fontSize: 12, color: isDark ? Colors.white : const Color(0xFF111827)),
                  dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: isDark ? const Color(0xFF334155) : const Color(0xFFE5E7EB)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: isDark ? const Color(0xFF334155) : const Color(0xFFE5E7EB)),
                    ),
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
                    onPressed: () => _submit(isDark),
                    icon: const Icon(Icons.person_add_rounded, color: Colors.white, size: 18),
                    label: const Text(
                      'إنشاء الحساب ودعوة العضو',
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
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
    required bool isDark,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF374151)),
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          validator: validator,
          style: TextStyle(fontSize: 12, color: isDark ? Colors.white : const Color(0xFF111827)),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(fontSize: 11.5, color: isDark ? const Color(0xFF64748B) : const Color(0xFF9CA3AF)),
            prefixIcon: Icon(icon, size: 18, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280)),
            suffixIcon: suffixIcon,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: isDark ? const Color(0xFF334155) : const Color(0xFFE5E7EB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: isDark ? const Color(0xFF334155) : const Color(0xFFE5E7EB)),
            ),
          ),
        ),
      ],
    );
  }

  void _submit(bool isDark) {
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
      status: MemberStatus.active,
      lastLoginText: 'تم إنشاء الحساب الآن',
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
        content: Text('تم إنشاء حساب ${newMember.name} وتعيين كلمة المرور وإضافته للفريق بنجاح!'),
        backgroundColor: const Color(0xFF16A34A),
      ),
    );
  }
}


