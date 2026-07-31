import 'package:flutter/material.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';

class ProfileHeroBanner extends StatelessWidget {
  final String bannerUrl;
  final String logoUrl;

  const ProfileHeroBanner({
    super.key,
    required this.bannerUrl,
    required this.logoUrl,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Banner image showing textile factory floor
          Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(bannerUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Floating square logo
          Positioned(
            bottom: 0,
            right: 24,
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(color: Theme.of(context).colorScheme.surface, width: 3),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(17),
                child: Image.network(
                  logoUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.business, size: 40, color: AppColors.primary),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
