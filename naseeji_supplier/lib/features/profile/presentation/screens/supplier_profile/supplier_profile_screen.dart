import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../../controllers/profile_controller.dart';
import 'widgets/profile_badge.dart';
import 'widgets/profile_section_tile.dart';

class SupplierProfileScreen extends ConsumerWidget {
  const SupplierProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('الملف الشخصي للمورد'),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.onSurface,
        elevation: 0.5,
      ),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('خطأ: $err')),
        data: (profile) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Banner & Logo Stack
                SizedBox(
                  height: 180,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Image.network(
                        profile.bannerUrl,
                        width: double.infinity,
                        height: 140,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 140,
                          color: AppColors.primaryContainer.withValues(alpha: 0.1),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 24,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border: Border.all(color: Colors.white, width: 4),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(40),
                            child: Image.network(
                              profile.logoUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.business, size: 40, color: AppColors.primary),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Company Name & City
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile.companyName,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.onSurface),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, size: 16, color: AppColors.onSurfaceVariant),
                          const SizedBox(width: 4),
                          Text(profile.city, style: const TextStyle(fontSize: 13, color: AppColors.onSurfaceVariant)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Stats Dashboard Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ProfileBadge(
                          icon: Icons.star,
                          label: 'التقييم',
                          value: '${profile.rating} / 5.0',
                          color: Colors.amber,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ProfileBadge(
                          icon: Icons.done_all,
                          label: 'معدل التوريد',
                          value: '${profile.completionRate}%',
                          color: AppColors.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Profile Sections List
                ProfileSectionTile(
                  icon: Icons.business,
                  title: 'بيانات الشركة والمسؤول',
                  subtitle: 'المسؤول: ${profile.managerName}',
                ),
                ProfileSectionTile(
                  icon: Icons.email_outlined,
                  title: 'معلومات الاتصال',
                  subtitle: '${profile.email}\n${profile.phone}',
                ),
                ProfileSectionTile(
                  icon: Icons.inventory_2_outlined,
                  title: 'إحصائيات المنتجات',
                  subtitle: 'إجمالي المنتجات: ${profile.productsCount} | طلبات ناجحة: ${profile.ordersCount}',
                ),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }
}
