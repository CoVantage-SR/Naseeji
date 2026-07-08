import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import 'package:naseeji_supplier/core/widgets/general_widgets.dart';
import '../controllers/marketing_controllers.dart';
import '../widgets/budget_progress_card.dart';

class BudgetManagementScreen extends ConsumerStatefulWidget {
  const BudgetManagementScreen({super.key});

  @override
  ConsumerState<BudgetManagementScreen> createState() => _BudgetManagementScreenState();
}

class _BudgetManagementScreenState extends ConsumerState<BudgetManagementScreen> {
  final _dailyController = TextEditingController();
  final _monthlyController = TextEditingController();

  @override
  void dispose() {
    _dailyController.dispose();
    _monthlyController.dispose();
    super.dispose();
  }

  void _updateCap(double daily, double monthly) {
    if (daily <= 0 || monthly <= 0) return;

    ref.read(marketingBudgetControllerProvider.notifier).updateCap(daily, monthly);
    _dailyController.clear();
    _monthlyController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم تحديث الحدود المالية بنجاح!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final budgetAsync = ref.watch(marketingBudgetControllerProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          title: const Text(
            'إدارة الميزانية الإعلانية',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.onSurface),
          ),
          centerTitle: true,
        ),
        body: Material(
          color: const Color(0xFFF8F9FF),
          child: budgetAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('خطأ: $e')),
            data: (budget) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Budget indicator
                    BudgetProgressCard(budgetInfo: budget),
                    const SizedBox(height: 16),

                    // Stats summary
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _buildSimpleRow('الحد اليومي المحدد', '${budget.dailyBudget.toStringAsFixed(0)} ر.س'),
                          _buildSimpleRow('الميزانية المرصودة للحملات', '${budget.campaignBudget.toStringAsFixed(0)} ر.س'),
                          _buildSimpleRow('معدل النفاذ اليومي المتوقع', '${(budget.spent / 30).toStringAsFixed(0)} ر.س/يوم'),
                          _buildSimpleRow('الوصول والتعاقدات المقدرة', '${budget.estimatedReach} مصنع / ~${budget.estimatedOrders} عقد جديد'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Update Caps Form
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            'تعديل حدود الإنفاق التسويقي',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.onSurface),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Divider(color: AppColors.outlineVariant),
                          ),
                          CustomTextField(
                            controller: _dailyController,
                            labelText: 'الحد الأقصى للإنفاق اليومي (ر.س)',
                            hintText: 'مثال: 500',
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 12),
                          CustomTextField(
                            controller: _monthlyController,
                            labelText: 'الحد الأقصى للميزانية الشهرية (ر.س)',
                            hintText: 'مثال: 15000',
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 16),
                          PrimaryButton(
                            onPressed: () {
                              final d = double.tryParse(_dailyController.text) ?? budget.dailyBudget;
                              final m = double.tryParse(_monthlyController.text) ?? budget.monthlyBudget;
                              _updateCap(d, m);
                            },
                            child: const Text('تطبيق الحدود الجديدة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSimpleRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
          Text(label, style: const TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant)),
        ],
      ),
    );
  }
}
