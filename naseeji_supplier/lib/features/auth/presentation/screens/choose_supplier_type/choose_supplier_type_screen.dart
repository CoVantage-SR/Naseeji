import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/general_widgets.dart';
import '../../domain/entities/supplier_registration_data.dart';
import '../../controllers/registration_controller.dart';
import 'widgets/supplier_type_card.dart';

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
              Expanded(
                child: ListView(
                  children: [
                    SupplierTypeCard(
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
                    SupplierTypeCard(
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
                    SupplierTypeCard(
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
