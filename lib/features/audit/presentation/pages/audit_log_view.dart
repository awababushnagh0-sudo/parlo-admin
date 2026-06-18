import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:polyglot_admin/core/l10n/generated/translations.g.dart';
import 'package:polyglot_admin/core/ui/format.dart';
import 'package:polyglot_admin/core/ui/widgets/async_value_view.dart';
import 'package:polyglot_admin/core/ui/widgets/console_table.dart';
import 'package:polyglot_admin/core/ui/widgets/empty_state.dart';
import 'package:polyglot_admin/features/audit/presentation/providers/audit_deps.dart';

String auditActionLabel(String action, Translations t) => switch (action) {
  'user_disable' => t.audit.action_user_disable,
  'user_enable' => t.audit.action_user_enable,
  'user_delete' => t.audit.action_user_delete,
  'user_rename' => t.audit.action_user_rename,
  'complaint_resolve' => t.audit.action_complaint_resolve,
  'complaint_dismiss' => t.audit.action_complaint_dismiss,
  'complaint_reopen' => t.audit.action_complaint_reopen,
  'admin_add' => t.audit.action_admin_add,
  'admin_remove' => t.audit.action_admin_remove,
  'config_update' => t.audit.action_config_update,
  'announcement_post' => t.audit.action_announcement_post,
  'announcement_delete' => t.audit.action_announcement_delete,
  _ => action,
};

class AuditLogView extends ConsumerWidget {
  const AuditLogView({super.key});

  static List<ConsoleColumn> _columns(Translations t) => [
    ConsoleColumn(t.audit.columnAdmin, flex: 3),
    ConsoleColumn(t.audit.columnAction, flex: 3),
    ConsoleColumn(t.audit.columnTarget, flex: 3),
    ConsoleColumn(t.audit.columnDate, flex: 2, align: TextAlign.end),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final entries = ref.watch(AuditDeps.entriesStreamProvider);
    return AsyncValueView(
      value: entries,
      onRetry: () => ref.invalidate(AuditDeps.entriesStreamProvider),
      data: (list) {
        if (list.isEmpty) {
          return EmptyState(
            icon: Icons.history_rounded,
            title: t.audit.noEntries,
          );
        }
        final theme = Theme.of(context);
        return ConsoleTable(
          columns: _columns(t),
          rowCount: list.length,
          showChevron: false,
          cellsBuilder: (context, i) {
            final e = list[i];
            final target = e.targetType == null
                ? t.common.none
                : '${e.targetType}${e.targetId != null ? ' · ${e.targetId}' : ''}';
            return [
              Text(
                e.adminEmail,
                style: theme.textTheme.bodyMedium,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                auditActionLabel(e.action, t),
                style: theme.textTheme.titleSmall,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                target,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                Format.dateTime(e.createdAt),
                textAlign: TextAlign.end,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ];
          },
        );
      },
    );
  }
}
