import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'request_product_provider.g.dart';

class RequestProductState {
  final int quantity;
  final String unit;
  final String color;
  final String size;
  final DateTime? deliveryDate;
  final String deliveryAddress;
  final String notes;
  final bool isLoading;
  final String? successMessage;

  const RequestProductState({
    this.quantity = 500,
    this.unit = 'كيلو جرام',
    this.color = '',
    this.size = '',
    this.deliveryDate,
    this.deliveryAddress = 'المنطقة الصناعية الثالثة، السادس من أكتوبر، الجيزة',
    this.notes = '',
    this.isLoading = false,
    this.successMessage,
  });

  RequestProductState copyWith({
    int? quantity,
    String? unit,
    String? color,
    String? size,
    DateTime? deliveryDate,
    String? deliveryAddress,
    String? notes,
    bool? isLoading,
    String? successMessage,
  }) {
    return RequestProductState(
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      color: color ?? this.color,
      size: size ?? this.size,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      notes: notes ?? this.notes,
      isLoading: isLoading ?? this.isLoading,
      successMessage: successMessage,
    );
  }

  double calculateCost(double pricePerUnit) {
    return quantity * pricePerUnit;
  }
}

@riverpod
class RequestProductNotifier extends _$RequestProductNotifier {
  @override
  RequestProductState build() {
    return RequestProductState(
      deliveryDate: DateTime.now().add(const Duration(days: 14)),
    );
  }

  void updateQuantity(int qty) {
    state = state.copyWith(quantity: qty);
  }

  void updateUnit(String unit) {
    state = state.copyWith(unit: unit);
  }

  void updateColor(String color) {
    state = state.copyWith(color: color);
  }

  void updateSize(String size) {
    state = state.copyWith(size: size);
  }

  void updateDeliveryDate(DateTime date) {
    state = state.copyWith(deliveryDate: date);
  }

  void updateAddress(String address) {
    state = state.copyWith(deliveryAddress: address);
  }

  void updateNotes(String notes) {
    state = state.copyWith(notes: notes);
  }

  Future<bool> submitRequest(String productId) async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(seconds: 1)); // Mock submission delay
    state = state.copyWith(
      isLoading: false,
      successMessage: 'تم إرسال طلب عرض السعر للمورد بنجاح! سيتم إخطارك فور الرد.',
    );
    return true;
  }
}

