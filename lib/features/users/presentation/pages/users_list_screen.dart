import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:polyglot_admin/core/l10n/generated/translations.g.dart';
import 'package:polyglot_admin/core/theme/app_colors.dart';
import 'package:polyglot_admin/core/theme/app_spacing.dart';
import 'package:polyglot_admin/core/ui/csv_export.dart';
import 'package:polyglot_admin/core/ui/format.dart';
import 'package:polyglot_admin/core/ui/widgets/async_value_view.dart';
import 'package:polyglot_admin/core/ui/widgets/console_table.dart';
import 'package:polyglot_admin/core/ui/widgets/empty_state.dart';
import 'package:polyglot_admin/core/ui/widgets/page_header.dart';
import 'package:polyglot_admin/core/ui/widgets/search_field.dart';
import 'package:polyglot_admin/core/ui/widgets/status_badge.dart';
import 'package:polyglot_admin/features/users/domain/entities/managed_user.dart';
import 'package:polyglot_admin/features/users/presentation/providers/users_deps.dart';

class UsersListScreen extends ConsumerWidget {
  const UsersListScreen({super.key});

  static List<ConsoleColumn> _columns(Translations t) => [
    ConsoleColumn(t.users.columnUser, flex: 5),
    ConsoleColumn(t.users.columnJoined, flex: 3),
    ConsoleColumn(t.users.columnStreak, flex: 2),
    ConsoleColumn(t.users.columnStatus, flex: 3),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final usersAsync = ref.watch(UsersDeps.usersStreamProvider);
    final filtered = ref.watch(UsersDeps.filteredUsersProvider);
    final statusFilter = ref.watch(UsersDeps.statusFilterProvider);
    final sort = ref.watch(UsersDeps.sortProvider);
    final total = usersAsync.value?.length ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PageHeader(
          title: t.users.title,
          subtitle: usersAsync.hasValue ? t.users.count(n: total) : null,
          actions: [
            OutlinedButton.icon(
              onPressed: () => _export(filtered.value ?? const [], t),
              icon: const Icon(Icons.download_rounded, size: 18),
              label: Text(t.common.export),
            ),
            SearchField(
              hint: t.users.searchHint,
              onChanged: (q) =>
                  ref.read(UsersDeps.searchProvider.notifier).search(q),
            ),
          ],
        ),
        _Controls(
          status: statusFilter,
          sort: sort,
          onStatus: (s) =>
              ref.read(UsersDeps.statusFilterProvider.notifier).select(s),
          onSort: (s) => ref.read(UsersDeps.sortProvider.notifier).select(s),
        ),
        const SizedBox(height: AppSpacing.md),
        Expanded(
          child: AsyncValueView(
            value: filtered,
            onRetry: () => ref.invalidate(UsersDeps.usersStreamProvider),
            data: (users) {
              if (users.isEmpty) {
                return EmptyState(
                  icon: Icons.people_outline_rounded,
                  title: t.users.noUsers,
                );
              }
              return ConsoleTable(
                columns: _columns(t),
                rowCount: users.length,
                onRowTap: (i) => context.go('/users/${users[i].id}'),
                cellsBuilder: (context, i) => _cells(context, users[i]),
              );
            },
          ),
        ),
      ],
    );
  }

  List<Widget> _cells(BuildContext context, ManagedUser user) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    return [
      // User
      Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.primary.withValues(alpha: 0.14),
            child: Text(
              Format.initials(user.name.isNotEmpty ? user.name : user.email),
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
                Text(
                  user.email,
                  style: theme.textTheme.titleSmall,
                  overflow: TextOverflow.ellipsis,
                ),
                if (user.name.isNotEmpty)
                  Text(
                    user.name,
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
      // Joined
      Text(
        Format.date(user.createdAt),
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
      // Streak (lazy per-row)
      _StreakCell(userId: user.id),
      // Status
      Align(
        alignment: Alignment.centerLeft,
        child: user.disabled
            ? StatusBadge(
                label: t.users.statusDisabled,
                color: AppColors.error,
                icon: Icons.block_rounded,
              )
            : StatusBadge(
                label: t.users.statusActive,
                color: AppColors.success,
                icon: Icons.check_circle_outline_rounded,
              ),
      ),
    ];
  }

  void _export(List<ManagedUser> users, Translations t) {
    final rows = <List<String>>[
      [t.users.columnUser, t.users.name, t.users.columnJoined, t.users.columnStatus],
      for (final u in users)
        [
          u.email,
          u.name,
          Format.date(u.createdAt),
          u.disabled ? t.users.statusDisabled : t.users.statusActive,
        ],
    ];
    downloadCsv('parlo-users.csv', rows);
  }
}

class _Controls extends StatelessWidget {
  const _Controls({
    required this.status,
    required this.sort,
    required this.onStatus,
    required this.onSort,
  });

  final UserStatusFilter status;
  final UserSort sort;
  final ValueChanged<UserStatusFilter> onStatus;
  final ValueChanged<UserSort> onSort;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    String statusLabel(UserStatusFilter s) => switch (s) {
      UserStatusFilter.all => t.users.filterAll,
      UserStatusFilter.active => t.users.filterActive,
      UserStatusFilter.disabled => t.users.filterDisabled,
    };
    String sortLabel(UserSort s) => switch (s) {
      UserSort.joined => t.users.sortJoined,
      UserSort.email => t.users.sortEmail,
    };
    return Row(
      children: [
        Wrap(
          spacing: AppSpacing.xs,
          children: [
            for (final s in UserStatusFilter.values)
              ChoiceChip(
                label: Text(statusLabel(s)),
                selected: status == s,
                onSelected: (_) => onStatus(s),
              ),
          ],
        ),
        const Spacer(),
        Text(
          '${t.users.sortBy}: ',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        DropdownButton<UserSort>(
          value: sort,
          underline: const SizedBox.shrink(),
          borderRadius: BorderRadius.circular(8),
          items: [
            for (final s in UserSort.values)
              DropdownMenuItem(value: s, child: Text(sortLabel(s))),
          ],
          onChanged: (s) {
            if (s != null) onSort(s);
          },
        ),
      ],
    );
  }
}

/// Streak cell — fetched lazily per row so the list stays one fast query.
class _StreakCell extends ConsumerWidget {
  const _StreakCell({required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final streak = ref.watch(UsersDeps.userStatsProvider(userId)).value?.currentStreak;
    final active = streak != null && streak > 0;
    return Row(
      children: [
        Icon(
          Icons.local_fire_department_rounded,
          size: 16,
          color: active
              ? AppColors.accentOrange
              : theme.colorScheme.onSurfaceVariant.withValues(alpha: .4),
        ),
        const SizedBox(width: 4),
        Text(streak?.toString() ?? '—', style: theme.textTheme.bodyMedium),
      ],
    );
  }
}
