import 'package:polyglot_admin/features/audit/data/datasources/audit_firestore_data_source.dart';
import 'package:polyglot_admin/features/audit/domain/entities/audit_entry.dart';
import 'package:polyglot_admin/features/audit/domain/repositories/audit_repository.dart';

class AuditRepositoryImpl implements AuditRepository {
  const AuditRepositoryImpl(this._source);

  final AuditFirestoreDataSource _source;

  @override
  Stream<List<AuditEntry>> watchEntries({int limit = 200}) =>
      _source.watchEntries(limit: limit);

  @override
  Future<void> log({
    required String adminUid,
    required String adminEmail,
    required String action,
    String? targetType,
    String? targetId,
  }) =>
      _source.log(
        adminUid: adminUid,
        adminEmail: adminEmail,
        action: action,
        targetType: targetType,
        targetId: targetId,
      );
}
