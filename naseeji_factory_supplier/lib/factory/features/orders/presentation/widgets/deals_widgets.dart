import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../providers/deals_provider.dart';

// ══════════════════════════════════════════════════════════════
//  1.  DealsHeader
// ══════════════════════════════════════════════════════════════

class DealsHeader extends StatelessWidget {
  final int notificationCount;
  final VoidCallback onNotificationTap;
  final VoidCallback onNewDealTap;

  const DealsHeader({
    super.key,
    required this.notificationCount,
    required this.onNotificationTap,
    required this.onNewDealTap,
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
          // Notification bell (leading in RTL)
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark ? AppColors.borderDark : AppColors.backgroundLight,
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(Icons.notifications_outlined, color: textPrimary, size: 22),
                  onPressed: onNotificationTap,
                ),
              ),
              if (notificationCount > 0)
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
                    child: Center(
                      child: Text(
                        '$notificationCount',
                        style: const TextStyle(
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
              'الصفقات',
              textAlign: TextAlign.center,
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: textPrimary,
              ),
            ),
          ),

          // New deal button
          TextButton.icon(
            onPressed: onNewDealTap,
            icon: const Icon(Icons.add_rounded, size: 18),
            label: const Text('صفقة جديدة'),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              backgroundColor: AppColors.primary.withValues(alpha: 0.08),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: AppRadius.rSM),
              textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  2.  DealsTabs
// ══════════════════════════════════════════════════════════════

class DealsTabs extends StatelessWidget {
  final TabController controller;
  final List<String> labels;

