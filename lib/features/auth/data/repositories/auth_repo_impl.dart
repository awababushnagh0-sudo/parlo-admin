import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:polyglot_admin/core/config/app_config.dart';
import 'package:polyglot_admin/features/auth/domain/entities/admin_user.dart';
import 'package:polyglot_admin/features/auth/domain/repositories/auth_repository.dart';

class AuthRepoImpl implements AuthRepository {
  const AuthRepoImpl(this._auth, this._db);

  final FirebaseAuth _auth;
  final FirebaseFirestore _db;

  @override
  Stream<AdminUser?> authStateChanges() {
    return _auth.authStateChanges().map(_mapUser);
  }

  @override
  AdminUser? get currentUser => _mapUser(_auth.currentUser);

  @override
  Future<bool> isAdmin(String uid) async {
    // An admin is any user with a document in the top-level `admins` collection.
    // Read is permitted to any signed-in user by the security rules.
    final doc = await _db
        .collection(AppConfig.adminsCollection)
        .doc(uid)
        .get()
        .timeout(const Duration(seconds: 10));
    return doc.exists;
  }

  @override
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  @override
  Future<void> signOut() => _auth.signOut();

  AdminUser? _mapUser(User? user) {
    if (user == null) return null;
    return AdminUser(id: user.uid, email: user.email ?? '');
  }
}
