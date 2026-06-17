import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:polyglot_admin/features/ratings/data/providers.dart';
import 'package:polyglot_admin/features/ratings/domain/entities/rating.dart';
import 'package:polyglot_admin/features/ratings/domain/entities/rating_summary.dart';

abstract class RatingsDeps {
  RatingsDeps._();

  /// Realtime list of all ratings (newest first).
  static final ratingsStreamProvider = StreamProvider<List<Rating>>((ref) {
    return ref.watch(ratingsRepositoryProvider).watchRatings();
  });

  /// Aggregate summary (average + distribution) derived from the list.
  static final summaryProvider = Provider<AsyncValue<RatingSummary>>((ref) {
    return ref
        .watch(ratingsStreamProvider)
        .whenData(RatingSummary.fromRatings);
  });
}
