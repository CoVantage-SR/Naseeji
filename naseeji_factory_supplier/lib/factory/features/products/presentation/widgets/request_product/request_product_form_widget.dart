import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naseeji_factory/factory/core/constants/app_colors.dart';
import 'package:naseeji_factory/factory/core/constants/app_radius.dart';
import 'package:naseeji_factory/factory/core/constants/app_spacing.dart';
import 'package:naseeji_factory/factory/core/extensions/context_extensions.dart';
import '../../providers/products_provider.dart';
import '../../providers/request_product_provider.dart';
import '../request_product_widgets.dart';

class RequestProductFormWidget extends ConsumerStatefulWidget {
  final Product product;

  const RequestProductFormWidget({super.key, required this.product});

  @override
  ConsumerState<RequestProductFormWidget> createState() => _RequestProductFormWidgetState();
}

class _RequestProductFormWidgetState extends ConsumerState<RequestProductFormWidget> {
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();
  final _quantityController = TextEditingController(text: '500');

  @override
  void initState() {
    super.initState();
    final formState = ref.read(requestProductNotifierProvider);
    _addressController.text = formState.deliveryAddress;
    _notesController.text = formState.notes;
  }

  @override
  void dispose() {
    _addressController.dispose();
    _notesController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, RequestProductNotifier notifier, DateTime current) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      notifier.updateDeliveryDate(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(requestProductNotifierProvider);
    final notifier = ref.read(requestProductNotifierProvider.notifier);
    final estimatedCost = formState.calculateCost(widget.product.price);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SelectedProductWidget(product: widget.product),
          AppSpacing.hLG,
          Text(
            'مواصفات الطلب المطلوبة',
            style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          AppSpacing.hMD,
          // Quantity and Unit Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: TextFormField(
                  controller: _quantityController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'الكمية المطلوبة',
                    prefixIcon: Icon(Icons.numbers_rounded),
                  ),
                  onChanged: (val) {
                    final parsed = int.tryParse(val) ?? 0;
                    notifier.updateQuantity(parsed);
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: DropdownButtonFormField<String>(
                  initialValue: formState.unit,
                  onChanged: (val) => notifier.updateUnit(val ?? 'كيلو جرام'),
                  decoration: const InputDecoration(
                    labelText: 'الوحدة',
                  ),
                  items: const [
                    DropdownMenuItem(value: 'كيلو جرام', child: Text('كيلو جرام')),
                    DropdownMenuItem(value: 'متر', child: Text('متر')),
                    DropdownMenuItem(value: 'بكرة', child: Text('بكرة')),
                  ],
                ),
              ),
            ],
          ),
          AppSpacing.hMD,
          // Color selection Wrap
          const Text('اللون المفضل', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.product.colors.map((color) {
              final isSelected = formState.color == color;
              return ChoiceChip(
                label: Text(color, style: const TextStyle(fontSize: 12)),
                selected: isSelected,
                onSelected: (_) => notifier.updateColor(color),
                selectedColor: AppColors.primary,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : context.colorScheme.onSurface,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                shape: RoundedRectangleBorder(borderRadius: AppRadius.rRound),
                showCheckmark: false,
              );
            }).toList(),
          ),
          AppSpacing.hMD,
          // Size selection Wrap
          const Text('المقاس / العرض المفضل', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.product.sizes.map((size) {
              final isSelected = formState.size == size;
              return ChoiceChip(
                label: Text(size, style: const TextStyle(fontSize: 12)),
                selected: isSelected,
                onSelected: (_) => notifier.updateSize(size),
                selectedColor: AppColors.primary,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : context.colorScheme.onSurface,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                shape: RoundedRectangleBorder(borderRadius: AppRadius.rRound),
                showCheckmark: false,
              );
            }).toList(),
          ),
          AppSpacing.hMD,
          // Delivery Date Widget
          InkWell(
            onTap: () => _selectDate(context, notifier, formState.deliveryDate ?? DateTime.now()),
            borderRadius: AppRadius.rMD,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: AppRadius.rMD,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.calendar_today_rounded, color: Colors.grey, size: 20),
                      SizedBox(width: 12),
                      Text('تاريخ التسليم المطلوب المفضل'),
                    ],
                  ),
                  Text(
                    formState.deliveryDate != null
                        ? '${formState.deliveryDate!.year}/${formState.deliveryDate!.month}/${formState.deliveryDate!.day}'
                        : 'اختر التاريخ',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                  ),
                ],
              ),
            ),
          ),
          AppSpacing.hMD,
          // Delivery Address
          TextField(
            controller: _addressController,
            maxLines: 2,
            decoration: const InputDecoration(
              labelText: 'عنوان المصنع للتوصيل',
              prefixIcon: Icon(Icons.location_on_outlined),
            ),
            onChanged: (val) => notifier.updateAddress(val.trim()),
          ),
          AppSpacing.hMD,
          // Notes
          TextField(
            controller: _notesController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'ملاحظات إضافية للمورد',
              hintText: 'اكتب تفاصيل إضافية مثل شروط الدفع، التعبئة والتغليف، أو شروط الجودة...',
              prefixIcon: Icon(Icons.edit_note_rounded),
            ),
            onChanged: (val) => notifier.updateNotes(val.trim()),
          ),
          AppSpacing.hLG,
          OrderSummaryWidget(
            product: widget.product,
            quantity: formState.quantity,
            estimatedCost: estimatedCost,
          ),
          const SizedBox(height: 24),
          // Action Buttons Row
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: AppColors.primary),
                    foregroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: AppRadius.rMD),
                  ),
                  child: const Text('إلغاء'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    final success = await notifier.submitRequest(widget.product.id);
                    if (success && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(formState.successMessage ?? 'تم إرسال طلبك بنجاح!')),
                      );
                      Navigator.of(context).pop();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: AppRadius.rMD),
                  ),
                  child: const Text('إرسال الطلب للمورد'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

