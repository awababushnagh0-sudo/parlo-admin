import 'package:polyglot_admin/features/ratings/data/datasources/ratings_firestore_data_source.dart';
import 'package:polyglot_admin/features/ratings/domain/entities/rating.dart';
import 'package:polyglot_admin/features/ratings/domain/repositories/ratings_repository.dart';

class RatingsRepositoryImpl implements RatingsRepository {
  const RatingsRepositoryImpl(this._source);

  final RatingsFirestoreDataSource _source;

  @override
  Stream<List<Rating>> watchRatings() => _source.watchRatings();
}
