import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../providers/purchases_provider.dart';
import 'purchases_reusable_widgets.dart';

// ─── Purchase History AppBar ───────────────────────────────────────────────
class PurchaseHistoryAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onFilterTap;
  const PurchaseHistoryAppBarWidget({super.key, required this.onFilterTap});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('سجل المشتريات والفواتير'),
      actions: [
        IconButton(
          icon: const Icon(Icons.filter_list_rounded),
          onPressed: onFilterTap,
          tooltip: 'تصفية',
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

// ─── Search Widget ─────────────────────────────────────────────────────────
class SearchWidget extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final String hint;
  const SearchWidget({super.key, required this.onChanged, this.hint = 'البحث...'});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 13),
        prefixIcon: const Icon(Icons.search_rounded, color: Colors.grey),
        filled: true,
        fillColor: context.theme.brightness == Brightness.dark
            ? AppColors.surfaceDark
            : AppColors.backgroundLight,
        border: OutlineInputBorder(
          borderRadius: AppRadius.rMD,
          borderSide: BorderSide(
            color: context.theme.brightness == Brightness.dark
                ? AppColors.borderDark
                : AppColors.borderLight,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.rMD,
          borderSide: BorderSide(
            color: context.theme.brightness == Brightness.dark
                ? AppColors.borderDark
                : AppColors.borderLight,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.rMD,
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
    );
  }
}

// ─── Filter Widget ─────────────────────────────────────────────────────────
class FilterWidget extends StatelessWidget {
  final List<String> filters;
  final String selected;
  final ValueChanged<String> onFilterChanged;
  const FilterWidget({
    super.key,
    required this.filters,
    required this.selected,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((f) {
          final isSelected = f == selected;
          return Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: FilterChip(
              label: Text(f, style: TextStyle(fontSize: 11, color: isSelected ? Colors.white : null)),
              selected: isSelected,
              onSelected: (_) => onFilterChanged(f),
              selectedColor: AppColors.primary,
              checkmarkColor: Colors.white,
              showCheckmark: false,
              shape: RoundedRectangleBorder(
                borderRadius: AppRadius.rRound,
                side: BorderSide(
                  color: isSelected ? AppColors.primary : AppColors.borderLight,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ─── Status Tabs Widget ────────────────────────────────────────────────────
class StatusTabsWidget extends StatelessWidget {
  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onTabChanged;
  const StatusTabsWidget({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: tabs.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final isSelected = i == selectedIndex;
          return GestureDetector(
            onTap: () => onTabChanged(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.transparent,
                borderRadius: AppRadius.rRound,
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.borderLight,
                ),
              ),
              child: Text(
                tabs[i],
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 12,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─── Purchase History List Widget ──────────────────────────────────────────
class PurchaseHistoryListWidget extends StatelessWidget {
  final List<PurchaseModel> purchases;
  final Function(String) onViewDetails;
  final Function(String) onReorder;

  const PurchaseHistoryListWidget({
    super.key,
    required this.purchases,
    required this.onViewDetails,
    required this.onReorder,
  });

  @override
  Widget build(BuildContext context) {
    if (purchases.isEmpty) {
      return const EmptyStateWidget(
        title: 'لا توجد مشتريات',
        description: 'لم يتم العثور على سجلات مشتريات مطابقة للفلتر المحدد.',
        icon: Icons.receipt_long_rounded,
      );
    }
    return ListView.builder(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: purchases.length,
      itemBuilder: (context, index) {
        final p = purchases[index];
        return PurchaseCard(
          purchase: p,
          onViewDetails: () => onViewDetails(p.order.id),
          onReorder: () => onReorder(p.order.id),
        );
      },
    );
  }
}


