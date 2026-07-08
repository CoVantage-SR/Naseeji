import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import 'package:naseeji_supplier/core/widgets/general_widgets.dart';
import '../controllers/marketing_controllers.dart';
import '../widgets/campaign_card.dart';
import '../../domain/entities/marketing_models.dart';

class CampaignsScreen extends ConsumerStatefulWidget {
  const CampaignsScreen({super.key});

  @override
  ConsumerState<CampaignsScreen> createState() => _CampaignsScreenState();
}

class _CampaignsScreenState extends ConsumerState<CampaignsScreen> {
  final _campaignNameController = TextEditingController();
  final _objectiveController = TextEditingController();
  final _budgetController = TextEditingController();

  @override
  void dispose() {
    _campaignNameController.dispose();
    _objectiveController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  void _showCreateCampaignDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: AlertDialog(
                title: const Text('إنشاء حملة تسويقية جديدة', textAlign: TextAlign.right),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomTextField(
                        controller: _campaignNameController,
                        labelText: 'اسم الحملة التسويقية',
                        hintText: 'مثال: حملة المنسوجات الشتوية 2026',
                      ),
                      const SizedBox(height: 12),
                      CustomTextField(
                        controller: _objectiveController,
                        labelText: 'الهدف الرئيسي للحملة',
                        hintText: 'مثال: استهداف مصانع اليونيفورم المدرسي',
                      ),
                      const SizedBox(height: 12),
                      CustomTextField(
                        controller: _budgetController,
                        labelText: 'الميزانية الإجمالية (ر.س)',
                        hintText: 'مثال: 5000',
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('إلغاء'),
                  ),
                  TextButton(
                    onPressed: () {
                      final budget = double.tryParse(_budgetController.text) ?? 0.0;
                      if (_campaignNameController.text.isEmpty || budget <= 0) {
                        return;
                      }

                      final newCamp = MarketingCampaign(
                        id: '',
                        name: _campaignNameController.text,
                        objective: _objectiveController.text,
                        budget: budget,
                        spent: 0.0,
                        productsCount: 1,
                        status: CampaignStatus.scheduled,
                        durationDays: 30,
                        roas: 0.0,
                        revenue: 0.0,
                        orders: 0,
                        reach: 0,
                        clicks: 0,
                        ctr: 0.0,
                      );

                      ref.read(marketingCampaignsControllerProvider.notifier).createCampaign(newCamp);
                      
                      _campaignNameController.clear();
                      _objectiveController.clear();
                      _budgetController.clear();

                      Navigator.pop(ctx);
                      
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('تم إنشاء الحملة بنجاح وجدولتها!')),
                      );
                    },
                    child: const Text('إنشاء حملة', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final campaignsAsync = ref.watch(marketingCampaignsControllerProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          title: const Text(
            'حملات التسويق B2B',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.onSurface),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.add_box_outlined, color: Color(0xFF0040E0)),
              onPressed: _showCreateCampaignDialog,
            )
          ],
        ),
        body: Material(
          color: const Color(0xFFF8F9FF),
          child: campaignsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('حدث خطأ: $e')),
            data: (campaigns) {
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: campaigns.length,
                itemBuilder: (context, index) {
                  final camp = campaigns[index];
                  return CampaignCard(
                    campaign: camp,
                    onView: () => context.push('/marketing/campaigns/${camp.id}', extra: camp),
                    onPauseToggle: () {
                      final newStatus = camp.status == CampaignStatus.active ? CampaignStatus.paused : CampaignStatus.active;
                      ref.read(marketingCampaignsControllerProvider.notifier).updateCampaignStatus(camp.id, newStatus);
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
