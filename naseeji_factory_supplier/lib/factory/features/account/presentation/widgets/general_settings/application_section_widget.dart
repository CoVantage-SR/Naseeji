import 'package:flutter/material.dart';
import 'package:naseeji_factory/core/constants/app_colors.dart';
import '../../providers/account_provider.dart';
import '../account_reusable_widgets.dart';

class ApplicationSectionWidget extends StatelessWidget {
  final AppSettingsModel settings;
  final SettingsNotifier notifier;

  const ApplicationSectionWidget({
    super.key,
    required this.settings,
    required this.notifier,
  });

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
            icon: Icons.attach_money_rounded,
            title: 'العملة',
            subtitle: settings.currency,
            onTap: () => _showPickerSheet(context, 'العملة',
                ['جنيه مصري (EGP)', 'دولار أمريكي (USD)', 'يورو (EUR)', 'ريال سعودي (SAR)'],
                notifier.setCurrency),
          ),
          const Divider(height: 0, indent: 60),
          SettingTile(
            icon: Icons.access_time_rounded,
            title: 'المنطقة الزمنية',
            subtitle: settings.timeZone,
            onTap: () => _showPickerSheet(context, 'المنطقة الزمنية',
                ['القاهرة (UTC+3)', 'الرياض (UTC+3)', 'دبي (UTC+4)', 'لندن (UTC+1)'],
                notifier.setTimeZone),
          ),
          const Divider(height: 0, indent: 60),
          SettingTile(
            icon: Icons.calendar_today_rounded,
            title: 'صيغة التاريخ',
            subtitle: settings.dateFormat,
            onTap: () => _showPickerSheet(context, 'صيغة التاريخ',
                ['YYYY/MM/DD', 'DD/MM/YYYY', 'MM-DD-YYYY'],
                notifier.setDateFormat),
          ),
          const Divider(height: 0, indent: 60),
          SettingTile(
            icon: Icons.translate_rounded,
            title: 'لغة التطبيق',
            subtitle: 'العربية (افتراضي)',
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(color: Colors.grey.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(20)),
              child: const Text('قريباً', style: TextStyle(fontSize: 10, color: Colors.grey)),
            ),
          ),
        ],
      ),
    );
  }

  void _showPickerSheet(BuildContext context, String title, List<String> options, ValueChanged<String> onPick) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 12),
            ...options.map((o) => ListTile(
                  title: Text(o, style: const TextStyle(fontSize: 13)),
                  trailing: const Icon(Icons.check_rounded, color: AppColors.primary, size: 18),
                  onTap: () {
                    onPick(o);
                    Navigator.pop(context);
                  },
                )),
          ],
        ),
      ),
    );
  }
}



