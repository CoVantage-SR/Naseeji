// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../../domain/services/quotation_pricing_calculator.dart';
import '../../domain/services/quotation_validator.dart';
import 'package:naseeji_supplier/features/messages/presentation/controllers/business_chat_controller.dart';

class CreateQuotationScreen extends ConsumerStatefulWidget {
  final String rfqId;
  final String? conversationId;

  const CreateQuotationScreen({super.key, required this.rfqId, this.conversationId});

  @override
  ConsumerState<CreateQuotationScreen> createState() => _CreateQuotationScreenState();
}

class _CreateQuotationScreenState extends ConsumerState<CreateQuotationScreen> {
  // Section 3: Pricing Controllers
  final _unitPriceController = TextEditingController(text: '12.50');
  final _quotedQtyController = TextEditingController(text: '5000');
  final _moqController = TextEditingController(text: '100');
  final _discountController = TextEditingController(text: '500.00');
  final _shippingCostController = TextEditingController(text: '250.00');
  final _taxRateController = TextEditingController(text: '15.00');
  final _additionalChargesController = TextEditingController(text: '0.00');

  // Section 4: Payment Terms
  String selectedPaymentMethod = 'Bank Transfer';
  final _advancePercentController = TextEditingController(text: '30');
  final _remainingPercentController = TextEditingController(text: '70');
  final _paymentDueDateController = TextEditingController(text: '30 أيام من الاستلام');
  final _paymentNotesController = TextEditingController(text: 'تطبق شروط خطابات الاعتماد المستندية البنكية.');

  // Section 5: Production & Delivery
  final _productionTimeController = TextEditingController(text: '7 أيام عمل');
  final _deliveryTimeController = TextEditingController(text: '3 أيام');
  final _shippingMethodController = TextEditingController(text: 'شحن بري سريع Aramex');
  final _expectedShippingController = TextEditingController(text: '2026-07-15');
  final _estimatedArrivalController = TextEditingController(text: '2026-07-18');
  bool rushOrderSupport = true;
  String priorityLevel = 'عالي';

  // Section 6: Expiry
  int selectedValidityDays = 7;
  DateTime customValidityDate = DateTime.now().add(const Duration(days: 7));

  // Section 7: Attachments Mock
  final List<String> mockAttachments = [
    'كتالوج_أقمشة_القطن_2026.pdf',
    'شهادة_اختبار_ثبات_الألوان_ISO.pdf',
  ];

  // Section 8 & 9: Notes
  final _notesController = TextEditingController(text: 'نلتزم بشحن ولف الأقمشة بأغلفة بلاستيكية متينة مقاومة للرطوبة وفقاً للمواصفات.');
  final _internalNotesController = TextEditingController(text: 'الربحية المستهدفة في هذا العرض هي 25%.');

  // Live Pricing Calculations
  double subtotal = 0.0;
  double taxAmount = 0.0;
  double grandTotal = 0.0;

  @override
  void initState() {
    super.initState();
    _recalculatePricing();

    // Listeners to update calculations dynamically
    _unitPriceController.addListener(_recalculatePricing);
    _quotedQtyController.addListener(_recalculatePricing);
    _discountController.addListener(_recalculatePricing);
    _shippingCostController.addListener(_recalculatePricing);
    _taxRateController.addListener(_recalculatePricing);
    _additionalChargesController.addListener(_recalculatePricing);
  }

  @override
  void dispose() {
    _unitPriceController.dispose();
    _quotedQtyController.dispose();
    _moqController.dispose();
    _discountController.dispose();
    _shippingCostController.dispose();
    _taxRateController.dispose();
    _additionalChargesController.dispose();
    _advancePercentController.dispose();
    _remainingPercentController.dispose();
    _paymentDueDateController.dispose();
    _paymentNotesController.dispose();
    _productionTimeController.dispose();
    _deliveryTimeController.dispose();
    _shippingMethodController.dispose();
    _expectedShippingController.dispose();
    _estimatedArrivalController.dispose();
    _notesController.dispose();
    _internalNotesController.dispose();
    super.dispose();
  }

