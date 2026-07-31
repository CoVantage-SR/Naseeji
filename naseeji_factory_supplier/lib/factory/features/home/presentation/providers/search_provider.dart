import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_provider.g.dart';

class SearchFilters {
  final String category;
  final String city;
  final String governorate;
  final double maxPrice;
  final double minRating;
  final double maxMinOrder;
  final int maxDeliveryTimeDays;

  SearchFilters({
    this.category = '',
    this.city = '',
    this.governorate = '',
    this.maxPrice = 100000,
    this.minRating = 0.0,
    this.maxMinOrder = 50000,
    this.maxDeliveryTimeDays = 30,
  });

  SearchFilters copyWith({
    String? category,
    String? city,
    String? governorate,
    double? maxPrice,
    double? minRating,
    double? maxMinOrder,
    int? maxDeliveryTimeDays,
  }) {
    return SearchFilters(
      category: category ?? this.category,
      city: city ?? this.city,
      governorate: governorate ?? this.governorate,
      maxPrice: maxPrice ?? this.maxPrice,
      minRating: minRating ?? this.minRating,
      maxMinOrder: maxMinOrder ?? this.maxMinOrder,
      maxDeliveryTimeDays: maxDeliveryTimeDays ?? this.maxDeliveryTimeDays,
    );
  }
}

class SearchState {
  final String query;
  final String searchType; // 'products', 'suppliers', 'orders', 'rfqs'
  final SearchFilters filters;
  final List<Map<String, dynamic>> results;

  SearchState({
    required this.query,
    required this.searchType,
    required this.filters,
    required this.results,
  });

  SearchState copyWith({
    String? query,
    String? searchType,
    SearchFilters? filters,
    List<Map<String, dynamic>>? results,
  }) {
    return SearchState(
      query: query ?? this.query,
      searchType: searchType ?? this.searchType,
      filters: filters ?? this.filters,
      results: results ?? this.results,
    );
  }
}

@riverpod
class SearchNotifier extends _$SearchNotifier {
  // All mock items
  late final List<Map<String, dynamic>> _mockProducts;
  late final List<Map<String, dynamic>> _mockSuppliers;
  late final List<Map<String, dynamic>> _mockOrders;
  late final List<Map<String, dynamic>> _mockRfqs;

  @override
  SearchState build() {
    _mockProducts = [
      {
        'title': 'خيوط قطن ممشط ١٠٠٪',
        'supplier': 'الشركة الدولية للخيوط',
        'price': 150.0,
        'rating': 4.7,
        'image': 'https://images.unsplash.com/photo-1606744824163-985d376605aa',
        'category': 'خيوط',
        'governorate': 'الغربية',
        'city': 'المحلة الكبرى',
        'min_order': 2000.0,
        'delivery_time': 3,
      },
      {
        'title': 'قماش جبردين تركي',
        'supplier': 'مصنع النيل للأقمشة',
        'price': 85.0,
        'rating': 4.5,
        'image': 'https://images.unsplash.com/photo-1544816155-12df9643f363',
        'category': 'أقمشة',
        'governorate': 'القاهرة',
        'city': 'شبرا',
        'min_order': 5000.0,
        'delivery_time': 5,
      },
      {
        'title': 'أزرار بلاستيك ملونة',
        'supplier': 'الفتح لمستلزمات المصانع',
        'price': 12.0,
        'rating': 4.2,
        'image': 'https://images.unsplash.com/photo-1595180632598-dfd9a8c62c3e',
        'category': 'إكسسوارات',
        'governorate': 'الجيزة',
        'city': 'الدقي',
        'min_order': 500.0,
        'delivery_time': 2,
      },
    ];

    _mockSuppliers = [
      {
        'name': 'شركة مصر للغزل والنسيج',
        'rating': 4.9,
        'specialization': 'غزل ونسيج قطن وبوليستر',
        'logo_url': '',
        'governorate': 'الغربية',
        'city': 'المحلة الكبرى',
        'min_order': 10000.0,
        'delivery_time': 7,
      },
      {
        'name': 'الشرق للأقمشة والحرير',
        'rating': 4.8,
        'specialization': 'أقمشة فاخرة ومفروشات',
        'logo_url': '',
        'governorate': 'القاهرة',
        'city': 'مصر الجديدة',
        'min_order': 5000.0,
        'delivery_time': 4,
      },
    ];

    _mockOrders = [
      {
        'title': 'طلب خيوط بوليستر ملونة',
        'supplier': 'الشركة الدولية للخيوط',
        'price': 25000.0,
        'rating': 4.7,
        'id': 'ORD-9843',
        'governorate': 'الغربية',
        'city': 'المحلة الكبرى',
        'min_order': 2000.0,
        'delivery_time': 3,
      },
    ];

    _mockRfqs = [
      {
        'title': 'طلب توريد أقمشة جينز ليكرا',
        'supplier': 'مصنع النيل للأقمشة',
        'price': 18500.0,
        'rating': 4.5,
        'id': 'rfq_102',
        'governorate': 'القاهرة',
        'city': 'شبرا',
        'min_order': 5000.0,
        'delivery_time': 5,
      },
    ];

    return SearchState(
      query: '',
      searchType: 'products',
      filters: SearchFilters(),
      results: _mockProducts,
    );
  }

