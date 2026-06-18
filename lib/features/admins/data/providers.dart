import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:polyglot_admin/core/providers/firebase_deps.dart';
import 'package:polyglot_admin/features/admins/data/datasources/admins_firestore_data_source.dart';
import 'package:polyglot_admin/features/admins/data/repositories/admins_repository_impl.dart';
import 'package:polyglot_admin/features/admins/domain/repositories/admins_repository.dart';

final adminsDataSourceProvider = Provider<AdminsFirestoreDataSource>((ref) {
  return AdminsFirestoreDataSource(ref.watch(firebaseFirestoreProvider));
});

final adminsRepositoryProvider = Provider<AdminsRepository>((ref) {
  return AdminsRepositoryImpl(ref.watch(adminsDataSourceProvider));
});
