import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:polyglot_admin/features/audit/presentation/providers/audit_deps.dart';
import 'package:polyglot_admin/features/users/data/providers.dart';
import 'package:polyglot_admin/features/users/domain/entities/content_item.dart';
import 'package:polyglot_admin/features/users/domain/entities/daily_activity.dart';
import 'package:polyglot_admin/features/users/domain/entities/managed_user.dart';

abstract class UsersDeps {
  UsersDeps._();

  /// Realtime list of all users.
  static final usersStreamProvider = StreamProvider<List<ManagedUser>>((ref) {
    return ref.watch(usersRepositoryProvider).watchUsers();
  });

  /// Free-text search query (email / name).
  static final searchProvider =
      NotifierProvider<UsersSearchNotifier, String>(UsersSearchNotifier.new);

  /// Active / disabled filter.
  static final statusFilterProvider =
      NotifierProvider<UserStatusFilterNotifier, UserStatusFilter>(
        UserStatusFilterNotifier.new,
      );

  /// Sort order.
  static final sortProvider =
      NotifierProvider<UserSortNotifier, UserSort>(UserSortNotifier.new);

  /// Users after search + status filter + sort.
  static final filteredUsersProvider =
      Provider<AsyncValue<List<ManagedUser>>>((ref) {
    final users = ref.watch(usersStreamProvider);
    final query = ref.watch(searchProvider).trim().toLowerCase();
    final status = ref.watch(statusFilterProvider);
    final sort = ref.watch(sortProvider);
    return users.whenData((list) {
      var result = list.where((u) {
        final matchesStatus = switch (status) {
          UserStatusFilter.all => true,
          UserStatusFilter.active => !u.disabled,
          UserStatusFilter.disabled => u.disabled,
        };
        if (!matchesStatus) return false;
        if (query.isEmpty) return true;
        return u.email.toLowerCase().contains(query) ||
            u.name.toLowerCase().contains(query);
      }).toList();
      result.sort(switch (sort) {
        UserSort.email => (a, b) => a.email.toLowerCase().compareTo(b.email.toLowerCase()),
        UserSort.joined => (a, b) {
          final ad = a.createdAt;
          final bd = b.createdAt;
          if (ad == null && bd == null) return 0;
          if (ad == null) return 1;
          if (bd == null) return -1;
          return bd.compareTo(ad);
        },
      });
      return result;
    });
  });

  /// A single user, derived from the realtime list (so detail updates live
  /// after edits / disable without a manual refetch).
  static final userByIdProvider = Provider.family<ManagedUser?, String>((
    ref,
    id,
  ) {
    final list = ref.watch(usersStreamProvider).value ?? const [];
    for (final u in list) {
      if (u.id == id) return u;
    }
    return null;
  });

  /// Streak / XP summary for a user (used by detail and lazily by list rows).
  static final userStatsProvider =
      FutureProvider.family<UserStats?, String>((ref, id) {
    return ref.watch(usersRepositoryProvider).getStats(id);
  });

  /// Saved-content counts for a user (detail screen).
  static final userContentCountsProvider =
      FutureProvider.family<UserContentCounts, String>((ref, id) {
    return ref.watch(usersRepositoryProvider).getContentCounts(id);
  });

  /// Lists a user's saved content of a given kind (detail drill-down).
  static final userContentProvider = FutureProvider.family<List<ContentItem>,
      ({String userId, ContentKind kind})>((ref, args) {
    return ref.watch(usersRepositoryProvider).getContent(args.userId, args.kind);
  });

  /// A user's recent daily activity (heatmap).
  static final userActivityProvider =
      FutureProvider.family<List<DailyActivity>, String>((ref, id) {
    return ref.watch(usersRepositoryProvider).getRecentActivity(id);
  });

  /// Write actions (update name / disable / delete) with loading + error state.
  static final controllerProvider =
      NotifierProvider<UsersController, AsyncValue<void>>(UsersController.new);
}

enum UserStatusFilter { all, active, disabled }

enum UserSort { joined, email }

class UsersSearchNotifier extends Notifier<String> {
  @override
  String build() => '';

  void search(String query) => state = query;
}

class UserStatusFilterNotifier extends Notifier<UserStatusFilter> {
  @override
  UserStatusFilter build() => UserStatusFilter.all;

  void select(UserStatusFilter value) => state = value;
}

class UserSortNotifier extends Notifier<UserSort> {
  @override
  UserSort build() => UserSort.joined;

  void select(UserSort value) => state = value;
}

class UsersController extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<bool> updateName(String userId, String name) async {
    final ok = await _run(
      () => ref.read(usersRepositoryProvider).updateName(userId, name),
    );
    if (ok) await _log('user_rename', userId);
    return ok;
  }

  Future<bool> setDisabled(String userId, bool disabled) async {
    final ok = await _run(
      () => ref.read(usersRepositoryProvider).setDisabled(userId, disabled),
    );
    if (ok) await _log(disabled ? 'user_disable' : 'user_enable', userId);
    return ok;
  }

  Future<bool> deleteUserData(String userId) async {
    final ok = await _run(
      () => ref.read(usersRepositoryProvider).deleteUserData(userId),
    );
    if (ok) await _log('user_delete', userId);
    return ok;
  }

  Future<void> _log(String action, String userId) => ref
      .read(AuditDeps.loggerProvider)
      .log(action, targetType: 'user', targetId: userId);

  Future<bool> _run(Future<void> Function() action) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(action);
    return !state.hasError;
  }
}
