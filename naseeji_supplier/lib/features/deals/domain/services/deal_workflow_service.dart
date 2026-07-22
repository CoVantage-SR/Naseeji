import '../entities/deal_model.dart';

class DealWorkflowService {
  /// Anti-external contact filter regex patterns
  static final RegExp _phoneRegExp = RegExp(r'(01[0125]\d{8}|\+?201[0125]\d{8}|\d{11})');
  static final RegExp _emailRegExp = RegExp(r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}');
  static final RegExp _urlRegExp = RegExp(r'(https?:\/\/|www\.)[^\s]+');
  static final RegExp _socialMediaRegExp = RegExp(
    r'(whatsapp|telegram|facebook|instagram|linkedin|gmail|yahoo|outlook)',
    caseSensitive: false,
  );

  /// Validates text input to ensure no external contact details are passed.
  static String? validateNoExternalContact(String text) {
    if (text.trim().isEmpty) return null;

    if (_phoneRegExp.hasMatch(text) ||
        _emailRegExp.hasMatch(text) ||
        _urlRegExp.hasMatch(text) ||
        _socialMediaRegExp.hasMatch(text)) {
      return 'تم اكتشاف وسيلة تواصل خارجية. يرجى إتمام جميع مراحل الصفقة داخل منصة نسيجي حفاظاً على حقوق جميع الأطراف.';
    }

    return null;
  }

  /// Calculates the current progress step (1 to 15) for timeline visualization.
  static int getStepIndex(DealStatus status) {
    switch (status) {
      case DealStatus.newDeal:
        return 1;
      case DealStatus.waitingSupplierReview:
        return 2;
      case DealStatus.quotationSent:
        return 3;
      case DealStatus.negotiation:
        return 4;
      case DealStatus.agreementPending:
        return 5;
      case DealStatus.signed:
        return 6;
      case DealStatus.production:
        return 7;
      case DealStatus.readyForDelivery:
        return 8;
      case DealStatus.delivering:
        return 9;
      case DealStatus.qualityInspection:
        return 10;
      case DealStatus.paymentPending:
        return 11;
      case DealStatus.completed:
        return 12;
      case DealStatus.cancelled:
        return 0;
      case DealStatus.dispute:
        return -1;
    }
  }
}
