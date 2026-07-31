import 'package:flutter/material.dart';
import '../account_reusable_widgets.dart';

class DataSectionWidget extends StatelessWidget {
  const DataSectionWidget({super.key});

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
            icon: Icons.cleaning_services_rounded,
            title: 'مسح الكاش',
            subtitle: '٢٤ ميجابايت',
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('تم مسح الكاش بنجاح.')),
            ),
          ),
          const Divider(height: 0, indent: 60),
          SettingTile(
            icon: Icons.file_download_rounded,
            title: 'تصدير البيانات',
            subtitle: 'تحميل نسخة من بياناتك',
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('جاري تحضير الملف للتحميل...')),
            ),
          ),
        ],
      ),
    );
  }
}

