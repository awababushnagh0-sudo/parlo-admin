import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:polyglot_admin/core/providers/firebase_deps.dart';
import 'package:polyglot_admin/features/complaints/data/datasources/complaints_firestore_data_source.dart';
import 'package:polyglot_admin/features/complaints/data/repositories/complaints_repository_impl.dart';
import 'package:polyglot_admin/features/complaints/domain/repositories/complaints_repository.dart';

final complaintsDataSourceProvider =
    Provider<ComplaintsFirestoreDataSource>((ref) {
  return ComplaintsFirestoreDataSource(ref.watch(firebaseFirestoreProvider));
});

final complaintsRepositoryProvider = Provider<ComplaintsRepository>((ref) {
  return ComplaintsRepositoryImpl(ref.watch(complaintsDataSourceProvider));
});
