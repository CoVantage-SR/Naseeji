import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'mini_profile_provider.g.dart';

class FactoryProfile {
  final String logoUrl;
  final String name;
  final String legalEntity;
  final List<String> businessCategories;
  final String governorate;
  final String city;
  final int totalOrders;
  final int totalRfqs;
  final int totalFavoriteSuppliers;
  final String accountStatus; // 'verified', 'pending', 'unverified'

  FactoryProfile({
    required this.logoUrl,
    required this.name,
    required this.legalEntity,
    required this.businessCategories,
    required this.governorate,
    required this.city,
    required this.totalOrders,
    required this.totalRfqs,
    required this.totalFavoriteSuppliers,
    required this.accountStatus,
  });
}

@riverpod
class MiniProfileNotifier extends _$MiniProfileNotifier {
  @override
  FactoryProfile build() {
    return FactoryProfile(
      logoUrl: '',
      name: 'مصنع النسيج الحديث',
      legalEntity: 'مصنع',
      businessCategories: ['ملابس جاهزة', 'ملابس رياضية', 'أقمشة'],
      governorate: 'القاهرة',
      city: 'شبرا الخيمة',
      totalOrders: 57,
      totalRfqs: 24,
      totalFavoriteSuppliers: 8,
      accountStatus: 'verified',
    );
  }

  void updateLogo(String url) {
    state = FactoryProfile(
      logoUrl: url,
      name: state.name,
      legalEntity: state.legalEntity,
      businessCategories: state.businessCategories,
      governorate: state.governorate,
      city: state.city,
      totalOrders: state.totalOrders,
      totalRfqs: state.totalRfqs,
      totalFavoriteSuppliers: state.totalFavoriteSuppliers,
      accountStatus: state.accountStatus,
    );
  }
}

