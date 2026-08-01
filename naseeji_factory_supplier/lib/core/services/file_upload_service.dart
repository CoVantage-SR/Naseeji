import 'dart:io';

class FileUploadService {
  Future<String> uploadFile(File file, {required String uploadEndpoint}) async {
    // Backend API integration entry point
    await Future.delayed(const Duration(milliseconds: 600));
    return file.path;
  }
}
