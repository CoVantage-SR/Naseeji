import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import 'package:naseeji_supplier/core/widgets/general_widgets.dart';
import '../controllers/marketing_controllers.dart';
import '../../domain/entities/marketing_models.dart';

class SeasonalCampaignsScreen extends ConsumerStatefulWidget {
  const SeasonalCampaignsScreen({super.key});

  @override
  ConsumerState<SeasonalCampaignsScreen> createState() => _SeasonalCampaignsScreenState();
}

class _SeasonalCampaignsScreenState extends ConsumerState<SeasonalCampaignsScreen> {
  final _budgetController = TextEditingController(text: '3000');
  String? _selectedProduct = 'قطن ممتاز طويل التيلة';

  final List<String> _products = [
    'قطن ممتاز طويل التيلة',
    'صوف كشمير طبيعي ناعم',
    'أقمشة كتان بلجيكي فاخر',
    'خيوط بوليستر 150/48',
    'كرتون مضلع سميك 5 طبقات'
  ];

  final List<Map<String, dynamic>> _seasonalEvents = [
    {
      'title': 'مهرجان تجهيزات العيد الكبرى 2026',
      'description': 'الحدث السنوي الأضخم لاستهداف دور الأزياء ومصانع الملابس الجاهزة قبل ضغط موسم الأعياد.',
      'dates': '1 أغسطس - 20 أغسطس 2026',
      'expectedCTR': '5.4%',
      'color': 0xFF0040E0,
      'objective': 'زيادة مبيعات الأقمشة والكتان الفاخر للعبايات والجلابيات',
    },
    {
      'title': 'موسم المنسوجات والملابس الشتوية',
      'description': 'استهدف مصانع السترات والأقمشة الصوفية والملابس الشتوية الثقيلة لتعاقدات التوريد المسبق.',
      'dates': '15 سبتمبر - 30 أكتوبر 2026',
      'expectedCTR': '4.8%',
      'color': 0xFF006B5F,
      'objective': 'تأمين عقود توريد خيوط الصوف والمنسوجات السميكة',
    },
    {
      'title': 'موسم العودة للمدارس والزي الموحد',
      'description': 'تواصل مع مصانع اليونيفورم والزي المدرسي لتأمين طلبيات خيوط البوليستر والأقمشة القطنية.',
      'dates': '10 يونيو - 25 يوليو 2026',
      'expectedCTR': '6.1%',
      'color': 0xFFFF9800,
      'objective': 'تأمين صفقات أقمشة وخيوط الزي الموحد والمدرسي',
    }
  ];

  @override
  void dispose() {
    _budgetController.dispose();
    super.dispose();
  }

  void _optIn(Map<String, dynamic> event) {
    final b = double.tryParse(_budgetController.text) ?? 3000.0;
    if (_selectedProduct == null) return;

    final camp = MarketingCampaign(
      id: 'CAMP-${DateTime.now().millisecondsSinceEpoch}',
      name: event['title'] as String,
      objective: event['objective'] as String,
      budget: b,
      spent: 0.0,
      productsCount: 1,
      status: CampaignStatus.scheduled,
      durationDays: 20,
      roas: 0.0,
      revenue: 0.0,
      orders: 0,
      reach: 0,
      clicks: 0,
      ctr: 0.0,
    );

    ref.read(marketingCampaignsControllerProvider.notifier).createCampaign(camp);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تم الانضمام لـ "${event['title']}" بنجاح بميزانية $b ر.س!')),
    );
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
            'حملات المنصة الموسمية B2B',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.onSurface),
          ),
          centerTitle: true,
        ),
        body: Material(
          color: const Color(0xFFF8F9FF),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'انضم للمهرجانات والمواسم الإعلانية التي تطلقها نسيجي',
                  style: TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 16),

                // Settings container for opt-in
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text('إعدادات الانضمام السريع للمواسم', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
                      const SizedBox(height: 12),
                      const Text('المنتج المروج المختار للموسم', style: TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant)),
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
                      const SizedBox(height: 12),
                      CustomTextField(
                        controller: _budgetController,
                        labelText: 'الميزانية المرصودة للموسم (ر.س)',
                        hintText: 'مثال: 3000',
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                ),

                // Events list
                ..._seasonalEvents.map((event) {
                  final colorVal = event['color'] as int;
                  final color = Color(colorVal);

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: color.withValues(alpha: 0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.1),
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                          ),
                          child: Text(
                            event['title'] as String,
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                event['description'] as String,
                                style: const TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant, height: 1.4),
                                textAlign: TextAlign.right,
                              ),
                              const SizedBox(height: 12),
                              const Divider(color: AppColors.outlineVariant),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('تفاعل CTR متوقع: ${event['expectedCTR']}', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF006B5F))),
                                  Text('تاريخ التشغيل: ${event['dates']}', style: const TextStyle(fontSize: 10, color: AppColors.onSurfaceVariant)),
                                ],
                              ),
                              const SizedBox(height: 16),
                              PrimaryButton(
                                onPressed: () => _optIn(event),
                                text: 'انضم للحملة الموسمية الآن',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
