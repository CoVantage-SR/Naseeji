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
      String content = entity.readAsStringSync();
      bool modified = false;

      // 1. Remove const from constructors of widgets that will contain dynamic colors
      final constReplacements = {
        'const TextStyle(': 'TextStyle(',
        'const Text(': 'Text(',
        'const BoxDecoration(': 'BoxDecoration(',
        'const Material(': 'Material(',
        'const Scaffold(': 'Scaffold(',
        'const AppBar(': 'AppBar(',
        'const Card(': 'Card(',
        'const Row(': 'Row(',
        'const Column(': 'Column(',
        'const Padding(': 'Padding(',
        'const Center(': 'Center(',
        'const SizedBox(': 'SizedBox(',
        'const Expanded(': 'Expanded(',
        'const Container(': 'Container(',
        'const PrimaryButton(': 'PrimaryButton(',
        'const CustomTextField(': 'CustomTextField(',
      };

      for (var entry in constReplacements.entries) {
        if (content.contains(entry.key)) {
          content = content.replaceAll(entry.key, entry.value);
          modified = true;
        }
      }

      // 2. Replace hardcoded AppColors/Colors references with dynamic Theme.of(context)
      final colorReplacements = {
        'AppColors.onSurfaceVariant': 'Theme.of(context).colorScheme.onSurfaceVariant',
        'AppColors.onSurface': 'Theme.of(context).colorScheme.onSurface',
        'AppColors.onBackground': 'Theme.of(context).colorScheme.onBackground',
        'AppColors.surface': 'Theme.of(context).colorScheme.surface',
        'backgroundColor: Colors.white': 'backgroundColor: Theme.of(context).colorScheme.surface',
        'color: Colors.white,': 'color: Theme.of(context).colorScheme.surface,',
        'color: Colors.white}': 'color: Theme.of(context).colorScheme.surface}',
        'color: const Color(0xFF191B24)': 'color: Theme.of(context).colorScheme.onSurface',
        'color: Color(0xFF191B24)': 'color: Theme.of(context).colorScheme.onSurface',
        'color: const Color(0xFF434656)': 'color: Theme.of(context).colorScheme.onSurfaceVariant',
        'color: Color(0xFF434656)': 'color: Theme.of(context).colorScheme.onSurfaceVariant',
      };

      for (var entry in colorReplacements.entries) {
        if (content.contains(entry.key)) {
          content = content.replaceAll(entry.key, entry.value);
          modified = true;
        }
      }

      if (modified) {
        entity.writeAsStringSync(content);
        print('Processed: ${entity.path}');
        count++;
      }
    }
  });

  print('Successfully processed $count files.');
}
