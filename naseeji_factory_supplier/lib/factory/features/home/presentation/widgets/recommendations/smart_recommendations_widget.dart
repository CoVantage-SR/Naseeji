import 'package:flutter/material.dart';
import '../../../domain/entities/home_entities.dart';
import '../common/section_header_widget.dart';
import 'recommendation_card_widget.dart';

class SmartRecommendationsWidget extends StatelessWidget {
  final List<SmartRecommendation> recommendations;
  final ValueChanged<SmartRecommendation> onRecommendationTap;

  const SmartRecommendationsWidget({
    super.key,
    required this.recommendations,
    required this.onRecommendationTap,
  });

  @override
  Widget build(BuildContext context) {
    if (recommendations.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeaderWidget(
          title: 'توصيات الذكاء الاصطناعي الذكية',
          actionLabel: '',
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: recommendations.length,
            itemBuilder: (context, index) {
              final rec = recommendations[index];
              return RecommendationCardWidget(
                recommendation: rec,
                onTap: () => onRecommendationTap(rec),
              );
            },
          ),
        ),
      ],
    );
  }
}



