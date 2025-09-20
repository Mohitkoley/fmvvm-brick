import 'dart:io';
import 'package:mason/mason.dart';

void run(HookContext context) {
  final feature = context.vars['feature_name'] as String;
  final controllerName = '${_capitalize(feature)}Controller';
  final filePath = 'lib/main.dart';

  final importLine =
      "import 'features/$feature/controllers/${feature}_controller.dart';";

  final file = File(filePath);

  if (!file.existsSync()) {
    context.logger.err('❌ main.dart not found at $filePath');
    return;
  }

  var lines = file.readAsLinesSync();

  // 1️⃣ Add import if not exists
  if (!lines.any((line) => line.trim() == importLine)) {
    final lastImportIndex =
        lines.lastIndexWhere((line) => line.trim().startsWith('import '));
    lines.insert(lastImportIndex + 1, importLine);
    context.logger.info('✅ Added import for $controllerName');
  }

  // 2️⃣ Add providers.add(...) after providers list declaration
  final providerAddSnippet =
      "  providers.add(ChangeNotifierProvider(lazy: true, create: (context) => $controllerName()));";

  final providersInitIndex = lines.indexWhere(
      (line) => line.contains('List<ChangeNotifierProvider> providers = ['));
  if (providersInitIndex == -1) {
    context.logger
        .err('❌ Could not find providers list declaration in main.dart');
  } else {
    // Find the line after the closing ];
    final endIndex = lines.indexWhere(
        (line) => line.trim().startsWith('];'), providersInitIndex);

    if (endIndex != -1) {
      if (!lines.contains(providerAddSnippet)) {
        lines.insert(endIndex + 1, providerAddSnippet);
        context.logger
            .info('✅ Added $controllerName to providers with providers.add()');
      } else {
        context.logger.warn('⚠️ $controllerName already exists in providers');
      }
    } else {
      context.logger.err('❌ Could not locate closing ]; for providers list');
    }
  }

  // Save back
  file.writeAsStringSync(lines.join('\n'));
}

String _capitalize(String s) => s[0].toUpperCase() + s.substring(1);
