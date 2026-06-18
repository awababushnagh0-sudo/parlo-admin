import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:polyglot_admin/core/providers/firebase_deps.dart';
import 'package:polyglot_admin/features/dashboard/data/analytics_datasource.dart';

final analyticsDatasourceProvider = Provider<AnalyticsDatasource>((ref) {
  return AnalyticsDatasource(ref.watch(firebaseFirestoreProvider));
});

/// Distinct active users in the last 30 days (collectionGroup).
final activeUsersProvider = FutureProvider.autoDispose<int>((ref) {
  return ref.watch(analyticsDatasourceProvider).activeUsers();
});

/// Saved words grouped by language (sampled).
final wordsByLanguageProvider =
    FutureProvider.autoDispose<Map<String, int>>((ref) {
  return ref.watch(analyticsDatasourceProvider).wordsByLanguage();
});

/// Complaints grouped by category.
final complaintsByCategoryProvider =
    FutureProvider.autoDispose<Map<String, int>>((ref) {
  return ref.watch(analyticsDatasourceProvider).complaintsByCategory();
});
