import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/supplier_profile.dart';
import '../../domain/repositories/profile_repository.dart';

part 'profile_repository_impl.g.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final List<CompanyCertificate> _certs = [
    const CompanyCertificate(name: 'شهادة مطابقة مواصفات الجودة ISO 9001', date: 'صالحة لغاية 2027-12', verified: true),
    const CompanyCertificate(name: 'شهادة منشأ للمنسوجات والقطنيات الرسمية', date: 'صالحة لغاية 2026-10', verified: true),
    const CompanyCertificate(name: 'رخصة التصدير الصناعية المعتمدة للمؤسسة', date: 'صالحة لغاية 2027-04', verified: true),
  ];

  late SupplierProfile _profile = SupplierProfile(
    companyName: 'مصنع نسيج الشرق للغزل والنسيج',
    managerName: 'أحمد محمد',
    email: 'ahmed@naseeji.com',
    phone: '+20 1012345678',
    city: 'المحلة الكبرى',
    rating: 4.9,
    completionRate: 97.4,
    logoUrl: 'https://images.unsplash.com/photo-1596461404969-9ae70f2830c1?auto=format&fit=crop&w=150&q=80',
    bannerUrl: 'https://images.unsplash.com/photo-1544816155-12df9643f363?auto=format&fit=crop&w=600&q=80',
    productsCount: 154,
    ordersCount: 382,
    certificates: _certs,
  );

  @override
  Future<SupplierProfile> getProfile() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _profile;
  }

  @override
  Future<void> updateProfile(SupplierProfile profile) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _profile = profile;
  }

  @override
  Future<void> addCertificate(CompanyCertificate cert) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _certs.insert(0, cert);
    _profile = _profile.copyWith(certificates: List.unmodifiable(_certs));
  }
}

@riverpod
ProfileRepository profileRepository(ProfileRepositoryRef ref) {
  return ProfileRepositoryImpl();
}
