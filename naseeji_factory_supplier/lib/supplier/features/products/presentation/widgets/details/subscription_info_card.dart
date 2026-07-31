import 'package:flutter/material.dart';
import 'package:naseeji_factory/supplier/features/products/domain/entities/product_subscription_limit_model.dart';

class SubscriptionInfoCard extends StatelessWidget {
  final ProductSubscriptionLimitModel? limits;
  final VoidCallback onUpgrade;

  const SubscriptionInfoCard({
    super.key,
    this.limits,
    required this.onUpgrade,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final planName = limits?.currentPlan ?? 'Professional (احترافي)';
    final usedProducts = limits?.usedProducts ?? 58;
    final maxProducts = limits?.maxProducts ?? 100;
    final usedImages = limits?.usedImages ?? 8;
    final maxImages = limits?.maxImagesPerProduct ?? 10;
    final usedVideos = limits?.usedVideos ?? 1;
    final maxVideos = limits?.maxVideosPerProduct ?? 1;
    final usedPdfs = limits?.usedPdfs ?? 1;
    final maxPdfs = limits?.maxPdfsPerProduct ?? 2;

    final isNearLimit = (usedProducts / maxProducts) > 0.5;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2D1B4E) : const Color(0xFFFBF7FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? const Color(0xFF581C87) : const Color(0xFFE9D5FF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF3B0764) : const Color(0xFFF3E8FF),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.workspace_premium_rounded,
                        size: 18,
                        color: isDark ? const Color(0xFFC084FC) : const Color(0xFF9333EA),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'حدود الاشتراك والباقة',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : const Color(0xFF111827),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'الخطة الحالية: $planName',
                            style: TextStyle(
                              fontSize: 10.5,
                              color: isDark ? const Color(0xFFE9D5FF) : const Color(0xFF6B7280),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              if (isNearLimit) ...[
                const SizedBox(width: 8),
                SizedBox(
                  height: 30,
                  child: ElevatedButton(
                    onPressed: onUpgrade,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF9333EA),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text(
                      'ترقية الباقة',
                      style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ],
          ),

          const SizedBox(height: 12),

          // Quota Metrics Row
          Row(
            children: [
              Expanded(
                child: _buildQuotaPill(
                  context,
                  label: 'المنتجات',
                  used: usedProducts,
                  total: maxProducts,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: _buildQuotaPill(
                  context,
                  label: 'الصور/منتج',
                  used: usedImages,
                  total: maxImages,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: _buildQuotaPill(
                  context,
                  label: 'فيديو/منتج',
                  used: usedVideos,
                  total: maxVideos,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: _buildQuotaPill(
                  context,
                  label: 'PDF/منتج',
                  used: usedPdfs,
                  total: maxPdfs,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuotaPill(
    BuildContext context, {
    required String label,
    required int used,
    required int total,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isFull = used >= total;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            '$used / $total',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: isFull
                  ? const Color(0xFFEF4444)
                  : (isDark ? const Color(0xFFC084FC) : const Color(0xFF9333EA)),
            ),
          ),
        ],
      ),
    );
  }
}

