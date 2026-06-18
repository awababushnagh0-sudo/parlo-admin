import 'package:polyglot_admin/features/audit/domain/entities/audit_entry.dart';

abstract class AuditRepository {
  /// Realtime audit log, newest first.
  Stream<List<AuditEntry>> watchEntries({int limit});

  /// Records an admin action.
  Future<void> log({
    required String adminUid,
    required String adminEmail,
    required String action,
    String? targetType,
    String? targetId,
  });
}
