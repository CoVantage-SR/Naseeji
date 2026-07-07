import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../../domain/entities/shipment.dart';
import '../controllers/shipping_controller.dart';
import '../widgets/premium_badge.dart'; // We can use it or similar if needed

class ShipmentDetailsScreen extends ConsumerStatefulWidget {
  final String shipmentId;

  const ShipmentDetailsScreen({super.key, required this.shipmentId});

  @override
  ConsumerState<ShipmentDetailsScreen> createState() => _ShipmentDetailsScreenState();
}

class _ShipmentDetailsScreenState extends ConsumerState<ShipmentDetailsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = ['التفاصيل والمالية', 'الخط الزمني', 'الصور والمستندات'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stateAsync = ref.watch(shippingControllerProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: stateAsync.when(
        loading: () => const Scaffold(body: Center(child: CircularProgressIndicator(color: AppColors.primary))),
        error: (e, _) => Scaffold(body: Center(child: Text('خطأ: $e'))),
        data: (shipments) {
          final shipmentIndex = shipments.indexWhere((s) => s.id == widget.shipmentId);
          if (shipmentIndex == -1) {
            return const Scaffold(body: Center(child: Text('الشحنة غير موجودة')));
          }
          final s = shipments[shipmentIndex];

          return Scaffold(
            backgroundColor: const Color(0xFFF8F9FF),
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0.5,
              centerTitle: true,
              title: Column(
                children: [
                  Text(
                    'تفاصيل الشحنة ${s.id}',
                    style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'طلب: ${s.orderNumber} • مصنع: ${s.factoryName}',
                    style: const TextStyle(color: AppColors.outline, fontSize: 10),
                  ),
                ],
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.onSurfaceVariant, size: 20),
                onPressed: () => context.pop(),
              ),
              bottom: TabBar(
                controller: _tabController,
                labelColor: const Color(0xFF0040E0),
                unselectedLabelColor: AppColors.onSurfaceVariant,
                indicatorColor: const Color(0xFF0040E0),
                labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                tabs: _tabs.map((title) => Tab(text: title)).toList(),
              ),
            ),
            body: TabBarView(
              controller: _tabController,
              children: [
                // Tab 1: Details & Finance & Factory Confirmation
                _buildDetailsTab(context, s),
                
                // Tab 2: Timeline Events
                _buildTimelineTab(s),
                
                // Tab 3: Media & Documents
                _buildMediaAndDocsTab(context, s),
              ],
            ),
            bottomNavigationBar: _buildBottomActionBar(context, s),
          );
        },
      ),
    );
  }

  Widget _buildDetailsTab(BuildContext context, Shipment s) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Current Status Tracker Header
          _buildStatusProgressHeader(s),
          const SizedBox(height: 16),

          // Order details card
          _buildSectionCard(
            title: 'تفاصيل الطلب والمنتج',
            icon: Icons.assignment_outlined,
            children: [
              _buildDetailRow('اسم المنتج', s.productName),
              _buildDetailRow('الكمية الإجمالية', '${s.quantity} ${s.unit}'),
              _buildDetailRow('الوزن الكلي للشحنة', '${s.weight} كجم'),
              _buildDetailRow('الحجم الكلي للشحنة', '${s.volume} متر مكعب'),
              _buildDetailRow('عدد الكرتونات والطرود', '${s.cartons} كرتونة • ${s.packages} طرد كبير'),
              _buildDetailRow('الرقم المرجعي RFQ', s.rfqNumber, isLink: true),
            ],
          ),
          const SizedBox(height: 16),

          // Carrier details card
          _buildSectionCard(
            title: 'تفاصيل الشحن والناقل',
            icon: Icons.local_shipping_outlined,
            children: [
              _buildDetailRow('شركة الشحن الناقلة', s.shippingCompany.isNotEmpty ? s.shippingCompany : 'لم يحدد بعد'),
              _buildDetailRow('طريقة ونوع الشحن', s.shippingMethod.isNotEmpty ? s.shippingMethod : 'لم يحدد بعد'),
              _buildDetailRow('رقم التتبع (Tracking Number)', s.trackingNumber.isNotEmpty ? s.trackingNumber : 'بانتظار التحديث', isPrimary: s.trackingNumber.isNotEmpty),
              _buildDetailRow('موعد الاستلام الفعلي', s.timeline.first.date),
              _buildDetailRow('الوصول المتوقع للمستودع', s.estimatedDelivery),
              _buildDetailRow('عنوان مستودع التسليم', s.deliveryAddress),
              if (s.driverName.isNotEmpty) ...[
                const Divider(height: 12),
                _buildDetailRow('اسم السائق الناقل', s.driverName),
                _buildDetailRow('رقم هاتف السائق', s.driverPhone),
                _buildDetailRow('رقم لوحة المركبة', s.vehicleNumber),
              ],
            ],
          ),
          const SizedBox(height: 16),

          // Shipping Cost breakdown card (Screen 7)
          _buildSectionCard(
            title: 'تفاصيل التكاليف والمالية اللوجستية',
            icon: Icons.account_balance_wallet_outlined,
            children: [
              _buildDetailRow('تكلفة الشحن المباشرة', '${s.cost.shipping.toStringAsFixed(2)} ر.س'),
              _buildDetailRow('تكلفة التأمين اللوجستي', '${s.cost.insurance.toStringAsFixed(2)} ر.س'),
              _buildDetailRow('الضرائب والرسوم الجمركية', '${s.cost.taxes.toStringAsFixed(2)} ر.س'),
              _buildDetailRow('رسوم التحميل والتفريغ', '${s.cost.handling.toStringAsFixed(2)} ر.س'),
              _buildDetailRow('تكلفة التعبئة والتغليف المتخصصة', '${s.cost.packaging.toStringAsFixed(2)} ر.س'),
              if (s.cost.other > 0) _buildDetailRow('رسوم لوجستية أخرى إضافية', '${s.cost.other.toStringAsFixed(2)} ر.س'),
              const Divider(height: 12),
              _buildDetailRow('المجموع الكلي اللوجستي', '${s.cost.total.toStringAsFixed(2)} ر.س', isBold: true),
              _buildDetailRow('حالة الدفعة المالية للشحن', s.status == ShipmentStatus.completed ? 'تم الإفراج والدفع' : 'قيد التعليق اللوجستي المربوط'),
            ],
          ),
          const SizedBox(height: 16),

          // Factory Confirmation Details (Screen 8)
          if (s.factoryConfirmation != null)
            _buildSectionCard(
              title: 'تأكيد استلام وفحص المصنع',
              icon: Icons.verified_user_outlined,
              children: [
                _buildDetailRow('حالة الاستلام الفعلي', s.factoryConfirmation!.received ? 'تم استلام وتأكيد وصول الشحنة' : 'لم يتم الاستلام بعد'),
                _buildDetailRow('حالة التدقيق الجمركي والفحص', s.factoryConfirmation!.inspectionStatus),
                _buildDetailRow('الكمية المقبولة المستلمة', '${s.factoryConfirmation!.acceptedQty.toStringAsFixed(0)} ${s.unit}'),
                _buildDetailRow('الكمية المرفوضة (إن وجدت)', '${s.factoryConfirmation!.rejectedQty.toStringAsFixed(0)} ${s.unit}', isWarning: s.factoryConfirmation!.rejectedQty > 0),
                _buildDetailRow('ملاحظات الجودة للمستودع', s.factoryConfirmation!.notes),
                _buildDetailRow('رأي المشتري النهائي', s.factoryConfirmation!.feedback),
                if (s.factoryConfirmation!.images.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  const Text('صور توثيق الاستلام في موقع الفحص:', style: TextStyle(fontSize: 10, color: AppColors.outline)),
                  const SizedBox(height: 6),
                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: s.factoryConfirmation!.images.length,
                      itemBuilder: (context, i) => Container(
                        margin: const EdgeInsets.only(left: 6),
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          image: DecorationImage(image: NetworkImage(s.factoryConfirmation!.images[i]), fit: BoxFit.cover),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          const SizedBox(height: 16),

          // Active Reported Issue Card
          if (s.issueReported != null)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: AppColors.error),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('تم فتح بلاغ/نزاع لوجستي نشط', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.error)),
                        const SizedBox(height: 2),
                        Text(s.issueReported!, style: TextStyle(fontSize: 10, color: Colors.red.shade900)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatusProgressHeader(Shipment s) {
    Color statusColor = AppColors.primary;
    String statusText = '';
    switch (s.status) {
      case ShipmentStatus.ready:
        statusColor = Colors.blue.shade700;
        statusText = 'جاهز للشحن والتسليم';
        break;
      case ShipmentStatus.loaded:
        statusColor = Colors.indigo;
        statusText = 'تم التحميل للناقل';
        break;
      case ShipmentStatus.pickedUp:
        statusColor = Colors.orange;
        statusText = 'تم تسليم الشحنة للسائق';
        break;
      case ShipmentStatus.inTransit:
        statusColor = Colors.orange.shade700;
        statusText = 'الشحنة في الطريق';
        break;
      case ShipmentStatus.arrived:
        statusColor = Colors.teal;
        statusText = 'وصلت الشحنة موقع الفحص';
        break;
      case ShipmentStatus.delivered:
        statusColor = Colors.green;
        statusText = 'تم تسليم الشحنة بالكامل';
        break;
      case ShipmentStatus.paymentPending:
        statusColor = Colors.purple;
        statusText = 'بانتظار الإفراج المالي';
        break;
      case ShipmentStatus.completed:
        statusColor = Colors.green.shade800;
        statusText = 'الشحنة مكتملة ومسواة مالياً';
        break;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                statusText,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: statusColor),
              ),
              Text(
                '${(s.progress * 100).toInt()}%',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: statusColor),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: s.progress,
              color: statusColor,
              backgroundColor: AppColors.surfaceContainerLow,
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'التحديث الأخير: ${s.lastUpdate}',
            style: const TextStyle(fontSize: 10, color: AppColors.outline, fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({required String title, required IconData icon, required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10)],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.onSurface),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.surfaceContainerLow),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isBold = false, bool isPrimary = false, bool isWarning = false, bool isLink = false}) {
    Color valueColor = AppColors.onSurface;
    if (isPrimary) valueColor = AppColors.primary;
    if (isWarning) valueColor = AppColors.error;
    if (isLink) valueColor = const Color(0xFF0040E0);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: AppColors.outline),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isBold || isLink ? FontWeight.bold : FontWeight.w600,
              color: valueColor,
              decoration: isLink ? TextDecoration.underline : TextDecoration.none,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineTab(Shipment s) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: s.timeline.length,
      itemBuilder: (context, index) {
        final ev = s.timeline[s.timeline.length - 1 - index]; // Show latest first
        final bool isFirst = index == 0;
        final bool isLast = index == s.timeline.length - 1;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Time & Date
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(ev.time, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.onSurface)),
                const SizedBox(height: 2),
                Text(ev.date, style: const TextStyle(fontSize: 9, color: AppColors.outline)),
              ],
            ),
            const SizedBox(width: 16),
            
            // Timeline Line & Dot Indicator
            Column(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: isFirst ? const Color(0xFF0040E0) : Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF0040E0), width: 3),
                  ),
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: 60,
                    color: AppColors.outlineVariant,
                  ),
              ],
            ),
            const SizedBox(width: 16),

            // Event Details Card
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.01), blurRadius: 4)],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(ev.status, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF0040E0))),
                    const SizedBox(height: 2),
                    Text('بواسطة: ${ev.user}', style: const TextStyle(fontSize: 9, color: AppColors.outline)),
                    const SizedBox(height: 6),
                    Text(ev.notes, style: const TextStyle(fontSize: 10, color: AppColors.onSurfaceVariant)),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMediaAndDocsTab(BuildContext context, Shipment s) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // Commercial Documents Header (Screen 5)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('مستندات وأوراق الشحن الرسمية', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.onSurface)),
            IconButton(
              icon: const Icon(Icons.add_circle_outline, color: AppColors.primary, size: 20),
              onPressed: () => _showUploadDocDialog(context, s),
            ),
          ],
        ),
        const SizedBox(height: 8),

        if (s.documents.isEmpty)
          const Center(child: Text('لا توجد مستندات مرفوعة حالياً', style: TextStyle(fontSize: 11, color: AppColors.outline)))
        else
          ...s.documents.map((doc) => _buildDocTile(context, s, doc)),
        const SizedBox(height: 24),

        // Media Gallery before / after loading (Screen 4)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('صور وإثباتات الشحن والتحميل', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.onSurface)),
            IconButton(
              icon: const Icon(Icons.add_a_photo_outlined, color: AppColors.primary, size: 20),
              onPressed: () => _showUploadMediaDialog(context, s),
            ),
          ],
        ),
        const SizedBox(height: 8),
        
        _buildMediaCategorySection(context, s, 'قبل الشحن (المنتجات والتعبئة)', 'beforeShipment'),
        const SizedBox(height: 12),
        _buildMediaCategorySection(context, s, 'أثناء التحميل للناقل', 'loading'),
        const SizedBox(height: 12),
        _buildMediaCategorySection(context, s, 'بعد وصول الشحنة وتفريغها', 'afterShipment'),
      ],
    );
  }

  Widget _buildDocTile(BuildContext context, Shipment s, ShipmentDocument doc) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.surfaceContainerLow),
      ),
      child: Row(
        children: [
          const Icon(Icons.description_outlined, color: Colors.orange, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(doc.type, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.onSurface)),
                const SizedBox(height: 2),
                Text('${doc.name} • إصدار v${doc.version}', style: const TextStyle(fontSize: 9, color: AppColors.outline)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined, size: 18, color: AppColors.outline),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تمت مشاركة مستند ${doc.type} بنجاح.')));
            },
          ),
          IconButton(
            icon: const Icon(Icons.file_download_outlined, size: 18, color: AppColors.outline),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تم تنزيل المستند ${doc.name} على جهازك.')));
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, size: 18, color: AppColors.outline),
            onSelected: (val) {
              if (val == 'replace') {
                _showUploadDocDialog(context, s, initialType: doc.type);
              }
            },
            itemBuilder: (ctx) => [
              const PopupMenuItem(value: 'replace', child: Row(children: [Icon(Icons.sync_outlined, size: 16), SizedBox(width: 6), Text('استبدال المستند', style: TextStyle(fontSize: 11))])),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMediaCategorySection(BuildContext context, Shipment s, String title, String category) {
    final list = s.media[category] ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.outline)),
        const SizedBox(height: 6),
        if (list.isEmpty)
          Container(
            height: 60,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: AppColors.surfaceContainerLow, borderRadius: BorderRadius.circular(8)),
            child: Text('لم يتم رفع صور/فيديوهات لهذه المرحلة', style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
          )
        else
          SizedBox(
            height: 70,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: list.length,
              itemBuilder: (ctx, i) => Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 8),
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(image: NetworkImage(list[i]), fit: BoxFit.cover),
                    ),
                  ),
                  Positioned(
                    top: 2,
                    right: 10,
                    child: InkWell(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم مسح إثبات الصورة اللوجستية.')));
                      },
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        child: const Icon(Icons.close, size: 10, color: Colors.red),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  void _showUploadDocDialog(BuildContext context, Shipment s, {String? initialType}) {
    final typeController = TextEditingController(text: initialType ?? 'فاتورة تجارية');
    final nameController = TextEditingController(text: 'Invoice_New.pdf');

    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text('رفع مستند رسمي جديد', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: typeController,
                decoration: const InputDecoration(labelText: 'نوع المستند (مثل: بوليصة شحن، فاتورة جمركية)'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'اسم الملف المرفوع'),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
            ElevatedButton(
              onPressed: () {
                ref.read(shippingControllerProvider.notifier).uploadCommercialDoc(
                  s.id,
                  typeController.text,
                  nameController.text,
                  'https://naseeji.com/docs/new_doc.pdf',
                );
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم رفع المستند وتحديث الإصدار v2 بنجاح.')));
              },
              child: const Text('رفع المستند'),
            ),
          ],
        ),
      ),
    );
  }

  void _showUploadMediaDialog(BuildContext context, Shipment s) {
    String category = 'beforeShipment';
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: const Text('رفع إثبات صور الشحنة', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('اختر تصنيف صور التحميل والإثبات:', style: TextStyle(fontSize: 11)),
                const SizedBox(height: 8),
                DropdownButton<String>(
                  value: category,
                  isExpanded: true,
                  items: const [
                    DropdownMenuItem(value: 'beforeShipment', child: Text('قبل الشحن (التعبئة والتغليف)')),
                    DropdownMenuItem(value: 'loading', child: Text('أثناء التحميل (مندوب سمسا/أرامكس)')),
                    DropdownMenuItem(value: 'afterShipment', child: Text('بعد التسليم ومطابقة الجودة')),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      setDialogState(() {
                        category = val;
                      });
                    }
                  },
                ),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
              ElevatedButton(
                onPressed: () {
                  ref.read(shippingControllerProvider.notifier).uploadProofMedia(
                    s.id,
                    category,
                    'https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d?auto=format&fit=crop&w=300&q=80',
                  );
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم رفع صورة إثبات الشحن بنجاح.')));
                },
                child: const Text('رفع صورة'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget? _buildBottomActionBar(BuildContext context, Shipment s) {
    if (s.status == ShipmentStatus.ready) {
      return Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => context.push('/shipping/company-selector/${s.id}'),
                style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.outline), minimumSize: const Size(0, 48)),
                child: const Text('اختيار شركة الشحن', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: () => _showSchedulePickupDialog(context, s),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0040E0), foregroundColor: Colors.white, minimumSize: const Size(0, 48)),
                child: const Text('جدولة استلام السائق', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      );
    }

    if (s.status == ShipmentStatus.loaded) {
      return Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => ref.read(shippingControllerProvider.notifier).updateStatus(s.id, ShipmentStatus.pickedUp),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0040E0), foregroundColor: Colors.white, minimumSize: const Size(0, 48)),
                child: const Text('تأكيد استلام السائق الفعلي الشحنة', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      );
    }

    if (s.status == ShipmentStatus.pickedUp || s.status == ShipmentStatus.inTransit || s.status == ShipmentStatus.arrived) {
      return Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => context.push('/shipping/issue/${s.id}'),
                icon: const Icon(Icons.warning_amber_rounded, size: 18),
                label: const Text('إبلاغ عن تأخر/تلف', style: TextStyle(fontWeight: FontWeight.bold)),
                style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.red), foregroundColor: Colors.red, minimumSize: const Size(0, 48)),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => context.push('/shipping/tracking/${s.id}'),
                icon: const Icon(Icons.map_outlined, size: 18),
                label: const Text('تتبع حي GPS', style: TextStyle(fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0040E0), foregroundColor: Colors.white, minimumSize: const Size(0, 48)),
              ),
            ),
          ],
        ),
      );
    }

    if (s.status == ShipmentStatus.delivered) {
      return Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  _tabController.animateTo(0);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('راجع تقرير فحص المصنع المرفق بالأسفل.')));
                },
                style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.outline), minimumSize: const Size(0, 48)),
                child: const Text('معاينة الفحص والاستلام', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  if (s.issueReported != null) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('لا يمكن الإفراج المالي طالما هناك بلاغ/نزاع مفتوح.')));
                  } else {
                    ref.read(shippingControllerProvider.notifier).updateStatus(s.id, ShipmentStatus.paymentPending);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('جاري مراجعة تسوية الإفراج المالي.')));
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: s.issueReported != null ? Colors.grey : const Color(0xFF0040E0),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(0, 48),
                ),
                child: const Text('طلب تسوية الإفراج المالي', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      );
    }

    if (s.status == ShipmentStatus.paymentPending) {
      return Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => ref.read(shippingControllerProvider.notifier).updateStatus(s.id, ShipmentStatus.completed),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade700, foregroundColor: Colors.white, minimumSize: const Size(0, 48)),
                child: const Text('إفراج الحوالة المالية بنجاح (مكتمل)', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      );
    }

    return null; // For completed shipments, no action bar needed
  }

  void _showSchedulePickupDialog(BuildContext context, Shipment s) {
    final driverController = TextEditingController(text: 'محمد العتيبي');
    final phoneController = TextEditingController(text: '+٩٦٦ ٥٠ ١٢٣ ٤٥٦٧');
    final vehicleController = TextEditingController(text: 'أ ب ج ١٢٣٤');

    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text('جدولة استلام الشحنة وتعيين السائق', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: driverController, decoration: const InputDecoration(labelText: 'اسم السائق الناقل')),
              TextField(controller: phoneController, decoration: const InputDecoration(labelText: 'رقم جوال السائق')),
              TextField(controller: vehicleController, decoration: const InputDecoration(labelText: 'رقم لوحة الشاحنة/المركبة')),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
            ElevatedButton(
              onPressed: () {
                ref.read(shippingControllerProvider.notifier).scheduleCarrierPickup(
                  s.id,
                  driverName: driverController.text,
                  driverPhone: phoneController.text,
                  vehicleNum: vehicleController.text,
                );
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تمت جدولة السائق وتأكيد استلام سمسا/أرامكس للشحنة.')));
              },
              child: const Text('تأكيد الجدول والتعيين'),
            ),
          ],
        ),
      ),
    );
  }
}
