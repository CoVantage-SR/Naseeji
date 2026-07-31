import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_radius.dart';

/// Reviews Tab content displaying:
/// - Overall rating score (4.8 / 5.0)
/// - Star rating distribution bars (5-star down to 1-star)
/// - Customer photos horizontal gallery
/// - Verified factory reviews list
class ProductReviewsWidget extends StatelessWidget {
  final String productId;

  const ProductReviewsWidget({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    final customerPhotos = [
      'https://images.unsplash.com/photo-1528301721190-186c3bd85418?w=300',
      'https://images.unsplash.com/photo-1607604276583-eef5d076aa5f?w=300',
      'https://images.unsplash.com/photo-1620799140408-edc6dcb6d633?w=300',
      'https://images.unsplash.com/photo-1579546929518-9e396f3cc809?w=300',
    ];

    final reviews = [
      {
        'name': 'م. أسامة محمود',
        'factory': 'مصنع النيل للملابس الجاهزة',
        'rating': 5,
        'date': 'منذ ٣ أيام',
        'comment': 'قماش ممتازة جداً ونسبة التماثل في اللون خيالية. تم استلام الشحنة في الموعد المحدد بالضبط مع شهادات الجودة المعتمدة.',
        'verified': true,
      },
      {
        'name': 'أ. أحمد السيد',
        'factory': 'مؤسسة الدلتا للنسيج والتطريز',
        'rating': 5,
        'date': 'منذ أسبوعين',
        'comment': 'الخامة قطن صافي 100% بدون أي شوائب، والتعامل مع موارد شركة مصر للغزل والنسيج احترافي جداً.',
        'verified': true,
      },
      {
        'name': 'م. طارق عبدالكريم',
        'factory': 'مصنع كليوباترا للصناعات القطنية',
        'rating': 4,
        'date': 'منذ شهر',
        'comment': 'منتج جيد جداً، نأمل زيادة الطاقة الإنتاجية لتقليل مدة التوريد في الطلبيات الكبيرة.',
        'verified': true,
      },
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: AppRadius.rMD,
        border: Border.all(
          color: isDark ? AppColors.borderDark : Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'تقييمات العملاء والمصانع',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Rating Overview Row
          Row(
            children: [
              // Big Rating Score
              Column(
                children: [
                  Text(
                    '4.8',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                  ),
                  Row(
                    children: List.generate(
                      5,
                      (i) => const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '32 تقييم معتمد',
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                  ),
                ],
              ),
              const SizedBox(width: 20),
              Container(width: 1, height: 70, color: isDark ? AppColors.borderDark : Colors.grey.shade300),
              const SizedBox(width: 20),
              // Rating Distribution Progress Bars
              Expanded(
                child: Column(
                  children: [
                    _buildRatingBar(context, star: '5 نجوم', percent: 0.85, primaryColor: primaryColor),
                    _buildRatingBar(context, star: '4 نجوم', percent: 0.10, primaryColor: primaryColor),
                    _buildRatingBar(context, star: '3 نجوم', percent: 0.03, primaryColor: primaryColor),
                    _buildRatingBar(context, star: '2 نجوم', percent: 0.01, primaryColor: primaryColor),
                    _buildRatingBar(context, star: 'نجمة', percent: 0.01, primaryColor: primaryColor),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Customer Photos Section
          const Text(
            'صور المنتجات من المصانع',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 70,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: customerPhotos.length,
              itemBuilder: (context, index) {
                return Container(
                  width: 70,
                  margin: const EdgeInsets.only(left: 8),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.backgroundDark : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: isDark ? AppColors.borderDark : Colors.grey.shade300),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.network(
                      customerPhotos[index],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: isDark ? AppColors.borderDark : Colors.grey.shade200,
                        child: Icon(Icons.image_outlined, size: 24, color: Colors.grey.shade500),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          Divider(color: isDark ? AppColors.borderDark : Colors.grey.shade200),
          const SizedBox(height: 12),

          // Reviews List
          ...reviews.map((r) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: primaryColor.withValues(alpha: 0.12),
                        child: Text(
                          (r['name'] as String).substring(3, 4),
                          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  r['name'] as String,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                                if (r['verified'] == true) ...[
                                  const SizedBox(width: 4),
                                  const Icon(Icons.verified_user_rounded, color: AppColors.success, size: 14),
                                ],
                              ],
                            ),
                            Text(
                              r['factory'] as String,
                              style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        r['date'] as String,
                        style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: List.generate(
                      5,
                      (i) => Icon(
                        i < (r['rating'] as int) ? Icons.star_rounded : Icons.star_border_rounded,
                        color: Colors.amber,
                        size: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    r['comment'] as String,
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.5,
                      color: isDark ? AppColors.textSecondaryDark : Colors.grey.shade800,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildRatingBar(
    BuildContext context, {
    required String star,
    required double percent,
    required Color primaryColor,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          SizedBox(
            width: 45,
            child: Text(
              star,
              style: TextStyle(fontSize: 10, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: percent,
                minHeight: 6,
                backgroundColor: isDark ? AppColors.backgroundDark : Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

