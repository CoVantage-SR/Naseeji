import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_factory/supplier/core/theme/app_colors.dart';
import '../../../domain/entities/rfq_item.dart';
import 'rfq_item_card.dart';

class RfqAppBar extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const RfqAppBar({super.key, required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.surface,
      elevation: 0.5,
      leading: IconButton(
        icon: Icon(Icons.menu, color: AppColors.onSurfaceVariant),
        onPressed: () => scaffoldKey.currentState?.openDrawer(),
      ),
      centerTitle: true,
      title: Text(
        'طلبات الأسعار (RFQ)',
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.search, color: AppColors.onSurfaceVariant),
          onPressed: () => context.push('/search'),
        ),
        Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              icon: const Icon(
                Icons.notifications_none,
                color: AppColors.onSurfaceVariant,
              ),
              onPressed: () => context.push('/notifications'),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: AppColors.error,
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(
                  minWidth: 14,
                  minHeight: 14,
                ),
                child: Text(
                  '3',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.surface,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(width: 8),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class RfqSearchBar extends StatelessWidget {
  const RfqSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: TextField(
        decoration: InputDecoration(
          hintText: 'ابحث في طلبات الأسعار...',
          hintStyle: TextStyle(
            color: AppColors.outline,
            fontSize: 13,
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: AppColors.outline,
            size: 20,
          ),
          fillColor: Colors.white,
          filled: true,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Color(0xFFE2E1EF),
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Color(0xFFE2E1EF),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: AppColors.primary,
              width: 1,
            ),
          ),
        ),
      ),
    );
  }
}

class RfqFilterSortRow extends StatelessWidget {
  final VoidCallback? onFilterPressed;
  final VoidCallback? onSortPressed;

  const RfqFilterSortRow({
    super.key,
    this.onFilterPressed,
    this.onSortPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onFilterPressed,
            icon: const Icon(
              Icons.tune,
              size: 16,
              color: AppColors.onSurfaceVariant,
            ),
            label: Text(
              'تصفية',
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(
                color: Color(0xFFE2E1EF),
                width: 1,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 10),
              backgroundColor: Theme.of(context).colorScheme.surface,
            ),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onSortPressed,
            icon: const Icon(
              Icons.sort,
              size: 16,
              color: AppColors.onSurfaceVariant,
            ),
            label: Text(
              'ترتيب',
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(
                color: Color(0xFFE2E1EF),
                width: 1,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 10),
              backgroundColor: Theme.of(context).colorScheme.surface,
            ),
          ),
        ),
      ],
    );
  }
}

class RfqItemsList extends StatelessWidget {
  final List<RfqItem> items;

  const RfqItemsList({super.key, required this.items});

  IconData? _getIconData(String? type) {
    if (type == 'more') {
      return Icons.more_horiz;
    } else if (type == 'chat') {
      return Icons.chat_bubble_outline;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return RfqItemCard(
          companyName: item.companyName,
          rfqNumber: item.rfqNumber,
          material: item.material,
          status: item.status,
          statusColor: Color(item.statusColorValue),
          statusBgColor: Color(item.statusBgColorValue),
          quantity: item.quantity,
          location: item.location,
          dateLabel: item.dateLabel,
          dateValue: item.dateValue,
          logoText: item.logoText,
          logoBgColor: Color(item.logoBgColorValue),
          actionButtonText: item.actionButtonText,
          actionButtonColor: Color(item.actionButtonColorValue),
          actionButtonTextColor: Color(item.actionButtonTextColorValue),
          actionButtonIsOutlined: item.actionButtonIsOutlined,
          hasIconButton: item.hasIconButton,
          iconButtonIcon: _getIconData(item.iconButtonIconType),
          onIconButtonPressed: () {
            final id = item.rfqNumber.replaceAll("RFQ-", "");
            if (item.iconButtonIconType == 'chat') {
              context.push('/orders/chat?rfqId=$id');
            } else {
              context.push('/orders/activity-log?rfqId=$id');
            }
          },
          onActionButtonPressed: () {
            final id = item.rfqNumber.replaceAll("RFQ-", "");
            if (item.actionButtonText == 'تقديم عرض') {
              context.push('/rfq-details?rfqId=$id');
            } else {
              context.push('/orders/order-center?rfqId=$id');
            }
          },
        );
      },
    );
  }
}
