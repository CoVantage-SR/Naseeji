import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'comparison_provider.g.dart';

class PriceQuotation {
  final String supplierId;
  final String supplierName;
  final double quotedPricePerUnit;
  final double discountPercent;
  final double shippingCost;
  final int moq;
  final int prepTimeDays;
  final String expiryDate;

  const PriceQuotation({
    required this.supplierId,
    required this.supplierName,
    required this.quotedPricePerUnit,
    required this.discountPercent,
    required this.shippingCost,
    required this.moq,
    required this.prepTimeDays,
    required this.expiryDate,
  });

  double get finalPrice => (quotedPricePerUnit * (1 - discountPercent / 100)) + shippingCost / moq;
}

class DeliveryComparisonItem {
  final String supplierId;
  final String supplierName;
  final int prepTimeDays;
  final int shippingTimeDays;
  final String deliveryPerformance;
  final double lateDeliveryPercent;

  const DeliveryComparisonItem({
    required this.supplierId,
    required this.supplierName,
    required this.prepTimeDays,
    required this.shippingTimeDays,
    required this.deliveryPerformance,
    required this.lateDeliveryPercent,
  });

  int get totalEstimatedTime => prepTimeDays + shippingTimeDays;
}

@riverpod
class ComparisonNotifier extends _$ComparisonNotifier {
  @override
  List<String> build() {
    return [];
  }

  void toggleSupplier(String id) {
    if (state.contains(id)) {
      state = state.where((item) => item != id).toList();
    } else {
      if (state.length < 3) {
        state = [...state, id];
      }
    }
  }

  void removeSupplier(String id) {
    state = state.where((item) => item != id).toList();
  }

  void clear() {
    state = [];
  }
}

@riverpod
List<PriceQuotation> priceQuotations(PriceQuotationsRef ref) {
  return const [
    PriceQuotation(
      supplierId: 'sup_1',
      supplierName: 'شركة غزل المحلة الكبرى',
      quotedPricePerUnit: 145.0,
      discountPercent: 5.0,
      shippingCost: 800.0,
      moq: 500,
      prepTimeDays: 7,
      expiryDate: '٢٠٢٦/٠٨/٠١',
    ),
    PriceQuotation(
      supplierId: 'sup_2',
      supplierName: 'مصنع النيل للأقمشة الحديثة',
      quotedPricePerUnit: 152.0,
      discountPercent: 10.0,
      shippingCost: 500.0,
      moq: 200,
      prepTimeDays: 12,
      expiryDate: '٢٠٢٦/٠٧/٣٠',
    ),
    PriceQuotation(
      supplierId: 'sup_3',
      supplierName: 'الفتح لخيوط البوليستر ومستلزمات المصانع',
      quotedPricePerUnit: 130.0,
      discountPercent: 0.0,
      shippingCost: 1200.0,
      moq: 1000,
      prepTimeDays: 5,
      expiryDate: '٢٠٢٦/٠٨/١٥',
    ),
  ];
}

@riverpod
List<DeliveryComparisonItem> deliveryComparisonItems(DeliveryComparisonItemsRef ref) {
  return const [
    DeliveryComparisonItem(
      supplierId: 'sup_1',
      supplierName: 'شركة غزل المحلة الكبرى',
      prepTimeDays: 7,
      shippingTimeDays: 2,
      deliveryPerformance: '٩٨%',
      lateDeliveryPercent: 2.0,
    ),
    DeliveryComparisonItem(
      supplierId: 'sup_2',
      supplierName: 'مصنع النيل للأقمشة الحديثة',
      prepTimeDays: 12,
      shippingTimeDays: 3,
      deliveryPerformance: '٩٤%',
      lateDeliveryPercent: 5.5,
    ),
    DeliveryComparisonItem(
      supplierId: 'sup_3',
      supplierName: 'الفتح لخيوط البوليستر ومستلزمات المصانع',
      prepTimeDays: 5,
      shippingTimeDays: 4,
      deliveryPerformance: '٩٠%',
      lateDeliveryPercent: 9.8,
    ),
  ];
}
