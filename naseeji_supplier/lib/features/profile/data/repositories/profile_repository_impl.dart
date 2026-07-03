import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/supplier_profile.dart';
import '../../domain/repositories/profile_repository.dart';

part 'profile_repository_impl.g.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  @override
  Future<SupplierProfile> getProfile() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return const SupplierProfile(
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
    );
  }
}

@riverpod
ProfileRepository profileRepository(ProfileRepositoryRef ref) {
  return ProfileRepositoryImpl();
}
