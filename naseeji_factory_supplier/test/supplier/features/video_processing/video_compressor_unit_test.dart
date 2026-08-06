import 'package:flutter_test/flutter_test.dart';
import 'package:naseeji_factory/supplier/features/video_processing/services/video_compressor_service.dart';

void main() {
  group('VideoCompressorService Unit Tests', () {
    late VideoCompressorService compressor;

    setUp(() {
      compressor = VideoCompressorService();
    });

    test('Rejects video exceeding 15 seconds max duration limit', () async {
      final result = await compressor.processAndCompressVideo(
        filePath: '/storage/raw_video.mp4',
        inputDurationSeconds: 25, // > 15s
        inputSizeMb: 15.0,
      );

      expect(result.isSuccess, isFalse);
      expect(result.errorMessage, contains('15 ثانية'));
    });

    test('Compresses valid video (<= 15s) and generates thumbnail', () async {
      final result = await compressor.processAndCompressVideo(
        filePath: '/storage/fabric_demo.mp4',
        inputDurationSeconds: 12,
        inputSizeMb: 18.0,
      );

      expect(result.isSuccess, isTrue);
      expect(result.sizeMb, lessThanOrEqualTo(10.0));
      expect(result.thumbnailUrl, contains('.webp'));
      expect(result.compressedPath, contains('opt_'));
    });
  });
}
