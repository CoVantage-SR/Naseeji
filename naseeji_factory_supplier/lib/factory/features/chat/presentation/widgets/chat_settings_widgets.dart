import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/reusable_widgets.dart';

class DangerZoneWidget extends StatelessWidget {
  final VoidCallback onDeleteChat;
  final VoidCallback onBlockSupplier;
  final bool isBlocked;

  const DangerZoneWidget({
    super.key,
    required this.onDeleteChat,
    required this.onBlockSupplier,
    required this.isBlocked,
  });

  @override
  Widget build(BuildContext context) {
    return PrimaryCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'منطقة الخطر (Danger Zone)',
            style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.error, fontSize: 13),
          ),
          const SizedBox(height: 12),
          ListTile(
            leading: const Icon(Icons.block_flipped, color: AppColors.error),
            title: Text(isBlocked ? 'إلغاء حظر المورد' : 'حظر هذا المورد', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            subtitle: const Text('لن تتمكن من استلام أي عروض أسعار جديدة منه.', style: TextStyle(fontSize: 10)),
            onTap: onBlockSupplier,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.delete_forever_rounded, color: AppColors.error),
            title: const Text('حذف سجل المحادثة بالكامل', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.error)),
            subtitle: const Text('سيتم حذف كافة الرسائل والملفات بشكل نهائي.', style: TextStyle(fontSize: 10)),
            onTap: onDeleteChat,
          ),
        ],
      ),
    );
  }
}


