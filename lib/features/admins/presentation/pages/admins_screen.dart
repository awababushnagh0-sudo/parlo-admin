import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:polyglot_admin/core/l10n/generated/translations.g.dart';
import 'package:polyglot_admin/core/theme/app_colors.dart';
import 'package:polyglot_admin/core/theme/app_snack_bar.dart';
import 'package:polyglot_admin/core/theme/app_spacing.dart';
import 'package:polyglot_admin/core/ui/format.dart';
import 'package:polyglot_admin/core/ui/widgets/async_value_view.dart';
import 'package:polyglot_admin/core/ui/widgets/confirm_dialog.dart';
import 'package:polyglot_admin/core/ui/widgets/console_table.dart';
import 'package:polyglot_admin/core/ui/widgets/empty_state.dart';
import 'package:polyglot_admin/core/ui/widgets/page_header.dart';
import 'package:polyglot_admin/core/ui/widgets/status_badge.dart';
import 'package:polyglot_admin/features/admins/domain/entities/admin_entry.dart';
import 'package:polyglot_admin/features/admins/presentation/providers/admins_deps.dart';
import 'package:polyglot_admin/features/auth/presentation/providers/auth_deps.dart';

class AdminsScreen extends ConsumerWidget {
  const AdminsScreen({super.key});

  static List<ConsoleColumn> _columns(Translations t) => [
    ConsoleColumn(t.admins.columnAdmin, flex: 5),
    ConsoleColumn(t.admins.columnAdded, flex: 3),
    const ConsoleColumn('', flex: 2, align: TextAlign.end),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final admins = ref.watch(AdminsDeps.adminsStreamProvider);
    final total = admins.value?.length ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PageHeader(
          title: t.admins.title,
          subtitle: admins.hasValue ? t.admins.count(n: total) : null,
          actions: [
            FilledButton.icon(
              onPressed: () => _showAddDialog(context, ref),
              icon: const Icon(Icons.add_rounded, size: 18),
              label: Text(t.admins.add),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
        Expanded(
          child: AsyncValueView(
            value: admins,
            onRetry: () => ref.invalidate(AdminsDeps.adminsStreamProvider),
            data: (list) {
              if (list.isEmpty) {
                return EmptyState(
                  icon: Icons.shield_outlined,
                  title: t.admins.noAdmins,
                  actionLabel: t.admins.add,
                  onAction: () => _showAddDialog(context, ref),
                );
              }
              return ConsoleTable(
                columns: _columns(t),
                rowCount: list.length,
                showChevron: false,
                cellsBuilder: (context, i) => _cells(context, ref, list[i]),
              );
            },
          ),
        ),
      ],
    );
  }

  List<Widget> _cells(BuildContext context, WidgetRef ref, AdminEntry admin) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final currentUid = ref.watch(AuthDeps.currentAdminProvider).value?.id;
    final isSelf = currentUid == admin.uid;
    return [
      Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.primary.withValues(alpha: 0.14),
            child: Text(
              Format.initials(admin.email),
              style: theme.textTheme.labelMedium?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        admin.email,
                        style: theme.textTheme.titleSmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isSelf) ...[
                      const SizedBox(width: AppSpacing.sm),
                      StatusBadge(label: t.admins.you, color: AppColors.info),
                    ],
                  ],
                ),
                Text(
                  admin.uid,
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
      Text(
        Format.date(admin.addedAt),
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
      Align(
        alignment: Alignment.centerRight,
        child: IconButton(
          tooltip: t.admins.remove,
          icon: const Icon(Icons.person_remove_outlined, size: 20),
          color: AppColors.error,
          onPressed: () => _removeAdmin(context, ref, admin),
        ),
      ),
    ];
  }

  Future<void> _showAddDialog(BuildContext context, WidgetRef ref) async {
    final t = Translations.of(context);
    final uidController = TextEditingController();
    final emailController = TextEditingController();
    final added = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t.admins.addTitle),
        content: SizedBox(
          width: 420,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: uidController,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: t.admins.uidLabel,
                  hintText: t.admins.uidHint,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: t.admins.emailLabel),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                t.admins.addHint,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(t.common.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(t.common.add),
          ),
        ],
      ),
    );
    if (added != true) return;
    final uid = uidController.text.trim();
    if (uid.isEmpty) return;
    final ok = await ref
        .read(AdminsDeps.controllerProvider.notifier)
        .addAdmin(uid: uid, email: emailController.text.trim());
    if (!context.mounted) return;
    AppSnackBar.show(
      context,
      message: ok ? t.admins.added : t.auth.somethingWrong,
      type: ok ? AppSnackBarType.success : AppSnackBarType.error,
    );
  }

  Future<void> _removeAdmin(
    BuildContext context,
    WidgetRef ref,
    AdminEntry admin,
  ) async {
    final t = Translations.of(context);
    final confirmed = await showConfirmDialog(
      context,
      title: t.admins.removeTitle,
      message: t.admins.removeWarning(email: admin.email),
      confirmLabel: t.admins.remove,
      destructive: true,
    );
    if (!confirmed) return;
    final ok = await ref
        .read(AdminsDeps.controllerProvider.notifier)
        .removeAdmin(admin.uid);
    if (!context.mounted) return;
    AppSnackBar.show(
      context,
      message: ok ? t.admins.removed : t.auth.somethingWrong,
      type: ok ? AppSnackBarType.success : AppSnackBarType.error,
    );
  }
}
