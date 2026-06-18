import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:polyglot_admin/core/config/app_config.dart';
import 'package:polyglot_admin/features/admins/domain/entities/admin_entry.dart';

class AdminsFirestoreDataSource {
  AdminsFirestoreDataSource(this._db);

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> get _admins =>
      _db.collection(AppConfig.adminsCollection);

  static DateTime? _toDate(dynamic v) {
    if (v is Timestamp) return v.toDate();
    if (v is DateTime) return v;
    return null;
  }

  Stream<List<AdminEntry>> watchAdmins() {
    return _admins.snapshots().map((snapshot) {
      final admins = snapshot.docs
          .map(
            (doc) => AdminEntry(
              uid: doc.id,
              email: doc.data()['email'] as String? ?? '',
              addedAt: _toDate(doc.data()['addedAt']),
            ),
          )
          .toList();
      admins.sort((a, b) {
        final ad = a.addedAt;
        final bd = b.addedAt;
        if (ad == null && bd == null) return a.email.compareTo(b.email);
        if (ad == null) return 1;
        if (bd == null) return -1;
        return bd.compareTo(ad);
      });
      return admins;
    });
  }

  Future<void> addAdmin({required String uid, required String email}) {
    return _admins.doc(uid).set({
      'email': email,
      'addedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> removeAdmin(String uid) => _admins.doc(uid).delete();
}
