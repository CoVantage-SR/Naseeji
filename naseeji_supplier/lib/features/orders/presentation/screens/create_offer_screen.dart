import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';

class CreateOfferScreen extends StatefulWidget {
  final String rfqId;

  const CreateOfferScreen({super.key, required this.rfqId});

  @override
  State<CreateOfferScreen> createState() => _CreateOfferScreenState();
}

class _CreateOfferScreenState extends State<CreateOfferScreen> {
  final _unitPriceController = TextEditingController(text: '0.00');
  final _moqController = TextEditingController(text: '100');
  final _qtyController = TextEditingController(text: '5000');
  final _prodPeriodController = TextEditingController(text: '5-7');
  final _deliveryPeriodController = TextEditingController(text: '2');
  final _shippingCostController = TextEditingController(text: 'مجاني');
  final _cashDiscountController = TextEditingController(text: '0');
  final _vatController = TextEditingController(text: '15');
  final _paymentTermsController = TextEditingController(text: 'Net 30');
  final _validityController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _unitPriceController.dispose();
    _moqController.dispose();
    _qtyController.dispose();
    _prodPeriodController.dispose();
    _deliveryPeriodController.dispose();
    _shippingCostController.dispose();
    _cashDiscountController.dispose();
    _vatController.dispose();
    _paymentTermsController.dispose();
    _validityController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        title: const Text(
          'إنشاء عرض سعر',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.onSurfaceVariant,
            size: 20,
          ),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: AppColors.onSurfaceVariant),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // RFQ Summary Header
                  Text(
                    'طلب رقم #${widget.rfqId}',
                    style: const TextStyle(
                      color: Color(0xFF0040E0),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'أقمشة قطنية فاخرة - توريد مصانع',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE2F9F5),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'عميل موثق: نسيجك',
                              style: TextStyle(
                                color: Color(0xFF006B5F),
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(Icons.verified, color: Color(0xFF006B5F), size: 12),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Pricing and Quantities Card
                  _buildSectionCard(
                    icon: Icons.payments_outlined,
                    title: 'التسعير والكميات',
                    color: const Color(0xFF0040E0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildInputField(
                          label: 'سعر الوحدة (ر.س)',
                          controller: _unitPriceController,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _buildInputField(
                                label: 'الكمية المتاحة',
                                controller: _qtyController,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildInputField(
                                label: 'الحد الأدنى (MOQ)',
                                controller: _moqController,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Logistics Card
                  _buildSectionCard(
                    icon: Icons.local_shipping_outlined,
                    title: 'الخدمات اللوجستية',
                    color: const Color(0xFF006B5F),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildInputField(
                          label: 'مدة الإنتاج (يوم)',
                          controller: _prodPeriodController,
                          suffixText: 'يوم عمل',
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _buildInputField(
                                label: 'تكلفة الشحن (ر.س)',
                                controller: _shippingCostController,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildInputField(
                                label: 'مدة التوصيل',
                                controller: _deliveryPeriodController,
                                suffixText: 'يومي',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Terms and Conditions Card
                  _buildSectionCard(
                    icon: Icons.gavel_outlined,
                    title: 'الشروط والأحكام',
                    color: const Color(0xFF993100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _buildInputField(
                                label: 'الضريبة المضافة (%)',
                                controller: _vatController,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildInputField(
                                label: 'خصم النقدي (%)',
                                controller: _cashDiscountController,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildInputField(
                          label: 'شروط الدفع',
                          controller: _paymentTermsController,
                        ),
                        const SizedBox(height: 16),
                        _buildInputField(
                          label: 'صلاحية العرض',
                          controller: _validityController,
                          hintText: 'mm/dd/yyyy',
                          suffixIcon: Icons.calendar_today_outlined,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Additional Notes Card
                  _buildSectionCard(
                    icon: Icons.description_outlined,
                    title: 'ملاحظات إضافية',
                    color: AppColors.onSurfaceVariant,
                    child: _buildInputField(
                      label: '',
                      controller: _notesController,
                      hintText: 'اكتب أي تفاصيل إضافية للعميل هنا...',
                      maxLines: 4,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Attachments Card
                  _buildSectionCard(
                    icon: Icons.attachment_outlined,
                    title: 'المرفقات',
                    color: AppColors.onSurfaceVariant,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFFE2E1EF),
                          width: 1,
                          style: BorderStyle.solid, // Dash effect can be custom, solid is fine
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: const BoxDecoration(
                              color: Color(0xFFE8F0FE),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.cloud_upload_outlined,
                              color: Color(0xFF0040E0),
                              size: 28,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'اضغط لرفع الملفات أو اسحبها هنا',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.onSurface,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'PDF, PNG, JPG (الحد الأقصى 10 ميجابايت)',
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.outline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Action Bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: SafeArea(
              child: Row(
                children: [
                  // Preview Button
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.visibility_outlined, size: 16, color: AppColors.outline),
                    label: const Text(
                      'معاينة',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.outline,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Save as Draft
                  OutlinedButton(
                    onPressed: () {
                      _showSuccessDialog('تم حفظ العرض كمسودة بنجاح');
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF0040E0),
                      side: const BorderSide(color: Color(0xFF0040E0), width: 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                    child: const Text(
                      'حفظ كمسودة',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Send Button
                  ElevatedButton.icon(
                    onPressed: () {
                      _showSuccessDialog('تم إرسال عرض السعر بنجاح');
                    },
                    icon: const Icon(Icons.send, size: 16, color: Colors.white),
                    label: const Text(
                      'إرسال عرض السعر',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0040E0),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required IconData icon,
    required String title,
    required Color color,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(width: 8),
              Icon(icon, color: color, size: 18),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF1F1F5)),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    String? hintText,
    TextInputType? keyboardType,
    int maxLines = 1,
    TextAlign textAlign = TextAlign.end,
    IconData? suffixIcon,
    String? suffixText,
  }) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label.isNotEmpty) ...[
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 6),
          ],
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            textAlign: textAlign,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(color: AppColors.outline, fontSize: 12),
              suffixText: suffixText,
              suffixStyle: const TextStyle(color: AppColors.outline, fontSize: 12, fontWeight: FontWeight.normal),
              suffixIcon: suffixIcon != null ? Icon(suffixIcon, color: AppColors.outline, size: 18) : null,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFFE2E1EF), width: 1),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFFE2E1EF), width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.primary, width: 1),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle_outline, color: Color(0xFF16A34A), size: 48),
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Pop dialog
              context.go('/orders'); // Navigate back to orders list
            },
            child: const Text('موافق'),
          ),
        ],
      ),
    );
  }
}
