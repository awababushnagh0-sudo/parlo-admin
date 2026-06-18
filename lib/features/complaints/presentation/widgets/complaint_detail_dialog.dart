import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:polyglot_admin/core/l10n/generated/translations.g.dart';
import 'package:polyglot_admin/core/theme/app_radius.dart';
import 'package:polyglot_admin/core/theme/app_snack_bar.dart';
import 'package:polyglot_admin/core/theme/app_spacing.dart';
import 'package:polyglot_admin/core/ui/format.dart';
import 'package:polyglot_admin/core/ui/widgets/status_badge.dart';
import 'package:polyglot_admin/features/complaints/domain/entities/complaint.dart';
import 'package:polyglot_admin/features/complaints/presentation/complaint_labels.dart';
import 'package:polyglot_admin/features/complaints/presentation/providers/complaints_deps.dart';

Future<void> showComplaintDetail(BuildContext context, Complaint complaint) {
  return showDialog<void>(
    context: context,
    builder: (_) => ComplaintDetailDialog(complaint: complaint),
  );
}

class ComplaintDetailDialog extends ConsumerStatefulWidget {
  const ComplaintDetailDialog({super.key, required this.complaint});

  final Complaint complaint;

  @override
  ConsumerState<ComplaintDetailDialog> createState() =>
      _ComplaintDetailDialogState();
}

class _ComplaintDetailDialogState extends ConsumerState<ComplaintDetailDialog> {
  late final TextEditingController _noteController =
      TextEditingController(text: widget.complaint.adminNote ?? '');

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _setStatus(ComplaintStatus status) async {
    final t = Translations.of(context);
    final ok = await ref
        .read(ComplaintsDeps.controllerProvider.notifier)
        .updateStatus(
          widget.complaint.id,
          status,
          adminNote: _noteController.text.trim().isEmpty
              ? null
              : _noteController.text.trim(),
        );
    if (!mounted) return;
    Navigator.of(context).pop();
    AppSnackBar.show(
      context,
      message: ok ? t.complaints.statusUpdated : t.auth.somethingWrong,
      type: ok ? AppSnackBarType.success : AppSnackBarType.error,
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final c = widget.complaint;
    final busy = ref.watch(ComplaintsDeps.controllerProvider).isLoading;
    final target = c.targetType.label(t) +
        (c.targetId != null ? ' · ${c.targetId}' : '');

    return AlertDialog(
      title: Row(
        children: [
          Expanded(child: Text(t.complaints.detailTitle)),
          StatusBadge(
            label: c.status.label(t),
            color: c.status.color,
            icon: c.status.icon,
          ),
        ],
      ),
      content: SizedBox(
        width: 460,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _row(t.complaints.columnUser, c.userEmail, theme),
              _row(t.complaints.category, c.category.label(t), theme),
              _row(t.complaints.target, target, theme),
              _row(t.complaints.columnDate, Format.dateTime(c.createdAt), theme),
              _row(
                t.complaints.assignedTo,
                c.assignedTo ?? t.complaints.unassigned,
                theme,
              ),
              if (c.resolutionTime != null)
                _row(
                  t.complaints.resolutionTime,
                  _fmtDuration(c.resolutionTime!),
                  theme,
                ),
              const SizedBox(height: AppSpacing.md),
              Text(t.complaints.message, style: theme.textTheme.labelMedium),
              const SizedBox(height: AppSpacing.xs),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(color: theme.colorScheme.outlineVariant),
                ),
                child: SelectableText(
                  c.message.isEmpty ? t.common.none : c.message,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: _noteController,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: t.complaints.adminNote,
                  hintText: t.complaints.adminNoteHint,
                ),
              ),
            ],
          ),
        ),
      ),
      actionsOverflowButtonSpacing: AppSpacing.sm,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(t.common.close),
        ),
        OutlinedButton.icon(
          onPressed: busy
              ? null
              : () => ref
                    .read(ComplaintsDeps.controllerProvider.notifier)
                    .assignToMe(c.id),
          icon: const Icon(Icons.person_pin_circle_outlined, size: 18),
          label: Text(t.complaints.assignToMe),
        ),
        if (c.status != ComplaintStatus.open)
          OutlinedButton.icon(
            onPressed: busy ? null : () => _setStatus(ComplaintStatus.open),
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: Text(t.complaints.reopen),
          ),
        if (c.status != ComplaintStatus.dismissed)
          OutlinedButton.icon(
            onPressed: busy ? null : () => _setStatus(ComplaintStatus.dismissed),
            icon: const Icon(Icons.cancel_outlined, size: 18),
            label: Text(t.complaints.markDismissed),
          ),
        if (c.status != ComplaintStatus.resolved)
          FilledButton.icon(
            onPressed: busy ? null : () => _setStatus(ComplaintStatus.resolved),
            icon: const Icon(Icons.check_rounded, size: 18),
            label: Text(t.complaints.markResolved),
          ),
      ],
    );
  }

  String _fmtDuration(Duration d) {
    if (d.inDays > 0) return '${d.inDays}d ${d.inHours % 24}h';
    if (d.inHours > 0) return '${d.inHours}h ${d.inMinutes % 60}m';
    return '${d.inMinutes}m';
  }

  Widget _row(String label, String value, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 96,
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(value, style: theme.textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}
