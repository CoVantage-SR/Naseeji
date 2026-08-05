import 'dart:io';

enum VerificationMethod { company, identity }

class VerificationValidator {
  static const int maxFileSizeBytes = 10 * 1024 * 1024; // 10 MB

  static const List<String> allowedExtensions = [
    'pdf',
    'png',
    'jpg',
    'jpeg',
  ];

  static String? validateFile(File? file, {bool isRequired = true, String fieldName = 'المستند'}) {
    if (file == null) {
      if (isRequired) return 'يرجى رفع $fieldName';
      return null;
    }

    final path = file.path.toLowerCase();
    final ext = path.split('.').last;

    if (!allowedExtensions.contains(ext)) {
      return 'صيغة الملف غير مدعومة. الصيغ المسموحة: PDF, PNG, JPG, JPEG';
    }

    try {
      final bytes = file.lengthSync();
      if (bytes > maxFileSizeBytes) {
        return 'حجم الملف يتجاوز الحد الأقصى (10 ميجابايت)';
      }
    } catch (_) {
      // In web or mock file path test
    }

    return null;
  }

  static Map<String, String> validateCompanyVerification({
    required String commercialRegister,
    required String? taxNumber,
    required File? crDocument,
    required File? taxDocument,
  }) {
    final Map<String, String> errors = {};

    final crErr = validateFile(crDocument, isRequired: false, fieldName: 'ملف السجل التجاري');
    if (crErr != null) errors['crDocument'] = crErr;

    final taxErr = validateFile(taxDocument, isRequired: false, fieldName: 'ملف البطاقة الضريبية');
    if (taxErr != null) errors['taxDocument'] = taxErr;

    return errors;
  }

  static Map<String, String> validateIdentityVerification({
    required File? idFront,
    required File? idBack,
    required File? selfieWithId,
    required String businessName,
    required String? businessType,
    required String businessAddress,
  }) {
    final Map<String, String> errors = {};

    final frontErr = validateFile(idFront, isRequired: false, fieldName: 'وجه البطاقة الشخصية');
    if (frontErr != null) errors['idFront'] = frontErr;

    final backErr = validateFile(idBack, isRequired: false, fieldName: 'ظهر البطاقة الشخصية');
    if (backErr != null) errors['idBack'] = backErr;

    final selfieErr = validateFile(selfieWithId, isRequired: false, fieldName: 'صورة سيلفي مع البطاقة');
    if (selfieErr != null) errors['selfieWithId'] = selfieErr;

    return errors;
  }
}
