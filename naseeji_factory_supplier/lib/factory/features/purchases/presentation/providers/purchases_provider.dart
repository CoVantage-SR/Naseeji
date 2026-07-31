import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../orders/presentation/providers/orders_provider.dart';

part 'purchases_provider.g.dart';

class PurchaseModel {
  final OrderModel order;
  final String invoiceNumber;
  final String supplierLogo;
  final double? supplierRating; // Null if not rated yet
  final String status; // 'completed', 'cancelled', 'returned', 'replacement'

  PurchaseModel({
    required this.order,
    required this.invoiceNumber,
    required this.supplierLogo,
    this.supplierRating,
    required this.status,
  });

  PurchaseModel copyWith({
    OrderModel? order,
    String? invoiceNumber,
    String? supplierLogo,
    double? supplierRating,
    String? status,
  }) {
    return PurchaseModel(
      order: order ?? this.order,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      supplierLogo: supplierLogo ?? this.supplierLogo,
      supplierRating: supplierRating ?? this.supplierRating,
      status: status ?? this.status,
    );
  }
}

class InvoiceModel {
  final String invoiceNumber;
  final String orderId;
  final String supplierName;
  final String invoiceDate;
  final String dueDate;
  final double totalAmount;
  final String paymentStatus; // 'مدفوعة' (Paid), 'قيد التحصيل' (Pending), 'ملغاة' (Cancelled)

  InvoiceModel({
    required this.invoiceNumber,
    required this.orderId,
    required this.supplierName,
    required this.invoiceDate,
    required this.dueDate,
    required this.totalAmount,
    required this.paymentStatus,
  });
}

class FavoriteSupplierModel {
  final String id;
  final String name;
  final String logo;
  final String type;
  final double rating;
  final int completedOrders;
  final String avgDeliveryTime;
  final String avgResponseTime;
  final String avgPriceLevel; // 'منخفض' (Low), 'متوسط' (Medium), 'مرتفع' (High)
  final String lastOrderDate;
  final bool isFavorite;

  FavoriteSupplierModel({
    required this.id,
    required this.name,
    required this.logo,
    required this.type,
    required this.rating,
    required this.completedOrders,
    required this.avgDeliveryTime,
    required this.avgResponseTime,
    required this.avgPriceLevel,
    required this.lastOrderDate,
    this.isFavorite = true,
  });

