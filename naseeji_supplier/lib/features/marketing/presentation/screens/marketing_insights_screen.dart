import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../controllers/marketing_controllers.dart';
import '../widgets/recommendation_card.dart';

class MarketingInsightsScreen extends ConsumerWidget {
  const MarketingInsightsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final insightsAsync = ref.watch(marketingInsightsControllerProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          title: const Text(
            'توصيات وتحليلات الذكاء B2B',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.onSurface),
          ),
          centerTitle: true,
        ),
        body: Material(
          color: const Color(0xFFF8F9FF),
          child: insightsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('خطأ: $e')),
            data: (insights) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'تحليلات ونصائح استراتيجية لتحسين أداء حملاتك',
                      style: TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant),
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: 16),

                    // Key Performance Insight Dashboard summary
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
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text('الملخص الاستراتيجي للنشاط الإعلاني', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
                              const SizedBox(width: 8),
                              Icon(Icons.query_stats, color: Color(0xFF0040E0), size: 20),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Divider(color: AppColors.outlineVariant),
                          ),
                          _buildSummaryRow('المنتج الأكثر تميزاً واستجابة', 'قطن ممتاز طويل التيلة'),
                          _buildSummaryRow('الحملة الأعلى كفاءة بمعدل التحويل', 'حملة الأقمشة الصيفية 2026'),
                          _buildSummaryRow('الشريحة الأكثر شراءً وتعاقداً', 'مصانع الملابس الجاهزة (كبير)'),
                          _buildSummaryRow('المنطقة الأعلى تفاعلاً وطلباً', 'منطقة الرياض الصناعية'),
                          _buildSummaryRow('الخامة الأكثر طلباً في RFQs', 'خيوط البوليستر والقطنيات'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Actionable Recommendations
                    const Text(
                      'التوصيات المقترحة من الذكاء الاصطناعي',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.onSurface),
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: 12),
                    ...insights.map((insight) {
                      IconData icon = Icons.info_outline;
                      Color color = const Color(0xFF0040E0);
                      String actionLabel = 'اتخاذ إجراء';
                      String route = '/marketing';

                      if (insight.type == 'success') {
                        icon = Icons.check_circle_outline;
                        color = const Color(0xFF006B5F);
                        actionLabel = 'توسيع الميزانية الإعلانية';
                        route = '/marketing/budget';
                      } else if (insight.type == 'warning') {
                        icon = Icons.warning_amber_rounded;
                        color = const Color(0xFFBA1A1A);
                        actionLabel = 'تمويل الحملة المتوقفة';
                        route = '/marketing/budget';
                      } else if (insight.type == 'tip') {
                        icon = Icons.tips_and_updates_outlined;
                        color = const Color(0xFFFF9800);
                        actionLabel = 'جدولة التنبيهات القادمة';
                        route = '/marketing/notifications';
                      }

                      return RecommendationCard(
                        title: insight.title,
                        description: '${insight.description}\n\nالتوصية: ${insight.recommendation}',
                        actionLabel: actionLabel,
                        onTapAction: () => context.push(route),
                        icon: icon,
                        iconColor: color,
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

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(value, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
          Text(label, style: const TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant)),
        ],
      ),
    );
  }
}
