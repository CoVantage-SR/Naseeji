import 'package:flutter/material.dart';

@immutable
class MarketplaceCategory {
  final String id;
  final String name;
  final IconData icon;
  final bool isSelected;

  const MarketplaceCategory({
    required this.id,
    required this.name,
    required this.icon,
    this.isSelected = false,
  });

  MarketplaceCategory copyWith({
    String? id,
    String? name,
    IconData? icon,
    bool? isSelected,
  }) {
    return MarketplaceCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}

@immutable
class MarketplaceProduct {
  final String id;
  final String name;
  final String supplierName;
  final bool isVerified;
  final double priceStart;
  final String priceUnit;
  final String moq;
  final String productionCapacity;
  final String deliveryTime;
  final bool isAvailable;
  final String imageUrl;
  final bool isFavorite;

  const MarketplaceProduct({
    required this.id,
    required this.name,
    required this.supplierName,
    required this.isVerified,
    required this.priceStart,
    required this.priceUnit,
    required this.moq,
    required this.productionCapacity,
    required this.deliveryTime,
    required this.isAvailable,
    required this.imageUrl,
    this.isFavorite = false,
  });

  MarketplaceProduct copyWith({
    String? id,
    String? name,
    String? supplierName,
    bool? isVerified,
    double? priceStart,
    String? priceUnit,
    String? moq,
    String? productionCapacity,
    String? deliveryTime,
    bool? isAvailable,
    String? imageUrl,
    bool? isFavorite,
  }) {
    return MarketplaceProduct(
      id: id ?? this.id,
      name: name ?? this.name,
      supplierName: supplierName ?? this.supplierName,
      isVerified: isVerified ?? this.isVerified,
      priceStart: priceStart ?? this.priceStart,
      priceUnit: priceUnit ?? this.priceUnit,
      moq: moq ?? this.moq,
      productionCapacity: productionCapacity ?? this.productionCapacity,
      deliveryTime: deliveryTime ?? this.deliveryTime,
      isAvailable: isAvailable ?? this.isAvailable,
      imageUrl: imageUrl ?? this.imageUrl,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

@immutable
class MarketplaceSupplier {
  final String id;
  final String name;
  final bool isVerified;
  final String city;
  final String country;
  final String categories;
  final int productCount;
  final double rating;
  final String logoUrl;

  const MarketplaceSupplier({
    required this.id,
    required this.name,
    required this.isVerified,
    required this.city,
    required this.country,
    required this.categories,
    required this.productCount,
    required this.rating,
    required this.logoUrl,
  });
}

@immutable
class RecommendedProductItem {
  final String id;
  final String name;
  final double price;
  final String priceUnit;
  final String moq;
  final String imageUrl;

  const RecommendedProductItem({
    required this.id,
    required this.name,
    required this.price,
    required this.priceUnit,
    required this.moq,
    required this.imageUrl,
  });
}

@immutable
class ActiveFilterItem {
  final String id;
  final String label;

  const ActiveFilterItem({
    required this.id,
    required this.label,
  });
}