  void _recalculatePricing() {
    final double up = double.tryParse(_unitPriceController.text) ?? 0.0;
    final double qty = double.tryParse(_quotedQtyController.text) ?? 0.0;
    final double disc = double.tryParse(_discountController.text) ?? 0.0;
    final double ship = double.tryParse(_shippingCostController.text) ?? 0.0;
    final double taxRate = double.tryParse(_taxRateController.text) ?? 0.0;
    final double addCharges = double.tryParse(_additionalChargesController.text) ?? 0.0;

    setState(() {
      subtotal = QuotationPricingCalculator.calculateSubtotal(up, qty);
      taxAmount = QuotationPricingCalculator.calculateTaxAmount(
        subtotal: subtotal,
        discount: disc,
        taxRatePercent: taxRate,
      );
      grandTotal = QuotationPricingCalculator.calculateGrandTotal(
        subtotal: subtotal,
        discount: disc,
        taxAmount: taxAmount,
        shippingCost: ship,
        additionalCharges: addCharges,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        title: Column(
          children: [
            const Text(
              'إنشاء عرض سعر رسمي B2B',
              style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(height: 2),
            Text(
              'RFQ #${widget.rfqId}',
              style: const TextStyle(color: AppColors.outline, fontSize: 10),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.onSurfaceVariant, size: 20),
          onPressed: () => context.pop(),
        ),
        actions: [
          TextButton(
            onPressed: () => _showSuccessToast('تم حفظ العرض كمسودة بنجاح'),
            child: const Text('حفظ مسودة', style: TextStyle(color: Color(0xFF0040E0), fontSize: 12, fontWeight: FontWeight.bold)),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: AppColors.onSurfaceVariant),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // SECTION 1 — Factory Request Summary
                  _buildFactorySummaryCard(),
                  const SizedBox(height: 16),

                  // SECTION 2 — Selected Product
                  _buildSelectedProductCard(),
                  const SizedBox(height: 16),

                  // SECTION 3 — Quotation Pricing
                  _buildPricingFormCard(),
                  const SizedBox(height: 16),

                  // SECTION 4 — Payment Terms
                  _buildPaymentTermsCard(),
                  const SizedBox(height: 16),

                  // SECTION 5 — Production & Delivery
                  _buildProductionDeliveryCard(),
                  const SizedBox(height: 16),

                  // SECTION 6 — Quotation Validity
                  _buildValidityCard(),
                  const SizedBox(height: 16),

                  // SECTION 7 — Attachments
                  _buildAttachmentsCard(),
                  const SizedBox(height: 16),

                  // SECTION 8 — Notes
                  _buildNotesCard('ملاحظات العميل والمواصفات الفنية', _notesController, 'اكتب أي شروط إضافية للمصنع هنا...'),
                  const SizedBox(height: 16),

                  // SECTION 9 — Internal Notes
                  _buildNotesCard('ملاحظات المورد الداخلية (سرية)', _internalNotesController, 'ملاحظات وتذكيرات لربحية العرض وهوامش التفاوض...'),
                  const SizedBox(height: 16),

                  // SECTION 10 — Live Quotation Summary Card
                  _buildLiveQuotationSummaryCard(),
                ],
              ),
            ),
          ),

          // SECTION 11 — Bottom Action Bar
          _buildBottomActionBar(),
        ],
      ),
    );
  }

  Widget _buildFactorySummaryCard() {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: const Color(0xFFE8F0FE), borderRadius: BorderRadius.circular(6)),
                child: const Row(
                  children: [
                    Icon(Icons.verified, color: Color(0xFF0040E0), size: 12),
                    SizedBox(width: 4),
                    Text('موثق', style: TextStyle(color: Color(0xFF0040E0), fontSize: 9, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const Row(
                children: [
                  Text('مصنع الملابس المتحدة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  SizedBox(width: 8),
                  Icon(Icons.factory_outlined, color: AppColors.onSurfaceVariant, size: 20),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF1F1F5)),
          const SizedBox(height: 12),
          _buildRowItem('رقم طلب الشراء RFQ', 'RFQ-2026-000125'),
          const SizedBox(height: 6),
          _buildRowItem('تاريخ الطلب المرفوع', '06 يوليو 2026'),
          const SizedBox(height: 6),
          _buildRowItem('تاريخ الاستلام المطلوب', '25 يوليو 2026'),
          const SizedBox(height: 6),
          _buildRowItem('مكان التوصيل', 'المنطقة الصناعية الثالثة، الرياض'),
          const SizedBox(height: 12),
          const Text('الخامات والمواصفات الفنية المطلوبة', style: TextStyle(fontSize: 10, color: AppColors.outline)),
          const SizedBox(height: 4),
          const Text(
            'قماش قطن 100% طبيعي ممشط، خالي من البقع، العرض لا يقل عن 150 سم، الوزن 180 GSM.',
            style: TextStyle(fontSize: 11, height: 1.4),
            textAlign: TextAlign.end,
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFFE2E1EF)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('عرض مواصفات RFQ الكاملة', style: TextStyle(fontSize: 11, color: Color(0xFF0040E0))),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedProductCard() {
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
          const Text('المنتج المقترح للربط من الكتالوج', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // ignore: prefer_const_constructors
              Expanded(
                // ignore: prefer_const_constructors
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('خيوط غزل القطن الفاخر - كود الكتان', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    const SizedBox(height: 4),
                    const Text('SKU: IND-COT-2026 | المنشأ: مصر Egypt', style: TextStyle(fontSize: 9, color: AppColors.outline)),
                    const SizedBox(height: 4),
                    const Text('الكمية المتاحة بالمستودع: 15,000 متر | الحد الأدنى للطلب (MOQ): 100 متر', style: TextStyle(fontSize: 9, color: AppColors.outline)),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: const DecorationImage(
                    image: NetworkImage('https://images.unsplash.com/photo-1544816155-12df9643f363?auto=format&fit=crop&w=100&q=80'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => _showSuccessToast('جاري فتح كشاف المنتجات المعتمد...'),
            icon: const Icon(Icons.swap_horiz, size: 14, color: Color(0xFF0040E0)),
            label: const Text('تغيير المنتج المقترن', style: TextStyle(fontSize: 11, color: Color(0xFF0040E0))),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFF0040E0)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPricingFormCard() {
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
          const Text('تفاصيل تسعير العرض المالي للوحدة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0040E0))),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildTextField('سعر الوحدة (ر.س/م)', _unitPriceController)),
              const SizedBox(width: 12),
              Expanded(child: _buildTextField('الكمية المعروضة المحددة', _quotedQtyController)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildTextField('الحد الأدنى للطلب (MOQ)', _moqController)),
              const SizedBox(width: 12),
              Expanded(child: _buildTextField('قيمة الخصم النقدي المباشر', _discountController)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildTextField('تكلفة الشحن والتأمين المباشرة', _shippingCostController)),
              const SizedBox(width: 12),
              Expanded(child: _buildTextField('نسبة ضريبة القيمة المضافة (%)', _taxRateController)),
            ],
          ),
          const SizedBox(height: 12),
          _buildTextField('أية مصاريف إدارية أو إضافية أخرى', _additionalChargesController),
        ],
      ),
    );
  }

  Widget _buildPaymentTermsCard() {
    final paymentMethods = ['Full Payment', 'Partial Payment', 'Bank Transfer', 'Cheque', 'Installments'];
    final arPayment = {
      'Full Payment': 'دفع كامل القيمة سلفاً',
      'Partial Payment': 'دفع مقدم مجزأ',
      'Bank Transfer': 'تحويل بنكي ضامن Escrow',
      'Cheque': 'شيك بنكي معتمد',
      'Installments': 'أقساط مجدولة',
    };

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
          const Text('شروط وطريقة الدفع المعتمدة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 16),
          const Text('طريقة السداد الأساسية', style: TextStyle(fontSize: 10, color: AppColors.outline)),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE2E1EF)),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: DropdownButton<String>(
                value: selectedPaymentMethod,
                underline: const SizedBox(),
                isExpanded: true,
                style: const TextStyle(fontSize: 12, color: AppColors.onSurface, fontWeight: FontWeight.bold),
                items: paymentMethods.map((e) => DropdownMenuItem(value: e, child: Text(arPayment[e] ?? e))).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      selectedPaymentMethod = val;
                    });
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildTextField('نسبة الدفعة المقدمة (%)', _advancePercentController)),
              const SizedBox(width: 12),
              Expanded(child: _buildTextField('نسبة الدفعة المتبقية (%)', _remainingPercentController)),
            ],
          ),
          const SizedBox(height: 12),
          _buildTextField('أقصى تاريخ لاستحقاق السداد المالي', _paymentDueDateController),
          const SizedBox(height: 12),
          _buildTextField('ملاحظات إضافية حول التسهيلات الائتمانية', _paymentNotesController),
        ],
      ),
    );
  }

  Widget _buildProductionDeliveryCard() {
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
          const Text('بيانات جدول الإنتاج واللوجستيات والشحن', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildTextField('مدة الإنتاج والتجهيز', _productionTimeController)),
              const SizedBox(width: 12),
              Expanded(child: _buildTextField('مدة الشحن والرحلة المتوقعة', _deliveryTimeController)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildTextField('تاريخ الشحن الفعلي المتوقع', _expectedShippingController)),
              const SizedBox(width: 12),
              Expanded(child: _buildTextField('تاريخ الوصول المتوقع للمخازن', _estimatedArrivalController)),
            ],
          ),
          const SizedBox(height: 12),
          _buildTextField('شركة وطريقة الشحن المقترحة', _shippingMethodController),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Switch(
                value: rushOrderSupport,
                onChanged: (val) {
                  setState(() {
                    rushOrderSupport = val;
                  });
                },
                activeThumbColor: const Color(0xFF0040E0),
              ),
              const Text('دعم الشحن المستعجل والمضغوط', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildValidityCard() {
    final validities = [3, 7, 15, 30];

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
          const Text('فترة صلاحية عرض السعر المالي والمخزون', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: validities.map((days) {
              final isSelected = selectedValidityDays == days;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: ChoiceChip(
                  label: Text('$days أيام', style: TextStyle(fontSize: 10, color: isSelected ? Colors.white : AppColors.onSurfaceVariant)),
                  selected: isSelected,
                  selectedColor: const Color(0xFF0040E0),
                  backgroundColor: const Color(0xFFF1F1F5),
                  onSelected: (val) {
                    if (val) {
                      setState(() {
                        selectedValidityDays = days;
                        customValidityDate = DateTime.now().add(Duration(days: days));
                      });
                    }
                  },
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${customValidityDate.year}-${customValidityDate.month.toString().padLeft(2, '0')}-${customValidityDate.day.toString().padLeft(2, '0')}',
                style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFDC2626), fontSize: 13),
              ),
              const Text('تاريخ انتهاء الصلاحية المتوقع', style: TextStyle(fontSize: 11, color: AppColors.outline)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentsCard() {
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
          const Text('مرفقات الملفات وشهادات الجودة (اختياري)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 12),
          ...mockAttachments.map((file) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FF),
                border: Border.all(color: const Color(0xFFE2E1EF)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: AppColors.error, size: 18),
                    onPressed: () {
                      setState(() {
                        mockAttachments.remove(file);
                      });
                    },
                  ),
                  const Spacer(),
                  Text(file, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  const Icon(Icons.picture_as_pdf_outlined, color: Color(0xFF0040E0), size: 18),
                ],
              ),
            );
          }),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF0040E0), style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('ارفع ملفات إضافية (PDF، صور، فيديو المنتج)', style: TextStyle(color: Color(0xFF0040E0), fontSize: 11, fontWeight: FontWeight.bold)),
                SizedBox(width: 8),
                Icon(Icons.cloud_upload_outlined, color: Color(0xFF0040E0), size: 18),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesCard(String title, TextEditingController controller, String hint) {
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
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          const SizedBox(height: 12),
          TextField(
            controller: controller,
            maxLines: 3,
            textAlign: TextAlign.end,
            style: const TextStyle(fontSize: 12),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: AppColors.outline, fontSize: 11),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveQuotationSummaryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFCBD5E1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text('معاينة العرض المالي الفوري (Live Summary)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF0F172A))),
          const SizedBox(height: 12),
          _buildSummaryRow('المنتج المقترح المربوط', 'خيوط غزل القطن الفاخر'),
          _buildSummaryRow('الكمية الإجمالية', '${_quotedQtyController.text} متر'),
          _buildSummaryRow('سعر الوحدة', '${_unitPriceController.text} ر.س/متر'),
          _buildSummaryRow('المجموع الفرعي (Subtotal)', '${subtotal.toStringAsFixed(2)} ر.س'),
          _buildSummaryRow('الخصم المباشر المطبق', '- ${_discountController.text} ر.س'),
          _buildSummaryRow('ضريبة القيمة المضافة المعتمدة', '+ ${taxAmount.toStringAsFixed(2)} ر.س'),
          _buildSummaryRow('تكلفة النقل والشحن', '+ ${_shippingCostController.text} ر.س'),
          const Divider(height: 1, color: Color(0xFFCBD5E1)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${grandTotal.toStringAsFixed(2)} ر.س',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF16A34A)),
              ),
              const Text('إجمالي قيمة عرض السعر (Grand Total)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActionBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => _showPreviewBottomSheet(),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFE2E1EF)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('معاينة العرض', style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () => _validateAndSendQuotation(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0040E0),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('إرسال العرض المالي', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String val) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(val, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
          Text(label, style: const TextStyle(fontSize: 10, color: AppColors.outline)),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController ctrl) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 10, color: AppColors.onSurfaceVariant)),
          const SizedBox(height: 6),
          TextField(
            controller: ctrl,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E1EF))),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E1EF))),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRowItem(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(child: Text(value, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold), textAlign: TextAlign.left)),
        const SizedBox(width: 10),
        Text('$label:', style: const TextStyle(fontSize: 10, color: AppColors.outline)),
      ],
    );
  }

  void _showSuccessToast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void _showPreviewBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('معاينة وثيقة العرض الرسمية', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 10),
              _buildSummaryRow('اسم المشتري', 'مصنع الملابس المتحدة'),
              _buildSummaryRow('المنتج المقترح المربوط', 'خيوط غزل القطن الفاخر'),
              _buildSummaryRow('الكمية المطلوبة', '${_quotedQtyController.text} متر'),
              _buildSummaryRow('سعر الوحدة', '${_unitPriceController.text} ر.س'),
              _buildSummaryRow('السعر الإجمالي بعد الخصم والضريبة', '${grandTotal.toStringAsFixed(2)} ر.س'),
              _buildSummaryRow('طريقة السداد', selectedPaymentMethod),
              _buildSummaryRow('تاريخ الصلاحية', '${customValidityDate.year}-${customValidityDate.month.toString().padLeft(2, '0')}-${customValidityDate.day.toString().padLeft(2, '0')}'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0040E0), foregroundColor: Colors.white),
                child: const Text('موافق وإغلاق'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _validateAndSendQuotation() {
    final double? unitPrice = double.tryParse(_unitPriceController.text);
    final double? qty = double.tryParse(_quotedQtyController.text);

    final String? priceErr = QuotationValidator.validateUnitPrice(unitPrice);
    if (priceErr != null) {
      _showErrorDialog(priceErr);
      return;
    }

    final String? qtyErr = QuotationValidator.validateQuotedQuantity(
      quotedQuantity: qty,
      availableQuantity: 15000.0,
    );
    if (qtyErr != null) {
      _showErrorDialog(qtyErr);
      return;
    }

    final String? expiryErr = QuotationValidator.validateExpirationDate(customValidityDate);
    if (expiryErr != null) {
      _showErrorDialog(expiryErr);
      return;
    }

    final convId = widget.conversationId;
    if (convId != null) {
      ref.read(businessChatControllerProvider(convId).notifier).sendQuotationCard(
        productName: 'خيوط غزل القطن الفاخر',
        quantity: '${qty.toInt()} متر',
        unitPrice: '${unitPrice.toStringAsFixed(2)}',
        totalPrice: '${grandTotal.toStringAsFixed(2)}',
        deliveryTime: '${_productionTimeController.text} + ${_deliveryTimeController.text}',
        paymentMethod: selectedPaymentMethod,
        expiration: '${customValidityDate.year}-${customValidityDate.month.toString().padLeft(2, '0')}-${customValidityDate.day.toString().padLeft(2, '0')}',
      );
    }

    // Success dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle_outline, color: Color(0xFF16A34A), size: 48),
            SizedBox(height: 16),
            Text(
              'تم إنشاء وإرسال العرض المالي بنجاح! سيتم إخطار مصنع المشتري فوراً وتحديث جدول النشاطات.',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Pop dialog
              if (convId != null) {
                context.pop(); // Go back to chat screen
              } else {
                context.go('/orders'); // Go back to orders
              }
            },
            child: const Text('موافق'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String msg) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('خطأ في التحقق من البيانات', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.error), textAlign: TextAlign.center),
        content: Text(msg, style: const TextStyle(fontSize: 12), textAlign: TextAlign.center),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('موافق')),
        ],
      ),
    );
  }
}
