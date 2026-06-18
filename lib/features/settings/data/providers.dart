import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:polyglot_admin/core/providers/firebase_deps.dart';
import 'package:polyglot_admin/features/settings/data/datasources/settings_firestore_data_source.dart';
import 'package:polyglot_admin/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:polyglot_admin/features/settings/domain/repositories/settings_repository.dart';

final settingsDataSourceProvider = Provider<SettingsFirestoreDataSource>((ref) {
  return SettingsFirestoreDataSource(ref.watch(firebaseFirestoreProvider));
});

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepositoryImpl(ref.watch(settingsDataSourceProvider));
});
