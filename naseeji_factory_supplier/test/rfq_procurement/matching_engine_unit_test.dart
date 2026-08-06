import 'package:flutter_test/flutter_test.dart';
import 'package:naseeji_factory/rfq_procurement/domain/services/matching_engine_service.dart';

void main() {
  group('SmartMatchingEngineService Unit Tests', () {
    late SmartMatchingEngineService engine;

    setUp(() {
      engine = SmartMatchingEngineService();
    });

    test('findTop20MatchedSuppliers limits notification targets to maximum 20 suppliers', () {
      // Create 50 candidate suppliers
      final candidates = List.generate(
        50,
        (i) => RFQCandidateSupplier(
          id: 'sup_$i',
          companyName: 'مصنع النسيج $i',
          categoryId: 'cat_cotton',
          governorate: i % 2 == 0 ? 'المحلة الكبرى' : 'القاهرة',
          country: 'مصر',
          rating: 3.5 + (i % 15) * 0.1,
          avgLeadTimeDays: 5 + (i % 10),
          availableCapacityPercentage: 20.0 + (i % 80),
          avgPricePerUnit: 100.0 + (i * 2),
          isBlueVerified: i % 3 == 0,
          isPremium: i % 5 == 0,
        ),
      );

      final topMatches = engine.findTop20MatchedSuppliers(
        categoryId: 'cat_cotton',
        governorate: 'المحلة الكبرى',
        maxLeadTimeDays: 7,
        targetPrice: 120.0,
        candidates: candidates,
      );

      // Must be exactly 20 (not 50)
      expect(topMatches.length, equals(20));

      // Must be sorted in descending order of matchScore
      for (int i = 0; i < topMatches.length - 1; i++) {
        expect(topMatches[i].matchScore, greaterThanOrEqualTo(topMatches[i + 1].matchScore));
      }
    });

    test('Top scored supplier receives highest ranking points', () {
      final candidates = [
        const RFQCandidateSupplier(
          id: 'sup_perfect',
          companyName: 'شركة النسيج الممتازة',
          categoryId: 'cat_cotton',
          governorate: 'المحلة الكبرى',
          country: 'مصر',
          rating: 5.0,
          avgLeadTimeDays: 3,
          availableCapacityPercentage: 80.0,
          avgPricePerUnit: 90.0,
          isBlueVerified: true,
          isPremium: true,
        ),
        const RFQCandidateSupplier(
          id: 'sup_low',
          companyName: 'ورشه غزل ضعيفة',
          categoryId: 'cat_wool',
          governorate: 'أسوان',
          country: 'مصر',
          rating: 2.0,
          avgLeadTimeDays: 20,
          availableCapacityPercentage: 10.0,
          avgPricePerUnit: 300.0,
          isBlueVerified: false,
          isPremium: false,
        ),
      ];

      final matches = engine.findTop20MatchedSuppliers(
        categoryId: 'cat_cotton',
        governorate: 'المحلة الكبرى',
        maxLeadTimeDays: 5,
        targetPrice: 100.0,
        candidates: candidates,
      );

      expect(matches.first.supplierId, equals('sup_perfect'));
      expect(matches.first.matchScore, equals(100.0)); // Perfect 100% score
    });
  });
}
