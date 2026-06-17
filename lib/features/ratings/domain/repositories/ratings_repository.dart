import 'package:polyglot_admin/features/ratings/domain/entities/rating.dart';

abstract class RatingsRepository {
  /// Realtime list of all ratings, newest first.
  Stream<List<Rating>> watchRatings();
}
