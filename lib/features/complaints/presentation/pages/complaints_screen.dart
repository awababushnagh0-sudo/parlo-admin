import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:polyglot_admin/core/l10n/generated/translations.g.dart';
import 'package:polyglot_admin/core/theme/app_spacing.dart';
import 'package:polyglot_admin/core/ui/csv_export.dart';
import 'package:polyglot_admin/core/ui/format.dart';
import 'package:polyglot_admin/core/ui/widgets/async_value_view.dart';
import 'package:polyglot_admin/core/ui/widgets/console_table.dart';
import 'package:polyglot_admin/core/ui/widgets/empty_state.dart';
import 'package:polyglot_admin/core/ui/widgets/page_header.dart';
import 'package:polyglot_admin/core/ui/widgets/status_badge.dart';
import 'package:polyglot_admin/features/complaints/domain/entities/complaint.dart';
import 'package:polyglot_admin/features/complaints/presentation/complaint_labels.dart';
import 'package:polyglot_admin/features/complaints/presentation/providers/complaints_deps.dart';
import 'package:polyglot_admin/features/complaints/presentation/widgets/complaint_detail_dialog.dart';

class ComplaintsScreen extends ConsumerWidget {
  const ComplaintsScreen({super.key});

  static List<ConsoleColumn> _columns(Translations t) => [
    ConsoleColumn(t.complaints.columnUser, flex: 3),
    ConsoleColumn(t.complaints.columnMessage, flex: 5),
    ConsoleColumn(t.complaints.columnDate, flex: 2),
    ConsoleColumn(t.complaints.columnStatus, flex: 2),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final complaints = ref.watch(ComplaintsDeps.complaintsStreamProvider);
    final filter = ref.watch(ComplaintsDeps.statusFilterProvider);
    final total = complaints.value?.length ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PageHeader(
          title: t.complaints.title,
          subtitle: complaints.hasValue ? t.complaints.count(n: total) : null,
          actions: [
            _StatusFilter(
              selected: filter,
              onSelect: (s) => ref
                  .read(ComplaintsDeps.statusFilterProvider.notifier)
                  .select(s),
            ),
            OutlinedButton.icon(
              onPressed: () => _export(complaints.value ?? const [], t),
              icon: const Icon(Icons.download_rounded, size: 18),
              label: Text(t.common.export),
            ),
          ],
        ),
        Expanded(
          child: AsyncValueView(
            value: complaints,
            onRetry: () =>
                ref.invalidate(ComplaintsDeps.complaintsStreamProvider),
            data: (items) {
              if (items.isEmpty) {
                return EmptyState(
                  icon: Icons.inbox_outlined,
                  title: t.complaints.noComplaints,
                );
              }
              return ConsoleTable(
                columns: _columns(t),
                rowCount: items.length,
                onRowTap: (i) => showComplaintDetail(context, items[i]),
                cellsBuilder: (context, i) => _cells(context, items[i]),
              );
            },
          ),
        ),
      ],
    );
  }

  List<Widget> _cells(BuildContext context, Complaint c) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    return [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            c.userEmail,
            style: theme.textTheme.titleSmall,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            '${c.category.label(t)} · ${c.targetType.label(t)}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
      Padding(
        padding: const EdgeInsets.only(right: AppSpacing.md),
        child: Text(
          c.message,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodyMedium,
        ),
      ),
      Text(
        Format.date(c.createdAt),
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
      Align(
        alignment: Alignment.centerLeft,
        child: StatusBadge(
          label: c.status.label(t),
          color: c.status.color,
          icon: c.status.icon,
        ),
      ),
    ];
  }

  void _export(List<Complaint> items, Translations t) {
    final rows = <List<String>>[
      [
        t.complaints.columnUser,
        t.complaints.category,
        t.complaints.target,
        t.complaints.columnMessage,
        t.complaints.columnStatus,
        t.complaints.columnDate,
      ],
      for (final c in items)
        [
          c.userEmail,
          c.category.label(t),
          c.targetType.label(t) + (c.targetId != null ? ' (${c.targetId})' : ''),
          c.message,
          c.status.label(t),
          Format.date(c.createdAt),
        ],
    ];
    downloadCsv('parlo-complaints.csv', rows);
  }
}

class _StatusFilter extends StatelessWidget {
  const _StatusFilter({required this.selected, required this.onSelect});

  final ComplaintStatus? selected;
  final ValueChanged<ComplaintStatus?> onSelect;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    return Wrap(
      spacing: AppSpacing.xs,
      children: [
        ChoiceChip(
          label: Text(t.common.all),
          selected: selected == null,
          onSelected: (_) => onSelect(null),
        ),
        for (final status in ComplaintStatus.values)
          ChoiceChip(
            label: Text(status.label(t)),
            selected: selected == status,
            onSelected: (_) => onSelect(status),
          ),
      ],
    );
  }
}
