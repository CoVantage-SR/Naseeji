import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/security_providers.dart';
import '../widgets/security_widgets.dart';

class SecurityLoginScreen extends ConsumerWidget {
  const SecurityLoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final securityState = ref.watch(securityProvider);
    final notifier = ref.read(securityProvider.notifier);
    final settings = securityState.settings;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF9FAFB),
        body: SafeArea(
          child: Column(
            children: [
              // 1. AppBar Header
              SecurityHeader(
                onBack: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go('/profile');
                  }
                },
              ),

              // Scrollable Body
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // -------------------------------------------------------
                      // SECTION 1: طرق تسجيل الدخول (Login Methods)
                      // -------------------------------------------------------
                      const SectionTitle(title: 'طرق تسجيل الدخول'),
                      Container(
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1E293B) : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE5E7EB)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.02),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // 1. Change Password
                            LoginMethodTile(
                              title: 'كلمة المرور',
                              subtitle: 'آخر تغيير ${settings.lastPasswordChange}',
                              icon: Icons.lock_outline_rounded,
                              trailingWidget: OutlinedButton(
                                onPressed: () => _showChangePasswordModal(context, notifier),
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFBF7FF),
                                  side: const BorderSide(color: Color(0xFFE9D5FF)),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                ),
                                child: const Text(
                                  'تغيير كلمة المرور',
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF9333EA)),
                                ),
                              ),
                            ),
                            const Divider(height: 1, color: Color(0xFFF3F4F6)),

                            // 2. Two-Factor Authentication (2FA)
                            LoginMethodTile(
                              title: 'التحقق بخطوتين',
                              subtitle: settings.twoFactorEnabled ? 'مفعل' : 'غير مفعل',
                              icon: Icons.verified_user_outlined,
                              trailingWidget: settings.twoFactorEnabled
                                  ? Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFDCFCE7),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Text(
                                        'مفعل',
                                        style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Color(0xFF16A34A)),
                                      ),
                                    )
                                  : OutlinedButton(
                                      onPressed: () => notifier.toggleTwoFactor(true),
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor: const Color(0xFFFBF7FF),
                                        side: const BorderSide(color: Color(0xFFE9D5FF)),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      ),
                                      child: const Text('تفعيل', style: TextStyle(fontSize: 11, color: Color(0xFF9333EA))),
                                    ),
                            ),
                            const Divider(height: 1, color: Color(0xFFF3F4F6)),

                            // 3. Fingerprint Login
                            LoginMethodTile(
                              title: 'تسجيل الدخول بالبصمة',
                              subtitle: settings.fingerprintEnabled ? 'مفعل' : 'غير مفعل',
                              icon: Icons.fingerprint_rounded,
                              trailingWidget: settings.fingerprintEnabled
                                  ? Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFDCFCE7),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Text(
                                        'مفعل',
                                        style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Color(0xFF16A34A)),
                                      ),
                                    )
                                  : OutlinedButton(
                                      onPressed: () => notifier.toggleFingerprint(true),
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor: const Color(0xFFFBF7FF),
                                        side: const BorderSide(color: Color(0xFFE9D5FF)),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      ),
                                      child: const Text('تفعيل', style: TextStyle(fontSize: 11, color: Color(0xFF9333EA))),
                                    ),
                            ),
                            const Divider(height: 1, color: Color(0xFFF3F4F6)),

                            // 4. Face ID Login
                            LoginMethodTile(
                              title: 'تسجيل الدخول بالوجه',
                              subtitle: settings.faceIdEnabled ? 'مفعل' : 'غير مفعل',
                              icon: Icons.face_retouching_natural_rounded,
                              trailingWidget: settings.faceIdEnabled
                                  ? Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFDCFCE7),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Text(
                                        'مفعل',
                                        style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Color(0xFF16A34A)),
                                      ),
                                    )
                                  : OutlinedButton(
                                      onPressed: () {
                                        notifier.toggleFaceId(true);
                                        _showToast(context, 'تم تفعيل تسجيل الدخول بالوجه بنجاح!');
                                      },
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor: const Color(0xFFFBF7FF),
                                        side: const BorderSide(color: Color(0xFFE9D5FF)),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      ),
                                      child: const Text('تفعيل', style: TextStyle(fontSize: 11, color: Color(0xFF9333EA))),
                                    ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // -------------------------------------------------------
                      // SECTION 2: الأجهزة والجلسات النشطة (Active Sessions)
                      // -------------------------------------------------------
                      const SectionTitle(title: 'الأجهزة والجلسات النشطة'),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                        ),
                        child: Column(
                          children: [
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: securityState.sessions.length,
                              separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFF3F4F6)),
                              itemBuilder: (context, index) {
                                final session = securityState.sessions[index];
                                return DeviceSessionTile(
                                  session: session,
                                  onLogout: () => _confirmLogoutDevice(context, notifier, session),
                                );
                              },
                            ),
                            const Divider(height: 1, color: Color(0xFFE5E7EB)),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: TextButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF9333EA), size: 18),
                                label: const Text(
                                  'عرض جميع الجلسات',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF9333EA)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // -------------------------------------------------------
                      // SECTION 3: نشاط الأمان (Security Activity)
                      // -------------------------------------------------------
                      const SectionTitle(title: 'نشاط الأمان'),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                        ),
                        child: Column(
                          children: [
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: securityState.activities.length,
                              separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFF3F4F6)),
                              itemBuilder: (context, index) {
                                final act = securityState.activities[index];
                                return SecurityActivityItem(activity: act);
                              },
                            ),
                            const Divider(height: 1, color: Color(0xFFE5E7EB)),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: TextButton(
                                onPressed: () {},
                                child: const Text(
                                  'عرض المزيد من النشاط',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF9333EA)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // -------------------------------------------------------
                      // SECTION 4: نصائح الأمان (Security Tips)
                      // -------------------------------------------------------
                      const SecurityTipsSection(),

                      const SizedBox(height: 24),

                      // -------------------------------------------------------
                      // BOTTOM BUTTON: مراجعة إعدادات الأمان
                      // -------------------------------------------------------
                      SecurityBottomButton(
                        onPressed: () {
                          _showToast(context, 'جميع إعدادات الأمان تعمل بأعلى كفاءة وحماية 🛡️');
                        },
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showChangePasswordModal(BuildContext context, SecurityNotifier notifier) {
    final oldPasswordCtrl = TextEditingController();
    final newPasswordCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('تغيير كلمة المرور', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 14),
                TextField(
                  controller: oldPasswordCtrl,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'كلمة المرور الحالية',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: newPasswordCtrl,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'كلمة المرور الجديدة',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      notifier.changePassword();
                      _showToast(context, 'تم تغيير كلمة المرور بنجاح! 🔑');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF9333EA),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('حفظ كلمة المرور الجديدة', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _confirmLogoutDevice(BuildContext context, SecurityNotifier notifier, dynamic session) {
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('تسجيل خروج الجهاز'),
          content: Text('هل أنت تأكد من إنهاء جلسة ${session.deviceName}؟'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                notifier.logoutDevice(session.deviceId);
                _showToast(context, 'تم تسجيل الخروج من الجهاز بنجاح');
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFDC2626)),
              child: const Text('تسجيل الخروج', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  void _showToast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF16A34A),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

