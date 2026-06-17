import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:polyglot_admin/core/providers/firebase_deps.dart';
import 'package:polyglot_admin/features/users/data/datasources/users_firestore_data_source.dart';
import 'package:polyglot_admin/features/users/data/repositories/users_repository_impl.dart';
import 'package:polyglot_admin/features/users/domain/repositories/users_repository.dart';

final usersDataSourceProvider = Provider<UsersFirestoreDataSource>((ref) {
  return UsersFirestoreDataSource(ref.watch(firebaseFirestoreProvider));
});

final usersRepositoryProvider = Provider<UsersRepository>((ref) {
  return UsersRepositoryImpl(ref.watch(usersDataSourceProvider));
});
