import 'package:polyglot_admin/features/admins/data/datasources/admins_firestore_data_source.dart';
import 'package:polyglot_admin/features/admins/domain/entities/admin_entry.dart';
import 'package:polyglot_admin/features/admins/domain/repositories/admins_repository.dart';

class AdminsRepositoryImpl implements AdminsRepository {
  const AdminsRepositoryImpl(this._source);

  final AdminsFirestoreDataSource _source;

  @override
  Stream<List<AdminEntry>> watchAdmins() => _source.watchAdmins();

  @override
  Future<void> addAdmin({required String uid, required String email}) =>
      _source.addAdmin(uid: uid, email: email);

  @override
  Future<void> removeAdmin(String uid) => _source.removeAdmin(uid);
}
