import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/features/dashboard/presentation/providers/dashboard_providers.dart';

class SupplierHomeHeader extends ConsumerWidget {
  final bool showNotificationBubble;

  const SupplierHomeHeader({super.key, this.showNotificationBubble = true});

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
      error: (_, __) => 3,
    );

    return Column(
      children: [
        // ─── 1. Top Profile Bar & Notification Popover Bubble ────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // ─── Right Side (RTL): Supplier Avatar & Greeting Info ─────
                  headerAsync.when(
                    data: (header) => Row(
                      children: [
                        // 1. Avatar Circle (Far Right in RTL)
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: colorScheme.outlineVariant.withValues(
                                alpha: 0.4,
                              ),
                              width: 2.5,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 21,
                            backgroundColor: const Color(0xFFEFF6FF),
                            backgroundImage:
                                (header.logoUrl != null &&
                                    header.logoUrl!.startsWith('http'))
                                ? NetworkImage(header.logoUrl!)
                                : null,
                            child:
                                (header.logoUrl == null ||
                                    !header.logoUrl!.startsWith('http'))
                                ? Text(
                                    header.supplierName.isNotEmpty
                                        ? header.supplierName[0]
                                        : 'م',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF2563EB),
                                      fontSize: 16,
                                    ),
                                  )
                                : null,
                          ),
                        ),

                        const SizedBox(width: 10),

                        // 2. Greeting Name & Verified Company (To the left of avatar)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'مرحبًا، ${header.supplierName}',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                if (header.isVerified) ...[
                                  const Icon(
                                    Icons.verified_rounded,
                                    color: Color(0xFF2563EB),
                                    size: 13,
                                  ),
                                  const SizedBox(width: 3),
                                ],
                                Text(
                                  header.companyName,
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    color: colorScheme.onSurfaceVariant
                                        .withValues(alpha: 0.8),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    loading: () => Row(
                      children: [
                        CircleAvatar(
                          radius: 21,
                          backgroundColor: colorScheme.surfaceContainerHighest,
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 100,
                              height: 14,
                              color: colorScheme.surfaceContainerHighest,
                            ),
                            const SizedBox(height: 4),
                            Container(
                              width: 80,
                              height: 10,
                              color: colorScheme.surfaceContainerHighest,
                            ),
                          ],
                        ),
                      ],
                    ),
                    error: (_, __) => const Text('مرحبًا، المورد'),
                  ),

                  const Spacer(),

                  // ─── Left Side (RTL): Messages & Notification Bell Icons ───
                  Row(
                    children: [
                      // Chat Icon (Far Left - 1)
                      IconButton(
                        onPressed: () => context.push('/messages'),
                        icon: const Icon(
                          Icons.chat_bubble_outline_rounded,
                          size: 22,
                        ),
                        style: IconButton.styleFrom(
                          foregroundColor: colorScheme.onSurface,
                          padding: const EdgeInsets.all(8),
                          minimumSize: const Size(20, 20),
                        ),
                      ),
                      const SizedBox(width: 2),

                      // Bell Icon with Red Badge (Far Left - 2)
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          IconButton(
                            onPressed: () => context.push('/notifications'),
                            icon: const Icon(
                              Icons.notifications_none_rounded,
                              size: 24,
                            ),
                            style: IconButton.styleFrom(
                              foregroundColor: colorScheme.onSurface,
                              padding: const EdgeInsets.all(8),
                              minimumSize: const Size(20, 20),
                            ),
                          ),
                          if (unreadNotificationsCount > 0)
                            Positioned(
                              top: 5,
                              right: 5,
                              child: Container(
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFDC2626), // Vibrant Red
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 1.5,
                                  ),
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 17,
                                  minHeight: 17,
                                ),
                                child: Text(
                                  '$unreadNotificationsCount',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 8.5,
                                    fontWeight: FontWeight.bold,
                                    height: 1.0,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),

              // ─── Notification Speech Bubble Popping From Bell Icon (Left) ──
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 300),
                crossFadeState:
                    (unreadNotificationsCount > 0 && showNotificationBubble)
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                firstChild: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: InkWell(
                    onTap: () => context.push('/notifications'),
                    borderRadius: BorderRadius.circular(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Pointer Arrow pointing up directly to notification bell icon on the left
                        Padding(
                          padding: const EdgeInsets.only(left: 14),
                          child: CustomPaint(
                            size: const Size(12, 6),
                            painter: _BubbleTrianglePainter(
                              color: const Color(0xFFEFF6FF),
                              borderColor: const Color(0xFF93C5FD),
                            ),
                          ),
                        ),
                        // Speech Bubble Glassmorphism Box
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFEFF6FF), Color(0xFFF0F9FF)],
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                            ),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: const Color(0xFF93C5FD),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFF2563EB,
                                ).withValues(alpha: 0.12),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              // Left Arrow Chevron
                              const Icon(
                                Icons.arrow_back_ios_new_rounded,
                                size: 16,
                                color: Color(0xFF2563EB),
                              ),
                              const Spacer(),

                              // Notification Text (Right Aligned RTL)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: const [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'لديك إشعارات جديدة',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF1E40AF),
                                        ),
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        '🔔',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'اضغط هنا لعرض كافة الإشعارات والعمليات الحديثة.',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Color(0xFF3B82F6),
                                      fontWeight: FontWeight.w500,
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
                secondChild: const SizedBox.shrink(),
              ),
            ],
          ),
        ),

        // ─── 2. Reference-Matching 3-Section Subscription Card ───────────────
        subscriptionAsync.when(
          data: (subscription) {
            final used = subscription.productsUsed;
            final max = subscription.maxProducts;
            final ratio = max > 0 ? (used / max).clamp(0.0, 1.0) : 0.0;

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.35),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.015),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // ─── Section 1: Plan Info & Crown Icon (Rightmost in RTL) ──
                  Expanded(
                    flex: 7,
                    child: Row(
                      children: [
                        // Crown Circle Icon (Far Right)
                        Container(
                          width: 38,
                          height: 38,
                          decoration: const BoxDecoration(
                            color: Color(0xFFEFF6FF), // Soft blue circle
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.workspace_premium_rounded,
                            color: Color(0xFF1E3A8A), // Navy crown
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Text Column (Plan Name, Expiry, Details Link)
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                subscription.planName,
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onSurface,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'تنتهي في ${subscription.expiryDateFormatted}',
                                style: TextStyle(
                                  fontSize: 9.5,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 3),
                              InkWell(
                                onTap: () =>
                                    context.push('/profile/subscription'),
                                borderRadius: BorderRadius.circular(4),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Icon(
                                      Icons.chevron_left_rounded,
                                      size: 13,
                                      color: Color(0xFF2563EB),
                                    ),
                                    SizedBox(width: 2),
                                    Text(
                                      'عرض التفاصيل',
                                      style: TextStyle(
                                        fontSize: 9.5,
                                        color: Color(0xFF2563EB),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Vertical Divider 1
                  Container(
                    height: 42,
                    width: 1,
                    color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                  ),

                  // ─── Section 2: Circular Usage Progress Ring (Center) ─────
                  Expanded(
                    flex: 5,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 50,
                              height: 50,
                              child: CircularProgressIndicator(
                                value: ratio,
                                strokeWidth: 4.5,
                                backgroundColor: const Color(0xFFF1F5F9),
                                color: const Color(0xFF2563EB),
                                strokeCap: StrokeCap.round,
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '$used / $max',
                                  style: const TextStyle(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.bold,
                                    height: 1.1,
                                  ),
                                ),
                                const SizedBox(height: 1),
                                Text(
                                  'منتج مستخدم',
                                  style: TextStyle(
                                    fontSize: 8,
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Vertical Divider 2
                  Container(
                    height: 42,
                    width: 1,
                    color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                  ),

                  // ─── Section 3: Action Buttons (Leftmost in RTL) ───────────
                  Expanded(
                    flex: 6,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Top Button: ترقية الباقة ↑
                        OutlinedButton(
                          onPressed: () =>
                              context.push('/profile/subscription'),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 26),
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            side: const BorderSide(
                              color: Color(0xFFDBEAFE),
                              width: 1.2,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            foregroundColor: const Color(0xFF2563EB),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                'ترقية الباقة',
                                style: TextStyle(
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 3),
                              Icon(Icons.arrow_upward_rounded, size: 11),
                            ],
                          ),
                        ),

                        const SizedBox(height: 3),

                        // Bottom Button: تجديد الباقة 🔄
                        ElevatedButton(
                          onPressed: () =>
                              context.push('/profile/subscription'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2563EB),
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 26),
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                'تجديد الباقة',
                                style: TextStyle(
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 3),
                              Icon(Icons.sync_rounded, size: 11),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
          loading: () => const SizedBox(height: 60),
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
