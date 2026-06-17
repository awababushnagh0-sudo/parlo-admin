import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:polyglot_admin/core/l10n/generated/translations.g.dart';
import 'package:polyglot_admin/core/theme/app_colors.dart';
import 'package:polyglot_admin/core/theme/app_spacing.dart';
import 'package:polyglot_admin/core/ui/widgets/page_header.dart';
import 'package:polyglot_admin/core/ui/widgets/stat_card.dart';
import 'package:polyglot_admin/features/complaints/presentation/providers/complaints_deps.dart';
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
        PageHeader(title: t.dashboard.title, subtitle: t.dashboard.subtitle),

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
      ],
    );
  }
}
