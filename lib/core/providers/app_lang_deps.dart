import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:polyglot_admin/core/l10n/generated/translations.g.dart';
import 'package:polyglot_admin/core/services/prefs_service.dart';

/// Current UI language. Mirrors the mobile app's language notifier: persists the
/// choice and drives slang's [LocaleSettings] so the whole app re-renders.
class LangNotifier extends Notifier<AppLocale> {
  @override
  AppLocale build() {
    final saved = ref.read(prefsServiceProvider).localeTag;
    if (saved != null) {
      return AppLocaleUtils.parse(saved);
    }
    return LocaleSettings.currentLocale;
  }

  void setLanguage(AppLocale locale) {
    state = locale;
    LocaleSettings.setLocale(locale);
    ref.read(prefsServiceProvider).setLocaleTag(locale.languageTag);
  }
}

final languageProvider = NotifierProvider<LangNotifier, AppLocale>(
  LangNotifier.new,
);

extension AppLocaleX on AppLocale {
  String get displayName => switch (this) {
    AppLocale.en => 'English',
    AppLocale.fr => 'Français',
    AppLocale.ar => 'العربية',
  };
}
