import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TodayTasksSection extends StatelessWidget {
  const TodayTasksSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.015),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // ─── 1. Section Header Row (RTL) ──────────────────────────────────
            Row(
              children: [
                // Title & Badge (Right in RTL)
                Row(
                  children: [
                    Text(
                      'مهام اليوم',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.5,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF2F2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFFCA5A5)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Color(0xFFDC2626),
                              shape: BoxShape.circle,
                            ),
                            child: const Text(
                              '1',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 8.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            '1 مهام عاجلة',
                            style: TextStyle(
                              color: Color(0xFFDC2626),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                // "عرض الكل" Text Button (Left in RTL)
                TextButton(
                  onPressed: () => context.push('/deals'),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 28),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    'عرض الكل',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2563EB),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ─── 2. Task Card 1: Urgent (Red) ─────────────────────────────────
            _buildSingleTaskCard(
              context: context,
              title: 'لديك 3 طلبات RFQ تحتاج الرد',
              description: 'طلبات عروض أسعار عاجلة من مشتريين بانتظار تقديم تسعيرك.',
              statusLabel: 'عاجل جداً',
              statusColor: const Color(0xFFDC2626),
              statusBgColor: const Color(0xFFFEF2F2),
              deadlineText: 'متبقي ٣ ساعات',
              btnLabel: 'عرض',
              onTap: () => context.push('/orders'),
            ),

            const SizedBox(height: 10),

            // ─── 3. Task Card 2: Negotiation (Orange) ─────────────────────────
            _buildSingleTaskCard(
              context: context,
              title: 'يوجد عرض يحتاج تفاوض',
              description: 'قدم المشتري عرضاً مضاداً على الطلب ORD-2304.',
              statusLabel: 'يحتاج تفاوض',
              statusColor: const Color(0xFFEA580C),
              statusBgColor: const Color(0xFFFFF7ED),
              deadlineText: 'اليوم ٥:٠٠ م',
              btnLabel: 'فتح',
              onTap: () => context.push('/orders'),
            ),

            const SizedBox(height: 10),

            // ─── 4. Task Card 3: Ready for Shipping (Green) ───────────────────
            _buildSingleTaskCard(
              context: context,
              title: 'يوجد طلب جاهز للشحن',
              description: 'اكتمل تجهيز الطلب ORD-2305 في المصنع وبانتظار التغليف.',
              statusLabel: 'جاهز للشحن 🚚',
              statusColor: const Color(0xFF16A34A),
              statusBgColor: const Color(0xFFF0FDF4),
              deadlineText: 'غداً ١٢:٠٠ م',
              btnLabel: 'إنشاء بوليصة',
              onTap: () => context.push('/shipping'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSingleTaskCard({
    required BuildContext context,
    required String title,
    required String description,
    required String statusLabel,
    required Color statusColor,
    required Color statusBgColor,
    required String deadlineText,
    required String btnLabel,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ─── Accent Color Bar (Rightmost in RTL) ──────────────────────
              Container(
                width: 4.5,
                color: statusColor,
              ),

              // ─── Main Content Area ─────────────────────────────────────────
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Top Row: Building Icon + Title + Status Badge
                      Row(
                        children: [
                          Container(
                            width: 34,
                            height: 34,
                            decoration: const BoxDecoration(
                              color: Color(0xFFEFF6FF),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.apartment_rounded,
                              color: Color(0xFF2563EB),
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              title,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: statusBgColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              statusLabel,
                              style: TextStyle(
                                color: statusColor,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // Middle: Description
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 11,
                          color: colorScheme.onSurfaceVariant,
                          height: 1.3,
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Bottom Row: Time + Action Button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.access_time_rounded,
                                size: 13,
                                color: colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                deadlineText,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: colorScheme.onSurfaceVariant,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: onTap,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: statusColor,
                              foregroundColor: Colors.white,
                              minimumSize: const Size(70, 28),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              elevation: 0,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.arrow_back_ios_new_rounded, size: 9, color: Colors.white),
                                const SizedBox(width: 4),
                                Text(
                                  btnLabel,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

