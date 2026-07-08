import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import 'package:naseeji_supplier/core/widgets/general_widgets.dart';
import '../controllers/marketing_controllers.dart';
import '../widgets/audience_filter_widget.dart';
import '../widgets/recommendation_card.dart';
import '../../domain/entities/marketing_models.dart';

class AudienceTargetingScreen extends ConsumerStatefulWidget {
  const AudienceTargetingScreen({super.key});

  @override
  ConsumerState<AudienceTargetingScreen> createState() => _AudienceTargetingScreenState();
}

class _AudienceTargetingScreenState extends ConsumerState<AudienceTargetingScreen> {
  B2BAudienceTarget _target = B2BAudienceTarget.empty();

  @override
  Widget build(BuildContext context) {
    final recommendationsAsync = ref.watch(smartB2BRecommendationsControllerProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          title: const Text(
            'استهداف المصانع الذكي B2B',
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
                // Smart recommendations engine section
                recommendationsAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text('خطأ: $e')),
                  data: (rec) => Container(
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
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'توصيات الذكاء الاصطناعي للاستهداف',
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.onSurface),
                            ),
                            const SizedBox(width: 8),
                            Icon(Icons.psychology, color: Color(0xFF0040E0), size: 20),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Divider(color: AppColors.outlineVariant),
                        ),
                        _buildInsightItem('المنتجات الموصى بترويجها حالياً', rec.bestProductsToPromote.join(' و ')),
                        _buildInsightItem('الوقت المفضل لإرسال الحملة', rec.bestTimeLaunch),
                        _buildInsightItem('الميزانية المقترحة للحملة', '${rec.recommendedBudget.toStringAsFixed(0)} ر.س'),
                        _buildInsightItem('الوصول / الطلبات المتوقعة', '${rec.expectedReach} مصنع / ~${rec.expectedOrders} طلبية'),
                        _buildInsightItem('العائد المقدر (ROAS)', '${(rec.expectedRevenue / rec.recommendedBudget).toStringAsFixed(1)}x (${rec.expectedRevenue.toStringAsFixed(0)} ر.س)'),
                        const SizedBox(height: 12),
                        const Divider(color: AppColors.outlineVariant),
                        const SizedBox(height: 8),
                        const Text(
                          'الشرائح الموصى بها للاستهداف التلقائي:',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.onSurface),
                          textAlign: TextAlign.right,
                        ),
                        const SizedBox(height: 6),
                        ...rec.recommendedSegments.map((seg) => Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(seg, style: const TextStyle(fontSize: 10, color: AppColors.onSurfaceVariant), textAlign: TextAlign.right),
                              const SizedBox(width: 6),
                              const Icon(Icons.circle, size: 6, color: Color(0xFF006B5F)),
                            ],
                          ),
                        )),
                      ],
                    ),
                  ),
                ),

                // Audience interactive targeting form
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
                        'إعداد شريحة مستهدفة مخصصة',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.onSurface),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: Divider(color: AppColors.outlineVariant),
                      ),
                      AudienceFilterWidget(
                        target: _target,
                        onChanged: (newTarget) {
                          setState(() => _target = newTarget);
                        },
                      ),
                      const SizedBox(height: 24),
                      PrimaryButton(
                        onPressed: () {
                          // Simulate calculating reach based on selections
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('حجم الجمهور المستهدف', textAlign: TextAlign.right),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Text('شريحة الجمهور المطابقة للمعايير المحددة:', textAlign: TextAlign.right),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('${(_target.factoryIndustries.length * 45 + 12)} مصنع نشط', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF006B5F))),
                                      const Text('المصانع المطابقة'),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  const Text('هذه الشريحة تحقق استجابة عالية في المواسم الصيفية.', style: TextStyle(fontSize: 10, color: AppColors.onSurfaceVariant), textAlign: TextAlign.right),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx),
                                  child: const Text('حسناً'),
                                ),
                              ],
                            ),
                          );
                        },
                        child: const Text('تطبيق الشريحة وحساب الوصول المتوقع', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInsightItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(value, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.onSurface), textAlign: TextAlign.left),
          Text(label, style: const TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant), textAlign: TextAlign.right),
        ],
      ),
    );
  }
}
