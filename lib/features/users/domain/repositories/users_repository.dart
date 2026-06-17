import 'package:polyglot_admin/features/users/domain/entities/managed_user.dart';

abstract class UsersRepository {
  /// Realtime list of all users.
  Stream<List<ManagedUser>> watchUsers();

  /// Streak / XP summary for a single user (null if they have no stats yet).
  Future<UserStats?> getStats(String userId);

  /// Counts of a user's saved content (words, sentences, videos, decks).
  Future<UserContentCounts> getContentCounts(String userId);

  Future<void> updateName(String userId, String name);

  /// Soft-ban: the mobile app signs the user out when this is true.
  Future<void> setDisabled(String userId, bool disabled);

  /// Permanently deletes the user's Firestore data tree (profile + all
  /// subcollections). Does NOT delete the Firebase Auth account.
  Future<void> deleteUserData(String userId);
}
