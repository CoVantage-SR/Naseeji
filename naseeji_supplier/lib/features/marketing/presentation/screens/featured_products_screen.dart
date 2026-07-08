import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import 'package:naseeji_supplier/core/widgets/general_widgets.dart';
import '../controllers/marketing_controllers.dart';
import '../../domain/entities/marketing_models.dart';

class FeaturedProductsScreen extends ConsumerStatefulWidget {
  const FeaturedProductsScreen({super.key});

  @override
  ConsumerState<FeaturedProductsScreen> createState() => _FeaturedProductsScreenState();
}

class _FeaturedProductsScreenState extends ConsumerState<FeaturedProductsScreen> {
  String? _selectedProduct = 'قطن ممتاز طويل التيلة';
  String _selectedPriority = 'Medium';
  final _durationController = TextEditingController(text: '10');

  final List<String> _products = [
    'قطن ممتاز طويل التيلة',
    'صوف كشمير طبيعي ناعم',
    'أقمشة كتان بلجيكي فاخر',
    'خيوط بوليستر 150/48',
    'كرتون مضلع سميك 5 طبقات'
  ];

  @override
  void dispose() {
    _durationController.dispose();
    super.dispose();
  }

  void _promoteProduct() {
    final days = int.tryParse(_durationController.text) ?? 10;
    final cost = days * (_selectedPriority == 'High' ? 50.0 : (_selectedPriority == 'Medium' ? 30.0 : 15.0));

    final promo = FeaturedProductPromotion(
      id: 'FTP-${DateTime.now().millisecondsSinceEpoch}',
      productName: _selectedProduct ?? '',
      featuredDurationDays: days,
      priorityLevel: _selectedPriority,
      promotionCost: cost,
      views: 0,
      clicks: 0,
      orders: 0,
      revenue: 0.0,
      active: true,
    );

    ref.read(featuredProductsControllerProvider.notifier).promoteProduct(promo);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تم ترويج $_selectedProduct بنجاح بتكلفة $cost ر.س!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final featuredAsync = ref.watch(featuredProductsControllerProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          title: const Text(
            'ترويج المنتجات المميزة B2B',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.onSurface),
          ),
          centerTitle: true,
        ),
        body: Material(
          color: const Color(0xFFF8F9FF),
          child: featuredAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('خطأ: $e')),
            data: (promotions) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Promote Form
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
                            'ترويج منتج جديد في المنصة',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.onSurface),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Divider(color: AppColors.outlineVariant),
                          ),
                          const Text('المنتج المراد تمييزه للمصانع', style: TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant)),
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
                          CustomTextField(
                            controller: _durationController,
                            labelText: 'مدة الترويج بالمنصة (أيام)',
                            hintText: 'مثال: 10',
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 16),
                          const Text('مستوى أولوية الظهور والإعلانات', style: TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant)),
                          const SizedBox(height: 6),
                          DropdownButtonFormField<String>(
                            value: _selectedPriority,
                            items: const [
                              DropdownMenuItem<String>(
                                value: 'High',
                                child: Text('ظهور مرتفع جداً (High - 50 ر.س/يوم)', style: TextStyle(fontSize: 12), textAlign: TextAlign.right),
                              ),
                              DropdownMenuItem<String>(
                                value: 'Medium',
                                child: Text('ظهور متوسط (Medium - 30 ر.س/يوم)', style: TextStyle(fontSize: 12), textAlign: TextAlign.right),
                              ),
                              DropdownMenuItem<String>(
                                value: 'Low',
                                child: Text('ظهور عادي (Low - 15 ر.س/يوم)', style: TextStyle(fontSize: 12), textAlign: TextAlign.right),
                              ),
                            ],
                            onChanged: (val) {
                              if (val != null) setState(() => _selectedPriority = val);
                            },
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 20),
                          PrimaryButton(
                            onPressed: _promoteProduct,
                            text: 'تفعيل الترويج المتميز',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Active promoted items list
                    const Text(
                      'قائمة المنتجات المميزة النشطة بالمنصة',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.onSurface),
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: 12),
                    ...promotions.map((promo) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: promo.active ? const Color(0xFF006B5F).withValues(alpha: 0.1) : AppColors.outline.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    promo.active ? 'نشط مميز' : 'موقوف',
                                    style: TextStyle(
                                      fontSize: 8,
                                      fontWeight: FontWeight.bold,
                                      color: promo.active ? const Color(0xFF006B5F) : AppColors.outline,
                                    ),
                                  ),
                                ),
                                Text(
                                  promo.productName,
                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.onSurface),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            const Divider(color: AppColors.outlineVariant),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildMetricColumn('المبيعات', '${promo.revenue.toStringAsFixed(0)} ر.س'),
                                _buildMetricColumn('التحويلات', '${promo.orders}'),
                                _buildMetricColumn('النقرات', '${promo.clicks}'),
                                _buildMetricColumn('المشاهدات', '${promo.views}'),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('المدة: ${promo.featuredDurationDays} يوم | تكلفة الترويج: ${promo.promotionCost} ر.س', style: const TextStyle(fontSize: 10, color: AppColors.onSurfaceVariant)),
                                Text('مستوى الأولوية: ${promo.priorityLevel == 'High' ? 'مرتفع' : (promo.priorityLevel == 'Medium' ? 'متوسط' : 'عادي')}', style: const TextStyle(fontSize: 10, color: AppColors.onSurfaceVariant)),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMetricColumn(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 9, color: AppColors.onSurfaceVariant)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
      ],
    );
  }
}