  void updateQuery(String newQuery) {
    state = state.copyWith(query: newQuery);
    _performSearch();
  }

  void updateSearchType(String newType) {
    state = state.copyWith(searchType: newType);
    _performSearch();
  }

  void updateFilters(SearchFilters newFilters) {
    state = state.copyWith(filters: newFilters);
    _performSearch();
  }

  void resetFilters() {
    state = state.copyWith(filters: SearchFilters());
    _performSearch();
  }

  void _performSearch() {
    final query = state.query.trim().toLowerCase();
    final type = state.searchType;
    final filters = state.filters;

    List<Map<String, dynamic>> sourceList;
    if (type == 'suppliers') {
      sourceList = _mockSuppliers;
    } else if (type == 'orders') {
      sourceList = _mockOrders;
    } else if (type == 'rfqs') {
      sourceList = _mockRfqs;
    } else {
      sourceList = _mockProducts;
    }

    final filtered = sourceList.where((item) {
      // 1. Text Search Filter
      final name = ((item['title'] ?? item['name'] ?? '') as String).toLowerCase();
      final supplier = ((item['supplier'] ?? '') as String).toLowerCase();
      final matchesQuery = name.contains(query) || supplier.contains(query);

      if (!matchesQuery) return false;

      // 2. Category Filter
      if (filters.category.isNotEmpty && item['category'] != null) {
        if (item['category'].toString().toLowerCase() != filters.category.toLowerCase()) {
          return false;
        }
      }

      // 3. Governorate Filter
      if (filters.governorate.isNotEmpty && item['governorate'] != null) {
        if (item['governorate'].toString().toLowerCase() != filters.governorate.toLowerCase()) {
          return false;
        }
      }

      // 4. City Filter
      if (filters.city.isNotEmpty && item['city'] != null) {
        if (item['city'].toString().toLowerCase() != filters.city.toLowerCase()) {
          return false;
        }
      }

      // 5. Price Filter (if exists)
      if (item['price'] != null && (item['price'] as double) > filters.maxPrice) {
        return false;
      }

      // 6. Rating Filter
      if (item['rating'] != null && (item['rating'] as double) < filters.minRating) {
        return false;
      }

      // 7. Minimum Order Filter
      if (item['min_order'] != null && (item['min_order'] as double) > filters.maxMinOrder) {
        return false;
      }

      // 8. Delivery Time Filter
      if (item['delivery_time'] != null && (item['delivery_time'] as int) > filters.maxDeliveryTimeDays) {
        return false;
      }

      return true;
    }).toList();

    state = state.copyWith(results: filtered);
  }
}



