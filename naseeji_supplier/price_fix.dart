import 'dart:io';

void main() {
  final dir = Directory('lib');
  if (!dir.existsSync()) {
    print('Error: lib folder not found.');
    return;
  }

  int count = 0;
  dir.listSync(recursive: true).forEach((entity) {
    if (entity is File && entity.path.endsWith('.dart')) {
      final file = entity;
      String content = file.readAsStringSync();
      bool modified = false;

      if (content.contains('ر.س')) {
        content = content.replaceAll('ر.س', 'جنيه');
        modified = true;
      }
      
      if (content.contains('SAR')) {
        content = content.replaceAll('SAR', 'جنيه');
        modified = true;
      }

      if (modified) {
        file.writeAsStringSync(content);
        print('Currency updated: ${file.path}');
        count++;
      }
    }
  });

  print('Successfully updated currency in $count files.');
}
