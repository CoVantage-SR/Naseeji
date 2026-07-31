import '../entities/product_subscription_limit_model.dart';

enum ValidationLimitType {
  productQuota,
  imageQuota,
  videoQuota,
  pdfQuota,
  subscriptionActive,
}

class ValidationResult {
  final bool isValid;
  final String? errorMessage;
  final ValidationLimitType? limitType;

  const ValidationResult({
    required this.isValid,
    this.errorMessage,
    this.limitType,
  });

  factory ValidationResult.valid() => const ValidationResult(isValid: true);
  factory ValidationResult.invalid(String message, ValidationLimitType type) => ValidationResult(
        isValid: false,
        errorMessage: message,
        limitType: type,
      );
}

class ProductValidationService {
  ValidationResult validateAddProduct(ProductSubscriptionLimitModel limits) {
    // Step 1: Check Subscription Exists
    // (limits is present)

    // Step 2: Check Active
    if (limits.isExpired) {
      return ValidationResult.invalid(
        'عفواً، اشتراكك الحالي منتهي أو موقوف. يرجى تجديد الاشتراك لإضافة منتجات جديدة.',
        ValidationLimitType.subscriptionActive,
      );
    }

    // Step 3: Check Product Limit
    if (limits.remainingProducts <= 0) {
      return ValidationResult.invalid(
        'وصلت للحد الأقصى للمنتجات المسموح بها في باقتك الحالية (${limits.maxProducts} منتج). قم بترقية الباقة لإضافة المزيد.',
        ValidationLimitType.productQuota,
      );
    }

    // Step 4: Check Image Limit
    if (limits.maxImagesPerProduct <= 0) {
      return ValidationResult.invalid(
        'باقتك الحالية لا تدعم رفع صور للمنتج. يرجى الترقية لتفعيل الصور.',
        ValidationLimitType.imageQuota,
      );
    }

    // Step 5: Check Video Limit
    if (limits.maxVideosPerProduct < 0) {
      return ValidationResult.invalid(
        'باقتك الحالية لا تدعم رفع فيديو للمنتج. يرجى الترقية.',
        ValidationLimitType.videoQuota,
      );
    }

    // Step 6: Check PDF Limit
    if (limits.maxPdfsPerProduct < 0) {
      return ValidationResult.invalid(
        'باقتك الحالية لا تدعم رفع ملفات PDF للمنتج. يرجى الترقية.',
        ValidationLimitType.pdfQuota,
      );
    }

    return ValidationResult.valid();
  }

  ValidationResult validateUploadImage(ProductSubscriptionLimitModel limits, int currentImageCount) {
    if (limits.isExpired) {
      return ValidationResult.invalid(
        'الاشتراك منتهي. لا يمكنك رفع صور جديدة.',
        ValidationLimitType.subscriptionActive,
      );
    }
    if (currentImageCount >= limits.maxImagesPerProduct) {
      return ValidationResult.invalid(
        'وصلت للحد الأقصى للصور المسموح بها للمنتج الواحد (${limits.maxImagesPerProduct} صور). ترقية الباقة تمنحك إمكانية رفع صور أكثر.',
        ValidationLimitType.imageQuota,
      );
    }
    return ValidationResult.valid();
  }

  ValidationResult validateUploadVideo(ProductSubscriptionLimitModel limits, int currentVideoCount) {
    if (limits.isExpired) {
      return ValidationResult.invalid(
        'الاشتراك منتهي. لا يمكنك رفع فيديوهات جديدة.',
        ValidationLimitType.subscriptionActive,
      );
    }
    if (currentVideoCount >= limits.maxVideosPerProduct) {
      return ValidationResult.invalid(
        'وصلت للحد الأقصى لفيديوهات المنتج المتاحة بباقتك (${limits.maxVideosPerProduct} فيديو). يرجى ترقية الباقة المعتمدة.',
        ValidationLimitType.videoQuota,
      );
    }
    return ValidationResult.valid();
  }

  ValidationResult validateUploadPdf(ProductSubscriptionLimitModel limits, int currentPdfCount) {
    if (limits.isExpired) {
      return ValidationResult.invalid(
        'الاشتراك منتهي. لا يمكنك رفع ملفات PDF جديدة.',
        ValidationLimitType.subscriptionActive,
      );
    }
    if (currentPdfCount >= limits.maxPdfsPerProduct) {
      return ValidationResult.invalid(
        'وصلت للحد الأقصى لكتالوجات ومستندات PDF بباقتك (${limits.maxPdfsPerProduct} ملف). يرجى ترقية الباقة لزيادة سعة المستندات.',
        ValidationLimitType.pdfQuota,
      );
    }
    return ValidationResult.valid();
  }
}

