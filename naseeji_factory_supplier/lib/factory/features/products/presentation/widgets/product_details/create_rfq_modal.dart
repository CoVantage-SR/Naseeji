import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_radius.dart';
import '../../../../home/presentation/providers/notifications_provider.dart';
import '../../../../rfq/presentation/providers/rfq_provider.dart';
import '../../providers/products_provider.dart';

/// Modal dialog / bottom sheet for creating and submitting a new Request For Quotation (RFQ)
class CreateRfqModal extends ConsumerStatefulWidget {
  final Product product;

  const CreateRfqModal({super.key, required this.product});

  @override
  ConsumerState<CreateRfqModal> createState() => _CreateRfqModalState();
}

class _CreateRfqModalState extends ConsumerState<CreateRfqModal> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _qtyController;
  late TextEditingController _notesController;
  String _selectedUnit = 'متر';
  DateTime _expectedDeliveryDate = DateTime.now().add(const Duration(days: 7));
  bool _isSubmitting = false;

  final List<String> _availableUnits = ['متر', 'كيلو جرام', 'قطعة', 'طن', 'بكرة'];

  @override
  void initState() {
    super.initState();
    _qtyController = TextEditingController(text: widget.product.moq.toString());
    _notesController = TextEditingController();
    _selectedUnit = widget.product.unit;
  }

  @override
  void dispose() {
    _qtyController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _expectedDeliveryDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 180)),
    );
    if (picked != null) {
      setState(() => _expectedDeliveryDate = picked);
    }
  }

  void _submitRfq() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final qty = int.tryParse(_qtyController.text.trim()) ?? widget.product.moq;
    final formattedDate =
        '${_expectedDeliveryDate.year}/${_expectedDeliveryDate.month.toString().padLeft(2, '0')}/${_expectedDeliveryDate.day.toString().padLeft(2, '0')}';

    // 1. Create RFQ via Riverpod RFQ Notifier
    ref.read(rFQNotifierProvider.notifier).createRFQ(
          title: widget.product.name,
          category: widget.product.category,
          quantity: qty,
          unit: _selectedUnit,
          description: _notesController.text.trim().isNotEmpty
              ? _notesController.text.trim()
              : 'طلب توريد من مصنع ${widget.product.supplierName} لمنتج ${widget.product.name}',
          material: widget.product.material,
          color: widget.product.colors.isNotEmpty ? widget.product.colors.first : 'أبيض',
          size: widget.product.sizes.isNotEmpty ? widget.product.sizes.first : 'قياسي',
          qualityLevel: 'نخب أول (درجة أ)',
          governorate: 'الدقهلية',
          city: 'المنصورة',
          address: 'المنطقة الصناعية',
          deliveryDate: formattedDate,
          attachments: const [],
          sendToRecommended: false,
          selectedSupplierIds: [widget.product.supplierId],
        );

    // 2. Add reactive notification to user system
    ref.read(notificationsNotifierProvider.notifier).addNotification(
          AppNotification(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            title: 'تم إرسال طلب عرض السعر (RFQ)',
            description: 'تم إرسال طلبك رقم RFQ إلى ${widget.product.supplierName} بنجاح!',
            time: 'الآن',
            category: 'rfqs',
            isRead: false,
          ),
        );

    await Future.delayed(const Duration(milliseconds: 300));

    if (mounted) {
      setState(() => _isSubmitting = false);
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'تم تقديم طلب RFQ بكمية $qty $_selectedUnit إلى ${widget.product.supplierName} بنجاح!',
          ),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.request_quote_rounded, color: primaryColor, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'إرسال طلب عرض سعر (RFQ)',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          widget.product.name,
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const Divider(height: 24),

              // Target Supplier Card Banner
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.08),
                  borderRadius: AppRadius.rSM,
                  border: Border.all(color: primaryColor.withValues(alpha: 0.2)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.factory_rounded, color: AppColors.primary, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'المورد المستهدف',
                            style: TextStyle(fontSize: 10, color: Colors.grey),
                          ),
                          Text(
                            widget.product.supplierName,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    const StatusChip(label: 'مباشر ✅', color: AppColors.success),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Step 1: Quantity & Unit
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      controller: _qtyController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'الكمية المطلوبة',
                        hintText: 'مثال: 500',
                        helperText: 'أقل كمية (MOQ): ${widget.product.moq}',
                        border: const OutlineInputBorder(),
                      ),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) return 'يرجى إدخال الكمية';
                        final num = int.tryParse(val.trim());
                        if (num == null || num <= 0) return 'كمية غير صالحة';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: DropdownButtonFormField<String>(
                      isExpanded: true,
                      initialValue: _selectedUnit,
                      decoration: const InputDecoration(
                        labelText: 'الوحدة',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                      ),
                      items: _availableUnits
                          .map((u) => DropdownMenuItem(
                                value: u,
                                child: Text(
                                  u,
                                  style: const TextStyle(fontSize: 13),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedUnit = val);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Step 2: Expected Delivery Date
              InkWell(
                onTap: () => _selectDate(context),
                borderRadius: AppRadius.rSM,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: AppRadius.rSM,
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_month_rounded, color: primaryColor, size: 20),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'تاريخ التوريد المتوقع',
                            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                          ),
                          Text(
                            '${_expectedDeliveryDate.year}/${_expectedDeliveryDate.month}/${_expectedDeliveryDate.day}',
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const Spacer(),
                      const Icon(Icons.arrow_drop_down_rounded),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Step 3: Notes & Special Requirements
              TextFormField(
                controller: _notesController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'المواصفات الفنية المخصصة واللاحظات',
                  hintText: 'أضف تفاصيل التغليف، مواصفات الشحن، أو أي متطلبات خاصة...',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: _isSubmitting ? null : _submitRfq,
                  icon: _isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.send_rounded, size: 18),
                  label: Text(_isSubmitting ? 'جارٍ إرسال الطلب...' : 'تأكيد وإرسال طلب RFQ'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: AppRadius.rSM),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StatusChip extends StatelessWidget {
  final String label;
  final Color color;

  const StatusChip({super.key, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );
  }
}



