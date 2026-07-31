import 'package:naseeji_supplier/core/services/moderation/domain/analyzers/content_analyzer_interface.dart';
import 'package:naseeji_supplier/core/services/moderation/domain/entities/moderation_enums.dart';
import 'package:naseeji_supplier/core/services/moderation/domain/entities/moderation_result.dart';

abstract class OcrScanner {
  Future<String?> extractTextFromImage(String imagePathOrUrl);
}

class MockOcrScanner implements OcrScanner {
  @override
  Future<String?> extractTextFromImage(String imagePathOrUrl) async {
    // MVP Mock OCR Implementation ready for Cloud Vision / ML Kit OCR integration
    await Future.delayed(const Duration(milliseconds: 50));
    return null; // Clean mock text
  }
}

class ImageOcrAnalyzer implements ContentAnalyzer {
  final OcrScanner ocrScanner;

  ImageOcrAnalyzer({OcrScanner? ocrScanner})
      : ocrScanner = ocrScanner ?? MockOcrScanner();

  @override
  Future<ContentModerationResult?> analyze({
    required String text,
    required ModerationTarget target,
  }) async {
    final extractedText = await ocrScanner.extractTextFromImage(text);
    if (extractedText != null && extractedText.isNotEmpty) {
      return ContentModerationResult(
        isAllowed: false,
        target: target,
        violationType: ViolationType.ocrDetectedText,
        matchedSnippet: extractedText,
        timestamp: DateTime.now(),
      );
    }
    return null;
  }
}
