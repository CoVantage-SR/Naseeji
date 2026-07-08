import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../controllers/marketing_controllers.dart';
import '../../domain/entities/marketing_models.dart';

class AdvertisementDetailsScreen extends ConsumerWidget {
  final String adId;
  final B2BAdvertisement? advertisement;

  const AdvertisementDetailsScreen({
    super.key,
    required this.adId,
    this.advertisement,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // If the full advertisement details are not passed via extra, we watch the list
    final adsAsync = ref.watch(marketingAdvertisementsControllerProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          title: const Text(
            'تفاصيل الإعلان B2B',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.onSurface),
          ),
          centerTitle: true,
        ),
        body: Material(
          color: const Color(0xFFF8F9FF),
          child: advertisement != null
              ? _buildDetailsBody(context, advertisement!)
              : adsAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text('خطأ: $e')),
                  data: (ads) {
                    final ad = ads.firstWhere((element) => element.id == adId, orElse: () => ads.first);
                    return _buildDetailsBody(context, ad);
                  },
                ),
        ),
      ),
    );
  }

  Widget _buildDetailsBody(BuildContext context, B2BAdvertisement ad) {
    final target = ad.targeting;
    final conversionRate = ad.reach > 0 ? (ad.orders / ad.reach) * 100 : 0.0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header info
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
                Text(
                  ad.title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.onSurface),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 8),
                Text(
                  ad.description,
                  style: const TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant, height: 1.4),
                  textAlign: TextAlign.right,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Divider(color: AppColors.outlineVariant),
                ),
                _buildInfoRow('الحملة الإعلانية', ad.campaignName),
                _buildInfoRow('المنتج المروج', ad.productName),
                _buildInfoRow('إجراء الاستجابة (CTA)', ad.callToAction),
                _buildInfoRow('ميعاد الحملة', '${ad.startDate.year}/${ad.startDate.month}/${ad.startDate.day} - ${ad.endDate.year}/${ad.endDate.month}/${ad.endDate.day}'),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Targeting Parameters
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
                  'المستهدفون المخصصون (B2B Targeting)',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.onSurface),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Divider(color: AppColors.outlineVariant),
                ),
                _buildTargetList('صناعات المصانع', target.factoryIndustries),
                _buildTargetList('أحجام المصانع الكبرى', target.factorySizes),
                _buildTargetList('المدن والدول المستهدفة', target.locations),
                _buildTargetList('سلوكيات الشراء والتفاعل', target.purchasingBehaviors),
                _buildTargetList('الفئات المرغوبة', target.interestedCategories),
                const SizedBox(height: 12),
                const Divider(color: AppColors.outlineVariant),
                const SizedBox(height: 8),
                _buildSmartCheckRow('المصانع الموثقة فقط', target.verifiedOnly),
                _buildSmartCheckRow('العملاء من الفئة الممتازة (Premium)', target.premiumOnly),
                _buildSmartCheckRow('عملاء VIP نسيجي', target.vipOnly),
                _buildSmartCheckRow('نشط خلال آخر 30 يوماً', target.activeLast30Days),
                _buildSmartCheckRow('يملك دفعات مكتملة ناجحة', target.completedPaymentsOnly),
                _buildSmartCheckRow('يبحث عن منتجات مماثلة', target.searchingSimilarProducts),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Performance Details
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
                  'نتائج الإعلان ومعدلات التحويل',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.onSurface),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Divider(color: AppColors.outlineVariant),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildPerformanceMetric('نسبة النقر CTR', '${ad.ctr.toStringAsFixed(2)}%'),
                    _buildPerformanceMetric('النقرات الكلية', '${ad.clicks}'),
                    _buildPerformanceMetric('الوصول', '${ad.reach}'),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildPerformanceMetric('معدل التحويل', '${conversionRate.toStringAsFixed(2)}%'),
                    _buildPerformanceMetric('الطلبات المولدة', '${ad.orders}'),
                    _buildPerformanceMetric('المبيعات المحققة', '${ad.revenue.toStringAsFixed(0)} ر.س'),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildPerformanceMetric('الميزانية المرصودة', '${ad.budget.toStringAsFixed(0)} ر.س'),
                    _buildPerformanceMetric('المبلغ المستهلك', '${ad.spent.toStringAsFixed(0)} ر.s'),
                    _buildPerformanceMetric('المتبقي في المحفظة', '${ad.remainingBudget.toStringAsFixed(0)} ر.س'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
          Text(label, style: const TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant)),
        ],
      ),
    );
  }

  Widget _buildTargetList(String title, List<String> list) {
    if (list.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(title, style: const TextStyle(fontSize: 10, color: AppColors.onSurfaceVariant)),
          const SizedBox(height: 4),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            textDirection: TextDirection.rtl,
            children: list.map((item) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
                ),
                child: Text(item, style: const TextStyle(fontSize: 10, color: AppColors.onSurface)),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSmartCheckRow(String label, bool active) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: active ? AppColors.onSurface : AppColors.outline),
          ),
          const SizedBox(width: 8),
          Icon(
            active ? Icons.check_circle : Icons.radio_button_unchecked,
            color: active ? const Color(0xFF006B5F) : AppColors.outline,
            size: 16,
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceMetric(String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontSize: 9, color: AppColors.onSurfaceVariant), textAlign: TextAlign.center),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.onSurface), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
