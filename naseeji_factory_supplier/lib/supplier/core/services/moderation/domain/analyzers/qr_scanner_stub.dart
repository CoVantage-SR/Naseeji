import 'package:naseeji_factory/supplier/core/services/moderation/domain/analyzers/content_analyzer_interface.dart';
import 'package:naseeji_factory/supplier/core/services/moderation/domain/entities/moderation_enums.dart';
import 'package:naseeji_factory/supplier/core/services/moderation/domain/entities/moderation_result.dart';

abstract class QrScanner {
  Future<String?> detectQrCodeContent(String imagePathOrUrl);
}

class MockQrScanner implements QrScanner {
  @override
  Future<String?> detectQrCodeContent(String imagePathOrUrl) async {
    // MVP Mock QR Scanner ready for zxing/mobile_scanner integration
    await Future.delayed(const Duration(milliseconds: 50));
    return null;
  }
}

class QrCodeAnalyzer implements ContentAnalyzer {
  final QrScanner qrScanner;

  QrCodeAnalyzer({QrScanner? qrScanner})
      : qrScanner = qrScanner ?? MockQrScanner();

  @override
  Future<ContentModerationResult?> analyze({
    required String text,
    required ModerationTarget target,
  }) async {
    final qrData = await qrScanner.detectQrCodeContent(text);
    if (qrData != null && qrData.isNotEmpty) {
      return ContentModerationResult(
        isAllowed: false,
        target: target,
        violationType: ViolationType.qrCode,
        matchedSnippet: qrData,
        timestamp: DateTime.now(),
      );
    }
    return null;
  }
}

