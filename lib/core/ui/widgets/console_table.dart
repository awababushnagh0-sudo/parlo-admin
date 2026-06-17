import 'package:flutter/material.dart';
import 'package:polyglot_admin/core/theme/app_radius.dart';
import 'package:polyglot_admin/core/theme/app_spacing.dart';

/// A column definition shared between a [ConsoleTable]'s header and its rows so
/// the two always stay aligned.
class ConsoleColumn {
  const ConsoleColumn(this.label, {this.flex = 1, this.align = TextAlign.start});

  final String label;
  final int flex;
  final TextAlign align;
}

/// The one tabular surface for the dashboard: a single bordered card with a
/// muted header row and hairline-divided body rows that highlight on hover.
/// Replaces stacks of individually-bordered cards (which read as "default
/// Material") for any list of records — users, complaints, ratings.
///
/// The body virtualizes via [ListView.separated], so it must be given a bounded
/// height (wrap it in an `Expanded`).
class ConsoleTable extends StatelessWidget {
  const ConsoleTable({
    super.key,
    required this.columns,
    required this.rowCount,
    required this.cellsBuilder,
    this.onRowTap,
    this.showChevron = true,
  });

  final List<ConsoleColumn> columns;
  final int rowCount;

  /// Returns one widget per column for row [index].
  final List<Widget> Function(BuildContext context, int index) cellsBuilder;
  final void Function(int index)? onRowTap;
  final bool showChevron;

  static const double _chevronSlot = 28;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: theme.colorScheme.outlineVariant, width: 0.6),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Column(
          children: [
            _Header(columns: columns, showChevron: showChevron),
            Divider(height: 1, color: theme.colorScheme.outlineVariant),
            Expanded(
              child: ListView.separated(
                itemCount: rowCount,
                separatorBuilder: (_, _) => Divider(
                  height: 1,
                  thickness: 1,
                  color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
                ),
                itemBuilder: (context, index) => _ConsoleRow(
                  onTap: onRowTap == null ? null : () => onRowTap!(index),
                  child: _RowCells(
                    columns: columns,
                    cells: cellsBuilder(context, index),
                    showChevron: showChevron,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.columns, required this.showChevron});

  final List<ConsoleColumn> columns;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.labelSmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.4,
    );
    return Container(
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm + 2,
      ),
      child: Row(
        children: [
          for (final c in columns)
            Expanded(
              flex: c.flex,
              child: Text(c.label.toUpperCase(), style: style, textAlign: c.align),
            ),
          if (showChevron) const SizedBox(width: ConsoleTable._chevronSlot),
        ],
      ),
    );
  }
}

class _RowCells extends StatelessWidget {
  const _RowCells({
    required this.columns,
    required this.cells,
    required this.showChevron,
  });

  final List<ConsoleColumn> columns;
  final List<Widget> cells;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        for (var i = 0; i < columns.length; i++)
          Expanded(flex: columns[i].flex, child: cells[i]),
        if (showChevron)
          SizedBox(
            width: ConsoleTable._chevronSlot,
            child: Icon(
              Icons.chevron_right_rounded,
              size: 18,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            ),
          ),
      ],
    );
  }
}

/// A single table row: hover highlight (web/desktop) + ripple, 52px-tall rhythm.
class _ConsoleRow extends StatefulWidget {
  const _ConsoleRow({required this.child, this.onTap});

  final Widget child;
  final VoidCallback? onTap;

  @override
  State<_ConsoleRow> createState() => _ConsoleRowState();
}

class _ConsoleRowState extends State<_ConsoleRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final interactive = widget.onTap != null;
    return MouseRegion(
      cursor: interactive ? SystemMouseCursors.click : MouseCursor.defer,
      onEnter: interactive ? (_) => setState(() => _hovered = true) : null,
      onExit: interactive ? (_) => setState(() => _hovered = false) : null,
      child: GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          color: _hovered
              ? theme.colorScheme.primary.withValues(alpha: 0.05)
              : Colors.transparent,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm + 4,
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
