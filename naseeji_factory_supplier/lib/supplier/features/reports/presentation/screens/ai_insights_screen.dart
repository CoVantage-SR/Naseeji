// ignore_for_file: unnecessary_brace_in_string_interps

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_factory/core/theme/app_colors.dart';
import '../../../dashboard/presentation/controllers/analytics_report_controller.dart';
import '../widgets/ai_insight_card.dart';
import '../widgets/report_filter_bar.dart';
import '../widgets/report_section_header.dart';

class AiInsightsScreen extends ConsumerWidget {
  const AiInsightsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataAsync = ref.watch(analyticsReportDataProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0.5,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.auto_awesome_outlined, color: AppColors.primary, size: 18),
            const SizedBox(width: 8),
            Text('رؤى الذكاء الاصطناعي',
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.onSurfaceVariant, size: 20),
          onPressed: () => context.canPop() ? context.pop() : context.go('/reports'),
        ),
      ),
      body: dataAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (e, _) => Center(child: Text('خطأ: $e')),
        data: (data) {
          final insights = _generateInsights(data);

          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () => ref.refresh(analyticsReportDataProvider.future),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const ReportFilterBar(showExport: false),
                  const SizedBox(height: 20),

                  // Headline
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [const Color(0xFF6366F1), const Color(0xFF4F46E5)],
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('مُحدَّث الآن', style: TextStyle(color: Colors.white70, fontSize: 11)),
                            const Icon(Icons.auto_awesome, color: Colors.white, size: 24),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text('تحليل ذكي مخصص لشغلك', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        const Text(
                          'بناءً على بيانات أداءك الفعلية، يقدم لك الذكاء الاصطناعي توصيات دقيقة لتحسين نتائجك وزيادة مبيعاتك.',
                          style: TextStyle(color: Colors.white70, fontSize: 12, height: 1.5),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Positive insights
                  ReportSectionHeader(
                    title: 'نقاط القوة',
                    icon: Icons.trending_up_rounded,
                    iconColor: const Color(0xFF00875A),
                    subtitle: 'ما تفعله بشكل ممتاز',
                  ),
                  const SizedBox(height: 12),
                  ...insights.where((i) => i.type == AiInsightType.success).map(
                        (i) => AiInsightCard(message: i.message, type: i.type, actionLabel: i.actionLabel, onAction: i.onAction != null ? () => i.onAction!(context) : null),
                      ),

                  const SizedBox(height: 20),

                  // Warnings
                  ReportSectionHeader(
                    title: 'فرص للتحسين',
                    icon: Icons.warning_amber_rounded,
                    iconColor: const Color(0xFFB45309),
                    subtitle: 'مناطق تحتاج اهتمام',
                  ),
                  const SizedBox(height: 12),
                  ...insights.where((i) => i.type == AiInsightType.warning).map(
                        (i) => AiInsightCard(message: i.message, type: i.type, actionLabel: i.actionLabel, onAction: i.onAction != null ? () => i.onAction!(context) : null),
                      ),

                  const SizedBox(height: 20),

                  // Tips
                  ReportSectionHeader(
                    title: 'نصائح ذكية',
                    icon: Icons.lightbulb_outline_rounded,
                    iconColor: const Color(0xFF6366F1),
                    subtitle: 'توصيات لتعظيم الأرباح',
                  ),
                  const SizedBox(height: 12),
                  ...insights.where((i) => i.type == AiInsightType.tip).map(
                        (i) => AiInsightCard(message: i.message, type: i.type, actionLabel: i.actionLabel, onAction: i.onAction != null ? () => i.onAction!(context) : null),
                      ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  List<_Insight> _generateInsights(ReportData data) {
    final insights = <_Insight>[];

    // Success insights
    if (data.averageRating >= 4.5) {
      insights.add(_Insight(
        'تقييمك المتوسط ${data.averageRating.toStringAsFixed(1)} نجمة ممتاز! العملاء راضون جداً عن جودة منتجاتك وخدمتك. حافظ على هذا المستوى.',
        AiInsightType.success,
      ));
    }

    if (data.revenueGrowth > 15) {
      insights.add(_Insight(
        'إيراداتك نمت بنسبة ${data.revenueGrowth.toStringAsFixed(1)}% — أداء استثنائي يتجاوز متوسط السوق. شغلك في المسار الصحيح.',
        AiInsightType.success,
      ));
    }

    if (data.winRate >= 65) {
      insights.add(_Insight(
        'معدل الفوز بالصفقات ${data.winRate.toStringAsFixed(1)}% يُعدّ ممتازاً. مهاراتك التفاوضية وجودة عروضك تُميّزك عن المنافسين.',
        AiInsightType.success,
        actionLabel: 'عرض تفاصيل',
        onAction: (ctx) => ctx.go('/reports/quotations'),
      ));
    }

    // Warnings
    if (data.cancelledOrders > 0 && data.totalOrders > 0) {
      final cancRate = (data.cancelledOrders / data.totalOrders * 100).toStringAsFixed(1);
      insights.add(_Insight(
        'معدل إلغاء الطلبات ${cancRate}%. دراسة أسباب الإلغاء يمكن أن تُقلّل هذه النسبة وتزيد إيراداتك.',
        AiInsightType.warning,
        actionLabel: 'عرض الطلبات',
        onAction: (ctx) => ctx.go('/orders'),
      ));
    }

    if (data.avgShippingDays > 3) {
      insights.add(_Insight(
        'متوسط وقت الشحن ${data.avgShippingDays.toStringAsFixed(1)} أيام. تقليله دون الـ 3 أيام سيحسّن رضا العملاء ويزيد التقييمات بشكل ملحوظ.',
        AiInsightType.warning,
        actionLabel: 'تحسين الشحن',
        onAction: (ctx) => ctx.go('/shipping'),
      ));
    }

    if (data.pendingOrders > 5) {
      insights.add(_Insight(
        'لديك ${data.pendingOrders} طلب معلق حالياً. الرد السريع يزيد معدل الفوز ويُحسّن ترتيبك في المنصة.',
        AiInsightType.warning,
        actionLabel: 'متابعة الطلبات',
        onAction: (ctx) => ctx.go('/orders'),
      ));
    }

    // Tips
    insights.add(_Insight(
      'أفضل يوم للمبيعات هو ${data.topSalesDay}. جرّب إطلاق عروض خاصة في هذا اليوم لتضاعف إيراداتك.',
      AiInsightType.tip,
    ));

    insights.add(_Insight(
      'منتجك الأفضل أداءً يحقق نسبة تحويل عالية. فكّر في إضافة منتجات مشابهة لاستغلال الطلب المتاح.',
      AiInsightType.tip,
      actionLabel: 'أداء المنتجات',
      onAction: (ctx) => ctx.go('/reports/products/performance'),
    ));

    if (data.activeAds < 3) {
      insights.add(_Insight(
        'لديك فقط ${data.activeAds} إعلانات نشطة. زيادة الإعلانات المستهدفة يمكن أن ترفع مبيعاتك بنسبة تصل لـ 35%.',
        AiInsightType.tip,
      ));
    }

    insights.add(_Insight(
      'شهر ${data.topSalesMonth} هو ذروة مبيعاتك. احرص على تجهيز مخزون كافٍ ومضاعفة الإعلانات قبله بشهر على الأقل.',
      AiInsightType.tip,
    ));

    return insights;
  }
}

class _Insight {
  final String message;
  final AiInsightType type;
  final String? actionLabel;
  final void Function(BuildContext)? onAction;

  _Insight(this.message, this.type, {this.actionLabel, this.onAction});
}


