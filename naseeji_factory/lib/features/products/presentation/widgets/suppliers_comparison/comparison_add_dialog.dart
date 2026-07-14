import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/reusable_widgets.dart';
import '../../providers/comparison_provider.dart';
import '../../providers/suppliers_provider.dart';

class ComparisonAddDialog extends ConsumerWidget {
  final List<Supplier> allSuppliers;
  final List<String> currentIds;

  const ComparisonAddDialog({
    super.key,
    required this.allSuppliers,
    required this.currentIds,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final available = allSuppliers.where((s) => !currentIds.contains(s.id)).toList();

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
  }
}
