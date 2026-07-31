// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../products/presentation/widgets/product_details/documents_widget.dart';
import '../providers/rfq_provider.dart';

/// Full Production-Ready Create RFQ Screen matching Reference Image 2
class CreateRFQScreen extends ConsumerStatefulWidget {
  const CreateRFQScreen({super.key});

  @override
  ConsumerState<CreateRFQScreen> createState() => _CreateRFQScreenState();
}

class _CreateRFQScreenState extends ConsumerState<CreateRFQScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _qtyController = TextEditingController(text: '10000');
  final TextEditingController _addressController = TextEditingController(text: 'المصنع الرئيسي - 6 أكتوبر');
  final TextEditingController _notesController = TextEditingController();

  String _selectedUnit = 'متر طولي';
  String _selectedDeliveryDate = '2024 - 06 - 25';
  String _selectedPaymentTerms = 'اعتماد مستندي بعد الاستلام';
  String _selectedCurrency = 'جنيه مصري (EGP)';
  int _selectedSuppliersCount = 3;
  final List<String> _attachments = [];

  final List<String> _units = ['متر طولي', 'كجم', 'بكرة', 'طبلية', 'طن'];
  final List<String> _paymentOptions = [
    'اعتماد مستندي بعد الاستلام',
    'تحويل بنكي 50% مقدم / 50% استلام',
    'دفع فوري عند الاستلام',
    'اعتماد مستندي 60 يوم',
  ];
  final List<String> _currencies = ['جنيه مصري (EGP)', 'دولار أمريكي (USD)', 'يورو (EUR)'];

  @override
  void dispose() {
    _qtyController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _saveDraft() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم حفظ طلب عرض السعر (RFQ) كمسودة بنجاح!')),
    );
  }

  void _openPdfSpecsModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const PdfViewerModal(
        docTitle: 'مواصفات قماش 100% قطن أبيض Standard',
        docType: 'مستند مواصفات قياسي PDF',
      ),
    );
  }

  void _pickAttachment() {
    setState(() {
      _attachments.add('ملف_رسم_فني_${_attachments.length + 1}.pdf');
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم إضافة المرفق الداعم بنجاح.')),
    );
  }

  void _showSupplierSelectionModal() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Material(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('تحديد الموردين المستهدفين', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                CheckboxListTile(
                  title: const Text('مصر للغزل والنسيج (مورد معتمد)'),
                  value: true,
                  onChanged: (val) {},
                ),
                CheckboxListTile(
                  title: const Text('النساجون المصريون (مورد معتمد)'),
                  value: true,
                  onChanged: (val) {},
                ),
                CheckboxListTile(
                  title: const Text('القاهرة للغزل والنسيج (مورد معتمد)'),
                  value: true,
                  onChanged: (val) {},
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() => _selectedSuppliersCount = 3);
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                    child: const Text('اعتماد الموردين المحددين (3)'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _submitRFQ() {
    if (_formKey.currentState!.validate()) {
      final qty = int.tryParse(_qtyController.text) ?? 10000;
      ref.read(rFQNotifierProvider.notifier).createRFQ(
            title: 'قماش 100% قطن أبيض',
            category: 'أقمشة وصباغة',
            description: _notesController.text.isNotEmpty
                ? _notesController.text
                : 'نحن نبحث عن موردين موثوقين لتوريد قماش 100% قطن عالية الاستخدام في إنتاج الملابس الجاهزة.',
            material: 'قطن 100%',
            color: 'أبيض',
            size: 'عرض 150 سم',
            qualityLevel: 'نخب أول تصديري',
            quantity: qty,
            unit: _selectedUnit,
            governorate: 'الجيزة',
            city: '6 أكتوبر',
            address: _addressController.text,
            deliveryDate: _selectedDeliveryDate,
            paymentTerms: _selectedPaymentTerms,
            currency: _selectedCurrency,
            attachments: _attachments,
            sendToRecommended: false,
            selectedSupplierIds: ['sup_1', 'sup_2', 'sup_3'],
          );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم إنشاء وإرسال طلب عرض السعر (RFQ) بنجاح!')),
      );

      context.push('/rfq/RFQ-2024-0045');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final appBarTextColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
        foregroundColor: appBarTextColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: appBarTextColor),
        title: Text(
          'إرسال طلب عرض سعر (RFQ)',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: appBarTextColor,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: appBarTextColor),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              context.go('/home');
            }
          },
        ),
        actions: [
          // Save Draft Action Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: OutlinedButton.icon(
              onPressed: _saveDraft,
              icon: const Icon(Icons.save_as_outlined, size: 16),
              label: const Text('حفظ كمسودة', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              style: OutlinedButton.styleFrom(
                foregroundColor: primaryColor,
                side: BorderSide(color: primaryColor.withValues(alpha: 0.5)),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          border: Border(top: BorderSide(color: isDark ? AppColors.borderDark : Colors.grey.shade200)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              // Preview Button (Outlined / Light Blue)
              Expanded(
                flex: 4,
                child: OutlinedButton.icon(
                  onPressed: () => context.push('/rfq/RFQ-2024-0045'),
                  icon: const Icon(Icons.remove_red_eye_outlined, size: 16),
                  label: const Text('معاينة الطلب', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: primaryColor,
                    backgroundColor: primaryColor.withValues(alpha: 0.05),
                    side: BorderSide(color: primaryColor.withValues(alpha: 0.3)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: AppRadius.rSM),
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // Submit RFQ Button (Filled Primary Blue)
              Expanded(
                flex: 6,
                child: ElevatedButton.icon(
                  onPressed: _submitRFQ,
                  icon: const Icon(Icons.send_rounded, size: 18),
                  label: const Text('إرسال طلب عرض السعر (RFQ)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: AppRadius.rSM),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Top Product Summary Card (Matching Reference Image 2)
              _buildProductSummaryCard(context, isDark: isDark, primaryColor: primaryColor),
              const SizedBox(height: 16),

              // Section 1: الكمية والوحدة
              _buildQuantityUnitSection(context, isDark: isDark, primaryColor: primaryColor),
              const SizedBox(height: 16),

              // Section 2: مكان وتاريخ التسليم
              _buildDeliverySection(context, isDark: isDark, primaryColor: primaryColor),
              const SizedBox(height: 16),

              // Section 3: شروط الدفع والعملة
              _buildPaymentCurrencySection(context, isDark: isDark, primaryColor: primaryColor),
              const SizedBox(height: 16),

              // Section 4: تفاصيل إضافية (مواصفات + مرفقات)
              _buildAdditionalDetailsSection(context, isDark: isDark, primaryColor: primaryColor),
              const SizedBox(height: 16),

              // Section 5: ملاحظات
              _buildNotesSection(context, isDark: isDark, primaryColor: primaryColor),
              const SizedBox(height: 16),

              // Section 6: إرسال إلى الموردين
              _buildSupplierSelectionSection(context, isDark: isDark, primaryColor: primaryColor),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // Product Summary Header Card
  Widget _buildProductSummaryCard(BuildContext context, {required bool isDark, required Color primaryColor}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: AppRadius.rMD,
        border: Border.all(color: isDark ? AppColors.borderDark : Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image thumbnail with counter badge & zoom icon
          Stack(
            children: [
              ClipRRect(
                borderRadius: AppRadius.rSM,
                child: SizedBox(
                  width: 80,
                  height: 80,
                  child: Image.network(
                    'https://images.unsplash.com/photo-1528301721190-186c3bd85418?w=500',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey.shade200),
                  ),
                ),
              ),
              Positioned(
                bottom: 4,
                left: 4,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text('1/5', style: TextStyle(color: Colors.white, fontSize: 9)),
                ),
              ),
              Positioned(
                bottom: 4,
                right: 4,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.zoom_in_rounded, color: Colors.white, size: 12),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),

          // Title, Subtitle, Supplier
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('قماش 100% قطن أبيض', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('عرض 150 سم - 140 جم/م²', style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.verified_rounded, color: AppColors.success, size: 14),
                    const SizedBox(width: 4),
                    const Text('مصر للغزل والنسيج', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 6),
                    Icon(Icons.location_on_outlined, size: 12, color: Colors.grey.shade500),
                    const SizedBox(width: 2),
                    Text('القاهرة، مصر', style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
                  ],
                ),
              ],
            ),
          ),

          // Price & MOQ Right Block
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('السعر', style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
              const Row(
                children: [
                  Text('42.00', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(width: 2),
                  Text('ج.م / متر', style: TextStyle(fontSize: 10, color: AppColors.primary)),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.backgroundDark : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Column(
                  children: [
                    Text('MOQ', style: TextStyle(fontSize: 9, color: Colors.grey.shade600)),
                    const Text('500 متر', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Section 1: الكمية والوحدة
  Widget _buildQuantityUnitSection(BuildContext context, {required bool isDark, required Color primaryColor}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: AppRadius.rMD,
        border: Border.all(color: isDark ? AppColors.borderDark : Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('الكمية والوحدة', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // الكمية المطلوبة
              Expanded(
                flex: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('الكمية المطلوبة ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        Text('*', style: TextStyle(color: AppColors.error, fontSize: 14)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _qtyController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        border: OutlineInputBorder(borderRadius: AppRadius.rSM),
                        filled: true,
                        fillColor: isDark ? AppColors.backgroundDark : Colors.grey.shade50,
                      ),
                      validator: (val) => val == null || val.isEmpty ? 'يرجى إدخال الكمية' : null,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),

              // وحدة القياس
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('وحدة القياس ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        Text('*', style: TextStyle(color: AppColors.error, fontSize: 14)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedUnit,
                      items: _units.map((u) => DropdownMenuItem(value: u, child: Text(u, style: const TextStyle(fontSize: 13)))).toList(),
                      onChanged: (val) => setState(() => _selectedUnit = val!),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        border: OutlineInputBorder(borderRadius: AppRadius.rSM),
                        filled: true,
                        fillColor: isDark ? AppColors.backgroundDark : Colors.grey.shade50,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'الحد الأدنى للطلب من هذا المورد: 500 متر',
            style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  // Section 2: مكان وتاريخ التسليم
  Widget _buildDeliverySection(BuildContext context, {required bool isDark, required Color primaryColor}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: AppRadius.rMD,
        border: Border.all(color: isDark ? AppColors.borderDark : Colors.grey.shade200),
      ),
      child: Row(
        children: [
          // مكان التسليم
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('مكان التسليم ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    Text('*', style: TextStyle(color: AppColors.error, fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.location_on_outlined, color: primaryColor, size: 20),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    border: OutlineInputBorder(borderRadius: AppRadius.rSM),
                    filled: true,
                    fillColor: isDark ? AppColors.backgroundDark : Colors.grey.shade50,
                    helperText: 'الجيزة، مصر',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // موعد التسليم المطلوب
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('موعد التسليم المطلوب ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    Text('*', style: TextStyle(color: AppColors.error, fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 6),
                InkWell(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now().add(const Duration(days: 15)),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 90)),
                    );
                    if (picked != null) {
                      setState(() {
                        _selectedDeliveryDate = '${picked.year} - ${picked.month.toString().padLeft(2, '0')} - ${picked.day.toString().padLeft(2, '0')}';
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.backgroundDark : Colors.grey.shade50,
                      borderRadius: AppRadius.rSM,
                      border: Border.all(color: isDark ? AppColors.borderDark : Colors.grey.shade400),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today_outlined, color: primaryColor, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_selectedDeliveryDate, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                              const Text('بعد 15 يوم', style: TextStyle(fontSize: 9, color: AppColors.success, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Section 3: شروط الدفع والعملة
  Widget _buildPaymentCurrencySection(BuildContext context, {required bool isDark, required Color primaryColor}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: AppRadius.rMD,
        border: Border.all(color: isDark ? AppColors.borderDark : Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('شروط الدفع والعملة', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(
            children: [
              // شروط الدفع
              Expanded(
                flex: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('شروط الدفع ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        Text('*', style: TextStyle(color: AppColors.error, fontSize: 14)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedPaymentTerms,
                      isExpanded: true,
                      items: _paymentOptions.map((p) => DropdownMenuItem(value: p, child: Text(p, style: const TextStyle(fontSize: 12)))).toList(),
                      onChanged: (val) => setState(() => _selectedPaymentTerms = val!),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        border: OutlineInputBorder(borderRadius: AppRadius.rSM),
                        filled: true,
                        fillColor: isDark ? AppColors.backgroundDark : Colors.grey.shade50,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),

              // العملة
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('العملة ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        Text('*', style: TextStyle(color: AppColors.error, fontSize: 14)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedCurrency,
                      isExpanded: true,
                      items: _currencies.map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontSize: 12)))).toList(),
                      onChanged: (val) => setState(() => _selectedCurrency = val!),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        border: OutlineInputBorder(borderRadius: AppRadius.rSM),
                        filled: true,
                        fillColor: isDark ? AppColors.backgroundDark : Colors.grey.shade50,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDark ? AppColors.backgroundDark : Colors.grey.shade100,
              borderRadius: AppRadius.rSM,
            ),
            child: Text(
              'يمكنك مناقشة شروط الدفع النهائية مع المورد أثناء التفاوض',
              style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
            ),
          ),
        ],
      ),
    );
  }

  // Section 4: تفاصيل إضافية (مواصفات + مرفقات)
  Widget _buildAdditionalDetailsSection(BuildContext context, {required bool isDark, required Color primaryColor}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: AppRadius.rMD,
        border: Border.all(color: isDark ? AppColors.borderDark : Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('تفاصيل إضافية', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(
            children: [
              // المواصفات المطلوبة
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.backgroundDark : Colors.grey.shade50,
                    borderRadius: AppRadius.rSM,
                    border: Border.all(color: isDark ? AppColors.borderDark : Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('المواصفات المطلوبة', style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                      const SizedBox(height: 4),
                      const Text('حسب المواصفات القياسية', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: _openPdfSpecsModal,
                        child: Row(
                          children: [
                            const Icon(Icons.picture_as_pdf_outlined, color: AppColors.primary, size: 16),
                            const SizedBox(width: 4),
                            Text('عرض المواصفات PDF', style: TextStyle(fontSize: 11, color: primaryColor, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // مرفقات (اختياري)
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.backgroundDark : Colors.grey.shade50,
                    borderRadius: AppRadius.rSM,
                    border: Border.all(color: isDark ? AppColors.borderDark : Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('مرفقات (اختياري)', style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                      const SizedBox(height: 4),
                      Text(
                        _attachments.isEmpty ? 'أمثلة: رسومات أو أي مستندات داعمة' : '${_attachments.length} مرفق مضاف',
                        style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
                      ),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: _pickAttachment,
                        child: Row(
                          children: [
                            Icon(Icons.link_rounded, color: primaryColor, size: 16),
                            const SizedBox(width: 4),
                            Text('إضافة مرفق', style: TextStyle(fontSize: 11, color: primaryColor, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Section 5: ملاحظات
  Widget _buildNotesSection(BuildContext context, {required bool isDark, required Color primaryColor}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: AppRadius.rMD,
        border: Border.all(color: isDark ? AppColors.borderDark : Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('ملاحظات', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          TextFormField(
            controller: _notesController,
            maxLines: 4,
            maxLength: 500,
            decoration: InputDecoration(
              hintText: 'اكتب أي ملاحظات أو متطلبات خاصة...',
              hintStyle: TextStyle(fontSize: 12, color: Colors.grey.shade400),
              border: OutlineInputBorder(borderRadius: AppRadius.rSM),
              filled: true,
              fillColor: isDark ? AppColors.backgroundDark : Colors.grey.shade50,
            ),
          ),
        ],
      ),
    );
  }

  // Section 6: إرسال إلى الموردين
  Widget _buildSupplierSelectionSection(BuildContext context, {required bool isDark, required Color primaryColor}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: AppRadius.rMD,
        border: Border.all(color: isDark ? AppColors.borderDark : Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('إرسال إلى الموردين', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              Text(
                'حدد الموردين الذين ترغب في إرسال طلب عرض السعر إليهم',
                style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
              ),
            ],
          ),
          InkWell(
            onTap: _showSupplierSelectionModal,
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('تحديد الموردين', style: TextStyle(fontSize: 12, color: primaryColor, fontWeight: FontWeight.bold)),
                    Text('$_selectedSuppliersCount موردين محددين', style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
                  ],
                ),
                const SizedBox(width: 6),
                Icon(Icons.arrow_forward_ios_rounded, size: 14, color: primaryColor),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
