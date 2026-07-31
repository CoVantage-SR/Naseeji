import 'package:flutter/material.dart';
import 'package:naseeji_factory/core/theme/app_colors.dart';

class UpgradeDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onUpgrade;
  final VoidCallback onBuyPack;

  const UpgradeDialog({
    super.key,
    required this.title,
    required this.content,
    required this.onUpgrade,
    required this.onBuyPack,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Theme.of(context).colorScheme.onSurface),
            ),
            SizedBox(width: 8),
            const Icon(Icons.info_outline, color: Color(0xFF0040E0), size: 24),
          ],
        ),
        content: Text(
          content,
          style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant, height: 1.5),
          textAlign: TextAlign.right,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'إلغاء',
              style: TextStyle(color: AppColors.outline),
            ),
          ),
          OutlinedButton(
            onPressed: () {
              Navigator.pop(context);
              onBuyPack();
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF0040E0),
              side: const BorderSide(color: Color(0xFF0040E0)),
            ),
            child: Text('شراء باقة منتجات', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onUpgrade();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0040E0),
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            child: Text('ترقية الباقة العامة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
          ),
        ],
      ),
    );
  }
}


