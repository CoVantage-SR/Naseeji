import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import 'package:naseeji_supplier/core/widgets/general_widgets.dart';
import '../controllers/marketing_controllers.dart';
import '../../domain/entities/marketing_models.dart';

class SponsoredProductsScreen extends ConsumerStatefulWidget {
  const SponsoredProductsScreen({super.key});

  @override
  ConsumerState<SponsoredProductsScreen> createState() => _SponsoredProductsScreenState();
}

class _SponsoredProductsScreenState extends ConsumerState<SponsoredProductsScreen> {
  String? _selectedProduct = 'قطن ممتاز طويل التيلة';
  final _budgetController = TextEditingController(text: '1000');

  final List<String> _products = [
    'قطن ممتاز طويل التيلة',
    'صوف كشمير طبيعي ناعم',
    'أقمشة كتان بلجيكي فاخر',
    'خيوط بوليستر 150/48',
    'كرتون مضلع سميك 5 طبقات'
  ];

  @override
  void dispose() {
    _budgetController.dispose();
    super.dispose();
  }

  void _addSponsored() {
    final b = double.tryParse(_budgetController.text) ?? 1000.0;
    if (_selectedProduct == null) return;

    final spp = SponsoredProduct(
      id: 'SPP-${DateTime.now().millisecondsSinceEpoch}',
      productName: _selectedProduct!,
      budget: b,
      spent: 0.0,
      views: 0,
      clicks: 0,
      orders: 0,
      revenue: 0.0,
      active: true,
    );

    ref.read(sponsoredProductsControllerProvider.notifier).createSponsored(spp);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تم تفعيل إعلان الدفع بالنقر لـ $_selectedProduct بميزانية $b ر.س!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sponsoredAsync = ref.watch(sponsoredProductsControllerProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          title: const Text(
            'المنتجات المدعومة (Sponsored)',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.onSurface),
          ),
          centerTitle: true,
        ),
        body: Material(
          color: const Color(0xFFF8F9FF),
          child: sponsoredAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('خطأ: $e')),
            data: (products) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Sponsored creation form
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
                            'تمويل ظهور المنتج إعلانياً (الدفع بالنقرة CPC)',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.onSurface),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Divider(color: AppColors.outlineVariant),
                          ),
                          const Text('اختر المنتج للرعاية الإعلانية', style: TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant)),
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
                            controller: _budgetController,
                            labelText: 'ميزانية النقرات المرصودة (ر.س)',
                            hintText: 'مثال: 1000',
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 20),
                          PrimaryButton(
                            onPressed: _addSponsored,
                            text: 'بدء حملة الدفع بالنقر CPC',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Active sponsored listings
                    const Text(
                      'المنتجات المدعومة النشطة جاري تشغيلها',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.onSurface),
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: 12),
                    ...products.map((p) {
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
                                Switch(
                                  value: p.active,
                                  onChanged: (val) {
                                    ref.read(sponsoredProductsControllerProvider.notifier).updateSponsoredStatus(p.id, val);
                                  },
                                  activeThumbColor: const Color(0xFF0040E0),
                                ),
                                Text(
                                  p.productName,
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
                                _buildPerformanceCol('المبيعات', '${p.revenue.toStringAsFixed(0)} ر.س'),
                                _buildPerformanceCol('الطلبات', '${p.orders}'),
                                _buildPerformanceCol('النقرات الكلية', '${p.clicks}'),
                                _buildPerformanceCol('المشاهدات', '${p.views}'),
                              ],
                            ),
                            const SizedBox(height: 12),
                            const Divider(color: AppColors.outlineVariant),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('المنفق حتى الآن: ${p.spent.toStringAsFixed(0)} ر.س', style: const TextStyle(fontSize: 10, color: AppColors.onSurfaceVariant)),
                                Text('الميزانية المتبقية: ${(p.budget - p.spent).toStringAsFixed(0)} ر.س / ${p.budget.toStringAsFixed(0)} ر.س', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.onSurfaceVariant)),
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

  Widget _buildPerformanceCol(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 9, color: AppColors.onSurfaceVariant)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
      ],
    );
  }
}
