import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/reusable_widgets.dart';
import '../providers/comparison_provider.dart';
import '../providers/suppliers_provider.dart';
import '../widgets/suppliers_comparison_widgets.dart';

class SuppliersComparisonScreen extends ConsumerWidget {
  const SuppliersComparisonScreen({super.key});

  void _showAddSupplierDialog(BuildContext context, WidgetRef ref, List<Supplier> allSuppliers, List<String> currentIds) {
    final available = allSuppliers.where((s) => !currentIds.contains(s.id)).toList();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          alignment: Alignment.center,
          title: const Text('أضف مورد للمقارنة', style: TextStyle(fontWeight: FontWeight.bold)),
          content: available.isEmpty
              ? const Text('جميع الموردين مضافين بالفعل للمقارنة.')
              : SizedBox(
                  width: double.maxFinite,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: available.length,
                    itemBuilder: (context, index) {
                      final sup = available[index];
                      return ListTile(
                        leading: SupplierAvatar(name: sup.name, size: 32),
                        title: Text(sup.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        subtitle: Text(sup.type, style: const TextStyle(fontSize: 10)),
                        onTap: () {
                          ref.read(comparisonNotifierProvider.notifier).toggleSupplier(sup.id);
                          Navigator.of(context).pop();
                        },
                      );
                    },
                  ),
                ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('تراجع'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIds = ref.watch(comparisonNotifierProvider);
    final allSuppliers = ref.watch(suppliersNotifierProvider);
    final notifier = ref.read(comparisonNotifierProvider.notifier);

    final selectedSuppliers = selectedIds
        .map((id) => allSuppliers.firstWhere((s) => s.id == id))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('مقارنة الموردين'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          if (selectedIds.isNotEmpty)
            TextButton(
              onPressed: () => notifier.clear(),
              child: const Text('مسح الكل', style: TextStyle(color: AppColors.error)),
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Top comparison slots
            Container(
              padding: const EdgeInsets.all(16.0),
              color: Theme.of(context).cardColor,
              child: Row(
                children: [
                  for (int i = 0; i < 3; i++)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: i < selectedSuppliers.length
                            ? ComparisonCardWidget(
                                supplier: selectedSuppliers[i],
                                onRemove: () => notifier.removeSupplier(selectedSuppliers[i].id),
                              )
                            : ChooseSupplierButtonWidget(
                                onTap: () => _showAddSupplierDialog(context, ref, allSuppliers, selectedIds),
                              ),
                      ),
                    ),
                ],
              ),
            ),
            const Divider(height: 1),
            // Comparison Table
            Expanded(
              child: selectedSuppliers.isEmpty
                  ? const EmptyState(
                      icon: Icons.compare_arrows_rounded,
                      title: 'ابدأ مقارنة الموردين',
                      description: 'قم بإضافة موردين اثنين على الأقل للمقارنة بينهم في الأسعار، الجودة، وشهادات الاعتماد.',
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          ComparisonRowWidget(
                            label: 'الشكل القانوني',
                            values: selectedSuppliers.map((s) => s.type).toList(),
                          ),
                          ComparisonRowWidget(
                            label: 'التقييم العام',
                            values: selectedSuppliers.map((s) => '${s.rating} ⭐').toList(),
                            highlightBest: selectedSuppliers.map((s) => s.rating == selectedSuppliers.map((s) => s.rating).reduce((a, b) => a > b ? a : b)).toList(),
                          ),
                          ComparisonRowWidget(
                            label: 'سنوات الخبرة',
                            values: selectedSuppliers.map((s) => s.experience).toList(),
                          ),
                          ComparisonRowWidget(
                            label: 'الطلبات المكتملة',
                            values: selectedSuppliers.map((s) => '${s.completedOrders}+').toList(),
                          ),
                          ComparisonRowWidget(
                            label: 'الالتزام بالتسليم',
                            values: selectedSuppliers.map((s) => s.deliveryPerformance).toList(),
                          ),
                          ComparisonRowWidget(
                            label: 'سرعة الرد',
                            values: selectedSuppliers.map((s) => s.responseSpeed).toList(),
                          ),
                          ComparisonRowWidget(
                            label: 'شهادات الاعتماد',
                            values: selectedSuppliers.map((s) => s.certificates.join('، ')).toList(),
                          ),
                          ComparisonRowWidget(
                            label: 'حالة التوثيق',
                            values: selectedSuppliers.map((s) => s.isVerified ? 'موثق ✅' : 'نشط').toList(),
                          ),
                          AppSpacing.hLG,
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () => context.push('/delivery-comparison'),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    side: const BorderSide(color: AppColors.primary),
                                    foregroundColor: AppColors.primary,
                                    shape: RoundedRectangleBorder(borderRadius: AppRadius.rMD),
                                  ),
                                  child: const Text('مقارنة مواعيد الشحن'),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () => context.push('/price-comparison'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    shape: RoundedRectangleBorder(borderRadius: AppRadius.rMD),
                                  ),
                                  child: const Text('مقارنة الأسعار والعروض'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
