import 'package:flutter/material.dart';
import '../providers/purchases_provider.dart';
import 'purchases_reusable_widgets.dart';

// ─── Favorite Suppliers Header ─────────────────────────────────────────────
class FavoriteSuppliersHeaderWidget extends StatelessWidget {
  final int count;
  const FavoriteSuppliersHeaderWidget({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'الموردين المفضلين',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            Text(
              '$count مورد في قائمتك المفضلة',
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
        const Icon(Icons.favorite_rounded, color: Colors.red, size: 28),
      ],
    );
  }
}

// ─── Favorite Suppliers List Widget ───────────────────────────────────────
class FavoriteSuppliersListWidget extends StatelessWidget {
  final List<FavoriteSupplierModel> suppliers;
  final VoidCallback Function(String) onViewProfile;
  final VoidCallback Function(String) onSendRFQ;
  final VoidCallback Function(String) onStartChat;
  final VoidCallback Function(String) onRemoveFavorite;

  const FavoriteSuppliersListWidget({
    super.key,
    required this.suppliers,
    required this.onViewProfile,
    required this.onSendRFQ,
    required this.onStartChat,
    required this.onRemoveFavorite,
  });

  @override
  Widget build(BuildContext context) {
    if (suppliers.isEmpty) {
      return const EmptyStateWidget(
        title: 'لا يوجد موردون مفضلون',
        description: 'أضف الموردين المميزين إلى قائمة المفضلة للوصول السريع إليهم.',
        icon: Icons.favorite_border_rounded,
      );
    }
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: suppliers.length,
      itemBuilder: (context, index) {
        final s = suppliers[index];
        return SupplierCard(
          supplier: s,
          onViewProfile: onViewProfile(s.id),
          onSendRFQ: onSendRFQ(s.id),
          onStartChat: onStartChat(s.id),
          onRemoveFavorite: onRemoveFavorite(s.id),
        );
      },
    );
  }
}
