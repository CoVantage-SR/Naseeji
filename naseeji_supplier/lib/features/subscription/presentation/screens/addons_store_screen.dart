import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../controllers/subscription_controllers.dart';
import '../widgets/addon_card.dart';

class AddonsStoreScreen extends ConsumerWidget {
  const AddonsStoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addonsAsync = ref.watch(addonsStoreControllerProvider);

    final List<Map<String, dynamic>> payAsYouGoList = [
      {
        'title': 'تمييز ورعاية منتج لمدة 7 أيام',
        'price': 49.0,
        'description': 'رفع أولوية ظهور منتج خام في الصفحة الرئيسية لنسيجي للمشترين والمصانع.',
      },
      {
        'title': 'تمييز ورعاية منتج لمدة 30 يوماً',
        'price': 149.0,
        'description': 'رعاية كاملة لكتالوج الخام المختار في صدارة نتائج البحث للمشتريات.',
      },
      {
        'title': 'مراجعة معملية فورية لشهادة الجودة',
        'price': 79.0,
        'description': 'تسريع مراجعة وتوثيق شهادات الجودة والمعايير لخاماتك من الإدارة.',
      },
      {
        'title': 'ترويج في الصفحة الرئيسية للبحث',
        'price': 199.0,
        'description': 'تثبيت بانر إعلاني للمنشأة بمدخل صفحة البحث الرئيسية للمصانع.',
      },
    ];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          title: const Text(
            'متجر ملحقات وخدمات الحساب B2B',
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
                // Add-ons header
                const Text(
                  'ملحقات التوسيع لموارد الباقة الحالية',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.onSurface),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 12),

                addonsAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text('خطأ: $e')),
                  data: (addons) {
                    return Column(
                      children: addons.map((addon) {
                        return AddonCard(
                          addon: addon,
                          onBuy: () {
                            context.push('/subscription/checkout', extra: {
                              'addon': addon,
                            });
                          },
                          onTapDetails: () => context.push('/subscription/addons/${addon.id}', extra: addon),
                        );
                      }).toList(),
                    );
                  },
                ),
                const SizedBox(height: 24),

                // Pay As You Go Services
                const Text(
                  'خدمات الدفع حسب الاستخدام (Pay As You Go)',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.onSurface),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 12),

                ...payAsYouGoList.map((service) {
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
                            Text(
                              '${(service['price'] as double).toStringAsFixed(0)} ر.س',
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF006B5F)),
                            ),
                            Text(
                              service['title'] as String,
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.onSurface),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          service['description'] as String,
                          style: const TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant),
                          textAlign: TextAlign.right,
                        ),
                        const SizedBox(height: 12),
                        const Divider(color: AppColors.outlineVariant),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('صلاحية فورية ومستقلة', style: TextStyle(fontSize: 9, color: AppColors.onSurfaceVariant)),
                            ElevatedButton(
                              onPressed: () {
                                ref.read(addonsStoreControllerProvider.notifier).buyPayAsYouGo(
                                      service['title'] as String,
                                      service['price'] as double,
                                    );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('تم شراء خدمة "${service['title']}" بنجاح!')),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0040E0),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                minimumSize: const Size(120, 36),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                              ),
                              child: const Text('شراء الخدمة الآن', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                            ),
                          ],
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
