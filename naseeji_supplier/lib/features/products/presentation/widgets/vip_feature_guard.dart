import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naseeji_supplier/features/profile/presentation/controllers/profile_controller.dart';
import 'premium_lock_overlay.dart';
import 'vip_bottom_sheet.dart';

class VipFeatureGuard extends ConsumerWidget {
  final Widget child;
  final VoidCallback? onCancelTap;

  const VipFeatureGuard({
    super.key,
    required this.child,
    this.onCancelTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileControllerProvider);

    return profileAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('خطأ: $err')),
      data: (profile) {
        final isVip = profile.isVip;

        if (isVip) {
          return child;
        }

        return Stack(
          children: [
            // The blurred child (interaction disabled)
            AbsorbPointer(
              absorbing: true,
              child: child,
            ),
            // The Premium Overlay
            PremiumLockOverlay(
              onUpgradeTap: () => _showUpgradeSheet(context, ref),
              onCancelTap: onCancelTap,
            ),
          ],
        );
      },
    );
  }

  void _showUpgradeSheet(BuildContext context, WidgetRef ref) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const VipBottomSheet(),
    );

    if (result == true) {
      // Toggle VIP Status to true
      await ref.read(profileControllerProvider.notifier).toggleVipStatus();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تهانينا! تم تفعيل اشتراك VIP بنجاح وبدء الميزات المميزة.'),
            backgroundColor: Color(0xFF16A34A),
          ),
        );
      }
    }
  }
}
