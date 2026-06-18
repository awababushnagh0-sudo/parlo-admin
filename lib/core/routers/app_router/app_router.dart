import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:polyglot_admin/core/routers/shell/admin_shell.dart';
import 'package:polyglot_admin/features/account/presentation/pages/account_screen.dart';
import 'package:polyglot_admin/features/admins/presentation/pages/admins_screen.dart';
import 'package:polyglot_admin/features/auth/presentation/pages/login_screen.dart';
import 'package:polyglot_admin/features/auth/presentation/providers/auth_deps.dart';
import 'package:polyglot_admin/features/complaints/presentation/pages/complaints_screen.dart';
import 'package:polyglot_admin/features/dashboard/presentation/pages/dashboard_screen.dart';
import 'package:polyglot_admin/features/ratings/presentation/pages/ratings_screen.dart';
import 'package:polyglot_admin/features/settings/presentation/pages/settings_screen.dart';
import 'package:polyglot_admin/features/users/presentation/pages/user_detail_screen.dart';
import 'package:polyglot_admin/features/users/presentation/pages/users_list_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    // Start on the gate; the redirect promotes an authorized admin to '/'.
    initialLocation: '/login',
    // Re-evaluate guards whenever the resolved auth status changes.
    redirect: (context, state) {
      final status = ref.watch(AuthDeps.authStatusProvider).value;

      // Still resolving auth / admin check — don't redirect yet.
      if (status == null || status == AuthStatus.unknown) return null;

      final goingToLogin = state.matchedLocation == '/login';
      final authorized = status == AuthStatus.admin;

      if (!authorized) {
        // Signed out OR signed-in-but-not-admin: stay on the login screen
        // (it renders a "not authorized" state for the not-admin case).
        return goingToLogin ? null : '/login';
      }

      // Authorized admin trying to view login → send to the dashboard.
      if (goingToLogin) return '/';
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: LoginScreen()),
      ),
      ShellRoute(
        builder: (context, state, child) => AdminShell(child: child),
        routes: [
          GoRoute(
            path: '/',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: DashboardScreen()),
          ),
          GoRoute(
            path: '/users',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: UsersListScreen()),
            routes: [
              GoRoute(
                path: ':id',
                pageBuilder: (context, state) => NoTransitionPage(
                  child: UserDetailScreen(userId: state.pathParameters['id']!),
                ),
              ),
            ],
          ),
          GoRoute(
            path: '/complaints',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: ComplaintsScreen()),
          ),
          GoRoute(
            path: '/ratings',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: RatingsScreen()),
          ),
          GoRoute(
            path: '/admins',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: AdminsScreen()),
          ),
          GoRoute(
            path: '/settings',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: SettingsScreen()),
          ),
          GoRoute(
            path: '/account',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: AccountScreen()),
          ),
        ],
      ),
    ],
  );
});