  const DealsTabs({
    super.key,
    required this.controller,
    required this.labels,
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
        labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        unselectedLabelStyle:
            const TextStyle(fontWeight: FontWeight.normal, fontSize: 13),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        tabs: labels.map((l) => Tab(text: l)).toList(),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  3.  DealsSummaryCards
// ══════════════════════════════════════════════════════════════

class DealsSummaryCards extends StatelessWidget {
  final DealsSummary summary;
  final void Function(int tabIndex) onCardTap;

  const DealsSummaryCards({
    super.key,
    required this.summary,
    required this.onCardTap,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          _SummaryCard(
            value: summary.total.toString(),
            label: 'كل الصفقات',
            icon: Icons.handshake_outlined,
            iconColor: AppColors.info,
            onTap: () => onCardTap(0),
          ),
          const SizedBox(width: 8),
          _SummaryCard(
            value: summary.active.toString(),
            label: 'نشطة',
            icon: Icons.bolt_rounded,
            iconColor: AppColors.success,
            onTap: () => onCardTap(1),
          ),
          const SizedBox(width: 8),
          _SummaryCard(
            value: summary.inProduction.toString(),
            label: 'قيد الإنتاج',
            icon: Icons.precision_manufacturing_outlined,
            iconColor: AppColors.secondary,
            onTap: () => onCardTap(2),
          ),
          const SizedBox(width: 8),
          _SummaryCard(
            value: summary.inShipping.toString(),
            label: 'قيد الشحن',
            icon: Icons.local_shipping_outlined,
            iconColor: const Color(0xFF8B5CF6),
            onTap: () => onCardTap(3),
          ),
          const SizedBox(width: 8),
          _SummaryCard(
            value: summary.completed.toString(),
            label: 'مكتملة',
            icon: Icons.check_circle_outline_rounded,
            iconColor: AppColors.primary,
            onTap: () => onCardTap(4),
          ),
        ],
      ),
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

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 90,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: AppRadius.rMD,
          border: Border.all(color: border, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: isDark ? 0.2 : 0.1),
                borderRadius: AppRadius.rSM,
              ),
              child: Icon(icon, color: iconColor, size: 16),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                height: 1,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              maxLines: 2,
              style: TextStyle(
                fontSize: 10,
                color: textSecondary,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  4.  DealsSearchBar
// ══════════════════════════════════════════════════════════════

class DealsSearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onFilterTap;
  final VoidCallback onSortTap;

  const DealsSearchBar({
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
    final textColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;

    return Row(
      children: [
        // Filter button
        _ToolBtn(
          icon: Icons.tune_rounded,
          label: 'فلترة',
          onTap: onFilterTap,
          isDark: isDark,
        ),

        const SizedBox(width: 8),

        // Sort button
        _ToolBtn(
          icon: Icons.keyboard_arrow_down_rounded,
          label: 'ترتيب',
          onTap: onSortTap,
          isDark: isDark,
          isDropdown: true,
        ),

        const SizedBox(width: 8),

        // Search field
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
              style: TextStyle(fontSize: 13, color: textColor),
              decoration: InputDecoration(
                hintText: 'ابحث عن صفقة، مورد أو منتج...',
                hintStyle:
                    TextStyle(fontSize: 12, color: hint.withValues(alpha: 0.6)),
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
      ],
    );
  }
}

class _ToolBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDark;
  final bool isDropdown;

  const _ToolBtn({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.isDark,
    this.isDropdown = false,
  });

  @override
  Widget build(BuildContext context) {
    final surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;
    final textColor =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;

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
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!isDropdown) Icon(icon, size: 16, color: AppColors.primary),
            if (!isDropdown) const SizedBox(width: 4),
            Text(label, style: TextStyle(fontSize: 12, color: textColor)),
            if (isDropdown) ...[
              const SizedBox(width: 2),
              Icon(icon, size: 16, color: textColor),
            ],
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  5.  DealCard
// ══════════════════════════════════════════════════════════════

class DealCard extends StatelessWidget {
  final DealModel deal;
  final VoidCallback onTap;
  final void Function(String action) onAction;

  const DealCard({
    super.key,
    required this.deal,
    required this.onTap,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final bgLight = isDark ? AppColors.backgroundDark : AppColors.backgroundLight;

    return Container(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: AppRadius.rLG,
        border: Border.all(color: border, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.04),
            blurRadius: 8,
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
          child: Column(
            children: [
              // ── Top Section ─────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left: Supplier Avatar
                    _SupplierAvatarBox(
                      shortName: deal.supplierShortName,
                      isDark: isDark,
                      bgLight: bgLight,
                      border: border,
                    ),

                    const SizedBox(width: 10),

                    // Center: Deal info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // Deal number
                          Text(
                            '#${deal.id}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          // Product name
                          Text(
                            deal.productName,
                            textAlign: TextAlign.right,
                            style: context.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          // Supplier + verified
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                deal.supplierName,
                                style: TextStyle(
                                    fontSize: 12, color: textSecondary),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.verified_rounded,
                                size: 13,
                                color: AppColors.info,
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          // Specs
                          Text(
                            deal.specs,
                            textAlign: TextAlign.right,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11,
                              color: textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ── Divider ──────────────────────────────────────
              Divider(height: 1, thickness: 0.5, color: border),

              // ── Middle: Value + Payment + Delivery ───────────
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
                child: Row(
                  children: [
                    // Delivery date
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'تاريخ التسليم',
                            style: TextStyle(
                              fontSize: 10,
                              color: textSecondary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Icon(Icons.calendar_today_outlined,
                                  size: 12, color: textSecondary),
                              const SizedBox(width: 4),
                              Text(
                                deal.deliveryDate,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Value + payment
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'قيمة الصفقة',
                          style: TextStyle(fontSize: 10, color: textSecondary),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${_formatNumber(deal.dealValue)} ${deal.currency}',
                          style: context.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        _PaymentBadge(
                          percentage: deal.paidPercentage,
                          isDark: isDark,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // ── Payment Progress Bar ──────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: _PaymentProgress(
                  percentage: deal.paidPercentage,
                  isDark: isDark,
                ),
              ),

              const SizedBox(height: 10),

              // ── Workflow Steps ────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: _WorkflowRow(steps: deal.workflowSteps, isDark: isDark),
              ),

              const SizedBox(height: 10),

              // ── Bottom: Details button + last updated ─────────
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                child: Row(
                  children: [
                    // Details button
                    OutlinedButton(
                      onPressed: onTap,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.primary),
                        foregroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        shape: RoundedRectangleBorder(
                            borderRadius: AppRadius.rMD),
                        textStyle: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      child: const Text('عرض التفاصيل'),
                    ),

                    const Spacer(),

                    // Last updated
                    Icon(Icons.access_time_rounded,
                        size: 12, color: textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      'آخر تحديث: ${deal.lastUpdated}',
                      style: TextStyle(
                        fontSize: 10,
                        color: textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatNumber(double value) {
    if (value >= 1000) {
      return value.toInt().toString().replaceAllMapped(
            RegExp(r'(\d)(?=(\d{3})+$)'),
            (m) => '${m[1]},',
          );
    }
    return value.toInt().toString();
  }
}

// ── Supplier Avatar Box ─────────────────────────────────────

class _SupplierAvatarBox extends StatelessWidget {
  final String shortName;
  final bool isDark;
  final Color bgLight;
  final Color border;

  const _SupplierAvatarBox({
    required this.shortName,
    required this.isDark,
    required this.bgLight,
    required this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: bgLight,
        borderRadius: AppRadius.rMD,
        border: Border.all(color: border),
      ),
      child: Center(
        child: Text(
          shortName,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.textSecondaryDark : AppColors.primary,
            height: 1.3,
          ),
        ),
      ),
    );
  }
}

// ── Payment Badge ──────────────────────────────────────────

class _PaymentBadge extends StatelessWidget {
  final double percentage;
  final bool isDark;

  const _PaymentBadge({required this.percentage, required this.isDark});

  @override
  Widget build(BuildContext context) {
    Color badgeColor;
    String label;

    if (percentage <= 0) {
      badgeColor = AppColors.error;
      label = 'لم يُسدَّد';
    } else if (percentage < 100) {
      badgeColor = AppColors.secondary;
      label = 'مدفوع مقدماً ${percentage.toInt()}%';
    } else {
      badgeColor = AppColors.success;
      label = 'مدفوع 100%';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: isDark ? 0.25 : 0.12),
        borderRadius: AppRadius.rRound,
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: badgeColor,
        ),
      ),
    );
  }
}

// ── Payment Progress Bar ───────────────────────────────────

class _PaymentProgress extends StatelessWidget {
  final double percentage;
  final bool isDark;

  const _PaymentProgress({required this.percentage, required this.isDark});

  @override
  Widget build(BuildContext context) {
    Color barColor;
    if (percentage <= 0) {
      barColor = AppColors.error;
    } else if (percentage < 100) {
      barColor = AppColors.secondary;
    } else {
      barColor = AppColors.success;
    }

    return ClipRRect(
      borderRadius: AppRadius.rRound,
      child: LinearProgressIndicator(
        value: (percentage / 100.0).clamp(0.0, 1.0),
        color: barColor,
        backgroundColor:
            isDark ? AppColors.borderDark : const Color(0xFFE2E8F0),
        minHeight: 4,
      ),
    );
  }
}

// ── Workflow Steps Row ────────────────────────────────────

class _WorkflowRow extends StatelessWidget {
  final List<DealWorkflowStep> steps;
  final bool isDark;

  const _WorkflowRow({required this.steps, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(steps.length * 2 - 1, (i) {
        if (i.isOdd) {
          // Connector line
          final leftStepIndex = i ~/ 2;
          final isCompleted =
              steps[leftStepIndex].state == WorkflowStepState.completed;
          return Expanded(
            child: Container(
              height: 2,
              color: isCompleted
                  ? AppColors.primary
                  : (isDark ? AppColors.borderDark : const Color(0xFFE2E8F0)),
            ),
          );
        }
        final step = steps[i ~/ 2];
        return _WorkflowStep(step: step, isDark: isDark);
      }),
    );
  }
}

class _WorkflowStep extends StatelessWidget {
  final DealWorkflowStep step;
  final bool isDark;

  const _WorkflowStep({required this.step, required this.isDark});

  @override
  Widget build(BuildContext context) {
    Color circleColor;
    Color textColor;
    Widget icon;

    switch (step.state) {
      case WorkflowStepState.completed:
        circleColor = AppColors.primary;
        textColor = AppColors.primary;
        icon = const Icon(Icons.check_rounded, color: Colors.white, size: 12);
      case WorkflowStepState.active:
        circleColor = AppColors.secondary;
        textColor = AppColors.secondary;
        icon = Container(
          width: 6,
          height: 6,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        );
      case WorkflowStepState.pending:
        circleColor =
            isDark ? AppColors.borderDark : const Color(0xFFE2E8F0);
        textColor =
            isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
        icon = const SizedBox.shrink();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            color: circleColor,
            shape: BoxShape.circle,
          ),
          child: Center(child: icon),
        ),
        const SizedBox(height: 4),
        Text(
          step.label,
          style: TextStyle(
            fontSize: 10,
            color: textColor,
            fontWeight: step.state != WorkflowStepState.pending
                ? FontWeight.bold
                : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  6.  DealStatusBadge (standalone for external use)
// ══════════════════════════════════════════════════════════════

class DealStatusBadge extends StatelessWidget {
  final String status;

  const DealStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final config = _config(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: config.$1.withValues(alpha: isDark ? 0.2 : 0.12),
        borderRadius: AppRadius.rRound,
        border: Border.all(
          color: config.$1.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (config.$2)
            Container(
              width: 6,
              height: 6,
              margin: const EdgeInsets.only(left: 4),
              decoration: BoxDecoration(
                color: config.$1,
                shape: BoxShape.circle,
              ),
            ),
          Text(
            DealStatus.label(status),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: config.$1,
            ),
          ),
        ],
      ),
    );
  }

  (Color, bool) _config(String s) {
    switch (s) {
      case DealStatus.active:
        return (AppColors.success, true);
      case DealStatus.inProduction:
        return (AppColors.secondary, false);
      case DealStatus.inShipping:
        return (const Color(0xFF8B5CF6), false);
      case DealStatus.completed:
        return (AppColors.primary, false);
      case DealStatus.cancelled:
        return (AppColors.error, false);
      default:
        return (AppColors.info, false);
    }
  }
}

// ══════════════════════════════════════════════════════════════
//  7.  DealsFilterSheet
// ══════════════════════════════════════════════════════════════

class DealsFilterSheet extends StatelessWidget {
  final void Function(String filter) onApply;

  const DealsFilterSheet({super.key, required this.onApply});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;

    const options = [
      (DealTab.all, 'كل الصفقات'),
      (DealStatus.active, 'نشطة'),
      (DealStatus.inProduction, 'قيد الإنتاج'),
      (DealStatus.inShipping, 'قيد الشحن'),
      (DealStatus.completed, 'مكتملة'),
      (DealStatus.cancelled, 'ملغاة'),
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: surface,
        borderRadius:
            const BorderRadius.vertical(top: Radius.circular(20)),
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
            'فلترة الصفقات',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: textPrimary,
                ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: options
                .map(
                  (o) => GestureDetector(
                    onTap: () => onApply(o.$1),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color:
                            AppColors.primary.withValues(alpha: 0.08),
                        borderRadius: AppRadius.rRound,
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        o.$2,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.rMD),
              ),
              child: const Text('تطبيق'),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

