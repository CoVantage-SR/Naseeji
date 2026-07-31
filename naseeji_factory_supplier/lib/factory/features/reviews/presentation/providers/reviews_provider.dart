import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'reviews_provider.g.dart';

class ReviewModel {
  final String id;
  final String orderId;
  final String supplierId;
  final String supplierName;
  final String factoryName;
  final String factoryLogo;
  final double overallRating;
  final Map<String, double> categoryRatings;
  final bool wouldRecommend;
  final String reviewText;
  final List<String> images;
  final List<String> videos;
  final bool isPublic;
  final String reviewDate;
  final String? supplierReply;
  final String? replyDate;

  ReviewModel({
    required this.id,
    required this.orderId,
    required this.supplierId,
    required this.supplierName,
    required this.factoryName,
    required this.factoryLogo,
    required this.overallRating,
    required this.categoryRatings,
    required this.wouldRecommend,
    required this.reviewText,
    required this.images,
    required this.videos,
    required this.isPublic,
    required this.reviewDate,
    this.supplierReply,
    this.replyDate,
  });

  ReviewModel copyWith({
    double? overallRating,
    Map<String, double>? categoryRatings,
    bool? wouldRecommend,
    String? reviewText,
    List<String>? images,
    List<String>? videos,
    bool? isPublic,
    String? supplierReply,
    String? replyDate,
  }) {
    return ReviewModel(
      id: id,
      orderId: orderId,
      supplierId: supplierId,
      supplierName: supplierName,
      factoryName: factoryName,
      factoryLogo: factoryLogo,
      overallRating: overallRating ?? this.overallRating,
      categoryRatings: categoryRatings ?? this.categoryRatings,
      wouldRecommend: wouldRecommend ?? this.wouldRecommend,
      reviewText: reviewText ?? this.reviewText,
      images: images ?? this.images,
      videos: videos ?? this.videos,
      isPublic: isPublic ?? this.isPublic,
      reviewDate: reviewDate,
      supplierReply: supplierReply ?? this.supplierReply,
      replyDate: replyDate ?? this.replyDate,
    );
  }
}

class ReviewsState {
  final List<ReviewModel> reviews;
  final Map<String, Map<String, double>> draftRatings; // orderId -> categoryRatings
  final Map<String, bool> draftRecommendations;

  ReviewsState({
    required this.reviews,
    required this.draftRatings,
    required this.draftRecommendations,
  });

  ReviewsState copyWith({
    List<ReviewModel>? reviews,
    Map<String, Map<String, double>>? draftRatings,
    Map<String, bool>? draftRecommendations,
  }) {
    return ReviewsState(
      reviews: reviews ?? this.reviews,
      draftRatings: draftRatings ?? this.draftRatings,
      draftRecommendations: draftRecommendations ?? this.draftRecommendations,
    );
  }
}

// Static category rating names
const List<String> kRatingCategories = [
  'جودة المنتج',
  'جودة الخامات',
  'الأسعار والتنافسية',
  'سرعة التسليم',
  'جودة التغليف',
  'مستوى التواصل',
  'خدمة ما بعد البيع',
  'الالتزام بالمواصفات',
];

final List<ReviewModel> _mockReviews = [
  ReviewModel(
    id: 'REV-001',
    orderId: 'ORD-204',
    supplierId: 'SUP-01',
    supplierName: 'مصنع غزل المحلة',
    factoryName: 'نسيجي للصناعات النسيجية',
    factoryLogo: 'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61',
    overallRating: 4.7,
    categoryRatings: {
      'جودة المنتج': 5.0,
      'جودة الخامات': 4.5,
      'الأسعار والتنافسية': 4.5,
      'سرعة التسليم': 4.5,
      'جودة التغليف': 5.0,
      'مستوى التواصل': 5.0,
      'خدمة ما بعد البيع': 4.5,
      'الالتزام بالمواصفات': 4.5,
    },
    wouldRecommend: true,
    reviewText:
        'تجربة ممتازة مع مصنع غزل المحلة، الخيوط كانت بجودة عالية ومطابقة تماماً للمواصفات المتفق عليها. التعامل كان احترافياً من أول اتصال وحتى استلام البضاعة. أنصح بالتعامل معهم.',
    images: [
      'https://images.unsplash.com/photo-1544816155-12df9643f363',
      'https://images.unsplash.com/photo-1598300042247-d088f8ab3a91',
    ],
    videos: [],
    isPublic: true,
    reviewDate: '٢٠٢٦/٠٧/١٢',
    supplierReply: 'شكراً جزيلاً على تقييمكم المميز! يسعدنا أن تكون تجربتكم إيجابية ونتطلع للتعامل معكم دائماً.',
    replyDate: '٢٠٢٦/٠٧/١٣',
  ),
  ReviewModel(
    id: 'REV-002',
    orderId: 'ORD-203',
    supplierId: 'SUP-02',
    supplierName: 'منسوجات النيل الحديثة',
    factoryName: 'نسيجي للصناعات النسيجية',
    factoryLogo: 'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61',
    overallRating: 3.8,
    categoryRatings: {
      'جودة المنتج': 4.0,
      'جودة الخامات': 4.0,
      'الأسعار والتنافسية': 5.0,
      'سرعة التسليم': 3.0,
      'جودة التغليف': 3.0,
      'مستوى التواصل': 4.0,
      'خدمة ما بعد البيع': 3.0,
      'الالتزام بالمواصفات': 3.5,
    },
    wouldRecommend: true,
    reviewText: 'الجودة كانت معقولة لكن التوصيل تأخر بعض الشيء عن الموعد المحدد. التغليف كان بسيطاً ويحتاج إلى تحسين. الأسعار تنافسية جداً.',
    images: [],
    videos: [],
    isPublic: true,
    reviewDate: '٢٠٢٦/٠٧/٠٥',
    supplierReply: null,
    replyDate: null,
  ),
];

