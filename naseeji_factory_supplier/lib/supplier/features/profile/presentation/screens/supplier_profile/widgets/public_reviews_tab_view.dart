import 'package:flutter/material.dart';
import 'package:naseeji_factory/core/theme/app_colors.dart';
import 'package:naseeji_factory/supplier/features/profile/domain/entities/supplier_profile.dart';

class PublicReviewsTabView extends StatelessWidget {
  final SupplierProfile profile;

  const PublicReviewsTabView({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Ratings summary header card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E1EF)),
            ),
            child: Row(
              children: [
                // Right side: Progress bars
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      _buildProgressBarRow('5 نجوم', 0.85),
                      _buildProgressBarRow('4 نجوم', 0.12),
                      _buildProgressBarRow('3 نجوم', 0.03),
                    ],
                  ),
                ),
                SizedBox(width: 16),
                // Left side: Rating score
                Column(
                  children: [
                    Text(
                      '${profile.rating}',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Color(0xFF0040E0)),
                    ),
                    SizedBox(height: 2),
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          index < profile.rating.floor() ? Icons.star : Icons.star_half,
                          color: Colors.orange,
                          size: 14,
                        );
                      }),
                    ),
                    SizedBox(height: 4),
                    Text('38 تقييم موثق', style: TextStyle(fontSize: 8, color: AppColors.outline)),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 20),

          // Title
          Text(
            'تقييمات المصانع والشركاء',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            textAlign: TextAlign.end,
          ),
          SizedBox(height: 12),

          // Reviews list
          _buildReviewCard('مصانع النور للملابس الجاهزة', 'تعاقدنا مع المورد لتوريد 50,000 متر قماش قطني وجاءت الشحنة مطابقة تماماً للعينات وبموعد التوصيل المحدد.', 5.0, '2026-05'),
          _buildReviewCard('شركة الفوزان المحدودة للأزياء', 'تسهيلات مريحة في الدفع الضامن، واستجابة سريعة جداً للمقترحات وتغيير الكميات.', 4.8, '2026-04'),
          _buildReviewCard('مؤسسة خيوط الشرق التجارية', 'جودة القماش ممتازة ومغلف بعناية لحمايته من الرطوبة أثناء الشحن.', 5.0, '2026-03'),
        ],
      ),
    );
  }

  Widget _buildProgressBarRow(String label, double pct) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: pct,
                  backgroundColor: const Color(0xFFF1F1FE),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
                  minHeight: 6,
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          Text(label, style: TextStyle(fontSize: 8, color: AppColors.outline), textAlign: TextAlign.end),
        ],
      ),
    );
  }

  Widget _buildReviewCard(String author, String text, double score, String date) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E1EF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(date, style: TextStyle(fontSize: 8, color: AppColors.outline)),
              Row(
                children: [
                  Text(author, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
                  SizedBox(width: 8),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(color: const Color(0xFFF0F4FF), shape: BoxShape.circle),
                    child: const Icon(Icons.business, color: Color(0xFF0040E0), size: 16),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: List.generate(5, (index) {
              return Icon(
                index < score.floor() ? Icons.star : Icons.star_border,
                color: Colors.orange,
                size: 14,
              );
            }),
          ),
          SizedBox(height: 8),
          Text(
            text,
            style: TextStyle(fontSize: 10.5, color: AppColors.onSurfaceVariant, height: 1.5),
            textAlign: TextAlign.end,
          ),
        ],
      ),
    );
  }
}

