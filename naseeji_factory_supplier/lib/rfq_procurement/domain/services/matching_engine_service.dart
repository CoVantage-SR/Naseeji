import 'package:flutter/foundation.dart';

@immutable
class RFQCandidateSupplier {
  final String id;
  final String companyName;
  final String categoryId;
  final String governorate;
  final String country;
  final double rating;
  final int avgLeadTimeDays;
  final double availableCapacityPercentage;
  final double avgPricePerUnit;
  final bool isBlueVerified;
  final bool isPremium;

  const RFQCandidateSupplier({
    required this.id,
    required this.companyName,
    required this.categoryId,
    required this.governorate,
    required this.country,
    required this.rating,
    required this.avgLeadTimeDays,
    required this.availableCapacityPercentage,
    required this.avgPricePerUnit,
    required this.isBlueVerified,
    required this.isPremium,
  });
}

@immutable
class RFQMatchResult {
  final String supplierId;
  final String companyName;
  final double matchScore; // 0 to 100
  final String matchReason;

  const RFQMatchResult({
    required this.supplierId,
    required this.companyName,
    required this.matchScore,
    required this.matchReason,
  });
}

class SmartMatchingEngineService {
  /// Evaluates all suppliers against RFQ specifications,
  /// calculates composite weighted scores, and returns the TOP 20 suppliers ONLY.
  List<RFQMatchResult> findTop20MatchedSuppliers({
    required String categoryId,
    required String governorate,
    required int maxLeadTimeDays,
    required double targetPrice,
    required List<RFQCandidateSupplier> candidates,
  }) {
    final matches = <RFQMatchResult>[];

    for (final supplier in candidates) {
      double score = 0.0;
      final reasons = <String>[];

      // 1. Category Match (30%)
      if (supplier.categoryId == categoryId) {
        score += 30.0;
        reasons.add('تطابق التخصص');
      }

      // 2. Lead Time Match (20%)
      if (supplier.avgLeadTimeDays <= maxLeadTimeDays) {
        score += 20.0;
        reasons.add('سرعة التوريد');
      } else {
        score += ((maxLeadTimeDays / supplier.avgLeadTimeDays) * 20.0).clamp(0.0, 20.0);
      }

      // 3. Rating (15%)
      final ratingScore = (supplier.rating / 5.0) * 15.0;
      score += ratingScore;
      if (supplier.rating >= 4.5) reasons.add('تقييم ممتازة');

      // 4. Governorate / Location Match (10%)
      if (supplier.governorate == governorate) {
        score += 10.0;
        reasons.add('قرب الجغرافيا');
      } else {
        score += 5.0;
      }

      // 5. Capacity Availability (10%)
      if (supplier.availableCapacityPercentage >= 30.0) {
        score += 10.0;
        reasons.add('طاقة إنتاجية متاحة');
      }

      // 6. Price Competitiveness (10%)
      if (supplier.avgPricePerUnit <= targetPrice) {
        score += 10.0;
        reasons.add('سعر منافس');
      }

      // 7. Blue Verification Bonus (5%)
      if (supplier.isBlueVerified) {
        score += 5.0;
        reasons.add('حساب موثق');
      }

      matches.add(
        RFQMatchResult(
          supplierId: supplier.id,
          companyName: supplier.companyName,
          matchScore: double.parse(score.toStringAsFixed(1)),
          matchReason: reasons.join(' • '),
        ),
      );
    }

    // Sort descending by match score
    matches.sort((a, b) => b.matchScore.compareTo(a.matchScore));

    // Pick ONLY Top 20 (or fewer if total candidates < 20)
    return matches.take(20).toList();
  }
}
