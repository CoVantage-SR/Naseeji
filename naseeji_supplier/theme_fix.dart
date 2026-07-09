import 'dart:io';

void main() {
  final dir = Directory('lib');
  if (!dir.existsSync()) {
    print('Error: lib folder not found. Run from the project root.');
    return;
  }

  int count = 0;
  dir.listSync(recursive: true).forEach((entity) {
    if (entity is File && entity.path.endsWith('.dart')) {
      final content = entity.readAsStringSync();
      if (content.contains('0xFFF8F9FF')) {
        // Replace color with Theme.of(context).scaffoldBackgroundColor
        // Also remove const from decoration/widgets if it causes errors
        String updated = content.replaceAll(
          'const Color(0xFFF8F9FF)',
          'Theme.of(context).scaffoldBackgroundColor',
        );
        updated = updated.replaceAll(
          'Color(0xFFF8F9FF)',
          'Theme.of(context).scaffoldBackgroundColor',
        );
        
        // Remove const from BoxDecoration if it was const
        updated = updated.replaceAll(
          'const BoxDecoration',
          'BoxDecoration',
        );
        
        entity.writeAsStringSync(updated);
        print('Updated: ${entity.path}');
        count++;
      }
    }
  });

  print('Success: Updated $count files.');
}
