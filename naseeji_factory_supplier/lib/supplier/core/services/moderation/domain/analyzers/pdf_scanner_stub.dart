import 'package:naseeji_factory/core/services/moderation/domain/analyzers/content_analyzer_interface.dart';
import 'package:naseeji_factory/core/services/moderation/domain/entities/moderation_enums.dart';
import 'package:naseeji_factory/core/services/moderation/domain/entities/moderation_result.dart';

abstract class PdfScanner {
  Future<String?> extractTextFromPdf(String pdfPathOrUrl);
}

class MockPdfScanner implements PdfScanner {
  @override
  Future<String?> extractTextFromPdf(String pdfPathOrUrl) async {
    // MVP Mock PDF Scanner ready for pdfx/pdf_text parser integration
    await Future.delayed(const Duration(milliseconds: 50));
    return null;
  }
}

class PdfContentAnalyzer implements ContentAnalyzer {
  final PdfScanner pdfScanner;

  PdfContentAnalyzer({PdfScanner? pdfScanner})
      : pdfScanner = pdfScanner ?? MockPdfScanner();

  @override
  Future<ContentModerationResult?> analyze({
    required String text,
    required ModerationTarget target,
  }) async {
    final extractedText = await pdfScanner.extractTextFromPdf(text);
    if (extractedText != null && extractedText.isNotEmpty) {
      return ContentModerationResult(
        isAllowed: false,
        target: target,
        violationType: ViolationType.url,
        matchedSnippet: extractedText,
        timestamp: DateTime.now(),
      );
    }
    return null;
  }
}


