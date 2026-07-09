import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../controllers/quotations_controller.dart';
import '../../domain/entities/quotation_model.dart';
import '../widgets/quotation_timeline_widget.dart';

class QuotationHistoryScreen extends ConsumerStatefulWidget {
  final String quotationId;

  const QuotationHistoryScreen({super.key, required this.quotationId});

  @override
  ConsumerState<QuotationHistoryScreen> createState() => _QuotationHistoryScreenState();
}

class _QuotationHistoryScreenState extends ConsumerState<QuotationHistoryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stateAsync = ref.watch(quotationsControllerProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          centerTitle: true,
          title: Text(
            'سجل التغييرات والتفاوض لعرض ${widget.quotationId}',
            style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 13),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.onSurfaceVariant, size: 20),
            onPressed: () => context.pop(),
          ),
          bottom: TabBar(
            controller: _tabController,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.onSurfaceVariant,
            indicatorColor: AppColors.primary,
            tabs: const [
              Tab(text: 'الخط الزمني للعمليات'),
              Tab(text: 'سجل مراجعات الأسعار'),
            ],
          ),
        ),
        body: stateAsync.when(
          loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
          error: (e, _) => Center(child: Text('خطأ: $e')),
          data: (quotations) {
            final index = quotations.indexWhere((q) => q.id == widget.quotationId);
            if (index == -1) {
              return const Center(child: Text('عرض السعر غير موجود'));
            }
            final q = quotations[index];

            final allRevisions = List<QuotationRevisionModel>.from(q.revisions);
            if (allRevisions.isEmpty) {
              allRevisions.add(QuotationRevisionModel(
                version: 'v${q.version}',
                supplierPrice: q.supplierUnitPrice,
                factoryCounterOffer: q.originalRequestedPrice,
                priceDifference: (q.supplierUnitPrice - q.originalRequestedPrice).abs(),
                reason: 'العرض الأساسي المقدم.',
                createdDate: q.createdDate,
                negotiatedBy: 'مورد نسيجي',
                status: 'العرض الحالي المفتوح',
              ));
            }

            return TabBarView(
              controller: _tabController,
              children: [
                // Tab 1: Timeline
                ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    QuotationTimelineWidget(steps: q.timeline),
                  ],
                ),

                // Tab 2: Revisions List (Negotiation History)
                ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: allRevisions.length,
                  itemBuilder: (context, index) {
                    final rev = allRevisions[index];
                    return _buildRevisionCard(context, rev, q);
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildRevisionCard(BuildContext context, QuotationRevisionModel rev, QuotationModel q) {
    Color statusColor = AppColors.primary;
    if (rev.status.contains('مقبول') || rev.status.contains('معتمد')) {
      statusColor = Colors.green;
    } else if (rev.status.contains('مرفوض')) {
      statusColor = Colors.red;
    } else if (rev.status.contains('تفاوض')) {
      statusColor = Colors.orange;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Color(0x05000000), blurRadius: 10)],
        border: Border.all(color: const Color(0xFFE2E1EF), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'نسخة العرض: ${rev.version}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primary),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  rev.status,
                  style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: statusColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.surfaceContainerLow),
          const SizedBox(height: 12),

          Row(
            children: [
              _buildMetricColumn('سعر المورد المقترح', '${rev.supplierPrice.toStringAsFixed(2)} ر.س'),
              _buildMetricColumn('عرض المصنع المقابل', '${rev.factoryCounterOffer.toStringAsFixed(2)} ر.س'),
              _buildMetricColumn('الفارق المالي الفعلي', '${rev.priceDifference.toStringAsFixed(2)} ر.س', isWarning: rev.priceDifference > 0),
            ],
          ),
          const SizedBox(height: 12),

          _buildRow('تاريخ المراجعة', rev.createdDate),
          _buildRow('تم التفاوض بواسطة', rev.negotiatedBy),
          if (rev.reason.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                rev.reason,
                style: const TextStyle(fontSize: 9, color: AppColors.onSurfaceVariant, height: 1.4),
              ),
            ),
          ],
          
          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.surfaceContainerLow),
          const SizedBox(height: 8),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                onPressed: () => context.push('/quotations/versions/${q.id}'),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primary, width: 0.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                child: const Text('قارن مع إصدار آخر', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.primary)),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () => _showRevisionDetailsDialog(context, rev),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  elevation: 0,
                ),
                child: const Text('عرض التفاصيل', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricColumn(String label, String value, {bool isWarning = false}) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 8, color: AppColors.outline)),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 10, 
              fontWeight: FontWeight.bold, 
              color: isWarning ? AppColors.error : AppColors.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 9, color: AppColors.outline)),
          Text(value, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
        ],
      ),
    );
  }

  void _showRevisionDetailsDialog(BuildContext context, QuotationRevisionModel rev) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تفاصيل مراجعة العرض ${rev.version}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDialogRow('سعر المورد المقترح', '${rev.supplierPrice} ر.س'),
            _buildDialogRow('السعر المطلوب للمصنع', '${rev.factoryCounterOffer} ر.س'),
            _buildDialogRow('الفارق المالي المتبقي', '${rev.priceDifference} ر.س'),
            _buildDialogRow('تاريخ المراجعة الفعلي', rev.createdDate),
            _buildDialogRow('المسؤول عن التعديل', rev.negotiatedBy),
            _buildDialogRow('الحالة التفاوضية', rev.status),
            const SizedBox(height: 12),
            const Text('ملاحظات وإيضاحات التفاوض:', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.outline)),
            const SizedBox(height: 4),
            Text(rev.reason, style: const TextStyle(fontSize: 10, color: AppColors.onSurfaceVariant, height: 1.3)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('إغلاق')),
        ],
      ),
    );
  }

  Widget _buildDialogRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 10, color: AppColors.outline)),
          Text(value, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
        ],
      ),
    );
  }
}
