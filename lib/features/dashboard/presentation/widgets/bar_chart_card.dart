import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:polyglot_admin/core/theme/app_radius.dart';
import 'package:polyglot_admin/core/theme/app_spacing.dart';
import 'package:polyglot_admin/core/ui/widgets/app_card.dart';

/// A labelled bar value for [BarChartCard].
class BarDatum {
  const BarDatum({required this.label, required this.value});
  final String label;
  final int value;
}

/// A titled card wrapping an fl_chart [BarChart]. Used for signups-over-time
/// and rating-distribution on the dashboard.
class BarChartCard extends StatelessWidget {
  const BarChartCard({
    super.key,
    required this.title,
    required this.data,
    required this.color,
    this.emptyLabel,
  });

  final String title;
  final List<BarDatum> data;
  final Color color;
  final String? emptyLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final maxValue = data.fold<int>(0, (m, d) => d.value > m ? d.value : m);
    final hasData = maxValue > 0;
    final maxY = hasData ? maxValue * 1.25 : 1.0;

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.titleMedium),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            height: 220,
            child: !hasData && emptyLabel != null
                ? Center(
                    child: Text(
                      emptyLabel!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  )
                : BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: maxY,
                      barTouchData: BarTouchData(
                        touchTooltipData: BarTouchTooltipData(
                          getTooltipColor: (_) => theme.colorScheme.inverseSurface,
                          getTooltipItem: (group, _, rod, _) => BarTooltipItem(
                            '${rod.toY.toInt()}',
                            theme.textTheme.labelMedium!.copyWith(
                              color: theme.colorScheme.onInverseSurface,
                            ),
                          ),
                        ),
                      ),
                      titlesData: FlTitlesData(
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 30,
                            interval: (maxY / 4).ceilToDouble().clamp(1, double.infinity),
                            getTitlesWidget: (value, meta) {
                              if (value % 1 != 0) return const SizedBox.shrink();
                              return Text(
                                value.toInt().toString(),
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              );
                            },
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 28,
                            getTitlesWidget: (value, meta) {
                              final i = value.toInt();
                              if (i < 0 || i >= data.length) {
                                return const SizedBox.shrink();
                              }
                              return Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Text(
                                  data[i].label,
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        getDrawingHorizontalLine: (_) => FlLine(
                          color: theme.colorScheme.outlineVariant,
                          strokeWidth: 1,
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      barGroups: [
                        for (var i = 0; i < data.length; i++)
                          BarChartGroupData(
                            x: i,
                            barRods: [
                              BarChartRodData(
                                toY: data[i].value.toDouble(),
                                color: color,
                                width: 22,
                                borderRadius: BorderRadius.circular(AppRadius.sm),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
