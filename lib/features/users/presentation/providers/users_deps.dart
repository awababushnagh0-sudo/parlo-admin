import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:polyglot_admin/features/users/data/providers.dart';
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

  /// Users filtered by the current search query.
  static final filteredUsersProvider =
      Provider<AsyncValue<List<ManagedUser>>>((ref) {
    final users = ref.watch(usersStreamProvider);
    final query = ref.watch(searchProvider).trim().toLowerCase();
    return users.whenData((list) {
      if (query.isEmpty) return list;
      return list
          .where(
            (u) =>
                u.email.toLowerCase().contains(query) ||
                u.name.toLowerCase().contains(query),
          )
          .toList();
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

  /// Write actions (update name / disable / delete) with loading + error state.
  static final controllerProvider =
      NotifierProvider<UsersController, AsyncValue<void>>(UsersController.new);
}

class UsersSearchNotifier extends Notifier<String> {
  @override
  String build() => '';

  void search(String query) => state = query;
}

class UsersController extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<bool> updateName(String userId, String name) =>
      _run(() => ref.read(usersRepositoryProvider).updateName(userId, name));

  Future<bool> setDisabled(String userId, bool disabled) =>
      _run(() => ref.read(usersRepositoryProvider).setDisabled(userId, disabled));

  Future<bool> deleteUserData(String userId) =>
      _run(() => ref.read(usersRepositoryProvider).deleteUserData(userId));

  Future<bool> _run(Future<void> Function() action) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(action);
    return !state.hasError;
  }
}
