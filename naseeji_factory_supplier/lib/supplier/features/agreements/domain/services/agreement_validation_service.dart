import '../entities/agreement_model.dart';

class AgreementValidationResult {
  final bool isValid;
  final String? errorMessage;

  const AgreementValidationResult.valid()
      : isValid = true,
        errorMessage = null;

  const AgreementValidationResult.invalid(this.errorMessage) : isValid = false;
}

class AgreementValidationService {
  /// يتحقق من إمكانية إنشاء الاتفاقية (يجب أن يكون عرض السعر مقبولاً)
  static AgreementValidationResult validateCreationFromQuotation({
    required bool isQuotationAccepted,
    required String rfqNumber,
    required String quotationNumber,
  }) {
    if (!isQuotationAccepted) {
      return const AgreementValidationResult.invalid(
        'لا يمكن إنشاء الاتفاقية إلا بعد قبول عرض السعر بشكل رسمي من المصنع.',
      );
    }
    if (rfqNumber.isEmpty || quotationNumber.isEmpty) {
      return const AgreementValidationResult.invalid(
        'بيانات RFQ أو عرض السعر مفقودة أو غير مكتملة.',
      );
    }
    return const AgreementValidationResult.valid();
  }

  /// يتحقق من إمكانية توقيع المورد على الاتفاقية
  static AgreementValidationResult validateSupplierSignature(B2BAgreement agreement) {
    if (agreement.status != AgreementStatus.awaitingSupplierSignature) {
      return AgreementValidationResult.invalid(
        'حالة الاتفاقية الحالية (${agreement.status.titleAr}) لا تسمح بالتوقيع الآن.',
      );
    }
    if (agreement.supplierSignature?.isSigned == true) {
      return const AgreementValidationResult.invalid(
        'تم توقيع الاتفاقية بالفعل من قبل المورد.',
      );
    }
    return const AgreementValidationResult.valid();
  }

  /// يتحقق من إمكانية توقيع المصنع على الاتفاقية
  static AgreementValidationResult validateFactorySignature(B2BAgreement agreement) {
    if (agreement.status != AgreementStatus.awaitingFactorySignature) {
      return AgreementValidationResult.invalid(
        'يجب أولاً توقيع المورد قبل أن يستطيع المصنع الاعتماد والتوقيع.',
      );
    }
    if (agreement.supplierSignature?.isSigned != true) {
      return const AgreementValidationResult.invalid(
        'توقيع المورد غير مكتمل بعد.',
      );
    }
    if (agreement.factorySignature?.isSigned == true) {
      return const AgreementValidationResult.invalid(
        'تم توقيع الاتفاقية بالفعل من قبل المصنع.',
      );
    }
    return const AgreementValidationResult.valid();
  }

  /// يتحقق من إمكانية بدء مرحلة الإنتاج والتصنيع
  static AgreementValidationResult validateProductionStart(B2BAgreement agreement) {
    if (agreement.status != AgreementStatus.active) {
      return const AgreementValidationResult.invalid(
        'يمنع البدء في عمليات الإنتاج قبل أن تصبح حالة الاتفاقية "ساري" بتوقيع الطرفين.',
      );
    }
    return const AgreementValidationResult.valid();
  }

  /// يتحقق مما إذا كان يسمح بتعديل عرض السعر بعد التوقيع
  static bool canModifyQuotation(B2BAgreement agreement) {
    return !agreement.isQuotationLocked;
  }
}

