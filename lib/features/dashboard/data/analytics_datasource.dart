import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:polyglot_admin/core/config/app_config.dart';

/// Cross-user platform analytics via Firestore collection-group queries.
/// Requires the collectionGroup rules + indexes (see polyglot/firestore.rules
/// and firestore.indexes.json). Callers tolerate failures (e.g. before indexes
/// finish building) by treating errors as "no data".
class AnalyticsDatasource {
  AnalyticsDatasource(this._db);

  final FirebaseFirestore _db;

  static String _dateKey(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';

  /// Distinct users with any activity in the last [days] days.
  Future<int> activeUsers({int days = 30}) async {
    final start = _dateKey(DateTime.now().subtract(Duration(days: days)));
    final snap = await _db
        .collectionGroup(AppConfig.activitySub)
        .where('date', isGreaterThanOrEqualTo: start)
        .get();
    final users = <String>{};
    for (final doc in snap.docs) {
      final uid = doc.reference.parent.parent?.id;
      if (uid != null) users.add(uid);
    }
    return users.length;
  }

  /// Count of saved words per language (sampled to [limit] documents).
  Future<Map<String, int>> wordsByLanguage({int limit = 2000}) async {
    final snap = await _db
        .collectionGroup(AppConfig.wordsSub)
        .limit(limit)
        .get();
    final counts = <String, int>{};
    for (final doc in snap.docs) {
      final lang = (doc.data()['language'] as String?) ?? '??';
      counts[lang] = (counts[lang] ?? 0) + 1;
    }
    return counts;
  }

  /// Count of complaints per category (across all complaints).
  Future<Map<String, int>> complaintsByCategory() async {
    final snap = await _db.collection(AppConfig.complaintsCollection).get();
    final counts = <String, int>{};
    for (final doc in snap.docs) {
      final cat = (doc.data()['category'] as String?) ?? 'other';
      counts[cat] = (counts[cat] ?? 0) + 1;
    }
    return counts;
  }
}
