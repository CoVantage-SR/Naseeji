import 'package:flutter/material.dart';
import '../account_reusable_widgets.dart';

class AccountSectionWidget extends StatelessWidget {
  const AccountSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          SettingTile(
            icon: Icons.lock_rounded,
            title: 'تغيير كلمة المرور',
            subtitle: 'آخر تغيير: منذ ٣٠ يوماً',
            onTap: () => _showChangePasswordSheet(context),
          ),
          const Divider(height: 0, indent: 60),
          SettingTile(
            icon: Icons.phone_rounded,
            title: 'تغيير رقم الهاتف',
            subtitle: '+20 10 *** *678',
            onTap: () {},
          ),
          const Divider(height: 0, indent: 60),
          SettingTile(
            icon: Icons.email_rounded,
            title: 'تغيير البريد الإلكتروني',
            subtitle: 'info@naseeji.com',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  void _showChangePasswordSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('تغيير كلمة المرور', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 16),
            const TextField(obscureText: true, decoration: InputDecoration(labelText: 'كلمة المرور الحالية', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            const TextField(obscureText: true, decoration: InputDecoration(labelText: 'كلمة المرور الجديدة', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            const TextField(obscureText: true, decoration: InputDecoration(labelText: 'تأكيد كلمة المرور الجديدة', border: OutlineInputBorder())),
            const SizedBox(height: 16),
            PrimaryButton(label: 'تغيير كلمة المرور', onPressed: () => Navigator.pop(context)),
          ],
        ),
      ),
    );
  }
}

