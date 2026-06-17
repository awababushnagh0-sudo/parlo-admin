import 'package:equatable/equatable.dart';
import 'package:polyglot_admin/features/ratings/domain/entities/rating.dart';

/// Aggregate view over a set of ratings: mean score, total count and the
/// per-star distribution (keys 1..5).
class RatingSummary with EquatableMixin {
  final double average;
  final int total;
  final Map<int, int> distribution;

  const RatingSummary({
    required this.average,
    required this.total,
    required this.distribution,
  });

  factory RatingSummary.fromRatings(List<Rating> ratings) {
    final distribution = {for (var i = 1; i <= 5; i++) i: 0};
    var sum = 0;
    for (final r in ratings) {
      final stars = r.stars.clamp(1, 5);
      distribution[stars] = (distribution[stars] ?? 0) + 1;
      sum += stars;
    }
    final total = ratings.length;
    return RatingSummary(
      average: total == 0 ? 0 : sum / total,
      total: total,
      distribution: distribution,
    );
  }

  @override
  List<Object?> get props => [average, total, distribution];
}
