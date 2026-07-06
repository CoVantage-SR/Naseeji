import 'package:flutter/material.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import 'package:naseeji_supplier/features/profile/domain/entities/supplier_profile.dart';

class SettingsTabView extends StatelessWidget {
  final SupplierProfile profile;

  const SettingsTabView({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      children: [
        ListTile(
          trailing: const Icon(Icons.arrow_forward_ios, size: 14),
          title: const Text('تغيير كلمة المرور الشخصية للمفتاح', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold), textAlign: TextAlign.end),
          leading: const Icon(Icons.lock_outline, color: AppColors.outline),
          onTap: () {},
        ),
        ListTile(
          trailing: const Icon(Icons.arrow_forward_ios, size: 14),
          title: const Text('لغة واجهة التطبيق واللوكاليزيشن', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold), textAlign: TextAlign.end),
          leading: const Icon(Icons.language, color: AppColors.outline),
          onTap: () {},
        ),
        ListTile(
          trailing: const Icon(Icons.arrow_forward_ios, size: 14),
          title: const Text('الأجهزة المتصلة والصلاحيات الأمنية والرموز', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold), textAlign: TextAlign.end),
          leading: const Icon(Icons.devices_outlined, color: AppColors.outline),
          onTap: () {},
        ),
        ListTile(
          trailing: const Icon(Icons.arrow_forward_ios, size: 14),
          title: const Text('تسجيل الخروج الآمن للمورد', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.error), textAlign: TextAlign.end),
          leading: const Icon(Icons.logout, color: AppColors.error),
          onTap: () {},
        ),
      ],
    );
  }
}
