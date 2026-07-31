import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/reusable_widgets.dart';
import '../providers/comparison_provider.dart';
import '../providers/suppliers_provider.dart';
import '../widgets/suppliers_comparison/comparison_add_dialog.dart';
import '../widgets/suppliers_comparison/comparison_table_widget.dart';
import '../widgets/suppliers_comparison_widgets.dart';

class SuppliersComparisonScreen extends ConsumerWidget {
  const SuppliersComparisonScreen({super.key});

  void _showAddSupplierDialog(BuildContext context, WidgetRef ref, List<Supplier> allSuppliers, List<String> currentIds) {
    showDialog(
      context: context,
      builder: (context) {
        return ComparisonAddDialog(
          allSuppliers: allSuppliers,
          currentIds: currentIds,
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
                      child: ComparisonTableWidget(
                        selectedSuppliers: selectedSuppliers,
                        onDeliveryComparisonTap: () => context.push('/delivery-comparison'),
                        onPriceComparisonTap: () => context.push('/price-comparison'),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

