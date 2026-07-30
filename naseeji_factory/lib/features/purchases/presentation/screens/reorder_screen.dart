import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../orders/presentation/providers/orders_provider.dart';
import '../widgets/reorder_widgets.dart';

class ReorderScreen extends ConsumerStatefulWidget {
  final String orderId;
  const ReorderScreen({super.key, required this.orderId});

  @override
  ConsumerState<ReorderScreen> createState() => _ReorderScreenState();
}

class _ReorderScreenState extends ConsumerState<ReorderScreen> {
  late int _quantity;
  String _color = '';
  String _size = '';
  String _material = '';
  String _deliveryDate = '';

  @override
  Widget build(BuildContext context) {
    final orders = ref.watch(ordersNotifierProvider);
    final OrderModel? order = () {
      try {
        return orders.firstWhere((o) => o.id == widget.orderId);
      } catch (_) {
        return null;
      }
    }();

    if (order == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('إعادة طلب')),
        body: const Center(child: Text('لم يتم العثور على الطلب.')),
      );
    }

    _quantity = _quantity == 0 ? order.quantity : _quantity;
    if (_color.isEmpty) _color = '';
    if (_size.isEmpty) _size = '';
    if (_material.isEmpty) _material = '';

    final unitPrice = order.finalPrice / order.quantity;

    return Scaffold(
      appBar: AppBar(
        title: const Text('إعادة طلب المنتج'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PreviousOrderWidget(order: order),
              AppSpacing.hMD,
              EditableProductsWidget(
                quantity: _quantity,
                color: _color,
                size: _size,
                material: _material,
                onQuantityChanged: (val) => setState(() => _quantity = val),
                onColorChanged: (val) => setState(() => _color = val),
                onSizeChanged: (val) => setState(() => _size = val),
                onMaterialChanged: (val) => setState(() => _material = val),
              ),
              AppSpacing.hMD,
              DeliveryWidget(
                deliveryDate: _deliveryDate,
                onDateChanged: (val) => setState(() => _deliveryDate = val),
              ),
              AppSpacing.hMD,
              SummaryWidget(
                quantity: _quantity,
                unitPrice: unitPrice,
              ),
              AppSpacing.hLG,
              ReorderSubmitWidget(
                onSendRFQ: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تم إرسال طلب عرض السعر بنجاح!')),
                  );
                  context.pop();
                },
                onRepeatSame: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تم تكرار الطلب وإرساله للمورد!')),
                  );
                  context.pop();
                },
                onCancel: () => context.pop(),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
