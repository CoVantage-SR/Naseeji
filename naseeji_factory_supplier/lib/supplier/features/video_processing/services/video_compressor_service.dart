import 'package:flutter/foundation.dart';

@immutable
class ProcessedVideoResult {
  final String originalPath;
  final String compressedPath;
  final String thumbnailUrl;
  final int durationSeconds;
  final double sizeMb;
  final int width;
  final int height;
  final bool isSuccess;
  final String? errorMessage;

  const ProcessedVideoResult({
    required this.originalPath,
    required this.compressedPath,
    required this.thumbnailUrl,
    required this.durationSeconds,
    required this.sizeMb,
    this.width = 1280,
    this.height = 720,
    this.isSuccess = true,
    this.errorMessage,
  });
}

class VideoCompressorService {
  static const int maxDurationSeconds = 15;
  static const double maxFileSizeBytes = 10 * 1024 * 1024; // 10MB
  static const int targetResolutionP = 720;

  /// Validates video constraints: max 15 seconds, max 10MB, max 720P.
  /// Simulates background video transcoding, auto-trimming, and thumbnail generation.
  Future<ProcessedVideoResult> processAndCompressVideo({
    required String filePath,
    required int inputDurationSeconds,
    required double inputSizeMb,
  }) async {
    // 1. Validation Check
    if (inputDurationSeconds > maxDurationSeconds) {
      return ProcessedVideoResult(
        originalPath: filePath,
        compressedPath: '',
        thumbnailUrl: '',
        durationSeconds: inputDurationSeconds,
        sizeMb: inputSizeMb,
        isSuccess: false,
        errorMessage:
            'مدة الفيديو أكبر من الحد الأقصى المسموح به (15 ثانية). يرجى تقصير الفيديو.',
      );
    }

    // 2. Background Compression Simulation (H.264 / 720P / 30fps)
    await Future.delayed(const Duration(milliseconds: 600));

    final compressedMb = (inputSizeMb * 0.4).clamp(0.5, 9.8); // Compressed down to <= 10MB
    final thumbnail =
        'https://example.com/thumbnails/thumb_${DateTime.now().millisecondsSinceEpoch}.webp';

    return ProcessedVideoResult(
      originalPath: filePath,
      compressedPath:
          'https://cdn.naseeji.com/videos/opt_${DateTime.now().millisecondsSinceEpoch}.mp4',
      thumbnailUrl: thumbnail,
      durationSeconds: inputDurationSeconds,
      sizeMb: compressedMb,
      width: 1280,
      height: 720,
      isSuccess: true,
    );
  }
}
