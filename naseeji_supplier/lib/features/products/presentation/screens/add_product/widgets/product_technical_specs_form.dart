import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../../../controllers/add_product_controller.dart';

class ProductTechnicalSpecsForm extends ConsumerStatefulWidget {
  const ProductTechnicalSpecsForm({super.key});

  @override
  ConsumerState<ProductTechnicalSpecsForm> createState() => _ProductTechnicalSpecsFormState();
}

class _ProductTechnicalSpecsFormState extends ConsumerState<ProductTechnicalSpecsForm> {
  final List<Map<String, String>> _specs = [
    {'name': 'الخامة (Material)', 'value': 'قطن 100% (Cotton 100%)'},
    {'name': 'نوع القماش (Fabric Type)', 'value': 'جيرسيه (Jersey)'},
    {'name': 'العرض (Width)', 'value': '150 سم'},
    {'name': 'الوزن (Weight)', 'value': '180 GSM'},
  ];

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(addProductControllerProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
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
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _specs.add({'name': '', 'value': ''});
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary.withValues(alpha: 0.08),
                      foregroundColor: AppColors.primary,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      minimumSize: const Size(60, 40),
                    ),
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('إضافة مواصفة جديدة', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'المواصفات التقنية',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.onSurface,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'قم بتعريف الخصائص الفنية الدقيقة لمنتج النسيج لضمان الدقة',
                          textAlign: TextAlign.right,
                          style: TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Specs Rows
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _specs.length,
                separatorBuilder: (context, index) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F9FF),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: AppColors.error),
                          onPressed: () {
                            setState(() {
                              _specs.removeAt(index);
                            });
                          },
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text('القيمة', style: TextStyle(fontSize: 11, color: AppColors.outline)),
                              const SizedBox(height: 6),
                              TextFormField(
                                initialValue: _specs[index]['value'],
                                textAlign: TextAlign.right,
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  fillColor: Colors.white,
                                  filled: true,
                                ),
                                onChanged: (val) {
                                  _specs[index]['value'] = val;
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text('اسم المواصفة', style: TextStyle(fontSize: 11, color: AppColors.outline)),
                              const SizedBox(height: 6),
                              TextFormField(
                                initialValue: _specs[index]['name'],
                                textAlign: TextAlign.right,
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  fillColor: Colors.white,
                                  filled: true,
                                ),
                                onChanged: (val) {
                                  _specs[index]['name'] = val;
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),

              // Buttons
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        controller.setStep(3);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        minimumSize: const Size(120, 48),
                      ),
                      icon: const Icon(Icons.arrow_back, size: 18),
                      label: const Text(
                        'حفظ ومتابعة للتسعير',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 1,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        controller.setStep(1);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.onSurfaceVariant,
                        side: const BorderSide(color: AppColors.outlineVariant),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        minimumSize: const Size(120, 48),
                      ),
                      icon: const Icon(Icons.arrow_forward, size: 18),
                      label: const Text(
                        'العودة للسابق',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Info Bento Box
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.speed, color: AppColors.primary, size: 32),
                    const SizedBox(height: 8),
                    const Text(
                      'دقة البيانات',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.onSurface),
                    ),
                    const SizedBox(height: 4),
                    const Text('98% مكتملة', style: TextStyle(fontSize: 11, color: AppColors.outline)),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: 0.98,
                      backgroundColor: AppColors.surfaceContainerHighest,
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F3FD),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.2)),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'تأثير المواصفات على التصنيع',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'المواصفات التقنية الدقيقة تسمح لمحرك الذكاء الاصطناعي في المصانع بضبط آلات النسيج تلقائياً، مما يقلل الهدر بنسبة 15%.',
                            textAlign: TextAlign.right,
                            style: TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant, height: 1.4),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.info_outline, color: AppColors.primary),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
