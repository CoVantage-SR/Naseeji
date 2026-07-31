import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../providers/comparison_provider.dart';
import '../widgets/suppliers/suppliers_body.dart';

class SuppliersScreen extends ConsumerWidget {
  const SuppliersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedComparisonIds = ref.watch(comparisonNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('الموردين والشركاء'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          if (selectedComparisonIds.isNotEmpty)
            Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.compare_arrows_rounded),
                  tooltip: 'مقارنة الموردين المحددين',
                  onPressed: () => context.push('/suppliers-comparison'),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle),
                    child: Text(
                      selectedComparisonIds.length.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: const SafeArea(
        child: SuppliersBody(),
      ),
    );
  }
}
