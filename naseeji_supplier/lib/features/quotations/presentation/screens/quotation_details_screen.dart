import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../controllers/quotations_controller.dart';
import '../../domain/entities/quotation_model.dart';
import '../widgets/quotation_status_card.dart';
import '../widgets/quotation_progress_widget.dart';
import '../widgets/quotation_price_card.dart';
import '../widgets/quotation_action_buttons.dart';
import '../widgets/quotation_attachment_card.dart';

class QuotationDetailsScreen extends ConsumerWidget {
  final String quotationId;

  const QuotationDetailsScreen({super.key, required this.quotationId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateAsync = ref.watch(quotationsControllerProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: stateAsync.when(
        loading: () => Scaffold(body: Center(child: CircularProgressIndicator(color: AppColors.primary))),
        error: (e, _) => Scaffold(body: Center(child: Text('خطأ في التحميل: $e'))),
        data: (quotations) {
          final index = quotations.indexWhere((q) => q.id == quotationId);
          if (index == -1) {
            return Scaffold(body: Center(child: Text('عرض السعر غير موجود')));
          }
          final q = quotations[index];

          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.surface,
              elevation: 0.5,
              centerTitle: true,
              title: Column(
                children: [
                  Text(
                    'تفاصيل عرض السعر ${q.id}',
                    style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'RFQ: ${q.rfqNumber} • النسخة: v${q.version}',
                    style: TextStyle(color: AppColors.outline, fontSize: 9),
                  ),
                ],
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Theme.of(context).colorScheme.onSurfaceVariant, size: 20),
                onPressed: () => context.pop(),
              ),
            ),
            body: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                // Status card
                QuotationStatusCard(quotation: q),
                SizedBox(height: 12),
                
                // Stepped progress widget
                QuotationProgressWidget(quotation: q),
                SizedBox(height: 16),

                // Navigation Shortcuts to associated sub-modules
                _buildNavigationRow(context, q),
                SizedBox(height: 16),

                // 2. Quotation Metadata
                _buildSectionCard(
                  title: 'معلومات عرض السعر الأساسية',
                  icon: Icons.info_outline,
                  children: [
                    _buildDetailRow('رقم عرض السعر الموحد', q.id),
                    _buildDetailRow('رقم طلب التسعير (RFQ)', q.rfqNumber),
                    if (q.orderNumber != null) _buildDetailRow('رقم الاتفاقية/العقد المرتبط', q.orderNumber!, isBold: true, isPrimary: true),
                    _buildDetailRow('الإصدار الحالي للعرض', 'v${q.version}', isBold: true),
                    _buildDetailRow('تاريخ الإنشاء', q.createdDate),
                    _buildDetailRow('تاريخ آخر تحديث ومراجعة', q.lastUpdated),
                    _buildDetailRow('تاريخ انتهاء صلاحية العرض', q.expirationDate, isWarning: q.status == QuotationStatus.expired),
                    _buildDetailRow('نوع التسعير والعرض', q.incoterms != null ? 'عقد توريد دولي (شروط ${q.incoterms})' : 'عقد توريد محلي'),
                  ],
                ),
                SizedBox(height: 16),

                // 3. Factory Details
                _buildSectionCard(
                  title: 'بيانات الطرف المشتري (المصنع)',
                  icon: Icons.store_outlined,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: Color(q.factoryInfo.logoBgColorValue),
                          child: Text(q.factoryInfo.logoText, style: TextStyle(color: Theme.of(context).colorScheme.surface, fontWeight: FontWeight.bold, fontSize: 11)),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(q.factoryInfo.factoryName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                  SizedBox(width: 4),
                                  const Icon(Icons.verified, color: Colors.blue, size: 14),
                                ],
                              ),
                              Text('الممثل المعتمد: ${q.factoryInfo.contactPerson} • تقييم المشتري: ${q.factoryInfo.rating} ★', style: TextStyle(fontSize: 9, color: AppColors.outline)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 16),
                    _buildDetailRow('هاتف المصنع المباشر', q.factoryInfo.phone),
                    _buildDetailRow('البريد الإلكتروني المعتمد', q.factoryInfo.email),
                    _buildDetailRow('عنوان التسليم المستهدف', q.factoryInfo.address),
                  ],
                ),
                SizedBox(height: 16),

                // 4. Product Details
                _buildSectionCard(
                  title: 'تفاصيل المنتجات والمواصفات المطلوبة',
                  icon: Icons.category_outlined,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(image: NetworkImage(q.productImageUrl), fit: BoxFit.cover),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(q.productName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                              SizedBox(height: 2),
                              Text('SKU: ${q.productSku} • التصنيف: ${q.productCategory}', style: TextStyle(fontSize: 9, color: AppColors.outline)),
                              SizedBox(height: 2),
                              Text('بلد المنشأ: ${q.countryOfOrigin}', style: TextStyle(fontSize: 9, color: AppColors.outline)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 16),
                    _buildDetailRow('مادة النسيج الفنية', q.productMaterial),
                    _buildDetailRow('المواصفات الفنية المعتمدة', q.productSpecifications),
                    _buildDetailRow('الحد الأدنى للطلب (MOQ)', '${q.moq.toInt()} ${q.unit}'),
                    _buildDetailRow('تفاصيل التعبئة والتغليف واللف', q.packagingDetails),
                    _buildDetailRow('الكمية المعروضة الكلية', '${q.quantity.toInt()} ${q.unit}', isBold: true),
                  ],
                ),
                SizedBox(height: 16),

                // 5. Pricing Breakdown
                QuotationPriceCard(quotation: q),
                SizedBox(height: 16),

                // 6. Payment Terms
                _buildSectionCard(
                  title: 'شروط وبنود الدفع المالي',
                  icon: Icons.payment_outlined,
                  children: [
                    _buildDetailRow('طريقة الدفع الفعلي المتبعة', q.paymentMethod),
                    _buildDetailRow('الدفعة المقدمة (عربون إنتاج)', '${q.advancePayment.toStringAsFixed(2)} ${q.currency}', isPrimary: true),
                    _buildDetailRow('الرصيد المتبقي المستحق', '${q.remainingBalance.toStringAsFixed(2)} ${q.currency}'),
                    _buildDetailRow('جدولة وفترة الائتمان', q.creditPeriod),
                    _buildDetailRow('شروط الفسح والإفراج المالي', q.releaseConditions),
                    _buildDetailRow('مدة التسوية والتسليم المالي', q.settlementTime),
                  ],
                ),
                SizedBox(height: 16),

                // 7. Delivery Terms
                _buildSectionCard(
                  title: 'شروط التوريد واللوجستيات',
                  icon: Icons.local_shipping_outlined,
                  children: [
                    _buildDetailRow('مدة تجهيز وتحضير البضائع', q.preparationTime),
                    _buildDetailRow('تاريخ التسليم النهائي المتوقع', q.estimatedDelivery, isBold: true),
                    _buildDetailRow('عنوان مستودع المصنع للمستلم', q.deliveryLocation),
                    _buildDetailRow('شركة الشحن اللوجستي المعتمدة', q.shippingCompany),
                    _buildDetailRow('طريقة ونوع الشحن اللوجستي', q.shippingMethod),
                    if (q.incoterms != null) _buildDetailRow('مصطلحات الشحن الدولية (Incoterms)', q.incoterms!),
                  ],
                ),
                SizedBox(height: 16),

                // 8. Attachments
                _buildSectionCard(
                  title: 'المستندات والوثائق المرفقة بالعرض',
                  icon: Icons.attach_file,
                  children: [
                    QuotationAttachmentCard(
                      title: 'وثيقة عرض السعر المالي المعتمد',
                      filename: 'Quotation_${q.id}.pdf',
                      icon: Icons.picture_as_pdf,
                      onPreview: () => _showAttachmentPreview(context, 'Quotation_${q.id}.pdf'),
                      onDownload: () => _downloadAttachment(context, 'Quotation_${q.id}.pdf'),
                      onShare: () => _shareAttachment(context, 'Quotation_${q.id}.pdf'),
                    ),
                    QuotationAttachmentCard(
                      title: 'صور مواصفات المنتج الفنية عينة',
                      filename: 'product_image_${q.productSku}.jpg',
                      icon: Icons.image,
                      onPreview: () => _showAttachmentPreview(context, 'product_image_${q.productSku}.jpg'),
                      onDownload: () => _downloadAttachment(context, 'product_image_${q.productSku}.jpg'),
                      onShare: () => _shareAttachment(context, 'product_image_${q.productSku}.jpg'),
                    ),
                    QuotationAttachmentCard(
                      title: 'فيديو معاينة الجودة والشد (5 ثوانٍ)',
                      filename: 'fabric_strength_test.mp4',
                      icon: Icons.video_library,
                      onPreview: () => _showAttachmentPreview(context, 'fabric_strength_test.mp4'),
                      onDownload: () => _downloadAttachment(context, 'fabric_strength_test.mp4'),
                      onShare: () => _shareAttachment(context, 'fabric_strength_test.mp4'),
                    ),
                    QuotationAttachmentCard(
                      title: 'كتالوج الخامات والمنتجات الكامل لعام 2026',
                      filename: 'Naseeji_Product_Catalog_2026.pdf',
                      icon: Icons.menu_book,
                      onPreview: () => _showAttachmentPreview(context, 'Naseeji_Product_Catalog_2026.pdf'),
                      onDownload: () => _downloadAttachment(context, 'Naseeji_Product_Catalog_2026.pdf'),
                      onShare: () => _shareAttachment(context, 'Naseeji_Product_Catalog_2026.pdf'),
                    ),
                    QuotationAttachmentCard(
                      title: 'شهادة الجودة والمطابقة الدولية ISO',
                      filename: 'ISO_9001_Quality_Certificate.pdf',
                      icon: Icons.verified_outlined,
                      onPreview: () => _showAttachmentPreview(context, 'ISO_9001_Quality_Certificate.pdf'),
                      onDownload: () => _downloadAttachment(context, 'ISO_9001_Quality_Certificate.pdf'),
                      onShare: () => _shareAttachment(context, 'ISO_9001_Quality_Certificate.pdf'),
                    ),
                  ],
                ),
                SizedBox(height: 30),
              ],
            ),
            bottomNavigationBar: QuotationActionButtons(
              quotation: q,
              onEdit: () => context.push('/orders/create-quotation?rfqId=${q.rfqNumber}'),
              onDelete: () {
                ref.read(quotationsControllerProvider.notifier).delete(q.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('تم حذف مسودة عرض السعر ${q.id} بنجاح.')),
                );
                context.pop();
              },
              onPreviewPdf: () => _showAttachmentPreview(context, 'Quotation_${q.id}.pdf'),
              onSend: () {
                ref.read(quotationsControllerProvider.notifier).send(q.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('تم إرسال عرض السعر ${q.id} للمشتري بنجاح.')),
                );
              },
              onWithdraw: () {
                ref.read(quotationsControllerProvider.notifier).withdraw(q.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('تم سحب عرض السعر ${q.id} وإعادته إلى المسودات.')),
                );
              },
              onDuplicate: () {
                ref.read(quotationsControllerProvider.notifier).duplicate(q.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('تم تكرار العرض وإنشاء مسودة جديدة.')),
                );
              },
              onOpenChat: () => context.push('/orders/chat?rfqId=${q.rfqNumber}'),
              onSendCounterOffer: () => _showCounterOfferDialog(context, ref, q),
              onViewHistory: () => context.push('/quotations/history/${q.id}'),
              onUpdateQuotation: () => context.push('/orders/create-quotation?rfqId=${q.rfqNumber}'),
              onViewAgreement: q.orderNumber != null 
                  ? () => context.push('/agreements/details/${q.orderNumber}')
                  : null,
              onViewOrder: () => context.push('/orders/order-center?rfqId=${q.rfqNumber}'),
              onTrackProduction: () => context.push('/orders/production-preparation?rfqId=${q.rfqNumber}'),
              onCreateNewVersion: () => context.push('/orders/create-quotation?rfqId=${q.rfqNumber}'),
              onViewRejectionReason: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('سبب الرفض المعتمد', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    content: Text(q.rejectionReason ?? 'لم يتم تحديد سبب الرفض.', style: TextStyle(fontSize: 12)),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context), child: Text('إغلاق')),
                    ],
                  ),
                );
              },
              onRenew: () {
                ref.read(quotationsControllerProvider.notifier).renew(q.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('تم تجديد عرض السعر ${q.id} وتمديد تاريخ الصلاحية.')),
                );
              },
              onArchive: () {
                ref.read(quotationsControllerProvider.notifier).delete(q.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('تم أرشفة وحذف عرض السعر من القائمة.')),
                );
                context.pop();
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildNavigationRow(BuildContext context, QuotationModel q) {
    return Row(
      children: [
        _buildNavButton(
          context, 
          label: 'مقارنة وتحليل الأسعار', 
          icon: Icons.compare_arrows_outlined, 
          path: '/quotations/comparison/${q.id}',
        ),
        SizedBox(width: 8),
        _buildNavButton(
          context, 
          label: 'إصدارات ومراجعات العرض', 
          icon: Icons.history_edu_outlined, 
          path: '/quotations/versions/${q.id}',
        ),
        SizedBox(width: 8),
        _buildNavButton(
          context, 
          label: 'سجل الأحداث والخط الزمني', 
          icon: Icons.timeline_outlined, 
          path: '/quotations/history/${q.id}',
        ),
      ],
    );
  }

  Widget _buildNavButton(BuildContext context, {required String label, required IconData icon, required String path}) {
    return Expanded(
      child: Container(
        height: 54,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.01), blurRadius: 4)],
        ),
        child: InkWell(
          onTap: () => context.push(path),
          borderRadius: BorderRadius.circular(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: AppColors.primary, size: 18),
              SizedBox(height: 4),
              Text(label, textAlign: TextAlign.center, style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({required String title, required IconData icon, required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.all(Radius.circular(16)),
        boxShadow: [BoxShadow(color: Color(0x05000000), blurRadius: 10)],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 18),
              SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Theme.of(context).colorScheme.onSurface),
              ),
            ],
          ),
          SizedBox(height: 10),
          const Divider(height: 1, color: Theme.of(context).colorScheme.surfaceContainerLow),
          SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isBold = false, bool isPrimary = false, bool isWarning = false}) {
    Color valueColor = Theme.of(context).colorScheme.onSurface;
    if (isPrimary) valueColor = AppColors.primary;
    if (isWarning) valueColor = AppColors.error;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(fontSize: 10, color: AppColors.outline),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
                color: valueColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAttachmentPreview(BuildContext context, String filename) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(filename, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        content: Container(
          width: 300,
          height: 250,
          color: Colors.grey.shade100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.description, size: 48, color: AppColors.primary),
              SizedBox(height: 16),
              Text('معاينة مستندات نسيجي اللوجستية المعتمدة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              SizedBox(height: 8),
              Text('اسم الملف: $filename', style: TextStyle(fontSize: 10, color: AppColors.outline)),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('إغلاق')),
        ],
      ),
    );
  }

  void _downloadAttachment(BuildContext context, String filename) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('بدء تنزيل الملف $filename بنجاح...')),
    );
  }

  void _shareAttachment(BuildContext context, String filename) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تم نسخ رابط مشاركة الملف $filename بنجاح.')),
    );
  }

  void _showCounterOfferDialog(BuildContext context, WidgetRef ref, QuotationModel q) {
    final priceController = TextEditingController(text: q.supplierUnitPrice.toString());
    final notesController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تقديم عرض مقابل جديد للمصنع', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: priceController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'سعر الوحدة الجديد المقترح (ر.س)',
                labelStyle: TextStyle(fontSize: 11),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: notesController,
              decoration: const InputDecoration(
                labelText: 'ملاحظات وتبرير السعر',
                labelStyle: TextStyle(fontSize: 11),
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('إلغاء')),
          ElevatedButton(
            onPressed: () {
              final price = double.tryParse(priceController.text);
              if (price != null) {
                ref.read(quotationsControllerProvider.notifier).sendCounterOffer(q.id, price, notesController.text);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('تم إرسال العرض المقابل v${(double.parse(q.version) + 1.0).toStringAsFixed(1)} بنجاح.')),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: Text('إرسال السعر', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
