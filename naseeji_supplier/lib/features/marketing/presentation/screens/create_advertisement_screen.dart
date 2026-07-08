import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import 'package:naseeji_supplier/core/widgets/general_widgets.dart';
import '../controllers/marketing_controllers.dart';
import '../widgets/audience_filter_widget.dart';
import '../../domain/entities/marketing_models.dart';

class CreateAdvertisementScreen extends ConsumerStatefulWidget {
  const CreateAdvertisementScreen({super.key});

  @override
  ConsumerState<CreateAdvertisementScreen> createState() => _CreateAdvertisementScreenState();
}

class _CreateAdvertisementScreenState extends ConsumerState<CreateAdvertisementScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _budgetController = TextEditingController();

  String? _selectedProduct = 'قطن ممتاز طويل التيلة';
  String? _selectedCampaign = 'حملة الأقمشة الصيفية 2026';
  String? _selectedCta = 'طلب عينة مجانية';

  B2BAudienceTarget _targeting = B2BAudienceTarget.empty();

  final List<String> _products = [
    'قطن ممتاز طويل التيلة',
    'صوف كشمير طبيعي ناعم',
    'أقمشة كتان بلجيكي فاخر',
    'خيوط بوليستر 150/48',
    'كرتون مضلع سميك 5 طبقات'
  ];

  final List<String> _campaigns = [
    'حملة الأقمشة الصيفية 2026',
    'حملة الخيوط واللوازم الربعية',
    'حملة باقات التغليف والصناديق',
    'حملة لوازم وإكسسوارات الملابس'
  ];

  final List<String> _ctas = [
    'طلب عينة مجانية',
    'طلب تسعيرة خاصة',
    'حجز موعد استشارة تصميم',
    'تواصل مع المبيعات',
    'شراء تجريبي بالجملة'
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  Future<void> _submitAd() async {
    if (!_formKey.currentState!.validate()) return;

    final double enteredBudget = double.tryParse(_budgetController.text) ?? 0.0;
    
    // Validate budget doesn't exceed supplier wallet balance (simulated cap check)
    if (enteredBudget > 62680.0) { // Using 62680.0 from financial repository balance
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('الميزانية المدخلة أكبر من الرصيد المتوفر في المحفظة المالية (62,680 ر.س)'),
          backgroundColor: Color(0xFFBA1A1A),
        ),
      );
      return;
    }

    final newAd = B2BAdvertisement(
      id: '',
      title: _titleController.text,
      productName: _selectedProduct ?? '',
      campaignName: _selectedCampaign ?? '',
      budget: enteredBudget,
      spent: 0.0,
      reach: 0,
      clicks: 0,
      ctr: 0.0,
      orders: 0,
      revenue: 0.0,
      status: AdStatus.pendingReview,
      remainingBudget: enteredBudget,
      description: _descController.text,
      callToAction: _selectedCta ?? '',
      startDate: DateTime.now().add(const Duration(days: 1)),
      endDate: DateTime.now().add(const Duration(days: 15)),
      targeting: _targeting,
    );

    await ref.read(marketingAdvertisementsControllerProvider.notifier).createAd(newAd);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم إنشاء الإعلان وإرساله للمراجعة بنجاح!')),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          title: const Text(
            'إنشاء إعلان B2B جديد',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.onSurface),
          ),
          centerTitle: true,
        ),
        body: Material(
          color: const Color(0xFFF8F9FF),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Basic settings
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
                          'معلومات الإعلان الأساسية',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.onSurface),
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: _titleController,
                          labelText: 'عنوان الإعلان الموجه للمصانع',
                          hintText: 'مثال: أقمشة قطن هندي فاخر 100% لتصنيع القمصان',
                          validator: (val) => val == null || val.isEmpty ? 'الرجاء إدخال عنوان الإعلان' : null,
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: _descController,
                          labelText: 'الوصف الإعلاني B2B التفصيلي',
                          hintText: 'اكتب مواصفات المواد الخام أو المزايا التنافسية لطلبيات المصانع...',
                          maxLines: 3,
                          validator: (val) => val == null || val.isEmpty ? 'الرجاء إدخال الوصف الإعلاني' : null,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'المنتج المروج',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.onSurfaceVariant),
                          textAlign: TextAlign.right,
                        ),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<String>(
                          value: _selectedProduct,
                          items: _products.map((p) {
                            return DropdownMenuItem<String>(
                              value: p,
                              child: Text(p, style: const TextStyle(fontSize: 12), textAlign: TextAlign.right),
                            );
                          }).toList(),
                          onChanged: (val) => setState(() => _selectedProduct = val),
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'الحملة الإعلانية المرتبطة',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.onSurfaceVariant),
                          textAlign: TextAlign.right,
                        ),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<String>(
                          value: _selectedCampaign,
                          items: _campaigns.map((c) {
                            return DropdownMenuItem<String>(
                              value: c,
                              child: Text(c, style: const TextStyle(fontSize: 12), textAlign: TextAlign.right),
                            );
                          }).toList(),
                          onChanged: (val) => setState(() => _selectedCampaign = val),
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'إجراء الاستجابة (Call to Action)',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.onSurfaceVariant),
                          textAlign: TextAlign.right,
                        ),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<String>(
                          value: _selectedCta,
                          items: _ctas.map((cta) {
                            return DropdownMenuItem<String>(
                              value: cta,
                              child: Text(cta, style: const TextStyle(fontSize: 12), textAlign: TextAlign.right),
                            );
                          }).toList(),
                          onChanged: (val) => setState(() => _selectedCta = val),
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: _budgetController,
                          labelText: 'ميزانية الإعلان الكلية (ر.س)',
                          hintText: 'مثال: 1500',
                          keyboardType: TextInputType.number,
                          validator: (val) {
                            if (val == null || val.isEmpty) return 'الرجاء إدخال الميزانية المخصصة';
                            final double? num = double.tryParse(val);
                            if (num == null || num <= 0) return 'الرجاء إدخال رقم صحيح أكبر من الصفر';
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Smart Targeting Parameters Selector
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
                          'معايير الاستهداف الذكي للمصانع B2B',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.onSurface),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          child: Divider(color: AppColors.outlineVariant),
                        ),
                        AudienceFilterWidget(
                          target: _targeting,
                          onChanged: (newTarget) {
                            setState(() => _targeting = newTarget);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Create button
                  PrimaryButton(
                    onPressed: _submitAd,
                    text: 'إنشاء الإعلان وإرساله للمراجعة',
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
