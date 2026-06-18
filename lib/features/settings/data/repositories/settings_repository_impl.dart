import 'package:polyglot_admin/features/settings/data/datasources/settings_firestore_data_source.dart';
import 'package:polyglot_admin/features/settings/domain/entities/announcement.dart';
import 'package:polyglot_admin/features/settings/domain/entities/app_remote_config.dart';
import 'package:polyglot_admin/features/settings/domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  const SettingsRepositoryImpl(this._source);

  final SettingsFirestoreDataSource _source;

  @override
  Stream<AppRemoteConfig> watchConfig() => _source.watchConfig();

  @override
  Future<void> saveConfig(AppRemoteConfig config) => _source.saveConfig(config);

  @override
  Stream<List<Announcement>> watchAnnouncements() =>
      _source.watchAnnouncements();

  @override
  Future<void> postAnnouncement({
    required String title,
    required String body,
    required bool active,
  }) =>
      _source.postAnnouncement(title: title, body: body, active: active);

  @override
  Future<void> setAnnouncementActive(String id, bool active) =>
      _source.setAnnouncementActive(id, active);

  @override
  Future<void> deleteAnnouncement(String id) =>
      _source.deleteAnnouncement(id);
}
