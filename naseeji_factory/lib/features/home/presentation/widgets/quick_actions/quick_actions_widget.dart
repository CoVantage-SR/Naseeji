import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/extensions/context_extensions.dart';
import '../common/section_header_widget.dart';
import 'quick_action_item.dart';

class QuickActionsWidget extends StatelessWidget {
  final VoidCallback onCreateRfq;
  final VoidCallback onSearchSupplier;
  final VoidCallback onOrders;
  final VoidCallback onMessages;
  final VoidCallback onReports;
  final VoidCallback onFavoriteSuppliers;

  const QuickActionsWidget({
    super.key,
    required this.onCreateRfq,
    required this.onSearchSupplier,
    required this.onOrders,
    required this.onMessages,
    required this.onReports,
    required this.onFavoriteSuppliers,
  });

  @override
  Widget build(BuildContext context) {
    final columnsCount = context.responsiveValue(mobile: 3, tablet: 6).toInt();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeaderWidget(title: 'إجراءات سريعة'),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: columnsCount,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.0,
          children: [
            QuickActionItemWidget(
              title: 'إنشاء طلب RFQ',
              icon: Icons.add_circle_outline_rounded,
              color: AppColors.primary,
              onTap: onCreateRfq,
            ),
            QuickActionItemWidget(
              title: 'البحث عن مورد',
              icon: Icons.search_rounded,
              color: AppColors.secondary,
              onTap: onSearchSupplier,
            ),
            QuickActionItemWidget(
              title: 'متابعة الطلبات',
              icon: Icons.receipt_long_outlined,
              color: AppColors.info,
              onTap: onOrders,
            ),
            QuickActionItemWidget(
              title: 'الرسائل والمحادثات',
              icon: Icons.chat_bubble_outline_rounded,
              color: Colors.purple,
              onTap: onMessages,
            ),
            QuickActionItemWidget(
              title: 'التقارير والإحصاءات',
              icon: Icons.analytics_outlined,
              color: Colors.orange,
              onTap: onReports,
            ),
            QuickActionItemWidget(
              title: 'المفضلين',
              icon: Icons.favorite_rounded,
              color: AppColors.success,
              onTap: onFavoriteSuppliers,
            ),
          ],
        ),
      ],
    );
  }
}
