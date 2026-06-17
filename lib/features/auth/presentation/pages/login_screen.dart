import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:polyglot_admin/core/l10n/generated/translations.g.dart';
import 'package:polyglot_admin/core/theme/app_colors.dart';
import 'package:polyglot_admin/core/theme/app_radius.dart';
import 'package:polyglot_admin/core/theme/app_snack_bar.dart';
import 'package:polyglot_admin/core/theme/app_spacing.dart';
import 'package:polyglot_admin/core/ui/widgets/app_card.dart';
import 'package:polyglot_admin/features/auth/presentation/providers/auth_deps.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    FocusScope.of(context).unfocus();
    await ref
        .read(AuthDeps.authControllerProvider.notifier)
        .signIn(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
  }

  String _mapFirebaseError(String code, Translations t) => switch (code) {
    'invalid-email' => t.auth.invalidEmail,
    'user-disabled' => t.auth.userDisabled,
    'user-not-found' ||
    'wrong-password' ||
    'invalid-credential' => t.auth.wrongCredentials,
    'too-many-requests' => t.auth.tooManyAttempts,
    _ => t.auth.somethingWrong,
  };

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final authState = ref.watch(AuthDeps.authControllerProvider);
    final statusAsync = ref.watch(AuthDeps.authStatusProvider);
    final status = statusAsync.value;
    final resolving = statusAsync.isLoading && !statusAsync.hasValue;
    final isLoading = authState.isLoading;

    ref.listen(AuthDeps.authControllerProvider, (previous, next) {
      next.whenOrNull(
        error: (error, _) {
          final message = error is FirebaseAuthException
              ? _mapFirebaseError(error.code, t)
              : t.auth.somethingWrong;
          AppSnackBar.show(context, message: message, type: AppSnackBarType.error);
        },
      );
    });

    final formCard = AppCard(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: resolving
          ? const SizedBox(
              height: 160,
              child: Center(child: CircularProgressIndicator()),
            )
          : status == AuthStatus.notAdmin
          ? _NotAuthorized()
          : _LoginForm(
              formKey: _formKey,
              emailController: _emailController,
              passwordController: _passwordController,
              obscure: _obscure,
              isLoading: isLoading,
              onToggleObscure: () => setState(() => _obscure = !_obscure),
              onSubmit: _submit,
              theme: theme,
              t: t,
            ),
    );

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 920;
          final form = Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: formCard,
              ),
            ),
          );
          if (!wide) return form;
          return Row(
            children: [
              const Expanded(flex: 5, child: _BrandPanel()),
              Expanded(flex: 4, child: form),
            ],
          );
        },
      ),
    );
  }
}

/// Dark brand panel shown beside the form on wide screens — the one "moment"
/// of saturated brand presence in an otherwise restrained product UI.
class _BrandPanel extends StatelessWidget {
  const _BrandPanel();

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final textTheme = Theme.of(context).textTheme;
    Widget bullet(IconData icon, String label) => Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm + 2),
      child: Row(
        children: [
          Icon(icon, color: AppColors.tertiary, size: 18),
          const SizedBox(width: AppSpacing.sm),
          Text(
            label,
            style: textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.85),
            ),
          ),
        ],
      ),
    );

    return DecoratedBox(
      decoration: const BoxDecoration(color: AppColors.backgroundDark),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: const Icon(Icons.shield_rounded, color: AppColors.tertiary, size: 28),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              t.app.title,
              style: textTheme.headlineMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 360),
              child: Text(
                t.app.tagline,
                style: textTheme.bodyLarge?.copyWith(
                  color: Colors.white.withValues(alpha: 0.7),
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            bullet(Icons.people_rounded, t.nav.users),
            bullet(Icons.report_rounded, t.nav.complaints),
            bullet(Icons.star_rounded, t.nav.ratings),
          ],
        ),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.obscure,
    required this.isLoading,
    required this.onToggleObscure,
    required this.onSubmit,
    required this.theme,
    required this.t,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscure;
  final bool isLoading;
  final VoidCallback onToggleObscure;
  final Future<void> Function() onSubmit;
  final ThemeData theme;
  final Translations t;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: const Icon(Icons.lock_outline_rounded, color: AppColors.primary, size: 26),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(t.auth.title, style: theme.textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.xs),
          Text(
            t.auth.subtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
            decoration: InputDecoration(
              labelText: t.auth.email,
              hintText: t.auth.hintEmail,
              prefixIcon: const Icon(Icons.mail_outline_rounded),
            ),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? t.auth.emailRequired : null,
          ),
          const SizedBox(height: AppSpacing.md),
          TextFormField(
            controller: passwordController,
            obscureText: obscure,
            autofillHints: const [AutofillHints.password],
            onFieldSubmitted: (_) => onSubmit(),
            decoration: InputDecoration(
              labelText: t.auth.password,
              prefixIcon: const Icon(Icons.lock_outline_rounded),
              suffixIcon: IconButton(
                icon: Icon(
                  obscure
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
                onPressed: onToggleObscure,
              ),
            ),
            validator: (v) =>
                (v == null || v.isEmpty) ? t.auth.passwordRequired : null,
          ),
          const SizedBox(height: AppSpacing.lg),
          FilledButton(
            onPressed: isLoading ? null : onSubmit,
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text(t.auth.signIn),
          ),
        ],
      ),
    );
  }
}

class _NotAuthorized extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.no_accounts_outlined, size: 48, color: AppColors.error),
        const SizedBox(height: AppSpacing.md),
        Text(
          t.auth.notAuthorized,
          textAlign: TextAlign.center,
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: AppSpacing.lg),
        OutlinedButton.icon(
          onPressed: () =>
              ref.read(AuthDeps.authControllerProvider.notifier).signOut(),
          icon: const Icon(Icons.logout_rounded, size: 18),
          label: Text(t.nav.signOut),
        ),
      ],
    );
  }
}