  FavoriteSupplierModel copyWith({
    bool? isFavorite,
  }) {
    return FavoriteSupplierModel(
      id: id,
      name: name,
      logo: logo,
      type: type,
      rating: rating,
      completedOrders: completedOrders,
      avgDeliveryTime: avgDeliveryTime,
      avgResponseTime: avgResponseTime,
      avgPriceLevel: avgPriceLevel,
      lastOrderDate: lastOrderDate,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

final List<FavoriteSupplierModel> _mockFavoriteSuppliers = [
  FavoriteSupplierModel(
    id: 'SUP-01',
    name: 'مصنع غزل المحلة',
    logo: 'https://images.unsplash.com/photo-1544816155-12df9643f363',
    type: 'خيوط وألياف قطنية',
    rating: 4.8,
    completedOrders: 28,
    avgDeliveryTime: '٥ أيام',
    avgResponseTime: '١٠ دقائق',
    avgPriceLevel: 'متوسط',
    lastOrderDate: '٢٠٢٦/٠٧/١٢',
  ),
  FavoriteSupplierModel(
    id: 'SUP-02',
    name: 'منسوجات النيل الحديثة',
    logo: 'https://images.unsplash.com/photo-1584622650111-993a426fbf0a',
    type: 'أقمشة ملونة وبوليستر',
    rating: 4.5,
    completedOrders: 15,
    avgDeliveryTime: '٧ أيام',
    avgResponseTime: '٣٠ دقيقة',
    avgPriceLevel: 'منخفض',
    lastOrderDate: '٢٠٢٦/٠٧/٠٢',
  ),
  FavoriteSupplierModel(
    id: 'SUP-03',
    name: 'حلوان لصناعة الغزل',
    logo: 'https://images.unsplash.com/photo-1528459801416-a9e53bbf4e17',
    type: 'أقمشة بوليستر وصوف',
    rating: 4.2,
    completedOrders: 42,
    avgDeliveryTime: '٤ أيام',
    avgResponseTime: '١٥ دقيقة',
    avgPriceLevel: 'مرتفع',
    lastOrderDate: '٢٠٢٦/٠٧/٠٥',
  ),
];

@riverpod
class PurchasesNotifier extends _$PurchasesNotifier {
  @override
  Map<String, dynamic> build() {
    // Initial state holds favorites list and rated status map
    return {
      'favorites': _mockFavoriteSuppliers,
      'ratings': <String, double>{
        'ORD-204': 5.0, // Default mock rating for ORD-204
      },
    };
  }

  List<FavoriteSupplierModel> getFavorites() {
    return List<FavoriteSupplierModel>.from(state['favorites'] ?? []);
  }

  void toggleFavorite(String supplierId) {
    final list = getFavorites();
    final updatedList = list.map((s) {
      if (s.id == supplierId) {
        return s.copyWith(isFavorite: !s.isFavorite);
      }
      return s;
    }).toList();

    state = {
      ...state,
      'favorites': updatedList,
    };
  }

  void addSupplierRating(String orderId, double rating) {
    final ratings = Map<String, double>.from(state['ratings'] ?? {});
    ratings[orderId] = rating;

    state = {
      ...state,
      'ratings': ratings,
    };
  }

  double? getSupplierRating(String orderId) {
    final ratings = Map<String, double>.from(state['ratings'] ?? {});
    return ratings[orderId];
  }

  List<PurchaseModel> getPurchases(List<OrderModel> orders) {
    // Wrap orders list into purchases based on their statuses
    return orders.map((o) {
      String purchaseStatus = 'completed';
      if (o.status == 'cancelled') {
        purchaseStatus = 'cancelled';
      } else if (o.status == 'returnRequested' || o.status == 'returned') {
        purchaseStatus = 'returned';
      } else if (o.status == 'replacementRequested' || o.status == 'replaced') {
        purchaseStatus = 'replacement';
      } else if (o.status == 'delivered' || o.status == 'completed') {
        purchaseStatus = 'completed';
      } else {
        // Active orders that are shipping or preparing are displayed in 'All' tab but not marked completed yet
        purchaseStatus = 'completed';
      }

      // Generate invoice number
      final invoiceNum = 'INV-${o.id.replaceAll("ORD-", "88210")}-EG';

      // Mock supplier logo based on name
      String logo = 'https://images.unsplash.com/photo-1544816155-12df9643f363';
      if (o.supplierName.contains('المحلة')) {
        logo = 'https://images.unsplash.com/photo-1544816155-12df9643f363';
      } else if (o.supplierName.contains('النيل')) {
        logo = 'https://images.unsplash.com/photo-1584622650111-993a426fbf0a';
      } else if (o.supplierName.contains('حلوان')) {
        logo = 'https://images.unsplash.com/photo-1528459801416-a9e53bbf4e17';
      }

      final rating = getSupplierRating(o.id);

      return PurchaseModel(
        order: o,
        invoiceNumber: invoiceNum,
        supplierLogo: logo,
        supplierRating: rating,
        status: purchaseStatus,
      );
    }).toList();
  }

  List<InvoiceModel> getInvoices(List<PurchaseModel> purchases) {
    return purchases.map((p) {
      String payStatus = 'مدفوعة';
      if (p.status == 'cancelled') {
        payStatus = 'ملغاة';
      } else if (p.status == 'returned') {
        payStatus = 'تم الارتجاع';
      }

      return InvoiceModel(
        invoiceNumber: p.invoiceNumber,
        orderId: p.order.id,
        supplierName: p.order.supplierName,
        invoiceDate: p.order.orderDate,
        dueDate: p.order.expectedDeliveryDate,
        totalAmount: p.order.finalPrice,
        paymentStatus: payStatus,
      );
    }).toList();
  }
}



