import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Thin typed wrapper over [SharedPreferences] for persisting dashboard
/// settings. A real instance is created in `main()` and injected via a
/// ProviderScope override, so reads are synchronous everywhere else.
class PrefsService {
  PrefsService(this._prefs);

  final SharedPreferences _prefs;

  static const _kThemeMode = 'theme_mode';
  static const _kLocale = 'app_locale';

  String? get themeModeName => _prefs.getString(_kThemeMode);
  Future<void> setThemeModeName(String value) =>
      _prefs.setString(_kThemeMode, value);

  String? get localeTag => _prefs.getString(_kLocale);
  Future<void> setLocaleTag(String value) => _prefs.setString(_kLocale, value);
}

/// Overridden with a concrete instance in `main()`.
final prefsServiceProvider = Provider<PrefsService>((ref) {
  throw UnimplementedError('prefsServiceProvider must be overridden in main()');
});
