import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';

class ProductSuccessSummary extends StatelessWidget {
  const ProductSuccessSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Success animation/checkmark header
        const Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Color(0xFFE8F6F3),
                ),
                Icon(
                  Icons.check_circle,
                  color: Color(0xFF009688),
                  size: 56,
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'تم إضافة المنتج بنجاح',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.onSurface),
            ),
            SizedBox(height: 6),
            Text(
              'المنتج الآن مدرج في الكتالوج الخاص بك وجاهز للطلبات.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: AppColors.onSurfaceVariant),
            ),
          ],
        ),
        const SizedBox(height: 32),

        // Bento grid layout
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Side cards column
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  // Price card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border(
                        top: const BorderSide(color: AppColors.primary, width: 4),
                        left: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
                        right: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
                        bottom: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
                      ),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('السعر التقريبي', style: TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant)),
                        SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text('/ للمتر', style: TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant)),
                            SizedBox(width: 4),
                            Text('12.50 SAR', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primary)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Stock/MOQ card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border(
                        top: const BorderSide(color: Colors.teal, width: 4),
                        left: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
                        right: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
                        bottom: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text('الحد الأدنى للطلب (MOQ)', style: TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant)),
                        const SizedBox(height: 6),
                        const Text('500 متر', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
                        const SizedBox(height: 12),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('متوفر بكثرة', style: TextStyle(fontSize: 11, color: Colors.teal, fontWeight: FontWeight.bold)),
                            Text('التوفر:', style: TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant)),
                          ],
                        ),
                        const SizedBox(height: 6),
                        LinearProgressIndicator(
                          value: 0.8,
                          backgroundColor: Colors.teal.shade50,
                          color: Colors.teal,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),

            // Main info card (Right side)
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(alpha: 0.08),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  'نسيج فاخر',
                                  style: TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'حرير "إنديجو برو" الفاخر',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.onSurface),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'قماش حريري عالي الجودة مصمم للمصانع الذكية، يتميز بمتانة استثنائية ولمسة ناعمة فاخرة. متوافق مع معايير الإنتاج الصناعي.',
                                textAlign: TextAlign.right,
                                style: TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant, height: 1.4),
                              ),
                              const SizedBox(height: 16),
                              const Divider(color: AppColors.outlineVariant, height: 1),
                              const SizedBox(height: 16),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text('التصنيف: منسوجات', style: TextStyle(fontSize: 12, color: AppColors.onSurface)),
                                  SizedBox(width: 16),
                                  Text('SKU: TX-IND-902', style: TextStyle(fontSize: 12, color: AppColors.onSurface)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuAfG8ELYUSnbXlnJ-Vpt0Dc35N_trgEcXKB0HZUYnw00-9v3UZabh3J_Aq-wbuIA6mC9jiMg7SbM0qTP2CCM14SXHPyVm1RGsZKxZ4g8Q5yujGYc8MLGSr2IHhhJTBa-jEGAG4OsfhtoTnwhA6Wmmrd5fKuGe80oNHpXiV2E3u5RxgFvum6WWNYfdT75UwEQqXWzNpcPEMKCAAHFSHBVS6mpJiDfoQnI3EESqnmjmMbyC8v53VaFA-TeByrNStHISRS8e6Q8b59vpU',
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Technical Specs summary
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'المواصفات الفنية للمنتج',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.onSurface),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(child: _buildSpecLabel('الغسيل', 'جاف فقط')),
                            const SizedBox(width: 8),
                            Expanded(child: _buildSpecLabel('التركيبة', '100% حرير')),
                            const SizedBox(width: 8),
                            Expanded(child: _buildSpecLabel('العرض', '150 سم')),
                            const SizedBox(width: 8),
                            Expanded(child: _buildSpecLabel('الوزن', '120 gsm')),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),

        // Action Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                context.go('/home');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              ),
              child: const Text('العودة للرئيسية', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSpecLabel(String title, String val) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(title, style: const TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant)),
          const SizedBox(height: 4),
          Text(val, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
        ],
      ),
    );
  }
}
