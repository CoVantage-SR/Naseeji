import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../controllers/marketing_controllers.dart';
import '../widgets/campaign_performance_card.dart';
import '../../domain/entities/marketing_models.dart';

class CampaignDetailsScreen extends ConsumerWidget {
  final String campaignId;
  final MarketingCampaign? campaign;

  const CampaignDetailsScreen({
    super.key,
    required this.campaignId,
    this.campaign,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final campaignsAsync = ref.watch(marketingCampaignsControllerProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          title: const Text(
            'تفاصيل الحملة التسويقية',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.onSurface),
          ),
          centerTitle: true,
        ),
        body: Material(
          color: const Color(0xFFF8F9FF),
          child: campaign != null
              ? _buildDetailsBody(context, campaign!)
              : campaignsAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text('خطأ: $e')),
                  data: (camps) {
                    final c = camps.firstWhere((element) => element.id == campaignId, orElse: () => camps.first);
                    return _buildDetailsBody(context, c);
                  },
                ),
        ),
      ),
    );
  }

  Widget _buildDetailsBody(BuildContext context, MarketingCampaign camp) {
    final double budgetPercent = camp.budget > 0 ? (camp.spent / camp.budget) : 0.0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Campaign Header
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      camp.status == CampaignStatus.active ? 'نشطة جارية' : 'مجدولة',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: camp.status == CampaignStatus.active ? const Color(0xFF006B5F) : const Color(0xFF0040E0),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        camp.name,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.onSurface),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  camp.objective,
                  style: const TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 16),
                const Divider(color: AppColors.outlineVariant),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${camp.durationDays} أيام المتبقية / 30 يوم', style: const TextStyle(fontSize: 10, color: AppColors.onSurfaceVariant)),
                    const Text('مدة التشغيل', style: const TextStyle(fontSize: 10, color: AppColors.onSurfaceVariant)),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: 0.6,
                    minHeight: 6,
                    backgroundColor: AppColors.outlineVariant,
                    valueColor: AlwaysStoppedAnimation<Color>(const Color(0xFF0040E0)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Budget breakdown
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
                  'استهلاك الميزانية للحملة',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.onSurface),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${(budgetPercent * 100).toStringAsFixed(1)}%', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0040E0))),
                    const Text('نسبة استهلاك ميزانية الحملة', style: const TextStyle(fontSize: 10, color: AppColors.onSurfaceVariant)),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: budgetPercent,
                    minHeight: 6,
                    backgroundColor: AppColors.outlineVariant,
                    valueColor: AlwaysStoppedAnimation<Color>(const Color(0xFF0040E0)),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildTextItem('الميزانية الكلية', '${camp.budget.toStringAsFixed(0)} ر.س'),
                    _buildTextItem('المبلغ المستهلك', '${camp.spent.toStringAsFixed(0)} ر.س'),
                    _buildTextItem('المتبقي للتشغيل', '${(camp.budget - camp.spent).toStringAsFixed(0)} ر.س'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Performance KPIs Component
          CampaignPerformanceCard(campaign: camp),
          const SizedBox(height: 16),

          // Top Targeting & conversion details B2B
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
                  'توزيع الاستجابة الجغرافية والصناعية',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.onSurface),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Divider(color: AppColors.outlineVariant),
                ),
                _buildAnalysisRow('الرياض، جدة، المنطقة الشرقية', 'المناطق الجغرافية الأكثر تفاعلاً'),
                _buildAnalysisRow('مصانع الملابس الجاهزة والزي الموحد', 'صناعات المصانع الأكثر تحقيقاً للمبيعات'),
                _buildAnalysisRow('أحجام المنشآت المتوسطة والكبيرة', 'أحجام المصانع المتفاعلة مع المنتجات المروج لها'),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildTextItem(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 9, color: AppColors.onSurfaceVariant)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
      ],
    );
  }

  Widget _buildAnalysisRow(String detail, String header) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(header, style: const TextStyle(fontSize: 10, color: AppColors.onSurfaceVariant)),
          const SizedBox(height: 4),
          Text(detail, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
        ],
      ),
    );
  }
}
