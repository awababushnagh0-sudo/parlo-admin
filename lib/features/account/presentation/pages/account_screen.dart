import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:polyglot_admin/core/l10n/generated/translations.g.dart';
import 'package:polyglot_admin/core/providers/app_lang_deps.dart';
import 'package:polyglot_admin/core/providers/app_theme_deps.dart';
import 'package:polyglot_admin/core/theme/app_colors.dart';
import 'package:polyglot_admin/core/theme/app_spacing.dart';
import 'package:polyglot_admin/core/ui/format.dart';
import 'package:polyglot_admin/core/ui/widgets/app_card.dart';
import 'package:polyglot_admin/core/ui/widgets/page_header.dart';
import 'package:polyglot_admin/core/ui/widgets/status_badge.dart';
import 'package:polyglot_admin/features/admins/presentation/providers/admins_deps.dart';
import 'package:polyglot_admin/features/auth/presentation/providers/auth_deps.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final admin = ref.watch(AuthDeps.currentAdminProvider).value;
    final admins = ref.watch(AdminsDeps.adminsStreamProvider).value ?? const [];
    final email = admin?.email ?? '—';
    final uid = admin?.id ?? '—';
    DateTime? addedAt;
    for (final a in admins) {
      if (a.uid == uid) {
        addedAt = a.addedAt;
        break;
      }
    }

    return ListView(
      children: [
        PageHeader(title: t.account.title),

        // Profile
        AppCard(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.14),
                    child: Text(
                      Format.initials(email),
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(email, style: theme.textTheme.titleMedium),
                        const SizedBox(height: AppSpacing.xs),
                        StatusBadge(
                          label: t.account.administrator,
                          color: AppColors.primary,
                          icon: Icons.shield_rounded,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              const Divider(),
              const SizedBox(height: AppSpacing.sm),
              _InfoRow(label: t.account.email, value: email),
              _InfoRow(label: t.account.uid, value: uid),
              _InfoRow(label: t.account.memberSince, value: Format.date(addedAt)),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // Preferences
        Text(
          t.account.preferences,
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: AppSpacing.sm),
        AppCard(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Theme
              Text(t.account.theme, style: theme.textTheme.titleSmall),
              const SizedBox(height: AppSpacing.sm),
              const _ThemeSelector(),
              const SizedBox(height: AppSpacing.lg),
              const Divider(),
              const SizedBox(height: AppSpacing.md),
              // Language
              Text(t.account.language, style: theme.textTheme.titleSmall),
              const SizedBox(height: AppSpacing.sm),
              const _LanguageSelector(),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        Align(
          alignment: Alignment.centerLeft,
          child: OutlinedButton.icon(
            onPressed: () =>
                ref.read(AuthDeps.authControllerProvider.notifier).signOut(),
            icon: const Icon(Icons.logout_rounded, size: 18),
            label: Text(t.account.signOut),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}

class _ThemeSelector extends ConsumerWidget {
  const _ThemeSelector();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final current = ref.watch(themeProvider);
    String label(AppThemeMode m) => switch (m) {
      AppThemeMode.system => t.account.theme_system,
      AppThemeMode.light => t.account.theme_light,
      AppThemeMode.dark => t.account.theme_dark,
    };
    return SegmentedButton<AppThemeMode>(
      segments: [
        for (final m in AppThemeMode.values)
          ButtonSegment(value: m, label: Text(label(m))),
      ],
      selected: {current},
      showSelectedIcon: false,
      onSelectionChanged: (s) =>
          ref.read(themeProvider.notifier).setTheme(s.first),
    );
  }
}

class _LanguageSelector extends ConsumerWidget {
  const _LanguageSelector();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(languageProvider);
    return DropdownButtonFormField<AppLocale>(
      initialValue: current,
      decoration: const InputDecoration(isDense: true),
      items: [
        for (final locale in AppLocale.values)
          DropdownMenuItem(value: locale, child: Text(locale.displayName)),
      ],
      onChanged: (locale) {
        if (locale != null) {
          ref.read(languageProvider.notifier).setLanguage(locale);
        }
      },
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: SelectableText(value, style: theme.textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}
