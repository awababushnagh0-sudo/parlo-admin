import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:polyglot_admin/core/providers/firebase_deps.dart';
import 'package:polyglot_admin/features/ratings/data/datasources/ratings_firestore_data_source.dart';
import 'package:polyglot_admin/features/ratings/data/repositories/ratings_repository_impl.dart';
import 'package:polyglot_admin/features/ratings/domain/repositories/ratings_repository.dart';

final ratingsDataSourceProvider = Provider<RatingsFirestoreDataSource>((ref) {
  return RatingsFirestoreDataSource(ref.watch(firebaseFirestoreProvider));
});

final ratingsRepositoryProvider = Provider<RatingsRepository>((ref) {
  return RatingsRepositoryImpl(ref.watch(ratingsDataSourceProvider));
});
