import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/dashboard_providers.dart';
import '../shared/loading_widget.dart';
import '../shared/error_state_widget.dart';

class SupplierHeaderWidget extends ConsumerWidget {
  final VoidCallback? onOpenDrawer;

  const SupplierHeaderWidget({super.key, this.onOpenDrawer});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final headerAsync = ref.watch(supplierHeaderProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return headerAsync.when(
      loading: () => const LoadingWidget(height: 75),
      error: (err, stack) => ErrorStateWidget(
        message: 'تعذر تحميل ترويسة الصفحة: $err',
        onRetry: () => ref.invalidate(supplierHeaderProvider),
      ),
      data: (header) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: 0.5),
            ),
          ),
          child: Row(
            children: [
              // Supplier Avatar / Logo
              GestureDetector(
                onTap: () => context.push('/profile'),
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: colorScheme.primary,
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      header.supplierName.isNotEmpty
                          ? header.supplierName.substring(0, 1)
                          : 'م',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Greeting, Company Name, Stars & Badges
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Greeting (السلام عليكم يا أ/ محمد)
                    Text(
                      header.greeting,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                        fontSize: 15,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),

                    // Company Name + Rating Stars + Badges
                    Wrap(
                      cross: WrapCrossAlignment.center,
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        Text(
                          header.companyName,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        // Rating Stars (★★★★★)
                        Text(
                          header.ratingStars,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.amber.shade800,
                            letterSpacing: 1.0,
                          ),
                        ),
                        if (header.isVerified)
                          Icon(
                            Icons.verified_rounded,
                            size: 14,
                            color: colorScheme.primary,
                          ),
                        // Subscription Badge (احترافي)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 1,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: colorScheme.primary.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Text(
                            header.subscriptionBadge,
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Action Buttons: Notification & Profile
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    children: [
                      IconButton(
                        onPressed: () => context.push('/notifications'),
                        icon: Icon(
                          Icons.notifications_outlined,
                          color: colorScheme.onSurfaceVariant,
                          size: 22,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                        tooltip: 'الإشعارات',
                      ),
                      if (header.unreadNotificationCount > 0)
                        Positioned(
                          right: 4,
                          top: 4,
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 14,
                              minHeight: 14,
                            ),
                            child: Text(
                              '${header.unreadNotificationCount}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  ),
                  IconButton(
                    onPressed: () => context.push('/profile'),
                    icon: Icon(
                      Icons.account_circle_outlined,
                      color: colorScheme.primary,
                      size: 24,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                    tooltip: 'حسابي',
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
