import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../providers/registration_provider.dart';

class FactoryTypeHeaderWidget extends StatelessWidget {
  const FactoryTypeHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'اختر نوع المنشأة',
          style: context.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        AppSpacing.hXS,
        Text(
          'حدد النشاط الرئيسي لمصنعك لتسهيل وصول المشتريين إليك.',
          style: context.textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondaryLight,
          ),
        ),
      ],
    );
  }
}

class FactoryTypeGridWidget extends ConsumerWidget {
  const FactoryTypeGridWidget({super.key});

  final List<Map<String, dynamic>> _types = const [
    {'key': 'garments', 'title': 'مصنع ملابس جاهزة', 'icon': Icons.checkroom_rounded},
    {'key': 'fabric', 'title': 'مصنع غزل وأقمشة', 'icon': Icons.texture_rounded},
    {'key': 'printing', 'title': 'طباعة وصباغة منسوجات', 'icon': Icons.color_lens_rounded},
    {'key': 'embroidery', 'title': 'تطريز ملابس وأقمشة', 'icon': Icons.palette_rounded},
    {'key': 'home_textile', 'title': 'منسوجات ومفروشات منزلية', 'icon': Icons.bed_rounded},
    {'key': 'accessories', 'title': 'إكسسوارات ومستلزمات ملابس', 'icon': Icons.dashboard_customize_rounded},
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final regState = ref.watch(registrationProvider);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: context.responsiveValue(mobile: 2, tablet: 3).toInt(),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.1,
      ),
      itemCount: _types.length,
      itemBuilder: (context, index) {
        final type = _types[index];
        final isSelected = regState.selectedFactoryType == type['key'];

        return FactoryTypeCardWidget(
          title: type['title'],
          icon: type['icon'],
          isSelected: isSelected,
          onTap: () {
            ref.read(registrationProvider.notifier).updateFactoryType(type['key']);
          },
        );
      },
    );
  }
}

class FactoryTypeCardWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const FactoryTypeCardWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isSelected ? 4 : 0,
      color: isSelected 
          ? AppColors.primary.withValues(alpha: 0.05) 
          : Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.rMD,
        side: BorderSide(
          color: isSelected ? AppColors.primary : AppColors.borderLight,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.rMD,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    icon,
                    size: 32,
                    color: isSelected ? AppColors.primary : AppColors.textSecondaryLight,
                  ),
                  SelectedIndicatorWidget(isSelected: isSelected),
                ],
              ),
              AppSpacing.hMD,
              Text(
                title,
                textAlign: TextAlign.center,
                style: context.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? AppColors.primary : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SelectedIndicatorWidget extends StatelessWidget {
  final bool isSelected;

  const SelectedIndicatorWidget({super.key, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.borderLight,
          width: 1.5,
        ),
      ),
      child: isSelected
          ? const Icon(
              Icons.check,
              size: 14,
              color: Colors.white,
            )
          : null,
    );
  }
}
