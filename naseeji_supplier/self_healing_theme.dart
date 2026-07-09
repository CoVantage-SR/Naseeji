import 'dart:io';

void main() async {
  final dir = Directory('lib');
  if (!dir.existsSync()) {
    print('Error: lib folder not found.');
    return;
  }

  print('Phase 1: Applying global dynamic theme replacements...');
  int count = 0;
  final entities = dir.listSync(recursive: true);
  print('Found ${entities.length} entities in lib/');
  
  for (final entity in entities) {
    if (entity is File && entity.path.endsWith('.dart')) {
      final file = entity;
      String content = file.readAsStringSync();
      bool modified = false;

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
        'const Color(0xFFF8F9FF)': 'Theme.of(context).scaffoldBackgroundColor',
        'Color(0xFFF8F9FF)': 'Theme.of(context).scaffoldBackgroundColor',
        'const Color(0xFFFFFFFF)': 'Theme.of(context).colorScheme.surface',
        'Color(0xFFFFFFFF)': 'Theme.of(context).colorScheme.surface',
      };

      for (var entry in colorReplacements.entries) {
        if (content.contains(entry.key)) {
          content = content.replaceAll(entry.key, entry.value);
          modified = true;
        }
      }

      if (modified) {
        file.writeAsStringSync(content);
        count++;
      }
    }
  }
  print('Successfully processed $count files.');

  print('Phase 2: Self-healing compilation checks...');
  bool hasErrors = true;
  int iteration = 0;

  while (hasErrors && iteration < 20) {
    iteration++;
    print('Running flutter analyze (Iteration $iteration)...');
    final result = await Process.run(
      Platform.isWindows ? 'flutter.bat' : 'flutter',
      ['analyze'],
      runInShell: true,
    );
    final output = result.stdout.toString() + '\n' + result.stderr.toString();

    final lines = output.split('\n');
    final errors = <String>[];
    for (final line in lines) {
      if (line.contains('error - ') || line.contains('warning - ')) {
        errors.add(line);
      }
    }

    // Only stop if there are no lines with 'error - '
    final hasActiveErrors = errors.any((e) => e.contains('error - '));
    if (!hasActiveErrors) {
      print('Success: No compile errors found!');
      hasErrors = false;
      break;
    }

    print('Found ${errors.length} issues. Healing...');
    int healedCount = 0;

    for (final error in errors) {
      if (!error.contains('error - ')) continue;

      // Parse error like: error - Undefined name 'context' - lib\path\to\file.dart:184:25 - undefined_identifier
      final parts = error.split(' - ');
      if (parts.length < 3) continue;
      final fileInfo = parts[2].trim(); // e.g. lib\path\to\file.dart:184:25
      final infoParts = fileInfo.split(':');
      if (infoParts.length < 2) continue;

      final filePath = infoParts[0].trim();
      final lineNum = int.tryParse(infoParts[1]);
      if (lineNum == null) continue;

      final file = File(filePath);
      if (!file.existsSync()) continue;

      final fileLines = file.readAsLinesSync();
      if (lineNum - 1 >= fileLines.length) continue;

      String errorLine = fileLines[lineNum - 1];

      // Revert replacements on this specific line
      final reverts = {
        'Theme.of(context).colorScheme.onSurfaceVariant': 'AppColors.onSurfaceVariant',
        'Theme.of(context).colorScheme.onSurface': 'AppColors.onSurface',
        'Theme.of(context).colorScheme.onBackground': 'AppColors.onBackground',
        'Theme.of(context).colorScheme.surface': 'AppColors.surface',
        'Theme.of(context).scaffoldBackgroundColor': 'const Color(0xFFF8F9FF)',
      };

      bool lineHealed = false;
      for (var entry in reverts.entries) {
        if (errorLine.contains(entry.key)) {
          errorLine = errorLine.replaceAll(entry.key, entry.value);
          lineHealed = true;
        }
      }

      // Also handle: Methods can't be invoked in constant expressions
      if (error.contains('constant expressions') || error.contains('const_eval_method_invocation')) {
        if (errorLine.contains('const ')) {
          errorLine = errorLine.replaceAll('const ', '');
          lineHealed = true;
        }
      }

      if (lineHealed) {
        fileLines[lineNum - 1] = errorLine;
        file.writeAsStringSync(fileLines.join('\n'));
        healedCount++;
      }
    }

    print('Healed $healedCount issues in iteration $iteration.');
    if (healedCount == 0) {
      print('Could not heal remaining issues automatically. Stopping.');
      break;
    }
  }
}
