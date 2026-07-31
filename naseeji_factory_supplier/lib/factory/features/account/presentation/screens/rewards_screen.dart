import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../providers/account_provider.dart';

class RewardsScreen extends ConsumerWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rewards = ref.watch(rewardPointsProvider);
    final isDark = context.theme.brightness == Brightness.dark;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSecondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    return Scaffold(
      appBar: AppBar(
        title: const Text('برنامج مكافآت نسيجي'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          physics: const BouncingScrollPhysics(),
          children: [
            // Points Overview Header Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFD97706), Color(0xFFF59E0B)],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                borderRadius: AppRadius.rLG,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.warning.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('رصيد النقاط الحالي', style: TextStyle(color: Colors.white70, fontSize: 12)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.25), borderRadius: AppRadius.rRound),
                        child: Text('المستوى ${rewards.tierName}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, color: Colors.white, size: 32),
                      const SizedBox(width: 8),
                      Text(
                        '${_formatPoints(rewards.points)} نقطة',
                        style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: Colors.white30, height: 1),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('إجمالي النقاط المكتسبة: ${rewards.earnedPoints}', style: const TextStyle(color: Colors.white70, fontSize: 11)),
                      Text('النقاط المستبدلة: ${rewards.usedPoints}', style: const TextStyle(color: Colors.white70, fontSize: 11)),
                    ],
                  ),
                ],
              ),
            ),

            AppSpacing.hLG,

            // Available Rewards
            Text('المكافآت المتاحة للاستبدال', style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 15)),
            AppSpacing.hSM,

            ...rewards.availableRewards.map((item) {
              final canRedeem = rewards.points >= item.pointsCost;
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: surface,
                  borderRadius: AppRadius.rMD,
                  border: Border.all(color: border),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: AppColors.warning.withValues(alpha: 0.1), borderRadius: AppRadius.rMD),
                      child: const Icon(Icons.card_giftcard_rounded, color: AppColors.warning, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.title, style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 13)),
                          const SizedBox(height: 3),
                          Text(item.description, style: TextStyle(color: textSecondary, fontSize: 11)),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.stars_rounded, color: AppColors.warning, size: 14),
                              const SizedBox(width: 4),
                              Text('${item.pointsCost} نقطة', style: const TextStyle(color: AppColors.warning, fontWeight: FontWeight.bold, fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: canRedeem ? AppColors.primary : Colors.grey,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: AppRadius.rSM),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      onPressed: canRedeem
                          ? () {
                              ref.read(accountNotifierProvider.notifier).redeemReward(item);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('تم استبدال المكافأة بنجاح: ${item.title}')),
                              );
                            }
                          : null,
                      child: Text(canRedeem ? 'استبدال' : 'نقاط غير كافية', style: const TextStyle(fontSize: 11)),
                    ),
                  ],
                ),
              );
            }),

            AppSpacing.hLG,

            // History Log
            Text('سجل النشاط والاستبدال', style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 15)),
            AppSpacing.hSM,
            Container(
              decoration: BoxDecoration(
                color: surface,
                borderRadius: AppRadius.rLG,
                border: Border.all(color: border),
              ),
              child: Column(
                children: rewards.history.map((h) {
                  final isPositive = h.points > 0;
                  return ListTile(
                    leading: Icon(
                      isPositive ? Icons.add_circle_outline_rounded : Icons.remove_circle_outline_rounded,
                      color: isPositive ? AppColors.success : AppColors.error,
                    ),
                    title: Text(h.title, style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 12)),
                    subtitle: Text(h.date, style: TextStyle(color: textSecondary, fontSize: 10)),
                    trailing: Text(
                      '${isPositive ? '+' : ''}${h.points} نقطة',
                      style: TextStyle(
                        color: isPositive ? AppColors.success : AppColors.error,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatPoints(int points) {
    return points.toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+$)'),
          (match) => '${match[1]},',
        );
  }
}

