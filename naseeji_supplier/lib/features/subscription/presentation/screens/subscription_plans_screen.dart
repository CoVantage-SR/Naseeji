import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../controllers/subscription_controllers.dart';
import '../widgets/subscription_plan_card.dart';
import '../../domain/entities/subscription_models.dart';

class SubscriptionPlansScreen extends ConsumerStatefulWidget {
  const SubscriptionPlansScreen({super.key});

  @override
  ConsumerState<SubscriptionPlansScreen> createState() => _SubscriptionPlansScreenState();
}

class _SubscriptionPlansScreenState extends ConsumerState<SubscriptionPlansScreen> {
  BillingCycle _selectedCycle = BillingCycle.monthly;

  @override
  Widget build(BuildContext context) {
    final plansAsync = ref.watch(subscriptionPlansControllerProvider);
    final activeSubAsync = ref.watch(activeSubscriptionControllerProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          title: const Text(
            'باقات وعروض الاشتراك B2B',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.onSurface),
          ),
          centerTitle: true,
        ),
        body: Material(
          color: const Color(0xFFF8F9FF),
          child: Column(
            children: [
              // Cycle Toggle
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ChoiceChip(
                      label: const Text('اشتراك سنوي (توفير 20%)', style: TextStyle(fontSize: 11)),
                      selected: _selectedCycle == BillingCycle.yearly,
                      onSelected: (val) {
                        if (val) setState(() => _selectedCycle = BillingCycle.yearly);
                      },
                    ),
                    const SizedBox(width: 12),
                    ChoiceChip(
                      label: const Text('اشتراك شهري', style: TextStyle(fontSize: 11)),
                      selected: _selectedCycle == BillingCycle.monthly,
                      onSelected: (val) {
                        if (val) setState(() => _selectedCycle = BillingCycle.monthly);
                      },
                    ),
                  ],
                ),
              ),

              // Plans list
              Expanded(
                child: activeSubAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text('خطأ: $e')),
                  data: (activeSub) => plansAsync.when(
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Center(child: Text('خطأ: $e')),
                    data: (plans) {
                      return ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: plans.length,
                        itemBuilder: (context, index) {
                          final plan = plans[index];
                          final isCurrent = activeSub.planId == plan.id;

                          return SubscriptionPlanCard(
                            plan: plan,
                            isCurrentPlan: isCurrent,
                            onSelect: () {
                              if (isCurrent) {
                                context.push('/subscription/details');
                              } else {
                                context.push('/subscription/checkout', extra: {
                                  'plan': plan,
                                  'cycle': _selectedCycle,
                                });
                              }
                            },
                            onCompare: () => context.push('/subscription/comparison'),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
