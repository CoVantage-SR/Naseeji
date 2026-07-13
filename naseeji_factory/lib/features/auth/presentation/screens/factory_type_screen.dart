import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/app_buttons.dart';
import '../providers/registration_provider.dart';
import '../widgets/factory_type_widgets.dart';
import '../widgets/register_widgets.dart';

class FactoryTypeScreen extends ConsumerWidget {
  const FactoryTypeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final regState = ref.watch(registrationProvider);
    final hasSelection = regState.selectedFactoryType.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const StepIndicatorWidget(currentStep: 2, totalSteps: 3),
              AppSpacing.hLG,
              const FactoryTypeHeaderWidget(),
              AppSpacing.hXL,
              const FactoryTypeGridWidget(),
              AppSpacing.hXXL,
              AppButton.primary(
                text: 'متابعة',
                onPressed: hasSelection ? () => context.push('/factory-info') : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
