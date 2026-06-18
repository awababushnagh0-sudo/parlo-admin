import 'package:flutter/material.dart';
import 'package:polyglot_admin/core/theme/app_colors.dart';

/// A GitHub-style contribution heatmap. Generic on purpose (takes a
/// date-key → value map) so it stays in `core` without depending on a feature
/// entity. Date keys are "yyyy-MM-dd".
class ActivityHeatmap extends StatelessWidget {
  const ActivityHeatmap({
    super.key,
    required this.valuesByDate,
    required this.today,
    this.days = 91,
    this.cell = 13,
    this.gap = 3,
  });

  final Map<String, int> valuesByDate;
  final DateTime today;
  final int days;
  final double cell;
  final double gap;

  static String keyOf(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';

  Color _color(BuildContext context, int value) {
    final scheme = Theme.of(context).colorScheme;
    if (value <= 0) return scheme.surfaceContainerHighest;
    if (value <= 2) return AppColors.primary.withValues(alpha: 0.30);
    if (value <= 5) return AppColors.primary.withValues(alpha: 0.50);
    if (value <= 10) return AppColors.primary.withValues(alpha: 0.75);
    return AppColors.primary;
  }

  @override
  Widget build(BuildContext context) {
    final end = DateTime(today.year, today.month, today.day);
    // Align the start back to the most recent Sunday so columns are clean weeks.
    var start = end.subtract(Duration(days: days - 1));
    start = start.subtract(Duration(days: start.weekday % 7));
    final totalDays = end.difference(start).inDays + 1;
    final weeks = (totalDays / 7).ceil();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var w = 0; w < weeks; w++)
            Padding(
              padding: EdgeInsets.only(right: gap),
              child: Column(
                children: [
                  for (var d = 0; d < 7; d++)
                    _buildCell(context, start.add(Duration(days: w * 7 + d)), end),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCell(BuildContext context, DateTime date, DateTime end) {
    if (date.isAfter(end)) {
      return SizedBox(width: cell, height: cell + gap);
    }
    final key = keyOf(date);
    final value = valuesByDate[key] ?? 0;
    return Padding(
      padding: EdgeInsets.only(bottom: gap),
      child: Tooltip(
        message: '$key · $value',
        waitDuration: const Duration(milliseconds: 300),
        child: Container(
          width: cell,
          height: cell,
          decoration: BoxDecoration(
            color: _color(context, value),
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ),
    );
  }
}
