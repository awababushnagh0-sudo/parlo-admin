import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:polyglot_admin/core/l10n/generated/translations.g.dart';
import 'package:polyglot_admin/core/providers/app_lang_deps.dart';
import 'package:polyglot_admin/core/providers/app_theme_deps.dart';
import 'package:polyglot_admin/core/routers/app_router/app_router.dart';
import 'package:polyglot_admin/core/services/prefs_service.dart';
import 'package:polyglot_admin/core/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final prefs = await SharedPreferences.getInstance();
  final prefsService = PrefsService(prefs);

  final savedLocale = prefsService.localeTag;
  if (savedLocale != null) {
    LocaleSettings.setLocaleRaw(savedLocale);
  } else {
    LocaleSettings.useDeviceLocale();
  }

  runApp(
    TranslationProvider(
      child: ProviderScope(
        overrides: [prefsServiceProvider.overrideWithValue(prefsService)],
        child: const AdminApp(),
      ),
    ),
  );
}

class AdminApp extends ConsumerWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeProvider).flutterThemeMode;
    // Rebuild when the chosen language changes so the new locale is applied.
    ref.watch(languageProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      locale: TranslationProvider.of(context).flutterLocale,
      supportedLocales: AppLocaleUtils.supportedLocales,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      title: 'Parlo Admin',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
