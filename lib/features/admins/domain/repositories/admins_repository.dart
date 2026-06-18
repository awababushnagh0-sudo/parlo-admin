import 'package:polyglot_admin/features/admins/domain/entities/admin_entry.dart';

abstract class AdminsRepository {
  /// Realtime list of all administrators.
  Stream<List<AdminEntry>> watchAdmins();

  /// Grants admin access by writing `admins/{uid}`.
  Future<void> addAdmin({required String uid, required String email});

  /// Revokes admin access.
  Future<void> removeAdmin(String uid);
}
