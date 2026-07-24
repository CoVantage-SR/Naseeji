import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/features/dashboard/presentation/providers/dashboard_providers.dart';

class SupplierHomeHeader extends ConsumerWidget {
  const SupplierHomeHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final headerAsync = ref.watch(supplierHeaderProvider);
    final subscriptionAsync = ref.watch(subscriptionProvider);
    final notificationsAsync = ref.watch(notificationsProvider);

    final unreadNotificationsCount = notificationsAsync.when(
      data: (items) => items.where((n) => !n.isRead).length,
      loading: () => 3,
      error: (_, __) => 0,
    );

    return Column(
      children: [
        // ─── 1. Top Profile Bar & Notification Popover Bubble ────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Notification Bell & Messages Icons (Left)
                  Row(
                    children: [
                      // Bell Icon with Red Badge
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          IconButton(
                            onPressed: () => context.push('/notifications'),
                            icon: const Icon(Icons.notifications_outlined, size: 24),
                            style: IconButton.styleFrom(
                              backgroundColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                              padding: const EdgeInsets.all(8),
                            ),
                          ),
                          if (unreadNotificationsCount > 0)
                            Positioned(
                              top: 4,
                              right: 4,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 16,
                                  minHeight: 16,
                                ),
                                child: Text(
                                  '$unreadNotificationsCount',
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
                      const SizedBox(width: 8),

                      // Chat Icon
                      IconButton(
                        onPressed: () => context.push('/messages'),
                        icon: const Icon(Icons.chat_bubble_outline_rounded, size: 22),
                        style: IconButton.styleFrom(
                          backgroundColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                          padding: const EdgeInsets.all(8),
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  // Supplier Info & Avatar (Right - RTL)
                  headerAsync.when(
                    data: (header) => Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'مرحبًا، ${header.supplierName}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (header.isVerified) ...[
                                  const Icon(
                                    Icons.verified_rounded,
                                    color: Color(0xFF2563EB),
                                    size: 14,
                                  ),
                                  const SizedBox(width: 4),
                                ],
                                Text(
                                  header.companyName,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(width: 10),

                        // Avatar Circle
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
                          backgroundImage: (header.logoUrl != null && header.logoUrl!.startsWith('http'))
                              ? NetworkImage(header.logoUrl!)
                              : null,
                          child: (header.logoUrl == null || !header.logoUrl!.startsWith('http'))
                              ? Text(
                                  header.supplierName.isNotEmpty
                                      ? header.supplierName[0]
                                      : 'م',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.primary,
                                  ),
                                )
                              : null,
                        ),
                      ],
                    ),
                    loading: () => const SizedBox(
                      width: 120,
                      height: 40,
                      child: Center(child: CircularProgressIndicator.adaptive(strokeWidth: 2)),
                    ),
                    error: (_, __) => const Text('المورد'),
                  ),
                ],
              ),

              // ─── Notification Speech Bubble Popping From Bell Icon ─────────
              if (unreadNotificationsCount > 0)
                Padding(
                  padding: const EdgeInsets.only(top: 4, left: 4),
                  child: InkWell(
                    onTap: () => context.push('/notifications'),
                    borderRadius: BorderRadius.circular(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Pointer Arrow pointing up to bell icon
                        Padding(
                          padding: const EdgeInsets.only(left: 14),
                          child: CustomPaint(
                            size: const Size(12, 6),
                            painter: _BubbleTrianglePainter(
                              color: const Color(0xFFEFF6FF),
                              borderColor: const Color(0xFFBFDBFE),
                            ),
                          ),
                        ),
                        // Speech Bubble Box
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF6FF),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFBFDBFE)),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF2563EB).withValues(alpha: 0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.arrow_back_ios_new_rounded, size: 11, color: Color(0xFF2563EB)),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: const [
                                  Text(
                                    '🔔 لديك إشعارات جديدة',
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1E40AF),
                                    ),
                                  ),
                                  SizedBox(height: 1),
                                  Text(
                                    'اضغط هنا لعرض كافة الإشعارات والعمليات الحديثة.',
                                    style: TextStyle(
                                      fontSize: 9.5,
                                      color: Color(0xFF3B82F6),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),

        // ─── 2. Subscription Card Header Widget ─────────────────────────────
        subscriptionAsync.when(
          data: (subscription) {
            final used = subscription.productsUsed;
            final max = subscription.maxProducts;
            final ratio = max > 0 ? (used / max).clamp(0.0, 1.0) : 0.0;

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.3)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.015),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Action Button (Left)
                  ElevatedButton(
                    onPressed: () => context.push('/profile/subscription'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(82, 30),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                    ),
                    child: const Text('تجديد الباقة', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  ),

                  const Spacer(),

                  // Progress Ring + Ratio Counter (Center)
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '$used / $max',
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'منتج مستخدم',
                            style: TextStyle(fontSize: 9.5, color: colorScheme.onSurfaceVariant),
                          ),
                        ],
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 32,
                        height: 32,
                        child: CircularProgressIndicator(
                          value: ratio,
                          strokeWidth: 3.5,
                          backgroundColor: colorScheme.surfaceContainerHighest,
                          color: const Color(0xFF2563EB),
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  // Plan Info (Right - RTL)
                  InkWell(
                    onTap: () => context.push('/profile/subscription'),
                    borderRadius: BorderRadius.circular(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Text(
                              subscription.planName,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.workspace_premium_rounded, color: Colors.amber, size: 16),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'تنتهي في ${subscription.expiryDateFormatted}',
                          style: TextStyle(
                            fontSize: 10,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
          loading: () => const SizedBox(height: 80),
          error: (_, __) => const SizedBox.shrink(),
        ),
      ],
    );
  }
}

class _BubbleTrianglePainter extends CustomPainter {
  final Color color;
  final Color borderColor;

  _BubbleTrianglePainter({required this.color, required this.borderColor});

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)
      ..close();

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawPath(path, paint);
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
