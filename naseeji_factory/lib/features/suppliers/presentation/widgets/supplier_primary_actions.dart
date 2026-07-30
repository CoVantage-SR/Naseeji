import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_radius.dart';
import '../../../products/presentation/providers/products_provider.dart';
import '../../../products/presentation/providers/suppliers_provider.dart';
import '../../../products/presentation/widgets/product_details/create_rfq_modal.dart';
import 'internal_contact_center_modal.dart';

/// Primary Actions Row:
/// 1. إرسال RFQ (Filled Primary Blue)
/// 2. بدء محادثة (Outlined Blue)
/// 3. مقارنة المنتجات (Outlined Blue)
/// 4. الاتصال (Outlined Blue)
class SupplierPrimaryActions extends StatelessWidget {
  final Supplier supplier;
  final Product defaultProduct;

  const SupplierPrimaryActions({
    super.key,
    required this.supplier,
    required this.defaultProduct,
  });

  void _showRfqModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CreateRfqModal(product: defaultProduct),
    );
  }

  void _showInternalContactModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => InternalContactCenterModal(supplier: supplier),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Row(
      children: [
        // 1. إرسال RFQ (Primary Filled Button)
        Expanded(
          flex: 3,
          child: ElevatedButton.icon(
            onPressed: () => _showRfqModal(context),
            icon: const Icon(Icons.send_rounded, size: 16),
            label: const Text(
              'إرسال RFQ',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: AppRadius.rSM),
            ),
          ),
        ),
        const SizedBox(width: 6),

        // 2. بدء محادثة (Outlined Button)
        Expanded(
          flex: 3,
          child: OutlinedButton.icon(
            onPressed: () {
              // Direct internal chat route
              context.push('/chat/chat_1');
            },
            icon: const Icon(Icons.chat_bubble_outline_rounded, size: 16),
            label: const Text(
              'بدء محادثة',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: primaryColor,
              side: BorderSide(color: primaryColor, width: 1.2),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: AppRadius.rSM),
            ),
          ),
        ),
        const SizedBox(width: 6),

        // 3. مقارنة المنتجات (Outlined Button)
        Expanded(
          flex: 3,
          child: OutlinedButton.icon(
            onPressed: () => context.push('/suppliers-comparison'),
            icon: const Icon(Icons.balance_rounded, size: 16),
            label: const Text(
              'مقارنة المنتجات',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: primaryColor,
              side: BorderSide(color: primaryColor, width: 1.2),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: AppRadius.rSM),
            ),
          ),
        ),
        const SizedBox(width: 6),

        // 4. الاتصال (Outlined Button)
        Expanded(
          flex: 2,
          child: OutlinedButton.icon(
            onPressed: () => _showInternalContactModal(context),
            icon: const Icon(Icons.phone_outlined, size: 16),
            label: const Text(
              'الاتصال',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: primaryColor,
              side: BorderSide(color: primaryColor, width: 1.2),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: AppRadius.rSM),
            ),
          ),
        ),
      ],
    );
  }
}
