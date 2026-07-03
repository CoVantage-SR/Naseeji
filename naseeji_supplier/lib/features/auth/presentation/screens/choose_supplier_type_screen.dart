import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/general_widgets.dart';
import '../../domain/entities/supplier_registration_data.dart';
import '../controllers/registration_controller.dart';

class ChooseSupplierTypeScreen extends ConsumerWidget {
  const ChooseSupplierTypeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registrationState = ref.watch(registrationControllerProvider);
    final selectedType = registrationState.data.supplierType;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'نوع الحساب',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'اختر نوع حسابك كمورد',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onBackground,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'حدد طبيعة عملك لنتمكن من توفير الأدوات المناسبة لك',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 32),
              // Cards for selection
              Expanded(
                child: ListView(
                  children: [
                    _SupplierTypeCard(
                      type: SupplierType.factoryUnit,
                      title: 'مصنع أو وحدة إنتاج',
                      description: 'إنتاج وتصنيع الملابس والمنتجات النسيجية الجاهزة.',
                      icon: Icons.factory_outlined,
                      isSelected: selectedType == SupplierType.factoryUnit,
                      onTap: () {
                        ref.read(registrationControllerProvider.notifier).updateSupplierType(SupplierType.factoryUnit);
                      },
                    ),
                    const SizedBox(height: 16),
                    _SupplierTypeCard(
                      type: SupplierType.supplier,
                      title: 'مورد خامات ومستلزمات',
                      description: 'توريد الأقمشة، الخيوط، الإكسسوارات ومستلزمات الإنتاج.',
                      icon: Icons.widgets_outlined,
                      isSelected: selectedType == SupplierType.supplier,
                      onTap: () {
                        ref.read(registrationControllerProvider.notifier).updateSupplierType(SupplierType.supplier);
                      },
                    ),
                    const SizedBox(height: 16),
                    _SupplierTypeCard(
                      type: SupplierType.customizer,
                      title: 'مقدم خدمات تخصيص',
                      description: 'خدمات الطباعة والتطريز وتصميم النماذج وغيرها.',
                      icon: Icons.palette_outlined,
                      isSelected: selectedType == SupplierType.customizer,
                      onTap: () {
                        ref.read(registrationControllerProvider.notifier).updateSupplierType(SupplierType.customizer);
                      },
                    ),
                  ],
                ),
              ),
              // Next button
              PrimaryButton(
                text: 'متابعة التسجيل',
                onPressed: selectedType != null
                    ? () {
                        context.push('/register');
                      }
                    : null,
                suffixIcon: Icons.arrow_forward_rounded,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SupplierTypeCard extends StatelessWidget {
  final SupplierType type;
  final String title;
  final String description;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _SupplierTypeCard({
    required this.type,
    required this.title,
    required this.description,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.surfaceContainerLow : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.outlineVariant,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.06),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  )
                ]
              : null,
        ),
        child: Row(
          children: [
            // Icon wrapper
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : AppColors.outline,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            // Text details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? AppColors.primary : AppColors.onBackground,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Radio-like circle
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.outlineVariant,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Center(
                      child: CircleAvatar(
                        radius: 5,
                        backgroundColor: AppColors.primary,
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
