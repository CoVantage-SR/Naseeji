import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';

// Import all controllers & domain models
import '../controllers/orders_controller.dart';
import '../controllers/rfq_details_controller.dart';
import '../controllers/rfq_chat_controller.dart';
import '../controllers/quotation_history_controller.dart';
import '../controllers/final_agreement_controller.dart';
import '../controllers/production_preparation_controller.dart';
import '../controllers/shipping_manifest_controller.dart';
import '../controllers/payment_release_controller.dart';
import '../controllers/activity_log_controller.dart';

// Import all widgets
import 'widgets/complete_timeline_widget.dart';
import 'widgets/order_media_center.dart';
import 'widgets/negotiation_summary_sheet.dart';
import 'widgets/orders_screen_widgets.dart';

// Import screens we are embedding
import 'rfq_details_screen.dart';
import 'create_offer_screen.dart';
import 'rfq_chat_screen.dart';
import 'offer_preview_screen.dart';
import 'offer_details_screen.dart';
import 'offer_rejected_screen.dart';
import 'offer_approved_screen.dart';
import 'final_agreement_screen.dart';
import 'quotation_revision_history_screen.dart';
import 'production_preparation_screen.dart';
import 'factory_preparation_review_screen.dart';
import 'shipping_manifest_screen.dart';
import 'delivery_confirmation_screen.dart';
import 'payment_release_screen.dart';
import 'activity_log_screen.dart';
import 'dispute_center_screen.dart';

class OrderCenterScreen extends ConsumerStatefulWidget {
  final String rfqId;

  const OrderCenterScreen({super.key, required this.rfqId});

  @override
  ConsumerState<OrderCenterScreen> createState() => _OrderCenterScreenState();
}

