import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:polyglot_admin/features/users/domain/entities/managed_user.dart';
import 'package:polyglot_admin/features/users/presentation/providers/users_deps.dart';

/// One bucket in the signups-over-time chart.
class MonthlySignups {
  const MonthlySignups({required this.label, required this.count});
  final String label; // e.g. "Jan"
  final int count;
}

abstract class DashboardDeps {
  DashboardDeps._();

  /// Number of users created in the current calendar month.
  static final newThisMonthProvider = Provider<int>((ref) {
    final users = ref.watch(UsersDeps.usersStreamProvider).value ?? const [];
    final now = DateTime.now();
    return users.where((u) {
      final d = u.createdAt;
      return d != null && d.year == now.year && d.month == now.month;
    }).length;
  });

  /// Signups grouped by month for the last 6 months (oldest → newest).
  static final signupsSeriesProvider = Provider<List<MonthlySignups>>((ref) {
    final users = ref.watch(UsersDeps.usersStreamProvider).value ?? const [];
    return _bucketByMonth(users, months: 6);
  });

  static List<MonthlySignups> _bucketByMonth(
    List<ManagedUser> users, {
    required int months,
  }) {
    final now = DateTime.now();
    final monthFormat = DateFormat.MMM();
    final buckets = <String, MonthlySignups>{};
    final order = <String>[];

    for (var i = months - 1; i >= 0; i--) {
      final month = DateTime(now.year, now.month - i);
      final key = '${month.year}-${month.month}';
      order.add(key);
      buckets[key] = MonthlySignups(label: monthFormat.format(month), count: 0);
    }

    for (final u in users) {
      final d = u.createdAt;
      if (d == null) continue;
      final key = '${d.year}-${d.month}';
      final existing = buckets[key];
      if (existing != null) {
        buckets[key] =
            MonthlySignups(label: existing.label, count: existing.count + 1);
      }
    }

    return [for (final key in order) buckets[key]!];
  }
}
