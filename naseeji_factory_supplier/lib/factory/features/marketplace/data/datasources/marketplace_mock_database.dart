import 'package:flutter/material.dart';
import '../../domain/entities/marketplace_models.dart';

class MarketplaceMockDatabase {
  MarketplaceMockDatabase._();

  static Future<List<MarketplaceCategory>> getCategories() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return const [
      MarketplaceCategory(
        id: 'cat_1',
        name: 'أقمشة',
        icon: Icons.layers_rounded,
        isSelected: true,
      ),
      MarketplaceCategory(
        id: 'cat_2',
        name: 'خيوط',
        icon: Icons.gesture_rounded,
        isSelected: false,
      ),
      MarketplaceCategory(
        id: 'cat_3',
        name: 'إكسسوارات',
        icon: Icons.interests_rounded,
        isSelected: false,
      ),
      MarketplaceCategory(
        id: 'cat_4',
        name: 'أصباغ',
        icon: Icons.water_drop_outlined,
        isSelected: false,
      ),
      MarketplaceCategory(
        id: 'cat_5',
        name: 'مواد تعبئة',
        icon: Icons.inventory_2_outlined,
        isSelected: false,
      ),
      MarketplaceCategory(
        id: 'cat_6',
        name: 'ماكينات',
        icon: Icons.precision_manufacturing_outlined,
        isSelected: false,
      ),
      MarketplaceCategory(
        id: 'cat_7',
        name: 'مستلزمات إنتاج',
        icon: Icons.settings_outlined,
        isSelected: false,
      ),
    ];
  }

  static Future<List<ActiveFilterItem>> getActiveFilters() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return const [
      ActiveFilterItem(id: 'f1', label: 'قطن'),
      ActiveFilterItem(id: 'f2', label: 'القاهرة'),
      ActiveFilterItem(id: 'f3', label: 'MOQ أقل من 500'),
      ActiveFilterItem(id: 'f4', label: 'جاهز للتوريد'),
    ];
  }

  static Future<List<MarketplaceProduct>> getProducts() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return const [
      MarketplaceProduct(
        id: 'prod_m1',
        name: 'قماش قطن مصري',
        supplierName: 'النيل للأقمشة',
        isVerified: true,
        priceStart: 75.00,
        priceUnit: 'ج/متر',
        moq: '400 متر',
        productionCapacity: '40,000 متر/يوم',
        deliveryTime: '4 - 8 أيام',
        isAvailable: true,
        imageUrl: 'assets/images/products/fabric_blue.jpg',
        isFavorite: false,
      ),
      MarketplaceProduct(
        id: 'prod_m2',
        name: 'قماش جبرين',
        supplierName: 'مصر للأقمشة',
        isVerified: true,
        priceStart: 65.00,
        priceUnit: 'ج/متر',
        moq: '500 متر',
        productionCapacity: '30,000 متر/يوم',
        deliveryTime: '5 - 15 أيام',
        isAvailable: true,
        imageUrl: 'assets/images/products/fabric_grey.jpg',
        isFavorite: false,
      ),
      MarketplaceProduct(
        id: 'prod_m3',
        name: 'قماش تريكو قطن 100%',
        supplierName: 'الوطنية للغزل والنسيج',
        isVerified: true,
        priceStart: 85.00,
        priceUnit: 'ج/متر',
        moq: '300 متر',
        productionCapacity: '50,000 متر/يوم',
        deliveryTime: '3 - 7 أيام',
        isAvailable: true,
        imageUrl: 'assets/images/products/fabric_white.jpg',
        isFavorite: false,
      ),
    ];
  }

  static Future<List<MarketplaceSupplier>> getSuppliers() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return const [
      MarketplaceSupplier(
        id: 'sup_m1',
        name: 'النيل للأقمشة',
        isVerified: true,
        city: 'المحلة الكبرى',
        country: 'مصر',
        categories: 'أقمشة - خيوط',
        productCount: 312,
        rating: 4.8,
        logoUrl: 'assets/images/suppliers/nile.png',
      ),
      MarketplaceSupplier(
        id: 'sup_m2',
        name: 'مصر للأقمشة',
        isVerified: true,
        city: 'المنصورة',
        country: 'مصر',
        categories: 'أقمشة - تجهيز',
        productCount: 178,
        rating: 4.6,
        logoUrl: 'assets/images/suppliers/misr.png',
      ),
      MarketplaceSupplier(
        id: 'sup_m3',
        name: 'الوطنية للغزل والنسيج',
        isVerified: true,
        city: 'القاهرة',
        country: 'مصر',
        categories: 'أقمشة - خيوط - أصباغ',
        productCount: 245,
        rating: 4.7,
        logoUrl: 'assets/images/suppliers/wataniya.png',
      ),
    ];
  }

  static Future<List<RecommendedProductItem>> getRecommendedProducts() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return const [
      RecommendedProductItem(
        id: 'rec_1',
        name: 'سوستة معدنية',
        price: 5.50,
        priceUnit: 'ج/قطعة',
        moq: '500 قطعة',
        imageUrl: 'assets/images/products/zipper.jpg',
      ),
      RecommendedProductItem(
        id: 'rec_2',
        name: 'خيط قطن',
        price: 70.00,
        priceUnit: 'ج/كجم',
        moq: '150 كجم',
        imageUrl: 'assets/images/products/cotton_thread.jpg',
      ),
      RecommendedProductItem(
        id: 'rec_3',
        name: 'قماش مارينو',
        price: 110.00,
        priceUnit: 'ج/متر',
        moq: '300 متر',
        imageUrl: 'assets/images/products/marino_fabric.jpg',
      ),
      RecommendedProductItem(
        id: 'rec_4',
        name: 'خيط بوليستر',
        price: 55.00,
        priceUnit: 'ج/كجم',
        moq: '100 كجم',
        imageUrl: 'assets/images/products/poly_thread.jpg',
      ),
      RecommendedProductItem(
        id: 'rec_5',
        name: 'قماش شرشيب',
        price: 90.00,
        priceUnit: 'ج/متر',
        moq: '200 متر',
        imageUrl: 'assets/images/products/fringe_fabric.jpg',
      ),
    ];
  }

  static Future<List<String>> getRecentSearches() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return const [
      'قماش تريكو قطن',
      'خيط بوليستر',
      'أصباغ صباغة',
      'سوستة مخفية',
      'قماش جبرين',
    ];
  }
}



