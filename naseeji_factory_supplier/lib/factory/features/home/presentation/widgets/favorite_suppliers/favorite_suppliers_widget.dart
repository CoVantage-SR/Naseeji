import 'package:flutter/material.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../domain/entities/home_entities.dart';
import '../common/section_header_widget.dart';
import 'supplier_card_widget.dart';

class FavoriteSuppliersWidget extends StatelessWidget {
  final List<FavoriteSupplier> suppliers;
  final VoidCallback? onHeaderActionTap;
  final ValueChanged<FavoriteSupplier> onViewProfile;
  final ValueChanged<FavoriteSupplier> onSendRfq;

  const FavoriteSuppliersWidget({
    super.key,
    required this.suppliers,
    required this.onViewProfile,
    required this.onSendRfq,
    this.onHeaderActionTap,
  });

  @override
  Widget build(BuildContext context) {
    final columnsCount = context.responsiveValue(mobile: 1, tablet: 2).toInt();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeaderWidget(
          title: 'الموردون المفضلون',
          onActionTap: onHeaderActionTap,
        ),
        const SizedBox(height: 12),
        if (suppliers.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: Text('لا يوجد موردون مفضلون حالياً.'),
            ),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columnsCount,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: context.responsiveValue(mobile: 2.1, tablet: 2.3),
            ),
            itemCount: suppliers.length,
            itemBuilder: (context, index) {
              final supplier = suppliers[index];
              return SupplierCardWidget(
                supplier: supplier,
                onViewProfileTap: () => onViewProfile(supplier),
                onSendRfqTap: () => onSendRfq(supplier),
              );
            },
          ),
      ],
    );
  }
}


