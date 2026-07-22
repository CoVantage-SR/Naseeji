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
    if (limits.remainingProducts <= 0) {
      return ValidationResult.invalid(
        'وصلت للحد الأقصى للمنتجات المسموح بها في باقتك الحالية (${limits.maxProducts} منتج). قم بترقية الباقة لإضافة المزيد.',
        ValidationLimitType.productQuota,
      );
    }
    return ValidationResult.valid();
  }

  ValidationResult validateUploadImage(ProductSubscriptionLimitModel limits, int currentImageCount) {
    if (currentImageCount >= limits.maxImagesPerProduct) {
      return ValidationResult.invalid(
        'وصلت للحد الأقصى للصور المسموح بها للمنتج الواحد (${limits.maxImagesPerProduct} صور). ترقية الباقة تمنحك إمكانية رفع صور أكثر.',
        ValidationLimitType.imageQuota,
      );
    }
    return ValidationResult.valid();
  }

  ValidationResult validateUploadVideo(ProductSubscriptionLimitModel limits, int currentVideoCount) {
    if (currentVideoCount >= limits.maxVideosPerProduct) {
      return ValidationResult.invalid(
        'وصلت للحد الأقصى لفيديوهات المنتج المتاحة بباقتك (${limits.maxVideosPerProduct} فيديو). يرجى ترقية الباقة المعتمدة.',
        ValidationLimitType.videoQuota,
      );
    }
    return ValidationResult.valid();
  }

  ValidationResult validateUploadPdf(ProductSubscriptionLimitModel limits, int currentPdfCount) {
    if (currentPdfCount >= limits.maxPdfsPerProduct) {
      return ValidationResult.invalid(
        'وصلت للحد الأقصى لكتالوجات ومستندات PDF بباقتك (${limits.maxPdfsPerProduct} ملف). يرجى ترقية الباقة لزيادة سعة المستندات.',
        ValidationLimitType.pdfQuota,
      );
    }
    return ValidationResult.valid();
  }
}
