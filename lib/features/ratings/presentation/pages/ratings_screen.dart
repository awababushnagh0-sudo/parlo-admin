import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:polyglot_admin/core/l10n/generated/translations.g.dart';
import 'package:polyglot_admin/core/theme/app_colors.dart';
import 'package:polyglot_admin/core/theme/app_radius.dart';
import 'package:polyglot_admin/core/theme/app_spacing.dart';
import 'package:polyglot_admin/core/ui/csv_export.dart';
import 'package:polyglot_admin/core/ui/format.dart';
import 'package:polyglot_admin/core/ui/widgets/app_card.dart';
import 'package:polyglot_admin/core/ui/widgets/async_value_view.dart';
import 'package:polyglot_admin/core/ui/widgets/console_table.dart';
import 'package:polyglot_admin/core/ui/widgets/empty_state.dart';
import 'package:polyglot_admin/core/ui/widgets/page_header.dart';
import 'package:polyglot_admin/core/ui/widgets/status_badge.dart';
import 'package:polyglot_admin/features/ratings/domain/entities/rating.dart';
import 'package:polyglot_admin/features/ratings/domain/entities/rating_summary.dart';
import 'package:polyglot_admin/features/ratings/presentation/providers/ratings_deps.dart';
import 'package:polyglot_admin/features/ratings/presentation/rating_labels.dart';
import 'package:polyglot_admin/features/ratings/presentation/widgets/star_row.dart';

class RatingsScreen extends ConsumerWidget {
  const RatingsScreen({super.key});

  static List<ConsoleColumn> _columns(Translations t) => [
    ConsoleColumn(t.ratings.columnUser, flex: 3),
    ConsoleColumn(t.ratings.columnType, flex: 2),
    ConsoleColumn(t.ratings.columnStars, flex: 2),
    ConsoleColumn(t.ratings.columnComment, flex: 4),
    ConsoleColumn(t.ratings.columnDate, flex: 2, align: TextAlign.end),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final ratings = ref.watch(RatingsDeps.ratingsStreamProvider);
    final total = ratings.value?.length ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PageHeader(
          title: t.ratings.title,
          subtitle: ratings.hasValue ? t.ratings.count(n: total) : null,
          actions: [
            OutlinedButton.icon(
              onPressed: () => _export(ratings.value ?? const [], t),
              icon: const Icon(Icons.download_rounded, size: 18),
              label: Text(t.common.export),
            ),
          ],
        ),
        Expanded(
          child: AsyncValueView(
            value: ratings,
            onRetry: () => ref.invalidate(RatingsDeps.ratingsStreamProvider),
            data: (items) {
              if (items.isEmpty) {
                return EmptyState(
                  icon: Icons.star_outline_rounded,
                  title: t.ratings.noRatings,
                );
              }
              final summary = RatingSummary.fromRatings(items);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _SummaryCard(summary: summary),
                  const SizedBox(height: AppSpacing.lg),
                  Expanded(
                    child: ConsoleTable(
                      columns: _columns(t),
                      rowCount: items.length,
                      showChevron: false,
                      cellsBuilder: (context, i) => _cells(context, items[i]),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  List<Widget> _cells(BuildContext context, Rating r) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    return [
      Text(
        r.userEmail,
        style: theme.textTheme.titleSmall,
        overflow: TextOverflow.ellipsis,
      ),
      Align(
        alignment: Alignment.centerLeft,
        child: StatusBadge(label: r.type.label(t), color: AppColors.accentBlue),
      ),
      StarRow(value: r.stars),
      Padding(
        padding: const EdgeInsets.only(right: AppSpacing.md),
        child: Text(
          (r.comment ?? '').isEmpty ? t.common.none : r.comment!,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodyMedium,
        ),
      ),
      Text(
        Format.date(r.createdAt),
        textAlign: TextAlign.end,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    ];
  }

  void _export(List<Rating> items, Translations t) {
    final rows = <List<String>>[
      [
        t.ratings.columnUser,
        t.ratings.columnType,
        t.ratings.columnStars,
        t.ratings.columnComment,
        t.ratings.columnDate,
      ],
      for (final r in items)
        [
          r.userEmail,
          r.type.label(t),
          '${r.stars}',
          r.comment ?? '',
          Format.date(r.createdAt),
        ],
    ];
    downloadCsv('parlo-ratings.csv', rows);
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.summary});

  final RatingSummary summary;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final narrow = constraints.maxWidth < 560;
          final average = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(t.ratings.average, style: theme.textTheme.labelMedium),
              const SizedBox(height: AppSpacing.xs),
              Text(
                summary.average.toStringAsFixed(1),
                style: theme.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              StarRow(value: summary.average.round(), size: 20),
              const SizedBox(height: AppSpacing.xs),
              Text(
                t.ratings.basedOn(n: summary.total),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          );
          final distribution = _Distribution(summary: summary);
          if (narrow) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                average,
                const SizedBox(height: AppSpacing.lg),
                distribution,
              ],
            );
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 180, child: average),
              const SizedBox(width: AppSpacing.xl),
              Expanded(child: distribution),
            ],
          );
        },
      ),
    );
  }
}

class _Distribution extends StatelessWidget {
  const _Distribution({required this.summary});

  final RatingSummary summary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final maxCount = summary.distribution.values.fold<int>(
      0,
      (m, v) => v > m ? v : m,
    );
    return Column(
      children: [
        for (var star = 5; star >= 1; star--)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Row(
              children: [
                SizedBox(
                  width: 18,
                  child: Text('$star', style: theme.textTheme.bodySmall),
                ),
                const Icon(Icons.star_rounded, size: 14, color: AppColors.warning),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.full),
                    child: LinearProgressIndicator(
                      value: maxCount == 0
                          ? 0
                          : (summary.distribution[star] ?? 0) / maxCount,
                      minHeight: 8,
                      backgroundColor: theme.colorScheme.surfaceContainerHighest,
                      color: AppColors.warning,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                SizedBox(
                  width: 32,
                  child: Text(
                    '${summary.distribution[star] ?? 0}',
                    textAlign: TextAlign.end,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
