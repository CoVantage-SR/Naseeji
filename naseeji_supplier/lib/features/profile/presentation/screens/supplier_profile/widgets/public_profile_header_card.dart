import 'package:flutter/material.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import 'package:naseeji_supplier/features/profile/domain/entities/supplier_profile.dart';

class PublicProfileHeaderCard extends StatelessWidget {
  final SupplierProfile profile;

  const PublicProfileHeaderCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Cover & Logo
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              height: 120,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(profile.bannerUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              bottom: -36,
              right: 20,
              child: Container(
                width: 102,
                height: 102,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: 0.05,
                      ),
                      blurRadius: 8,
                    ),
                  ],
                  image: DecorationImage(
                    image: NetworkImage(profile.logoUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 45),

        // Header Info
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 2,
                      vertical: 1,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2F9F5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.verified,
                          color: Color(0xFF006B5F),
                          size: 10,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'مورد معتمد',
                          style: TextStyle(
                            color: Color(0xFF006B5F),
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    profile.companyName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    '${profile.city}، SA',
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.outline,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.location_on_outlined,
                    color: AppColors.outline,
                    size: 12,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '${profile.rating} / 5.0 (تقييمات نسيجي)',
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.outline,
                    ),
                  ),
                  const SizedBox(width: 1),
                  const Icon(
                    Icons.star,
                    color: Colors.orange,
                    size: 12,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 1),

        // Public interaction actions
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10.0,
            vertical: 20,
          ),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم إرسال طلب تواصل للمورد.')),
                    );
                  },
                  icon: const Icon(
                    Icons.chat_bubble_outline,
                    size: 15,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'بدء دردشة ثنائية',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0040E0),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 1),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم حفظ المورد في قائمة المتابعة.')),
                    );
                  },
                  icon: const Icon(
                    Icons.person_add_alt_1_outlined,
                    size: 14,
                    color: Color(0xFF0040E0),
                  ),
                  label: const Text(
                    'متابعة المورد',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF0040E0),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: Color(0xFF0040E0),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
