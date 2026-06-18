import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:polyglot_admin/features/audit/data/providers.dart';
import 'package:polyglot_admin/features/audit/domain/entities/audit_entry.dart';
import 'package:polyglot_admin/features/auth/data/providers.dart';

abstract class AuditDeps {
  AuditDeps._();

  static final entriesStreamProvider = StreamProvider<List<AuditEntry>>((ref) {
    return ref.watch(auditRepositoryProvider).watchEntries();
  });

  /// Shared logger other controllers call after a successful admin action.
  static final loggerProvider = Provider<AuditLogger>((ref) => AuditLogger(ref));
}

/// Records admin actions, stamping the current admin. Best-effort: an audit
/// write failure never breaks the action it describes.
class AuditLogger {
  AuditLogger(this._ref);

  final Ref _ref;

  Future<void> log(String action, {String? targetType, String? targetId}) async {
    final admin = _ref.read(authRepositoryProvider).currentUser;
    if (admin == null) return;
    try {
      await _ref.read(auditRepositoryProvider).log(
        adminUid: admin.id,
        adminEmail: admin.email,
        action: action,
        targetType: targetType,
        targetId: targetId,
      );
    } catch (_) {
      // swallow — auditing must never block the primary action
    }
  }
}
