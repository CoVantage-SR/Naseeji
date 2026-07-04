import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../controllers/add_product_controller.dart';

class ProductPricingForm extends ConsumerStatefulWidget {
  const ProductPricingForm({super.key});

  @override
  ConsumerState<ProductPricingForm> createState() => _ProductPricingFormState();
}

class _ProductPricingFormState extends ConsumerState<ProductPricingForm> {
  double _reorderLevel = 50.0;
  String _selectedUnit = 'متر طولي';
  
  final List<Map<String, dynamic>> _tiers = [
    {'minQty': 100, 'discount': 10, 'price': 135.0},
    {'minQty': 500, 'discount': 20, 'price': 120.0},
  ];

  final List<String> _units = [
    'متر طولي',
    'قطعة',
    'لفة (Roll)',
    'كيلوجرام',
  ];

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(addProductControllerProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // MOQ & Inventory Card (Left/Side on Desktop)
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F6F3),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFB2DFDB)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text(
                          'الكميات والمخزون',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF004D40)),
                        ),
                        const SizedBox(width: 8),
                        Icon(Icons.inventory_2_outlined, color: Colors.teal.shade700, size: 20),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // MOQ Field
                    const Text('الحد الأدنى للطلب (MOQ)', style: TextStyle(fontSize: 12, color: Color(0xFF00796B), fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    TextFormField(
                      initialValue: '100',
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.right,
                      decoration: const InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Unit Selector
                    const Text('وحدة القياس', style: TextStyle(fontSize: 12, color: Color(0xFF00796B), fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      value: _selectedUnit,
                      alignment: AlignmentDirectional.centerEnd,
                      decoration: const InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      items: _units.map((u) {
                        return DropdownMenuItem(value: u, child: Text(u, textDirection: TextDirection.rtl));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            _selectedUnit = val;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 20),

                    // Reorder Level
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${_reorderLevel.round()} وحدة', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF004D40))),
                        const Text('مستوى إعادة الطلب', style: TextStyle(fontSize: 12, color: Color(0xFF00796B))),
                      ],
                    ),
                    Slider(
                      value: _reorderLevel,
                      min: 10,
                      max: 200,
                      activeColor: Colors.teal,
                      inactiveColor: const Color(0xFFB2DFDB),
                      onChanged: (val) {
                        setState(() {
                          _reorderLevel = val;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Basic Pricing Card (Right/Main on Desktop)
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text(
                          'إعدادات السعر الأساسي',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.onSurface),
                        ),
                        const SizedBox(width: 8),
                        Icon(Icons.payments_outlined, color: AppColors.primary, size: 20),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Grid fields
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text('سعر الجملة (للموردين)', style: TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant)),
                              const SizedBox(height: 8),
                              TextFormField(
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.right,
                                decoration: const InputDecoration(
                                  suffixText: 'SAR',
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text('سعر التجزئة (للقطعة)', style: TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant)),
                              const SizedBox(height: 8),
                              TextFormField(
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.right,
                                decoration: const InputDecoration(
                                  suffixText: 'SAR',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text('هامش الربح المستهدف (%)', style: TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant)),
                              const SizedBox(height: 8),
                              TextFormField(
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.right,
                                decoration: const InputDecoration(
                                  hintText: '25%',
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text('تكلفة الإنتاج التقديرية', style: TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant)),
                              const SizedBox(height: 8),
                              TextFormField(
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.right,
                                decoration: const InputDecoration(
                                  suffixText: 'SAR',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Bulk Discount Tiers Card
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton.icon(
                    onPressed: () {
                      setState(() {
                        _tiers.add({'minQty': 0, 'discount': 0, 'price': 0.0});
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    icon: const Icon(Icons.add, size: 14),
                    label: const Text('إضافة شريحة جديدة', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                  Row(
                    children: [
                      const Text(
                        'شرائح خصم الكميات الكبيرة',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.onSurface),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.loyalty_outlined, color: Colors.orange.shade800, size: 20),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Table
              Table(
                columnWidths: const {
                  0: FlexColumnWidth(1),
                  1: FlexColumnWidth(1.2),
                  2: FlexColumnWidth(1.2),
                  3: FlexColumnWidth(0.6),
                },
                children: [
                  const TableRow(
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: AppColors.outlineVariant, width: 1)),
                    ),
                    children: [
                      Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Text('السعر بعد الخصم', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                      Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Text('نسبة الخصم (%)', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                      Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Text('الكمية من', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                      Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Text('إجراء', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                    ],
                  ),
                  ..._tiers.map((tier) {
                    return TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text('${tier['price']} SAR', textAlign: TextAlign.right, style: const TextStyle(fontSize: 13)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                          child: TextFormField(
                            initialValue: '${tier['discount']}',
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                          child: TextFormField(
                            initialValue: '${tier['minQty']}',
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: IconButton(
                            icon: const Icon(Icons.delete_outline, color: AppColors.error, size: 18),
                            onPressed: () {
                              setState(() {
                                _tiers.remove(tier);
                              });
                            },
                          ),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),

        // Bottom Actions
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OutlinedButton.icon(
              onPressed: () {
                controller.setStep(2);
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.onSurfaceVariant,
                side: const BorderSide(color: AppColors.outlineVariant),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              icon: const Icon(Icons.arrow_forward, size: 16),
              label: const Text('الرجوع للخطوة السابقة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            ),
            Row(
              children: [
                TextButton(
                  onPressed: () {},
                  child: const Text('حفظ كمسودة', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () {
                    controller.setStep(4);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  icon: const Icon(Icons.arrow_back, size: 16),
                  label: const Text('الاستمرار للخطوة التالية', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                ),
              ],
            ),
          ],
        )
      ],
    );
  }
}
