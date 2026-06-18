import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:polyglot_admin/core/config/app_config.dart';
import 'package:polyglot_admin/features/audit/domain/entities/audit_entry.dart';

class AuditFirestoreDataSource {
  AuditFirestoreDataSource(this._db);

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> get _audit =>
      _db.collection(AppConfig.auditCollection);

  static DateTime? _toDate(dynamic v) {
    if (v is Timestamp) return v.toDate();
    if (v is DateTime) return v;
    return null;
  }

  Stream<List<AuditEntry>> watchEntries({int limit = 200}) {
    return _audit
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map(
                (d) => AuditEntry(
                  id: d.id,
                  adminUid: d.data()['adminUid'] as String? ?? '',
                  adminEmail: d.data()['adminEmail'] as String? ?? '',
                  action: d.data()['action'] as String? ?? '',
                  targetType: d.data()['targetType'] as String?,
                  targetId: d.data()['targetId'] as String?,
                  createdAt: _toDate(d.data()['createdAt']),
                ),
              )
              .toList(),
        );
  }

  Future<void> log({
    required String adminUid,
    required String adminEmail,
    required String action,
    String? targetType,
    String? targetId,
  }) {
    final data = <String, dynamic>{
      'adminUid': adminUid,
      'adminEmail': adminEmail,
      'action': action,
      'createdAt': FieldValue.serverTimestamp(),
    };
    if (targetType != null) data['targetType'] = targetType;
    if (targetId != null) data['targetId'] = targetId;
    return _audit.add(data);
  }
}
