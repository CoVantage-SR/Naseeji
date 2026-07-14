import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/services/storage/shared_preferences_service.dart';
import 'core/services/database/isar_service.dart';
import 'core/services/theme_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final results = await Future.wait([
    SharedPreferences.getInstance(),
    IsarService.init(),
  ]);

  final sharedPrefs = results[0] as SharedPreferences;
  final isarServiceInstance = results[1] as IsarService;

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesServiceProvider.overrideWithValue(
          SharedPreferencesService(sharedPrefs),
        ),
        isarServiceProvider.overrideWithValue(isarServiceInstance),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeServiceProvider);

    return MaterialApp.router(
      title: 'مصنع نسيجي',

      // Theme Configuration (Material 3 enabled, light/dark modes, system mode default)
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,

      // Router Config (GoRouter)
      routerConfig: router,

      // RTL Arabic Egyptian Localization Settings
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar'), Locale('ar', 'EG')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        return const Locale('ar');
      },

      // Force RTL layout throughout the app
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
