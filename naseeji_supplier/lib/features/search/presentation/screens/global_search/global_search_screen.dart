import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../../controllers/search_controller.dart';
import 'widgets/search_item_card.dart';

class GlobalSearchScreen extends ConsumerWidget {
  const GlobalSearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchAsync = ref.watch(searchControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('البحث العالمي'),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.onSurface,
        elevation: 0.5,
      ),
      body: Column(
        children: [
          // Search Input Container
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'ابحث عن خيوط، أقمشة، أو فئات...',
                prefixIcon: const Icon(Icons.search, color: AppColors.outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.outlineVariant),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onChanged: (val) {
                ref.read(searchControllerProvider.notifier).search(val);
              },
            ),
          ),

          // Search Results
          Expanded(
            child: searchAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('خطأ: $err')),
              data: (items) {
                if (items.isEmpty) {
                  return const Center(
                    child: Text(
                      'لا توجد نتائج بحث مطابقة',
                      style: TextStyle(color: AppColors.outline),
                    ),
                  );
                }

                return ListView.separated(
                  itemCount: items.length,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return SearchItemCard(item: item);
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
