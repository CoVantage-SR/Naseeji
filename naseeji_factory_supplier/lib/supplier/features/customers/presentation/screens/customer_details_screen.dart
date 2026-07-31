import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_factory/supplier/core/theme/app_colors.dart';
import '../controllers/customers_controller.dart';
import '../../domain/entities/customer_model.dart';
import '../widgets/customer_statistics_card.dart';
import '../widgets/customer_tags_widget.dart';
import '../widgets/customer_rating_widget.dart';
import '../widgets/customer_timeline_widget.dart';
import '../widgets/customer_action_buttons.dart';

class CustomerDetailsScreen extends ConsumerStatefulWidget {
  final String customerId;

  const CustomerDetailsScreen({super.key, required this.customerId});

  @override
  ConsumerState<CustomerDetailsScreen> createState() => _CustomerDetailsScreenState();
}

class _CustomerDetailsScreenState extends ConsumerState<CustomerDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<(String, IconData)> _tabs = const [
    ('معلومات الشركة', Icons.info_outline),
    ('الإحصائيات', Icons.bar_chart),
    ('الطلبات', Icons.shopping_bag_outlined),
    ('عروض الأسعار', Icons.description_outlined),
    ('الاتفاقيات', Icons.handshake_outlined),
    ('المدفوعات', Icons.payments_outlined),
    ('الشحنات', Icons.local_shipping_outlined),
    ('المستندات', Icons.folder_outlined),
    ('الجدول الزمني', Icons.timeline),
    ('الملاحظات', Icons.note_alt_outlined),
    ('التقييم الخاص', Icons.star_half_outlined),
  ];

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
    final stateAsync = ref.watch(customersControllerProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          elevation: 0.5,
          centerTitle: true,
          title: Text('تفاصيل العميل', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 16)),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new, size: 20, color: AppColors.onSurfaceVariant),
            onPressed: () => context.pop(),
          ),
          bottom: TabBar(
            controller: _tabController,
            labelColor: AppColors.primary,
            unselectedLabelColor: Theme.of(context).colorScheme.onSurfaceVariant,
            indicatorColor: AppColors.primary,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: _tabs.map((t) => Tab(icon: Icon(t.$2, size: 16), text: t.$1)).toList(),
          ),
        ),
        body: stateAsync.when(
          loading: () => Center(child: CircularProgressIndicator(color: AppColors.primary)),
          error: (e, _) => Center(child: Text('خطأ: $e')),
          data: (customers) {
            final idx = customers.indexWhere((c) => c.id == widget.customerId);
            if (idx == -1) return Center(child: Text('العميل غير موجود'));
            final customer = customers[idx];

            return Column(
              children: [
                _buildHeader(customer),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildInfoTab(customer),
                      _buildStatsTab(customer),
                      _buildOrdersTab(customer),
                      _buildQuotationsTab(customer),
                      _buildAgreementsTab(customer),
                      _buildPaymentsTab(customer),
                      _buildShipmentsTab(customer),
                      _buildDocumentsTab(customer),
                      _buildTimelineTab(customer),
                      _buildNotesTab(customer),
                      _buildRatingTab(customer),
                    ],
                  ),
                ),
                CustomerActionButtons(
                  customer: customer,
                  onChat: () => context.push('/messages'),
                  onOrders: () => context.push('/customers/orders/${customer.id}'),
                  onAgreements: () => context.push('/agreements'),
                  onPayments: () {},
                  onNewQuotation: () => context.push('/quotations'),
                  onAddNote: () => context.push('/customers/notes/${customer.id}'),
                  onBlock: () => _confirmBlock(context, customer),
                  onUnblock: () => ref.read(customersControllerProvider.notifier).unblockCustomer(customer.id),
                  onArchive: () => ref.read(customersControllerProvider.notifier).archiveCustomer(customer.id),
                  onDownloadStatement: () {},
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(CustomerModel customer) {
    final statusData = _statusDisplay(customer.status);
    return Container(
      color: Theme.of(context).colorScheme.surface,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 60, height: 60,
            decoration: BoxDecoration(color: Color(customer.logoBgColorValue), borderRadius: BorderRadius.circular(16)),
            child: Center(child: Text(customer.logoText, style: TextStyle(color: Theme.of(context).colorScheme.surface, fontWeight: FontWeight.bold, fontSize: 20))),
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Flexible(child: Text(customer.factoryName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Theme.of(context).colorScheme.onSurface))),
                  if (customer.isVerified) SizedBox(width: 4),
                  if (customer.isVerified) const Icon(Icons.verified, size: 16, color: AppColors.primary),
                ]),
                SizedBox(height: 3),
                Text('${customer.city}، ${customer.country}', style: TextStyle(fontSize: 11, color: AppColors.outline)),
                SizedBox(height: 3),
                Text(customer.businessCategory, style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(color: statusData.$2.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
            child: Text(statusData.$1, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: statusData.$2)),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTab(CustomerModel c) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _section('معلومات التواصل', [
          _row('مسؤول التواصل', c.contactPerson),
          _row('رقم الهاتف', c.phone),
          _row('البريد الإلكتروني', c.email),
          if (c.website.isNotEmpty) _row('الموقع الإلكتروني', c.website),
        ]),
        SizedBox(height: 12),
        _section('معلومات الموقع', [
          _row('الدولة', c.country),
          _row('المدينة', c.city),
          if (c.address.isNotEmpty) _row('العنوان', c.address),
        ]),
        SizedBox(height: 12),
        _section('معلومات النشاط', [
          _row('تخصص الأعمال', c.businessCategory),
          _row('القطاع الصناعي', c.industry),
          _row('عضو منذ', c.relationshipSince),
        ]),
        if (c.companyDescription.isNotEmpty) ...[
          SizedBox(height: 12),
          _section('نبذة عن الشركة', [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(c.companyDescription, style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant, height: 1.6)),
            ),
          ]),
        ],
        SizedBox(height: 12),
        _section('العلامات التعريفية', [
          CustomerTagsWidget(tags: c.tags, allowEdit: true,
            onAddTag: () => _showAddTagDialog(context, c),
            onRemoveTag: (id) => ref.read(customersControllerProvider.notifier).removeTag(c.id, id),
          ),
        ]),
      ],
    );
  }

  Widget _buildStatsTab(CustomerModel c) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Business Stats Grid
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 0.85,
            children: [
              CustomerStatisticsCard(label: 'إجمالي الطلبات', value: c.totalOrders.toString(), icon: Icons.shopping_bag_outlined),
              CustomerStatisticsCard(label: 'مكتملة', value: c.completedOrders.toString(), icon: Icons.check_circle_outline, color: Colors.green),
              CustomerStatisticsCard(label: 'ملغاة', value: c.cancelledOrders.toString(), icon: Icons.cancel_outlined, color: AppColors.error),
              CustomerStatisticsCard(label: 'إجمالي العروض', value: c.totalQuotations.toString(), icon: Icons.description_outlined, color: AppColors.secondary),
              CustomerStatisticsCard(label: 'مقبولة', value: c.acceptedQuotations.toString(), icon: Icons.thumb_up_outlined, color: Colors.green),
              CustomerStatisticsCard(label: 'مرفوضة', value: c.rejectedQuotations.toString(), icon: Icons.thumb_down_outlined, color: AppColors.error),
              CustomerStatisticsCard(label: 'الإيرادات الكلية', value: '${(c.totalRevenue / 1000).toStringAsFixed(0)}ك جنيه', icon: Icons.payments_outlined, color: AppColors.primary),
              CustomerStatisticsCard(label: 'متوسط الطلب', value: '${(c.averageOrderValue / 1000).toStringAsFixed(1)}ك', icon: Icons.analytics_outlined, color: AppColors.tertiary),
              CustomerStatisticsCard(label: 'نجاح التفاوض', value: '${c.negotiationSuccessRate.toStringAsFixed(0)}٪', icon: Icons.gavel, color: AppColors.secondary),
            ],
          ),
          SizedBox(height: 16),
          // Current Status
          _section('الوضع الراهن', [
            _row('طلبات نشطة', c.activeOrdersCount.toString()),
            _row('عروض أسعار معلقة', c.pendingQuotationsCount.toString()),
            _row('اتفاقيات معلقة', c.pendingAgreementsCount.toString()),
            _row('شحنات جارية', c.currentShipmentCount.toString()),
            _row('مدفوعات معلقة', c.pendingPaymentsCount.toString()),
            _row('تذاكر دعم', c.supportTicketsCount.toString()),
            _row('آخر شراء', c.lastPurchaseDate.isEmpty ? '—' : c.lastPurchaseDate),
            _row('علاقة منذ', c.relationshipSince.isEmpty ? '—' : c.relationshipSince),
          ]),
        ],
      ),
    );
  }

  Widget _buildOrdersTab(CustomerModel c) {
    if (c.orders.isEmpty) return _emptyState('لا توجد طلبات', Icons.shopping_bag_outlined);
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: c.orders.length,
      itemBuilder: (_, i) {
        final o = c.orders[i];
        return _buildOrderCard(o);
      },
    );
  }

  Widget _buildOrderCard(CustomerOrder o) {
    Color statusColor = AppColors.primary;
    if (o.status == 'مكتمل') statusColor = Colors.green;
    if (o.status == 'ملغي') statusColor = AppColors.error;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E1EF), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(o.orderNumber, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary)),
            _badge(o.status, statusColor),
          ]),
          SizedBox(height: 8),
          _row('المنتج', o.productName),
          _row('الكمية', '${o.quantity.toStringAsFixed(0)} وحدة'),
          _row('الإجمالي', '${o.totalPrice.toStringAsFixed(0)} ${o.currency}'),
          _row('موعد التسليم', o.deliveryDate),
          _row('حالة الدفع', o.paymentStatus),
          _row('حالة الشحن', o.shipmentStatus),
        ],
      ),
    );
  }

  Widget _buildQuotationsTab(CustomerModel c) {
    if (c.quotations.isEmpty) return _emptyState('لا توجد عروض أسعار', Icons.description_outlined);
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: c.quotations.length,
      itemBuilder: (_, i) {
        final q = c.quotations[i];
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFE2E1EF), width: 0.5)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(q.quotationNumber, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary)),
              _badge(q.status, _quotationStatusColor(q.status)),
            ]),
            SizedBox(height: 8),
            _row('المنتج', q.productName),
            _row('الكمية', '${q.quantity.toStringAsFixed(0)} وحدة'),
            _row('السعر', '${q.unitPrice} ${q.currency}/وحدة'),
            _row('التاريخ', q.date),
          ]),
        );
      },
    );
  }

  Widget _buildAgreementsTab(CustomerModel c) {
    if (c.agreements.isEmpty) return _emptyState('لا توجد اتفاقيات', Icons.handshake_outlined);
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: c.agreements.length,
      itemBuilder: (_, i) {
        final a = c.agreements[i];
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFE2E1EF), width: 0.5)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(a.agreementNumber, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary)),
              _badge(a.status, Colors.green),
            ]),
            SizedBox(height: 8),
            _row('تاريخ الاتفاقية', a.agreementDate),
            _row('الإجمالي', '${a.grandTotal.toStringAsFixed(0)} ${a.currency}'),
            _row('طريقة الدفع', a.paymentMethod),
            _row('موعد التسليم', a.deliveryDate),
            SizedBox(height: 8),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              OutlinedButton(onPressed: () => context.push('/agreements'), style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.primary, width: 0.5), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6)), child: Text('عرض الاتفاقية', style: TextStyle(fontSize: 9, color: AppColors.primary))),
            ]),
          ]),
        );
      },
    );
  }

  Widget _buildPaymentsTab(CustomerModel c) {
    if (c.payments.isEmpty) return _emptyState('لا توجد مدفوعات', Icons.payments_outlined);
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: c.payments.length,
      itemBuilder: (_, i) {
        final p = c.payments[i];
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: p.isLate ? AppColors.error.withValues(alpha: 0.3) : const Color(0xFFE2E1EF), width: 0.5)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(p.invoiceNumber, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary)),
              _badge(p.paymentStatus, p.paymentStatus == 'مدفوع' ? Colors.green : const Color(0xFFFFB800)),
            ]),
            SizedBox(height: 8),
            _row('المبلغ', '${p.amount.toStringAsFixed(0)} ${p.currency}'),
            _row('طريقة الدفع', p.paymentMethod),
            _row('تاريخ الدفع', p.paymentDate),
            _row('الرصيد المتبقي', '${p.outstandingBalance.toStringAsFixed(0)} ${p.currency}'),
            if (p.isLate)
              Container(margin: const EdgeInsets.only(top: 6), padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: AppColors.error.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)), child: Text('⚠ دفع متأخر', style: TextStyle(fontSize: 10, color: AppColors.error, fontWeight: FontWeight.bold))),
          ]),
        );
      },
    );
  }

  Widget _buildShipmentsTab(CustomerModel c) {
    if (c.shipments.isEmpty) return _emptyState('لا توجد شحنات', Icons.local_shipping_outlined);
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: c.shipments.length,
      itemBuilder: (_, i) {
        final s = c.shipments[i];
        final delivered = s.deliveredDate != null;
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFE2E1EF), width: 0.5)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(s.shipmentNumber, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary)),
              _badge(s.status, delivered ? Colors.green : Colors.orange),
            ]),
            SizedBox(height: 8),
            _row('شركة الشحن', s.shippingCompany),
            _row('رقم التتبع', s.trackingNumber),
            _row('التسليم المتوقع', s.estimatedDelivery),
            if (delivered) _row('تاريخ التسليم الفعلي', s.deliveredDate!),
            SizedBox(height: 8),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              OutlinedButton.icon(onPressed: () => context.push('/shipping'), icon: const Icon(Icons.location_on_outlined, size: 13), label: Text('تتبع الشحنة', style: TextStyle(fontSize: 9)), style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.primary, width: 0.5), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6))),
            ]),
          ]),
        );
      },
    );
  }

  Widget _buildDocumentsTab(CustomerModel c) {
    if (c.documents.isEmpty) return _emptyState('لا توجد مستندات', Icons.folder_outlined);
    final Map<String, List<CustomerDocument>> grouped = {};
    for (final d in c.documents) {
      grouped.putIfAbsent(d.type, () => []).add(d);
    }
    return ListView(
      padding: const EdgeInsets.all(16),
      children: grouped.entries.map((entry) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(_docTypeLabel(entry.key), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primary)),
            ),
            ...entry.value.map((d) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE2E1EF), width: 0.5)),
              child: Row(children: [
                const Icon(Icons.insert_drive_file_outlined, size: 24, color: AppColors.primary),
                SizedBox(width: 10),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(d.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  Text(d.uploadedAt, style: TextStyle(fontSize: 10, color: AppColors.outline)),
                ])),
                IconButton(icon: const Icon(Icons.download_outlined, size: 18, color: AppColors.primary), onPressed: () {}),
              ]),
            )),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildTimelineTab(CustomerModel c) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [CustomerTimelineWidget(events: c.timeline)],
    );
  }

  Widget _buildNotesTab(CustomerModel c) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('الملاحظات الخاصة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ElevatedButton.icon(
                onPressed: () => context.push('/customers/notes/${c.id}'),
                icon: const Icon(Icons.add, size: 14, color: Colors.white),
                label: Text('إضافة', style: TextStyle(fontSize: 10, color: Colors.white)),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
              ),
            ],
          ),
        ),
        if (c.notes.isEmpty)
          Expanded(child: _emptyState('لا توجد ملاحظات خاصة بعد', Icons.note_alt_outlined))
        else
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              itemCount: c.notes.length,
              itemBuilder: (_, i) {
                final note = c.notes[i];
                return _buildSimpleNoteCard(note, c.id);
              },
            ),
          ),
      ],
    );
  }

  Widget _buildSimpleNoteCard(CustomerNote note, String customerId) {
    final controller = ref.read(customersControllerProvider.notifier);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: note.isPinned ? AppColors.primary.withValues(alpha: 0.4) : const Color(0xFFE2E1EF), width: note.isPinned ? 1 : 0.5),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          if (note.isPinned) const Icon(Icons.push_pin, size: 13, color: AppColors.primary),
          if (note.isPinned) SizedBox(width: 4),
          Expanded(child: Text(note.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
          IconButton(icon: const Icon(Icons.push_pin_outlined, size: 16), onPressed: () => controller.pinNote(customerId, note.id, !note.isPinned), color: AppColors.outline),
          IconButton(icon: const Icon(Icons.delete_outline, size: 16), onPressed: () => controller.deleteNote(customerId, note.id), color: AppColors.error),
        ]),
        Text(note.description, style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant, height: 1.4)),
        SizedBox(height: 4),
        Text(note.createdDate, style: TextStyle(fontSize: 9, color: AppColors.outline)),
      ]),
    );
  }

  Widget _buildRatingTab(CustomerModel c) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8E1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFFD54F), width: 0.5),
            ),
            // ignore: prefer_const_literals_to_create_immutables
            child: Row(children: [
              Icon(Icons.lock_outline, size: 14, color: Color(0xFF996C00)),
              SizedBox(width: 6),
              Expanded(child: Text('هذا التقييم خاص بك ولن يُشارك مع العميل أبداً', style: TextStyle(fontSize: 10, color: Color(0xFF996C00)))),
            ]),
          ),
          SizedBox(height: 16),
          CustomerRatingWidget(
            rating: c.privateRating,
            readOnly: false,
            onChanged: (r) => ref.read(customersControllerProvider.notifier).updateRating(c.id, r),
          ),
        ],
      ),
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  Widget _section(String title, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFE2E1EF), width: 0.5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
            child: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary)),
          ),
          Divider(height: 1, color: AppColors.surfaceContainerLow),
          Padding(padding: const EdgeInsets.all(14), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children)),
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: TextStyle(fontSize: 11, color: AppColors.outline)),
        Flexible(child: Text(value, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface), textAlign: TextAlign.end)),
      ]),
    );
  }

  Widget _badge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
      child: Text(label, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: color)),
    );
  }

  Widget _emptyState(String msg, IconData icon) {
    return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 48, color: AppColors.outlineVariant),
      SizedBox(height: 10),
      Text(msg, style: TextStyle(color: AppColors.outline, fontSize: 13)),
    ]));
  }

  Color _quotationStatusColor(String status) {
    if (status.contains('مقبول')) return Colors.green;
    if (status.contains('مرفوض')) return AppColors.error;
    if (status.contains('تفاوض')) return Colors.orange;
    return AppColors.primary;
  }

  (String, Color) _statusDisplay(CustomerStatus s) {
    switch (s) {
      case CustomerStatus.vip: return ('VIP', const Color(0xFFFFB800));
      case CustomerStatus.active: return ('نشط', Colors.green);
      case CustomerStatus.newCustomer: return ('جديد', AppColors.primary);
      case CustomerStatus.inactive: return ('غير نشط', AppColors.outline);
      case CustomerStatus.blocked: return ('محظور', AppColors.error);
    }
  }

  String _docTypeLabel(String type) {
    switch (type) {
      case 'contract': return 'العقود';
      case 'invoice': return 'الفواتير';
      case 'quotation': return 'عروض الأسعار';
      case 'certificate': return 'الشهادات';
      case 'shipping': return 'مستندات الشحن';
      case 'tax': return 'المستندات الضريبية';
      default: return 'مستندات أخرى';
    }
  }

  void _confirmBlock(BuildContext context, CustomerModel c) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('تأكيد الحظر', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text('هل تريد حظر العميل "${c.factoryName}"؟ لن يتمكن من التعامل معك حتى تقوم برفع الحظر.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('إلغاء')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(customersControllerProvider.notifier).blockCustomer(c.id, 'تم الحظر يدوياً');
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: Text('حظر', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showAddTagDialog(BuildContext context, CustomerModel c) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('إضافة علامة جديدة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'اسم العلامة', border: OutlineInputBorder()),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('إلغاء')),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                final tag = CustomerTag(id: 'tag_${DateTime.now().millisecondsSinceEpoch}', label: controller.text, colorValue: AppColors.primary.toARGB32());
                ref.read(customersControllerProvider.notifier).addTag(c.id, tag);
                Navigator.pop(context);
              }
            },
            child: Text('إضافة'),
          ),
        ],
      ),
    );
  }
}
