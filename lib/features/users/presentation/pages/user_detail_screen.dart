import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:polyglot_admin/core/l10n/generated/translations.g.dart';
import 'package:polyglot_admin/core/theme/app_colors.dart';
import 'package:polyglot_admin/core/theme/app_radius.dart';
import 'package:polyglot_admin/core/theme/app_spacing.dart';
import 'package:polyglot_admin/core/theme/app_snack_bar.dart';
import 'package:polyglot_admin/core/ui/format.dart';
import 'package:polyglot_admin/core/ui/widgets/action_button.dart';
import 'package:polyglot_admin/core/ui/widgets/app_card.dart';
import 'package:polyglot_admin/core/ui/widgets/confirm_dialog.dart';
import 'package:polyglot_admin/core/ui/widgets/empty_state.dart';
import 'package:polyglot_admin/features/users/domain/entities/managed_user.dart';
import 'package:polyglot_admin/features/users/presentation/providers/users_deps.dart';

class UserDetailScreen extends ConsumerWidget {
  const UserDetailScreen({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final usersAsync = ref.watch(UsersDeps.usersStreamProvider);
    final user = ref.watch(UsersDeps.userByIdProvider(userId));

    // List still loading and user not yet resolved.
    if (user == null && usersAsync.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (user == null) {
      return EmptyState(
        icon: Icons.person_off_outlined,
        title: t.users.noUsers,
        actionLabel: t.common.close,
        onAction: () => context.go('/users'),
      );
    }

    return _UserDetailBody(user: user);
  }
}

class _UserDetailBody extends ConsumerWidget {
  const _UserDetailBody({required this.user});

  final ManagedUser user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final stats = ref.watch(UsersDeps.userStatsProvider(user.id));
    final counts = ref.watch(UsersDeps.userContentCountsProvider(user.id));
    final busy = ref.watch(UsersDeps.controllerProvider).isLoading;

    return ListView(
      children: [
        // Header: back + title
        Row(
          children: [
            IconButton(
              onPressed: () => context.go('/users'),
              icon: const Icon(Icons.arrow_back_rounded),
              tooltip: t.common.close,
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              t.users.detailTitle,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),

        if (user.disabled)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: _DisabledBanner(message: t.users.disabledBanner),
          ),

        // Profile + actions
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
                      Format.initials(
                        user.name.isNotEmpty ? user.name : user.email,
                      ),
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
                        Text(user.email, style: theme.textTheme.titleMedium),
                        if (user.name.isNotEmpty)
                          Text(
                            user.name,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              const Divider(),
              const SizedBox(height: AppSpacing.sm),
              _InfoRow(label: t.users.uid, value: user.id),
              _InfoRow(label: t.users.joined, value: Format.dateTime(user.createdAt)),
              _InfoRow(
                label: t.users.lastActive,
                value: stats.value?.lastActiveDate ?? t.common.none,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // Stats
        _SectionTitle(t.users.activity),
        const SizedBox(height: AppSpacing.sm),
        _MetricsWrap(
          children: [
            _Metric(
              icon: Icons.local_fire_department_rounded,
              color: AppColors.accentOrange,
              label: t.users.currentStreak,
              value: '${stats.value?.currentStreak ?? 0}',
            ),
            _Metric(
              icon: Icons.emoji_events_outlined,
              color: AppColors.warning,
              label: t.users.longestStreak,
              value: '${stats.value?.longestStreak ?? 0}',
            ),
            _Metric(
              icon: Icons.bolt_rounded,
              color: AppColors.accentPurple,
              label: t.users.totalXp,
              value: '${stats.value?.totalXp ?? 0}',
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),

        // Content counts
        _SectionTitle(t.users.profile),
        const SizedBox(height: AppSpacing.sm),
        _MetricsWrap(
          children: [
            _Metric(
              icon: Icons.translate_rounded,
              color: AppColors.primary,
              label: t.users.savedWords,
              value: '${counts.value?.words ?? 0}',
            ),
            _Metric(
              icon: Icons.notes_rounded,
              color: AppColors.accentBlue,
              label: t.users.savedSentences,
              value: '${counts.value?.sentences ?? 0}',
            ),
            _Metric(
              icon: Icons.video_library_outlined,
              color: AppColors.info,
              label: t.users.savedVideos,
              value: '${counts.value?.videos ?? 0}',
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),

        // Actions
        Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.md,
          children: [
            SizedBox(
              width: 220,
              child: ActionButton(
                variant: ActionButtonVariant.default_,
                icon: Icons.edit_outlined,
                onTap: busy ? null : () => _editName(context, ref),
                child: Text(t.users.edit),
              ),
            ),
            SizedBox(
              width: 220,
              child: ActionButton(
                variant: user.disabled
                    ? ActionButtonVariant.primary
                    : ActionButtonVariant.default_,
                icon: user.disabled
                    ? Icons.lock_open_rounded
                    : Icons.block_rounded,
                onTap: busy ? null : () => _toggleDisabled(context, ref),
                child: Text(
                  user.disabled ? t.users.enableUser : t.users.disableUser,
                ),
              ),
            ),
            SizedBox(
              width: 220,
              child: ActionButton(
                variant: ActionButtonVariant.destructive,
                icon: Icons.delete_outline_rounded,
                onTap: busy ? null : () => _deleteData(context, ref),
                child: Text(t.users.deleteUser),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }

  Future<void> _editName(BuildContext context, WidgetRef ref) async {
    final t = Translations.of(context);
    final controller = TextEditingController(text: user.name);
    final newName = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t.users.editTitle),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(labelText: t.users.name),
          onSubmitted: (v) => Navigator.of(context).pop(v.trim()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(t.common.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: Text(t.common.save),
          ),
        ],
      ),
    );
    if (newName == null || newName == user.name) return;
    final ok = await ref
        .read(UsersDeps.controllerProvider.notifier)
        .updateName(user.id, newName);
    if (context.mounted) {
      _toast(context, ok, t.users.userUpdated);
    }
  }

  Future<void> _toggleDisabled(BuildContext context, WidgetRef ref) async {
    final t = Translations.of(context);
    final disable = !user.disabled;
    if (disable) {
      final confirmed = await showConfirmDialog(
        context,
        title: t.users.disableUser,
        message: t.users.disabledBanner,
        confirmLabel: t.users.disableUser,
        destructive: true,
      );
      if (!confirmed) return;
    }
    final ok = await ref
        .read(UsersDeps.controllerProvider.notifier)
        .setDisabled(user.id, disable);
    if (context.mounted) {
      _toast(context, ok, disable ? t.users.userDisabled : t.users.userEnabled);
    }
  }

  Future<void> _deleteData(BuildContext context, WidgetRef ref) async {
    final t = Translations.of(context);
    final confirmed = await showConfirmDialog(
      context,
      title: t.users.deleteTitle,
      message: t.users.deleteWarning(email: user.email),
      confirmLabel: t.common.delete,
      destructive: true,
    );
    if (!confirmed) return;
    final ok = await ref
        .read(UsersDeps.controllerProvider.notifier)
        .deleteUserData(user.id);
    if (!context.mounted) return;
    _toast(context, ok, t.users.userDeleted);
    if (ok) context.go('/users');
  }

  void _toast(BuildContext context, bool ok, String successMessage) {
    final t = Translations.of(context);
    AppSnackBar.show(
      context,
      message: ok ? successMessage : t.auth.somethingWrong,
      type: ok ? AppSnackBarType.success : AppSnackBarType.error,
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
            width: 110,
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

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleMedium,
    );
  }
}

class _MetricsWrap extends StatelessWidget {
  const _MetricsWrap({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.md,
      children: children,
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final Color color;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: 200,
      child: AppCard(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    label,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DisabledBanner extends StatelessWidget {
  const _DisabledBanner({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          const Icon(Icons.block_rounded, color: AppColors.error, size: 20),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
