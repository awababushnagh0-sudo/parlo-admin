import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:polyglot_admin/features/auth/data/providers.dart';
import 'package:polyglot_admin/features/auth/domain/entities/admin_user.dart';

/// Resolved authentication + authorization status, derived from Firebase Auth
/// state plus the `admins/{uid}` check.
enum AuthStatus {
  /// Resolving auth state / admin check — the router waits, no redirect.
  unknown,

  /// No user signed in.
  signedOut,

  /// Signed in, but the account is not an administrator.
  notAdmin,

  /// Signed in and authorized.
  admin,
}

abstract class AuthDeps {
  AuthDeps._();

  /// The raw signed-in user (for displaying the admin's email).
  static final currentAdminProvider = StreamProvider<AdminUser?>((ref) {
    return ref.watch(authRepositoryProvider).authStateChanges();
  });

  /// Single source of truth for routing: emits a fully-resolved [AuthStatus]
  /// for every auth change, running the admin check inline (mirrors the
  /// mobile app's `currentUser` stream that augments auth state with Firestore).
  static final authStatusProvider = StreamProvider<AuthStatus>((ref) async* {
    final repo = ref.watch(authRepositoryProvider);
    await for (final user in repo.authStateChanges()) {
      if (user == null) {
        yield AuthStatus.signedOut;
        continue;
      }
      try {
        final isAdmin = await repo.isAdmin(user.id);
        yield isAdmin ? AuthStatus.admin : AuthStatus.notAdmin;
      } catch (_) {
        // Treat a failed admin check as "not authorized" rather than crashing
        // the gate; the user can retry by signing in again.
        yield AuthStatus.notAdmin;
      }
    }
  });

  /// Sign in / sign out actions with loading + error state.
  static final authControllerProvider =
      NotifierProvider<AuthController, AsyncValue<void>>(AuthController.new);
}

class AuthController extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    final repo = ref.read(authRepositoryProvider);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => repo.signIn(email: email, password: password),
    );
  }

  Future<void> signOut() async {
    final repo = ref.read(authRepositoryProvider);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(repo.signOut);
  }
}
