import 'package:polyglot_admin/features/auth/domain/entities/admin_user.dart';

/// Contract for authentication + admin authorization. Implemented over
/// Firebase Auth + the `admins/{uid}` registry in Firestore.
abstract class AuthRepository {
  /// Emits the current signed-in user (or null when signed out).
  Stream<AdminUser?> authStateChanges();

  /// The currently signed-in user, if any.
  AdminUser? get currentUser;

  /// Whether [uid] is registered as an administrator (`admins/{uid}` exists).
  Future<bool> isAdmin(String uid);

  Future<void> signIn({required String email, required String password});

  Future<void> signOut();
}