@riverpod
class ReviewsNotifier extends _$ReviewsNotifier {
  @override
  ReviewsState build() {
    return ReviewsState(
      reviews: _mockReviews,
      draftRatings: {},
      draftRecommendations: {},
    );
  }

  void updateDraftCategoryRating(String orderId, String category, double rating) {
    final drafts = Map<String, Map<String, double>>.from(state.draftRatings);
    final existing = Map<String, double>.from(drafts[orderId] ?? {});
    existing[category] = rating;
    drafts[orderId] = existing;
    state = state.copyWith(draftRatings: drafts);
  }

  double getDraftCategoryRating(String orderId, String category) {
    return state.draftRatings[orderId]?[category] ?? 0.0;
  }

  double getDraftOverallRating(String orderId) {
    final cats = state.draftRatings[orderId];
    if (cats == null || cats.isEmpty) return 0.0;
    return cats.values.reduce((a, b) => a + b) / cats.length;
  }

  void updateDraftRecommendation(String orderId, bool value) {
    final recs = Map<String, bool>.from(state.draftRecommendations);
    recs[orderId] = value;
    state = state.copyWith(draftRecommendations: recs);
  }

  bool? getDraftRecommendation(String orderId) {
    return state.draftRecommendations[orderId];
  }

  void submitReview({
    required String orderId,
    required String supplierId,
    required String supplierName,
    required String reviewText,
    required List<String> images,
    required List<String> videos,
    required bool isPublic,
  }) {
    final overallRating = getDraftOverallRating(orderId);
    final categoryRatings = Map<String, double>.from(state.draftRatings[orderId] ?? {});
    final wouldRecommend = state.draftRecommendations[orderId] ?? true;

    final newReview = ReviewModel(
      id: 'REV-${state.reviews.length + 100}',
      orderId: orderId,
      supplierId: supplierId,
      supplierName: supplierName,
      factoryName: 'نسيجي للصناعات النسيجية',
      factoryLogo: 'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61',
      overallRating: overallRating,
      categoryRatings: categoryRatings,
      wouldRecommend: wouldRecommend,
      reviewText: reviewText,
      images: images,
      videos: videos,
      isPublic: isPublic,
      reviewDate: '٢٠٢٦/٠٧/١٤',
    );
    state = state.copyWith(reviews: [newReview, ...state.reviews]);
  }

  ReviewModel? getReviewById(String reviewId) {
    try {
      return state.reviews.firstWhere((r) => r.id == reviewId);
    } catch (_) {
      return null;
    }
  }

  ReviewModel? getReviewByOrderId(String orderId) {
    try {
      return state.reviews.firstWhere((r) => r.orderId == orderId);
    } catch (_) {
      return null;
    }
  }

  List<ReviewModel> getReviewsBySupplier(String supplierId) {
    return state.reviews.where((r) => r.supplierId == supplierId).toList();
  }

  double getAverageRating(String supplierId) {
    final reviews = getReviewsBySupplier(supplierId);
    if (reviews.isEmpty) return 0;
    return reviews.map((r) => r.overallRating).reduce((a, b) => a + b) / reviews.length;
  }

  Map<int, int> getRatingBreakdown(String supplierId) {
    final reviews = getReviewsBySupplier(supplierId);
    final breakdown = {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};
    for (final r in reviews) {
      final rounded = r.overallRating.round().clamp(1, 5);
      breakdown[rounded] = (breakdown[rounded] ?? 0) + 1;
    }
    return breakdown;
  }

  void deleteReview(String reviewId) {
    state = state.copyWith(
      reviews: state.reviews.where((r) => r.id != reviewId).toList(),
    );
  }
}



