import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../providers/rfq_provider.dart';

// ══════════════════════════════════════════════════════════════
//  1. FactoryOrdersHeader
// ══════════════════════════════════════════════════════════════

class FactoryOrdersHeader extends StatelessWidget {
  final VoidCallback onNewOrderTap;
  final VoidCallback onNotificationTap;

  const FactoryOrdersHeader({
    super.key,
    required this.onNewOrderTap,
    required this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: surface,
        border: Border(bottom: BorderSide(color: border, width: 0.5)),
      ),
      child: Row(
        children: [
          // Notification icon (right side in RTL)
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark
                      ? AppColors.borderDark
                      : AppColors.backgroundLight,
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(Icons.notifications_outlined, color: textPrimary, size: 22),
                  onPressed: onNotificationTap,
                ),
              ),
              Positioned(
                top: -2,
                right: -2,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: const BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      '3',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Title (centered)
          Expanded(
            child: Text(
              'الطلبات',
              textAlign: TextAlign.center,
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: textPrimary,
              ),
            ),
          ),

          // New order button
          TextButton.icon(
            onPressed: onNewOrderTap,
            icon: const Icon(Icons.add_rounded, size: 18),
            label: const Text('طلب جديد'),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              backgroundColor: AppColors.primary.withValues(alpha: 0.08),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: AppRadius.rSM,
              ),
              textStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  2. OrdersTabs
// ══════════════════════════════════════════════════════════════

class OrdersTabs extends StatelessWidget {
  final TabController controller;
  final List<String> tabs;

  const OrdersTabs({
    super.key,
    required this.controller,
    required this.tabs,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
            width: 1,
          ),
        ),
      ),
      child: TabBar(
        controller: controller,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        labelColor: AppColors.primary,
        unselectedLabelColor:
            isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
        indicatorColor: AppColors.primary,
        indicatorWeight: 2.5,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 13,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        tabs: tabs.map((t) => Tab(text: t)).toList(),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  3. OrderSummaryCards
// ══════════════════════════════════════════════════════════════

class OrderSummaryCards extends StatelessWidget {
  final RFQSummary summary;
  final void Function(int tabIndex) onCardTap;

  const OrderSummaryCards({
    super.key,
    required this.summary,
    required this.onCardTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _SummaryCard(
          value: summary.total.toString(),
          label: 'كل الطلبات',
          icon: Icons.description_outlined,
          iconColor: AppColors.info,
          onTap: () => onCardTap(0),
        ),
        const SizedBox(width: 8),
        _SummaryCard(
          value: summary.waitingQuotations.toString(),
          label: 'بانتظار عروض',
          icon: Icons.hourglass_empty_rounded,
          iconColor: AppColors.secondary,
          onTap: () => onCardTap(2),
        ),
        const SizedBox(width: 8),
        _SummaryCard(
          value: summary.receivedQuotations.toString(),
          label: 'عروض مستلمة',
          icon: Icons.mark_email_read_outlined,
          iconColor: AppColors.success,
          onTap: () => onCardTap(3),
        ),
        const SizedBox(width: 8),
        _SummaryCard(
          value: summary.closed.toString(),
          label: 'طلبات مغلقة',
          icon: Icons.check_circle_outline_rounded,
          iconColor: const Color(0xFF8B5CF6), // Purple
          onTap: () => onCardTap(4),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  const _SummaryCard({
    required this.value,
    required this.label,
    required this.icon,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          decoration: BoxDecoration(
            color: surface,
            borderRadius: AppRadius.rMD,
            border: Border.all(color: border, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: isDark ? 0.2 : 0.1),
                  borderRadius: AppRadius.rSM,
                ),
                child: Icon(icon, color: iconColor, size: 16),
              ),
              const SizedBox(height: 6),
              Text(
                value,
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  height: 1,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                maxLines: 2,
                style: TextStyle(
                  fontSize: 10,
                  color: textSecondary,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  4. OrdersSearchBar
// ══════════════════════════════════════════════════════════════

class OrdersSearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onFilterTap;
  final VoidCallback onSortTap;

  const OrdersSearchBar({
    super.key,
    this.controller,
    required this.onChanged,
    required this.onFilterTap,
    required this.onSortTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;
    final hint = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    return Row(
      children: [
        // Sort button
        _ToolButton(
          label: 'ترتيب: الأحدث',
          icon: Icons.keyboard_arrow_down_rounded,
          onTap: onSortTap,
          isDark: isDark,
        ),

        const SizedBox(width: 8),

        // Search field (expanded)
        Expanded(
          child: Container(
            height: 42,
            decoration: BoxDecoration(
              color: surface,
              borderRadius: AppRadius.rMD,
              border: Border.all(color: border),
            ),
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              textAlign: TextAlign.right,
              textAlignVertical: TextAlignVertical.center,
              style: TextStyle(
                fontSize: 13,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
              decoration: InputDecoration(
                hintText: 'ابحث عن طلب أو منتج...',
                hintStyle: TextStyle(fontSize: 12, color: hint.withValues(alpha: 0.6)),
                suffixIcon: Icon(Icons.search_rounded, color: hint, size: 18),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                isDense: true,
              ),
            ),
          ),
        ),

        const SizedBox(width: 8),

        // Filter button
        _FilterIconButton(onTap: onFilterTap, isDark: isDark),
      ],
    );
  }
}

class _ToolButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool isDark;

  const _ToolButton({
    required this.label,
    required this.icon,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;
    final textColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 42,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: AppRadius.rMD,
          border: Border.all(color: border),
        ),
        child: Row(
          children: [
            Text(label, style: TextStyle(fontSize: 12, color: textColor)),
            Icon(icon, size: 16, color: textColor),
          ],
        ),
      ),
    );
  }
}

class _FilterIconButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isDark;

  const _FilterIconButton({required this.onTap, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: surface,
          borderRadius: AppRadius.rMD,
          border: Border.all(color: border),
        ),
        child: const Center(
          child: Icon(Icons.tune_rounded, color: AppColors.primary, size: 20),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  5. OrderCard
// ══════════════════════════════════════════════════════════════

class OrderCard extends StatelessWidget {
  final RFQ rfq;
  final VoidCallback onTap;
  final void Function(String action) onActionTap;

  const OrderCard({
    super.key,
    required this.rfq,
    required this.onTap,
    required this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    return Container(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: AppRadius.rLG,
        border: Border.all(color: border, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: AppRadius.rLG,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.rLG,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Row 1: Status badge + Title + RFQ Number ──
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left: Status badge
                    OrderStatusBadge(status: rfq.status),

                    const SizedBox(width: 8),

                    // Center: Title + product name
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            rfq.title,
                            textAlign: TextAlign.right,
                            style: context.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            rfq.productName,
                            textAlign: TextAlign.right,
                            style: TextStyle(fontSize: 12, color: textSecondary),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 8),

                    // Right: Quick action icon
                    _QuickActionIcon(status: rfq.status, onTap: onTap),
                  ],
                ),

                const SizedBox(height: 10),

                // ── Row 2: Quantity + Supplier count + Quote count ──
                Row(
                  children: [
                    Icon(Icons.people_outline_rounded, size: 14, color: textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      'الموردين: ${rfq.invitedSuppliersCount}',
                      style: TextStyle(fontSize: 12, color: textSecondary),
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.inventory_2_outlined, size: 14, color: textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      'الكمية: ${rfq.requestedQty} ${rfq.unit}',
                      style: TextStyle(fontSize: 12, color: textSecondary),
                    ),
                    if (rfq.receivedQuotesCount > 0) ...[
                      const SizedBox(width: 16),
                      Icon(Icons.receipt_long_outlined, size: 14, color: textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        'العروض: ${rfq.receivedQuotesCount}',
                        style: TextStyle(fontSize: 12, color: textSecondary),
                      ),
                    ],
                  ],
                ),

                const SizedBox(height: 8),

                // ── Row 3: RFQ number + Date + More menu ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // More menu
                    _MoreMenu(rfq: rfq, onAction: onActionTap),

                    // Date
                    Row(
                      children: [
                        Icon(Icons.calendar_today_outlined, size: 12, color: textSecondary),
                        const SizedBox(width: 4),
                        Text(
                          rfq.createdDate,
                          style: TextStyle(fontSize: 11, color: textSecondary),
                        ),
                      ],
                    ),

                    // RFQ Number
                    Text(
                      '#${rfq.id}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Quick Action Icon (matches the screenshot icons per status) ──

class _QuickActionIcon extends StatelessWidget {
  final String status;
  final VoidCallback onTap;

  const _QuickActionIcon({required this.status, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final config = _iconConfig(status);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: config.color.withValues(alpha: 0.1),
          borderRadius: AppRadius.rMD,
        ),
        child: Icon(config.icon, color: config.color, size: 20),
      ),
    );
  }

  _IconConfig _iconConfig(String status) {
    switch (status) {
      case RFQStatus.draft:
        return const _IconConfig(Icons.description_outlined, AppColors.info);
      case RFQStatus.sent:
        return const _IconConfig(Icons.send_outlined, AppColors.secondary);
      case RFQStatus.waitingQuotations:
        return const _IconConfig(Icons.description_rounded, AppColors.secondary);
      case RFQStatus.receivedQuotations:
        return const _IconConfig(Icons.mark_email_read_outlined, AppColors.success);
      case RFQStatus.negotiating:
        return const _IconConfig(Icons.balance_outlined, AppColors.secondary);
      case RFQStatus.approved:
        return const _IconConfig(Icons.thumb_up_alt_outlined, AppColors.success);
      case RFQStatus.dealCreated:
        return const _IconConfig(Icons.handshake_outlined, AppColors.primary);
      case RFQStatus.cancelled:
      case RFQStatus.closed:
        return const _IconConfig(Icons.lock_outline_rounded, Color(0xFF8B5CF6));
      default:
        return const _IconConfig(Icons.description_outlined, AppColors.info);
    }
  }
}

class _IconConfig {
  final IconData icon;
  final Color color;

  const _IconConfig(this.icon, this.color);
}

// ── More Menu ────────────────────────────────────────────────

class _MoreMenu extends StatelessWidget {
  final RFQ rfq;
  final void Function(String action) onAction;

  const _MoreMenu({required this.rfq, required this.onAction});

  List<_MenuAction> _actions(String status) {
    switch (status) {
      case RFQStatus.draft:
        return [
          const _MenuAction('edit', 'تعديل', Icons.edit_outlined),
          const _MenuAction('send', 'إرسال', Icons.send_outlined),
          const _MenuAction('delete', 'حذف', Icons.delete_outline_rounded,
              color: AppColors.error),
        ];
      case RFQStatus.waitingQuotations:
        return [
          const _MenuAction('view_suppliers', 'عرض الموردين', Icons.people_outline_rounded),
          const _MenuAction('cancel', 'إلغاء الطلب', Icons.cancel_outlined,
              color: AppColors.error),
        ];
      case RFQStatus.receivedQuotations:
        return [
          const _MenuAction('compare', 'عرض المقارنة', Icons.compare_arrows_rounded),
          const _MenuAction('negotiate', 'بدء التفاوض', Icons.gavel_outlined),
          const _MenuAction('accept_offer', 'قبول العرض', Icons.check_circle_outline_rounded,
              color: AppColors.success),
        ];
      case RFQStatus.negotiating:
        return [
          const _MenuAction('open_chat', 'فتح الشات', Icons.chat_bubble_outline_rounded),
          const _MenuAction('counter_offer', 'إرسال Counter Offer', Icons.swap_horiz_rounded),
          const _MenuAction('timeline', 'عرض Timeline', Icons.timeline_rounded),
        ];
      case RFQStatus.dealCreated:
        return [
          const _MenuAction('open_deal', 'فتح الصفقة', Icons.handshake_outlined),
        ];
      default:
        return [
          const _MenuAction('open', 'فتح', Icons.open_in_new_rounded),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final actions = _actions(rfq.status);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PopupMenuButton<String>(
      onSelected: onAction,
      tooltip: 'المزيد',
      color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.rMD,
        side: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      itemBuilder: (context) => actions
          .map(
            (a) => PopupMenuItem<String>(
              value: a.key,
              child: Row(
                children: [
                  Icon(a.icon, size: 16,
                      color: a.color ??
                          (isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight)),
                  const SizedBox(width: 8),
                  Text(
                    a.label,
                    style: TextStyle(
                      fontSize: 13,
                      color: a.color ??
                          (isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Icon(
          Icons.more_horiz_rounded,
          size: 18,
          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
        ),
      ),
    );
  }
}

class _MenuAction {
  final String key;
  final String label;
  final IconData icon;
  final Color? color;

  const _MenuAction(this.key, this.label, this.icon, {this.color});
}

// ══════════════════════════════════════════════════════════════
//  6. OrderStatusBadge
// ══════════════════════════════════════════════════════════════

class OrderStatusBadge extends StatelessWidget {
  final String status;

  const OrderStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final config = _badgeConfig(status);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: config.color.withValues(alpha: isDark ? 0.2 : 0.12),
        borderRadius: AppRadius.rRound,
        border: Border.all(
          color: config.color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (config.hasIndicator) ...[
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: config.color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
          ],
          Text(
            RFQStatus.label(status),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: config.color,
            ),
          ),
        ],
      ),
    );
  }

  _BadgeConfig _badgeConfig(String s) {
    switch (s) {
      case RFQStatus.draft:
        return const _BadgeConfig(AppColors.info, hasIndicator: false);
      case RFQStatus.sent:
        return const _BadgeConfig(AppColors.secondary, hasIndicator: false);
      case RFQStatus.waitingQuotations:
        return const _BadgeConfig(AppColors.secondary, hasIndicator: false);
      case RFQStatus.receivedQuotations:
        return const _BadgeConfig(AppColors.success, hasIndicator: true);
      case RFQStatus.negotiating:
        return const _BadgeConfig(AppColors.info, hasIndicator: false);
      case RFQStatus.approved:
        return const _BadgeConfig(AppColors.success, hasIndicator: false);
      case RFQStatus.dealCreated:
        return const _BadgeConfig(AppColors.primary, hasIndicator: false);
      case RFQStatus.cancelled:
        return const _BadgeConfig(AppColors.error, hasIndicator: false);
      case RFQStatus.closed:
        return const _BadgeConfig(Color(0xFF8B5CF6), hasIndicator: false);
      default:
        return const _BadgeConfig(Colors.grey, hasIndicator: false);
    }
  }
}

class _BadgeConfig {
  final Color color;
  final bool hasIndicator;

  const _BadgeConfig(this.color, {this.hasIndicator = false});
}

// ══════════════════════════════════════════════════════════════
//  7. OrdersFilterSheet
// ══════════════════════════════════════════════════════════════

class OrdersFilterSheet extends StatelessWidget {
  final void Function(String filter) onApply;

  const OrdersFilterSheet({super.key, required this.onApply});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'فلترة الطلبات',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold, color: textPrimary),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _filterChip(context, 'كل الطلبات', RFQTab.all, isDark),
              _filterChip(context, 'مسودات', RFQTab.drafts, isDark),
              _filterChip(context, 'بانتظار عروض', RFQTab.waitingQuotations, isDark),
              _filterChip(context, 'عروض مستلمة', RFQTab.receivedQuotations, isDark),
              _filterChip(context, 'مغلقة', RFQTab.closed, isDark),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => onApply(RFQTab.all),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: AppRadius.rMD),
              ),
              child: const Text('تطبيق'),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _filterChip(BuildContext context, String label, String key, bool isDark) {
    return GestureDetector(
      onTap: () => onApply(key),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.08),
          borderRadius: AppRadius.rRound,
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  8. OrdersSortSheet
// ══════════════════════════════════════════════════════════════

class OrdersSortSheet extends StatelessWidget {
  final void Function(String sort) onApply;

  const OrdersSortSheet({super.key, required this.onApply});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;

    const options = [
      ('newest', 'الأحدث أولاً'),
      ('oldest', 'الأقدم أولاً'),
      ('status', 'حسب الحالة'),
      ('qty_high', 'الكمية: الأعلى'),
      ('qty_low', 'الكمية: الأقل'),
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'ترتيب الطلبات',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold, color: textPrimary),
          ),
          const SizedBox(height: 16),
          ...options.map(
            (o) => ListTile(
              onTap: () => onApply(o.$1),
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                o.$1 == 'newest' ? Icons.arrow_downward_rounded : Icons.sort_rounded,
                color: AppColors.primary,
                size: 20,
              ),
              title: Text(o.$2,
                  style: TextStyle(fontSize: 14, color: textPrimary)),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}