class _OrderCenterScreenState extends ConsumerState<OrderCenterScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> tabTitles = const [
    'ملخص الطلب',
    'الخط الزمني',
    'المفاوضات',
    'سجل العروض',
    'الاتفاق النهائي',
    'التصنيع',
    'مراجعة الجودة',
    'بيان الشحن',
    'استلام الشحنة',
    'الدفع المالي',
    'مركز الملفات',
    'النزاعات والشكاوى',
    'سجل التدقيق',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabTitles.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        title: Column(
          children: [
            const Text(
              'مركز إدارة الطلبات الموحد B2B',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'RFQ #${widget.rfqId}',
              style: const TextStyle(
                color: AppColors.outline,
                fontSize: 10,
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.onSurfaceVariant, size: 20),
          onPressed: () => context.pop(),
        ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: const Color(0xFF0040E0),
          unselectedLabelColor: AppColors.onSurfaceVariant,
          indicatorColor: const Color(0xFF0040E0),
          labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          tabs: tabTitles.map((title) => Tab(text: title)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // 1. Overview Tab
          _buildOverviewTab(),
          
          // 2. Timeline Tab
          _buildTimelineTab(),
          
          // 3. Negotiation (Chat) Tab
          RfqChatScreen(rfqId: widget.rfqId),
          
          // 4. Quotation History Tab
          QuotationRevisionHistoryScreen(rfqId: widget.rfqId),
          
          // 5. Final Agreement Tab
          FinalAgreementScreen(rfqId: widget.rfqId),
          
          // 6. Production Tab
          ProductionPreparationScreen(rfqId: widget.rfqId),
          
          // 7. Factory Review Tab
          FactoryPreparationReviewScreen(rfqId: widget.rfqId),
          
          // 8. Shipment Tab
          ShippingManifestScreen(rfqId: widget.rfqId),
          
          // 9. Delivery Tab
          DeliveryConfirmationScreen(rfqId: widget.rfqId),
          
          // 10. Payment Tab
          PaymentReleaseScreen(rfqId: widget.rfqId),
          
          // 11. Files (Media Center) Tab
          OrderMediaCenter(rfqId: widget.rfqId),
          
          // 12. Dispute Tab
          DisputeCenterScreen(rfqId: widget.rfqId),
          
          // 13. Activity Log Tab
          ActivityLogScreen(rfqId: widget.rfqId),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // B2B Stats Grid card
          _buildB2BAnalyticsCard(),
          const SizedBox(height: 16),

          // Action: Repeat Order
          _buildRepeatOrderCard(),
          const SizedBox(height: 16),

          // Embedded RFQ Specs Summary Card
          const Text('مواصفات طلب المشتري الأصلية', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E1EF)),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildOverviewRow('نوع القماش المطلوب', 'قطن 100% طبيعي'),
                SizedBox(height: 10),
                _buildOverviewRow('الكمية الإجمالية', '5,000 متر'),
                SizedBox(height: 10),
                _buildOverviewRow('اللون والمواصفات الفنية', 'أزرق داكن Indigo | وزن 180 GSM'),
                SizedBox(height: 10),
                _buildOverviewRow('وجهة الشحن والتسليم', 'مستودعات الرياض الصناعية'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildB2BAnalyticsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E1EF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text('تحليلات زمن المعالجة B2B', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0040E0))),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF1F1F5)),
          const SizedBox(height: 14),
          _buildOverviewRow('زمن المفاوضات المالية', 'ساعتان و15 دقيقة'),
          const SizedBox(height: 8),
          _buildOverviewRow('عدد مراجعات العرض المتبادلة', '3 مراجعات مقترحة'),
          const SizedBox(height: 8),
          _buildOverviewRow('زمن إصدار الموافقة للمصنع', 'أقل من ساعة'),
          const SizedBox(height: 8),
          _buildOverviewRow('مدة إنتاج الطلبية الفعلي', '5 أيام عمل'),
          const SizedBox(height: 8),
          _buildOverviewRow('زمن الشحن اللوجستي والتسليم', '2 يوم عمل'),
          const SizedBox(height: 8),
          _buildOverviewRow('تأخير السداد المالي للضمان', 'تلقائي فوري (0 يوم delay)'),
          const SizedBox(height: 14),
          const Divider(height: 1, color: Color(0xFFF1F1F5)),
          const SizedBox(height: 14),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '7 أيام و 3 ساعات',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF006B5F)),
              ),
              Text('إجمالي دورة حياة الطلب (Cycle Time)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRepeatOrderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E1EF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text('إعادة طلب المنتجات (Repeat Order)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 4),
          const Text('نسخ تفاصيل هذا الطلب بالكامل لإنشاء طلب جديد بشكل فوري.', style: TextStyle(fontSize: 10, color: AppColors.outline)),
          const SizedBox(height: 14),
          ElevatedButton.icon(
            onPressed: () => _showRepeatOrderDialog(context),
            icon: const Icon(Icons.replay_rounded, size: 16, color: Colors.white),
            label: const Text('تكرار هذا الطلب الآن', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0040E0),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              minimumSize: const Size(double.infinity, 44),
            ),
          ),
        ],
      ),
    );
  }

  void _showRepeatOrderDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('تكرار طلب الشراء', textAlign: TextAlign.center, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('سيتم نسخ البيانات التالية وتكرارها:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('• الخامات: قطن 100% طبيعي (5000 متر)', style: TextStyle(fontSize: 11)),
            Text('• الوجهة: مستودعات الرياض الصناعية', style: TextStyle(fontSize: 11)),
            Text('• طريقة السداد: تحويل بنكي ضامن', style: TextStyle(fontSize: 11)),
            SizedBox(height: 12),
            Text('هل ترغب في الانتقال إلى صفحة المراجعة والتعديل قبل الإرسال؟', style: TextStyle(fontSize: 11, color: AppColors.outline), textAlign: TextAlign.end),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.go('/orders');
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم تكرار الطلب وفتح المسودة للمراجعة')));
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0040E0), foregroundColor: Colors.white),
            child: const Text('تكرار ومراجعة'),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineTab() {
    final mockTimelineSteps = [
      const TimelineStepData(
        title: 'تم إنشاء طلب السعر RFQ',
        date: '2026-07-01',
        time: '09:00 ص',
        user: 'الشركة المتحدة للنسيج الذكي',
        notes: 'تم تقديم طلب سعر لشراء 5,000 متر قطن طبيعي.',
        isCompleted: true,
      ),
      const TimelineStepData(
        title: 'تم مشاهدة طلب السعر من المورد',
        date: '2026-07-01',
        time: '11:15 ص',
        user: 'مورد نسيجي',
        isCompleted: true,
      ),
      const TimelineStepData(
        title: 'تم إرسال عرض السعر المبدئي',
        date: '2026-07-02',
        time: '02:30 م',
        user: 'مورد نسيجي',
        notes: 'سعر الوحدة المقترح 15.00 ريال/متر.',
        attachments: ['عرض_سعر_RFQ8820.pdf'],
        isCompleted: true,
      ),
      const TimelineStepData(
        title: 'بدء المفاوضات وتعديل السعر',
        date: '2026-07-03',
        time: '10:00 ص',
        user: 'الطرفين',
        isCompleted: true,
      ),
      const TimelineStepData(
        title: 'تأكيد واعتماد الاتفاقية النهائية',
        date: '2026-07-04',
        time: '04:00 م',
        user: 'مصنع الأقمشة المتطور',
        notes: 'تم تثبيت السعر النهائي على 12.00 ريال/متر.',
        isCompleted: true,
      ),
      const TimelineStepData(
        title: 'بدء إنتاج وتجهيز الطلب',
        date: '2026-07-05',
        time: '08:00 ص',
        user: 'مورد نسيجي',
        notes: 'جاري نسج وتغليف اللفات بالمصنع.',
        isActive: true,
      ),
      const TimelineStepData(
        title: 'تدقيق واعتماد جاهزية الإنتاج',
        date: 'مجدول',
        time: 'لاحقاً',
        user: 'المشتري',
        isCompleted: false,
      ),
      const TimelineStepData(
        title: 'شحن الإرسالية وتحديث البولصية',
        date: 'مجدول',
        time: 'لاحقاً',
        user: 'المورد',
        isCompleted: false,
      ),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.share_outlined, color: Color(0xFF0040E0), size: 20),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم تصدير الخط الزمني للطلب بصيغة PDF بنجاح')));
                },
              ),
              const Text('سجل المتابعة والتدقيق الزمني للطلب', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 16),
          CompleteTimelineWidget(steps: mockTimelineSteps),
        ],
      ),
    );
  }

  static Widget _buildOverviewRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(child: Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold), textAlign: TextAlign.left)),
        const SizedBox(width: 10),
        Text('$label:', style: const TextStyle(fontSize: 11, color: AppColors.outline)),
      ],
    );
  }
}
