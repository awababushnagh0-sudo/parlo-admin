import 'package:polyglot_admin/features/users/data/datasources/users_firestore_data_source.dart';
import 'package:polyglot_admin/features/users/domain/entities/content_item.dart';
import 'package:polyglot_admin/features/users/domain/entities/daily_activity.dart';
import 'package:polyglot_admin/features/users/domain/entities/managed_user.dart';
import 'package:polyglot_admin/features/users/domain/repositories/users_repository.dart';

class UsersRepositoryImpl implements UsersRepository {
  const UsersRepositoryImpl(this._source);

  final UsersFirestoreDataSource _source;

  @override
  Stream<List<ManagedUser>> watchUsers() => _source.watchUsers();

  @override
  Future<UserStats?> getStats(String userId) => _source.getStats(userId);

  @override
  Future<UserContentCounts> getContentCounts(String userId) =>
      _source.getContentCounts(userId);

  @override
  Future<List<ContentItem>> getContent(
    String userId,
    ContentKind kind, {
    int limit = 100,
  }) =>
      _source.getContent(userId, kind, limit: limit);

  @override
  Future<List<DailyActivity>> getRecentActivity(String userId, {int days = 90}) =>
      _source.getRecentActivity(userId, days: days);

  @override
  Future<void> updateName(String userId, String name) =>
      _source.updateName(userId, name);

  @override
  Future<void> setDisabled(String userId, bool disabled) =>
      _source.setDisabled(userId, disabled);

  @override
  Future<void> deleteUserData(String userId) =>
      _source.deleteUserData(userId);
}
