import 'package:flutter/material.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../../domain/entities/marketing_models.dart';

class AudienceFilterWidget extends StatelessWidget {
  final B2BAudienceTarget target;
  final ValueChanged<B2BAudienceTarget> onChanged;

  const AudienceFilterWidget({
    super.key,
    required this.target,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildSectionTitle('نوع وصناعة المصنع المستهدف'),
        _buildFilterChips(
          options: ['مصانع الملابس الجاهزة', 'مصانع النسيج', 'مصانع اليونيفورم', 'مصانع الحقائب والأحذية', 'مصانع التعبئة والتغليف', 'دور الأزياء المصنعة'],
          selectedItems: target.factoryIndustries,
          onSelectedChanged: (list) {
            onChanged(target.copyWith(factoryIndustries: list));
          },
        ),
        const SizedBox(height: 16),
        _buildSectionTitle('حجم المنشأة B2B'),
        _buildFilterChips(
          options: ['صغير', 'متوسط', 'كبير', 'ضخم'],
          selectedItems: target.factorySizes,
          onSelectedChanged: (list) {
            onChanged(target.copyWith(factorySizes: list));
          },
        ),
        const SizedBox(height: 16),
        _buildSectionTitle('المنطقة الجغرافية / النطاق'),
        _buildFilterChips(
          options: ['السعودية', 'الرياض', 'جدة', 'الدمام', 'الإمارات', 'مصر', 'دبي'],
          selectedItems: target.locations,
          onSelectedChanged: (list) {
            onChanged(target.copyWith(locations: list));
          },
        ),
        const SizedBox(height: 16),
        _buildSectionTitle('السلوك الشرائي للمصانع'),
        _buildFilterChips(
          options: [
            'شراء متكرر',
            'طلب عينات مسبق',
            'مفاوضات سابقة',
            'استفسار عن عروض التعبئة',
            'طلب تسعيرات RFQ',
            'تصفح الكتان مسبقاً'
          ],
          selectedItems: target.purchasingBehaviors,
          onSelectedChanged: (list) {
            onChanged(target.copyWith(purchasingBehaviors: list));
          },
        ),
        const SizedBox(height: 16),
        _buildSectionTitle('حجم الطلبيات المعتاد'),
        _buildFilterChips(
          options: ['كميات خفيفة', 'كميات متوسطة', 'مشتريات بالجملة', 'كميات ضخمة'],
          selectedItems: target.purchaseVolumes,
          onSelectedChanged: (list) {
            onChanged(target.copyWith(purchaseVolumes: list));
          },
        ),
        const SizedBox(height: 16),
        _buildSectionTitle('الفئات والمواد المهتم بها'),
        _buildFilterChips(
          options: ['قطنيات', 'خيوط', 'أقمشة', 'بوليستر', 'تغليف', 'كرتون', 'كتان', 'أقمشة طبيعية', 'إكسسوارات ملابس'],
          selectedItems: target.interestedCategories,
          onSelectedChanged: (list) {
            onChanged(target.copyWith(interestedCategories: list));
          },
        ),
        const SizedBox(height: 20),
        const Divider(color: AppColors.outlineVariant),
        const SizedBox(height: 10),
        _buildSwitchTile('المصانع الموثقة والنشطة فقط', target.verifiedOnly, (val) {
          onChanged(target.copyWith(verifiedOnly: val));
        }),
        _buildSwitchTile('المصانع من الفئة الممتازة (Premium)', target.premiumOnly, (val) {
          onChanged(target.copyWith(premiumOnly: val));
        }),
        _buildSwitchTile('عملاء نسيجي من فئة VIP فقط', target.vipOnly, (val) {
          onChanged(target.copyWith(vipOnly: val));
        }),
        _buildSwitchTile('المصانع التي تفاعلت في الـ 30 يوماً الأخيرة', target.activeLast30Days, (val) {
          onChanged(target.copyWith(activeLast30Days: val));
        }),
        _buildSwitchTile('المصانع التي تمتلك عمليات دفع ناجحة مكتملة', target.completedPaymentsOnly, (val) {
          onChanged(target.copyWith(completedPaymentsOnly: val));
        }),
        _buildSwitchTile('المصانع التي تبحث عن منتجات شبيهة حالياً', target.searchingSimilarProducts, (val) {
          onChanged(target.copyWith(searchingSimilarProducts: val));
        }),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.onSurface),
        textAlign: TextAlign.right,
      ),
    );
  }

  Widget _buildFilterChips({
    required List<String> options,
    required List<String> selectedItems,
    required ValueChanged<List<String>> onSelectedChanged,
  }) {
    return Align(
      alignment: Alignment.centerRight,
      child: Wrap(
        spacing: 8,
        runSpacing: 4,
        textDirection: TextDirection.rtl,
        children: options.map((option) {
          final isSelected = selectedItems.contains(option);
          return FilterChip(
            label: Text(
              option,
              style: TextStyle(
                fontSize: 11,
                color: isSelected ? Colors.white : AppColors.onSurfaceVariant,
              ),
            ),
            selected: isSelected,
            selectedColor: const Color(0xFF0040E0),
            checkmarkColor: Colors.white,
            backgroundColor: AppColors.surfaceContainerLow,
            onSelected: (selected) {
              final newList = List<String>.from(selectedItems);
              if (selected) {
                newList.add(option);
              } else {
                newList.remove(option);
              }
              onSelectedChanged(newList);
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSwitchTile(String label, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      title: Text(
        label,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.onSurface),
        textAlign: TextAlign.right,
      ),
      activeThumbColor: const Color(0xFF0040E0),
      contentPadding: EdgeInsets.zero,
      dense: true,
    );
  }
}
