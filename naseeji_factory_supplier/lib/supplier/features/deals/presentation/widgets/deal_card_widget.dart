import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/deal_model.dart';

class DealCardWidget extends StatelessWidget {
  final DealModel deal;

  const DealCardWidget({super.key, required this.deal});

  String _formatNumber(double number) {
    final intVal = number.toInt();
    final str = intVal.toString();
    final result = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) {
        result.write(',');
      }
      result.write(str[i]);
    }
    return result.toString();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.08 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () => context.push('/deals/details/${deal.id}'),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Top Section: Avatar/Location, Middle Title, Status Badge
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Right: Factory Avatar & Location
                    Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: Color(deal.factoryInfo.logoBgColorValue),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Icon(
                                  _getFactoryIcon(deal.factoryInfo.name),
                                  size: 24,
                                  color: _getFactoryIconColor(deal.factoryInfo.name),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 2,
                              left: 2,
                              child: Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF16A34A),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 1.5),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined, size: 10, color: Color(0xFF9CA3AF)),
                            const SizedBox(width: 2),
                            Text(
                              deal.factoryInfo.city,
                              style: const TextStyle(
                                fontSize: 9.5,
                                color: Color(0xFF6B7280),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(width: 10),

                    // Middle: Order Title, Factory Name & Product
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title (e.g. طلب أسعار رقم RFQ-2505-001)
                          Text(
                            deal.dealNumber.startsWith('RFQ')
                                ? 'طلب أسعار رقم ${deal.dealNumber}'
                                : 'طلب رقم ${deal.dealNumber}',
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : const Color(0xFF111827),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 3),

                          // Factory Name with Verified Checkmark
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  deal.factoryInfo.name,
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w600,
                                    color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF4B5563),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                Icons.verified_rounded,
                                size: 14,
                                color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),

                          // Product Subtitle with small image thumbnail
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Image.network(
                                  deal.product.imageUrl,
                                  width: 26,
                                  height: 26,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    width: 26,
                                    height: 26,
                                    color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF3F4F6),
                                    child: Icon(Icons.inventory_2_outlined, size: 14, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF9CA3AF)),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  deal.product.name,
                                  style: TextStyle(
                                    fontSize: 10.5,
                                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280),
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Left (in RTL): Status Badge
                    _buildStatusBadge(context, deal.status),
                  ],
                ),

                const SizedBox(height: 10),
                Divider(height: 1, color: isDark ? const Color(0xFF334155) : const Color(0xFFF3F4F6)),
                const SizedBox(height: 10),

                // 2. Middle Stats Grid: الكمية / قيمة الطلب / آخر تحديث
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Quantity
                    _buildStatColumn(context, 'الكمية', '${_formatNumber(deal.product.quantity.toDouble())} ${deal.product.unit}'),
                    // Order Value
                    _buildStatColumn(context, 'قيمة الطلب', '${_formatNumber(deal.payment?.totalAmount ?? deal.product.totalPrice)} ج.م'),
                    // Last Updated
                    _buildStatColumn(context, 'آخر تحديث', deal.formattedLastUpdated),
                  ],
                ),

                const SizedBox(height: 10),
                Divider(height: 1, color: isDark ? const Color(0xFF334155) : const Color(0xFFF3F4F6)),
                const SizedBox(height: 8),

                // 3. Bottom Action Bar: "عرض التفاصيل >" & Action Button + 3 dots
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Action Buttons (Left in RTL)
                    Row(
                      children: [
                        PopupMenuButton<String>(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(
                            Icons.more_horiz_rounded,
                            color: Color(0xFF9CA3AF),
                            size: 22,
                          ),
                          onSelected: (val) {
                            if (val == 'details') {
                              context.push('/deals/details/${deal.id}');
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'details',
                              child: Text('عرض التفاصيل الكاملة', style: TextStyle(fontSize: 12)),
                            ),
                            const PopupMenuItem(
                              value: 'chat',
                              child: Text('فتح المحادثة المباشرة', style: TextStyle(fontSize: 12)),
                            ),
                          ],
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton(
                          onPressed: () => context.push('/deals/details/${deal.id}'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            side: const BorderSide(color: Color(0xFF2563EB), width: 1.2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            _getActionButtonLabel(deal.status),
                            style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2563EB),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Details Link (Right in RTL)
                    InkWell(
                      onTap: () => context.push('/deals/details/${deal.id}'),
                      borderRadius: BorderRadius.circular(6),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.chevron_left_rounded,
                            size: 18,
                            color: Color(0xFF2563EB),
                          ),
                          SizedBox(width: 2),
                          Text(
                            'عرض التفاصيل',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2563EB),
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
      ),
    );
  }

  IconData _getFactoryIcon(String name) {
    if (name.contains('الحديث')) return Icons.apartment_rounded;
    if (name.contains('الخليج')) return Icons.business_rounded;
    if (name.contains('مصر')) return Icons.domain_rounded;
    return Icons.store_rounded;
  }

  Color _getFactoryIconColor(String name) {
    if (name.contains('الحديث')) return const Color(0xFF2563EB);
    if (name.contains('الخليج')) return const Color(0xFF059669);
    if (name.contains('مصر')) return const Color(0xFFDC2626);
    return const Color(0xFF7C3AED);
  }

  String _getActionButtonLabel(DealStatus status) {
    switch (status) {
      case DealStatus.negotiation:
        return 'فتح التفاوض';
      case DealStatus.waitingSupplierReview:
        return 'إرسال متابعة';
      case DealStatus.production:
        return 'تتبع الطلب';
      case DealStatus.completed:
        return 'إعادة طلب';
      default:
        return 'عرض ومتابعة';
    }
  }

  Widget _buildStatusBadge(BuildContext context, DealStatus status) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color bg;
    Color textColor;
    String label;

    switch (status) {
      case DealStatus.negotiation:
        bg = isDark ? const Color(0xFF7C2D12) : const Color(0xFFFFF7ED);
        textColor = isDark ? const Color(0xFFFB923C) : const Color(0xFFEA580C);
        label = 'مفاوضات';
        break;
      case DealStatus.waitingSupplierReview:
        bg = isDark ? const Color(0xFF1E3A8A) : const Color(0xFFEFF6FF);
        textColor = isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB);
        label = 'بانتظار رد المصنع';
        break;
      case DealStatus.production:
        bg = isDark ? const Color(0xFF14532D) : const Color(0xFFF0FDF4);
        textColor = isDark ? const Color(0xFF4ADE80) : const Color(0xFF16A34A);
        label = 'قيد التنفيذ';
        break;
      case DealStatus.completed:
        bg = isDark ? const Color(0xFF374151) : const Color(0xFFF3F4F6);
        textColor = isDark ? const Color(0xFF9CA3AF) : const Color(0xFF4B5563);
        label = 'مكتملة';
        break;
      default:
        bg = isDark ? const Color(0xFF1E3A8A) : const Color(0xFFEFF6FF);
        textColor = isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB);
        label = status.titleAr;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(
              color: textColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(BuildContext context, String label, String value) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF9CA3AF),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color(0xFF111827),
          ),
        ),
      ],
    );
  }
}
