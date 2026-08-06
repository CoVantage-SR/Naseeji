import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_factory/core/constants/app_colors.dart';
import 'package:naseeji_factory/core/constants/app_radius.dart';
import 'package:naseeji_factory/core/constants/app_spacing.dart';
import 'package:naseeji_factory/supplier/features/credits/domain/entities/credit_package.dart';
import 'package:naseeji_factory/supplier/features/credits/presentation/controllers/credit_manager.dart';

class CreditStoreScreen extends ConsumerStatefulWidget {
  const CreditStoreScreen({super.key});

  @override
  ConsumerState<CreditStoreScreen> createState() => _CreditStoreScreenState();
}

class _CreditStoreScreenState extends ConsumerState<CreditStoreScreen> {
  bool _isProcessing = false;

  Future<void> _handlePurchase(CreditPackage package) async {
    setState(() => _isProcessing = true);
    await Future.delayed(const Duration(milliseconds: 600));

    final success = await ref
        .read(creditManagerProvider.notifier)
        .buyPackage(package);

    if (mounted) {
      setState(() => _isProcessing = false);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color(0xFF16A34A),
            content: Text(
              'تم شراء باقة (${package.name}) وإضافة ${package.credits} نقطة إلى رصيدك بنجاح! 🎉',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final creditState = ref.watch(creditManagerProvider);
    final credits = creditState.value;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text(
          'متجر النقاط والرصيد',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/supplier/dashboard');
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Current Balance Top Banner ──────────────────────────────
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: AppRadius.rLG,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2563EB).withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.bolt_rounded,
                      color: Color(0xFFFBBF24),
                      size: 36,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'رصيد النقاط الحالي',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${credits?.creditsBalance ?? 0} نقطة',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            AppSpacing.hLG,

            const Text(
              'اختر باقة النقاط المناسبة لنشاطك',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'النقاط تتيح لك توثيق الحساب، وإضافة المنتجات وفيديوهات العرض بكل مرونة بدون اشتراكات شهرية',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.grey[400] : const Color(0xFF64748B),
              ),
            ),

            AppSpacing.hMD,

            // ── Credit Packages List ─────────────────────────────────────
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: CreditPackage.defaultPackages.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final pkg = CreditPackage.defaultPackages[index];
                final isPopular = pkg.badge == 'الأكثر طلباً';

                return Card(
                  elevation: isPopular ? 2 : 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.rMD,
                    side: BorderSide(
                      color: isPopular
                          ? const Color(0xFF2563EB)
                          : (isDark ? AppColors.borderDark : AppColors.borderLight),
                      width: isPopular ? 2 : 1,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              pkg.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            if (pkg.badge != null)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: isPopular
                                      ? const Color(0xFFEFF6FF)
                                      : const Color(0xFFF3E8FF),
                                  borderRadius: AppRadius.rRound,
                                ),
                                child: Text(
                                  pkg.badge!,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: isPopular
                                        ? const Color(0xFF2563EB)
                                        : const Color(0xFF9333EA),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(
                              Icons.bolt_rounded,
                              color: Color(0xFFF59E0B),
                              size: 24,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${pkg.credits} نقطة',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2563EB),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '${pkg.price.toInt()} ${pkg.currency}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isProcessing ? null : () => _handlePurchase(pkg),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isPopular
                                  ? const Color(0xFF2563EB)
                                  : (isDark ? AppColors.surfaceDark : Colors.grey[900]),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              minimumSize: const Size(0, 44),
                              shape: const RoundedRectangleBorder(
                                borderRadius: AppRadius.rMD,
                              ),
                            ),
                            child: _isProcessing
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    'شراء الآن — ${pkg.price.toInt()} ${pkg.currency}',
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            AppSpacing.hXL,

            // ── Purchase History Section ──────────────────────────────────
            const Text(
              'سجل عمليات الشراء والعمليات',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            if (credits?.transactions.isEmpty ?? true)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Text(
                    'لا يوجد سجل عمليات سابق',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: credits!.transactions.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final tx = credits.transactions[index];
                  final isDeduct = tx.isDeduction;

                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isDeduct
                            ? const Color(0xFFFEF2F2)
                            : const Color(0xFFECFDF5),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isDeduct
                            ? Icons.remove_circle_outline_rounded
                            : Icons.add_circle_outline_rounded,
                        color: isDeduct
                            ? const Color(0xFFEF4444)
                            : const Color(0xFF10B981),
                        size: 20,
                      ),
                    ),
                    title: Text(
                      tx.operation,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    subtitle: Text(
                      '${tx.createdAt.year}/${tx.createdAt.month}/${tx.createdAt.day} • الرصيد بعدها: ${tx.balanceAfter}',
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                    trailing: Text(
                      '${tx.amount > 0 ? "+" : ""}${tx.amount} نقطة',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: isDeduct
                            ? const Color(0xFFEF4444)
                            : const Color(0xFF10B981),
                      ),
                    ),
                  );
                },
              ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
