import '../entities/subscription_models.dart';

/// Pure domain service responsible for subscription rule enforcement and validation.
/// Contains ZERO UI dependencies or logic.
class SubscriptionService {
  const SubscriptionService();

  /// Validates whether the supplier can add a new product under their current plan.
  ValidationResult validateAddProduct({
    required SupplierSubscription subscription,
    required SubscriptionUsage usage,
  }) {
    final maxProducts = subscription.limits.maxProducts;

    // -1 signifies unlimited products (Enterprise tier)
    if (maxProducts != -1 && usage.productsUsed >= maxProducts) {
      return ValidationResult.denied(
        title: 'لقد وصلت للحد الأقصى',
        errorMessage:
            'لقد استخدمت جميع المنتجات المتاحة في باقتك الحالية.\nيمكنك ترقية الباقة لإضافة المزيد.',
        requiresUpgrade: true,
      );
    }
    return ValidationResult.allowed();
  }

  /// Validates whether the supplier can upload additional images for a single product.
  ValidationResult validateAddImage({
    required SupplierSubscription subscription,
    required int currentImagesCount,
  }) {
    final maxImages = subscription.limits.maxImagesPerProduct;

    if (maxImages != -1 && currentImagesCount >= maxImages) {
      return ValidationResult.denied(
        title: 'حد الصور المسموح',
        errorMessage:
            'وصلت للحد الأقصى لعدد الصور المسموح بها للمنتج في باقتك الحالية ($maxImages صور).',
        requiresUpgrade: true,
      );
    }
    return ValidationResult.allowed();
  }

  /// Validates whether the supplier can upload video for a product.
  ValidationResult validateAddVideo({
    required SupplierSubscription subscription,
    required int currentVideosCount,
  }) {
    final maxVideos = subscription.limits.maxVideosPerProduct;

    // Plan does not allow videos at all (e.g. Free plan)
    if (maxVideos == 0) {
      return ValidationResult.denied(
        title: 'الميزة غير متاحة',
        errorMessage: 'هذه الميزة متاحة في الباقات الأعلى.',
        requiresUpgrade: true,
      );
    }

    if (maxVideos != -1 && currentVideosCount >= maxVideos) {
      return ValidationResult.denied(
        title: 'حد الفيديوهات المسموح',
        errorMessage:
            'وصلت للحد الأقصى لعدد الفيديوهات المسموح بها للمنتج في باقتك الحالية ($maxVideos فيديو).',
        requiresUpgrade: true,
      );
    }

    return ValidationResult.allowed();
  }

  /// Validates whether the supplier can attach additional PDF files for a product.
  ValidationResult validateAddPdf({
    required SupplierSubscription subscription,
    required int currentPdfsCount,
  }) {
    final maxPdfs = subscription.limits.maxPdfsPerProduct;

    if (maxPdfs != -1 && currentPdfsCount >= maxPdfs) {
      return ValidationResult.denied(
        title: 'حد ملفات PDF المسموح',
        errorMessage:
            'وصلت للحد الأقصى لعدد ملفات PDF المسموح بها للمنتج في باقتك الحالية ($maxPdfs ملف).',
        requiresUpgrade: true,
      );
    }
    return ValidationResult.allowed();
  }

  /// Validates whether the supplier can create a new advertisement.
  ValidationResult validateAddAdvertisement({
    required SupplierSubscription subscription,
    required SubscriptionUsage usage,
  }) {
    final maxAds = subscription.limits.maxAdvertisements;

    if (maxAds != -1 && usage.advertisementsUsed >= maxAds) {
      return ValidationResult.denied(
        title: 'لقد وصلت للحد الأقصى للإعلانات',
        errorMessage:
            'لقد استخدمت جميع الإعلانات المتاحة في باقتك الحالية.\nيمكنك ترقية الباقة لإضافة المزيد.',
        requiresUpgrade: true,
      );
    }
    return ValidationResult.allowed();
  }

  /// Validates whether the supplier can mark a product as featured.
  ValidationResult validateSetFeaturedProduct({
    required SupplierSubscription subscription,
    required SubscriptionUsage usage,
  }) {
    final maxFeatured = subscription.limits.maxFeaturedProducts;

    if (maxFeatured == 0) {
      return ValidationResult.denied(
        title: 'المنتجات المميزة',
        errorMessage:
            'الباقة الحالية لا تدعم المنتجات المميزة. يمكنك ترقية الباقة لتفعيل هذه الميزة.',
        requiresUpgrade: true,
      );
    }

    if (maxFeatured != -1 && usage.featuredProductsUsed >= maxFeatured) {
      return ValidationResult.denied(
        title: 'حد المنتجات المميزة',
        errorMessage:
            'لقد استخدمت جميع المنتجات المميزة المتاحة في باقتك الحالية ($maxFeatured منتج مميز).',
        requiresUpgrade: true,
      );
    }
    return ValidationResult.allowed();
  }

  /// Validates whether the supplier can submit an RFQ response/request.
  ValidationResult validateSubmitRfq({
    required SupplierSubscription subscription,
    required SubscriptionUsage usage,
  }) {
    final maxRfqs = subscription.limits.maxMonthlyRfqs;

    if (maxRfqs != -1 && usage.rfqsUsed >= maxRfqs) {
      return ValidationResult.denied(
        title: 'حد طلبات RFQ المسموح',
        errorMessage:
            'لقد استخدمت جميع طلبات RFQ المتاحة في باقتك لهذا الشهر ($maxRfqs طلب). يمكنك ترقية الباقة لإرسال المزيد.',
        requiresUpgrade: true,
      );
    }
    return ValidationResult.allowed();
  }
}


