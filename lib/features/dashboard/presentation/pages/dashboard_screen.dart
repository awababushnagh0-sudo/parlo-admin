import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:polyglot_admin/core/l10n/generated/translations.g.dart';
import 'package:polyglot_admin/core/services/backend_health_service.dart';
import 'package:polyglot_admin/core/theme/app_colors.dart';
import 'package:polyglot_admin/core/theme/app_radius.dart';
import 'package:polyglot_admin/core/theme/app_spacing.dart';
import 'package:polyglot_admin/core/ui/widgets/page_header.dart';
import 'package:polyglot_admin/core/ui/widgets/stat_card.dart';
import 'package:polyglot_admin/features/complaints/domain/entities/complaint.dart';
import 'package:polyglot_admin/features/complaints/presentation/complaint_labels.dart';
import 'package:polyglot_admin/features/complaints/presentation/providers/complaints_deps.dart';
import 'package:polyglot_admin/features/dashboard/data/providers.dart';
import 'package:polyglot_admin/features/dashboard/presentation/providers/dashboard_deps.dart';
import 'package:polyglot_admin/features/dashboard/presentation/widgets/bar_chart_card.dart';
import 'package:polyglot_admin/features/ratings/presentation/providers/ratings_deps.dart';
import 'package:polyglot_admin/features/users/presentation/providers/users_deps.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final users = ref.watch(UsersDeps.usersStreamProvider);
    final newThisMonth = ref.watch(DashboardDeps.newThisMonthProvider);
    final openComplaints = ref.watch(ComplaintsDeps.openCountProvider);
    final ratingSummary = ref.watch(RatingsDeps.summaryProvider);
    final signups = ref.watch(DashboardDeps.signupsSeriesProvider);

    String orDash(int? value) => value?.toString() ?? '—';

    final average = ratingSummary.value?.average;
    final ratingDistribution = ratingSummary.value?.distribution;

    return ListView(
      children: [
        PageHeader(
          title: t.dashboard.title,
          subtitle: t.dashboard.subtitle,
          actions: const [_BackendChip()],
        ),

        // KPI cards
        LayoutBuilder(
          builder: (context, constraints) {
            // 4 across when wide, 2 when medium, 1 when narrow.
            final columns = constraints.maxWidth >= 1000
                ? 4
                : constraints.maxWidth >= 560
                    ? 2
                    : 1;
            const spacing = AppSpacing.md;
            final cardWidth =
                (constraints.maxWidth - spacing * (columns - 1)) / columns;
            return Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: [
                SizedBox(
                  width: cardWidth,
                  child: StatCard(
                    label: t.dashboard.totalUsers,
                    value: orDash(users.value?.length),
                    icon: Icons.people_alt_outlined,
                    color: AppColors.primary,
                    onTap: () => context.go('/users'),
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  child: StatCard(
                    label: t.dashboard.newThisMonth,
                    value: users.hasValue ? '$newThisMonth' : '—',
                    icon: Icons.person_add_alt_1_outlined,
                    color: AppColors.accentBlue,
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  child: StatCard(
                    label: t.dashboard.openComplaints,
                    value: orDash(openComplaints.value),
                    icon: Icons.report_gmailerrorred_outlined,
                    color: AppColors.warning,
                    onTap: () => context.go('/complaints'),
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  child: StatCard(
                    label: t.dashboard.avgRating,
                    value: average == null ? '—' : average.toStringAsFixed(1),
                    icon: Icons.star_rounded,
                    color: AppColors.accentOrange,
                    onTap: () => context.go('/ratings'),
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: AppSpacing.lg),

        // Charts
        LayoutBuilder(
          builder: (context, constraints) {
            final signupsChart = BarChartCard(
              title: t.dashboard.signupsOverTime,
              color: AppColors.primary,
              emptyLabel: t.dashboard.noChartData,
              data: [
                for (final m in signups)
                  BarDatum(label: m.label, value: m.count),
              ],
            );
            final ratingChart = BarChartCard(
              title: t.dashboard.ratingDistribution,
              color: AppColors.warning,
              emptyLabel: t.dashboard.noChartData,
              data: [
                for (var star = 1; star <= 5; star++)
                  BarDatum(
                    label: '$star★',
                    value: ratingDistribution?[star] ?? 0,
                  ),
              ],
            );
            if (constraints.maxWidth >= 900) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: signupsChart),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(child: ratingChart),
                ],
              );
            }
            return Column(
              children: [
                signupsChart,
                const SizedBox(height: AppSpacing.md),
                ratingChart,
              ],
            );
          },
        ),
        const SizedBox(height: AppSpacing.xl),
        const _PlatformAnalytics(),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}

/// Cross-user analytics (collectionGroup). Degrades to empty charts before the
/// rules + indexes are deployed, so it never breaks the dashboard.
class _PlatformAnalytics extends ConsumerWidget {
  const _PlatformAnalytics();

  List<BarDatum> _top(
    Map<String, int> map,
    String Function(String key) label, {
    int max = 8,
  }) {
    final entries = map.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return [
      for (final e in entries.take(max)) BarDatum(label: label(e.key), value: e.value),
    ];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final active = ref.watch(activeUsersProvider).value;
    final wordsByLang = ref.watch(wordsByLanguageProvider).value ?? const {};
    final byCategory = ref.watch(complaintsByCategoryProvider).value ?? const {};

    final wordsChart = BarChartCard(
      title: t.dashboard.wordsByLanguage,
      color: AppColors.primary,
      emptyLabel: t.dashboard.noChartData,
      data: _top(wordsByLang, (k) => k.toUpperCase()),
    );
    final categoryChart = BarChartCard(
      title: t.dashboard.mostReported,
      color: AppColors.warning,
      emptyLabel: t.dashboard.noChartData,
      data: _top(byCategory, (k) => ComplaintCategory.fromKey(k).label(t)),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          t.dashboard.platformAnalytics,
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          t.dashboard.analyticsHint,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        SizedBox(
          width: 260,
          child: StatCard(
            label: t.dashboard.activeUsers,
            value: active?.toString() ?? '—',
            icon: Icons.trending_up_rounded,
            color: AppColors.accentBlue,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth >= 900) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: wordsChart),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(child: categoryChart),
                ],
              );
            }
            return Column(
              children: [
                wordsChart,
                const SizedBox(height: AppSpacing.md),
                categoryChart,
              ],
            );
          },
        ),
      ],
    );
  }
}

/// Live backend `/health` status pill (auto-refreshing).
class _BackendChip extends ConsumerWidget {
  const _BackendChip();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final health = ref.watch(backendHealthProvider);

    final (Color color, IconData icon, String label) = health.when(
      loading: () => (
        theme.colorScheme.onSurfaceVariant,
        Icons.cloud_queue_rounded,
        t.dashboard.backendChecking,
      ),
      error: (_, _) => (
        AppColors.error,
        Icons.cloud_off_rounded,
        t.dashboard.backendDown,
      ),
      data: (h) => switch (h.status) {
        BackendStatus.healthy => (
          AppColors.success,
          Icons.cloud_done_rounded,
          h.latencyMs != null
              ? '${t.dashboard.backendHealthy} · ${t.dashboard.latency(ms: h.latencyMs!)}'
              : t.dashboard.backendHealthy,
        ),
        BackendStatus.down => (
          AppColors.error,
          Icons.cloud_off_rounded,
          t.dashboard.backendDown,
        ),
      },
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            '${t.dashboard.backendStatus}: $label',
            style: theme.textTheme.labelMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
