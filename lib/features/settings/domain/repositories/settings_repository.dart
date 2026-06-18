import 'package:polyglot_admin/features/settings/domain/entities/announcement.dart';
import 'package:polyglot_admin/features/settings/domain/entities/app_remote_config.dart';

abstract class SettingsRepository {
  // Remote config
  Stream<AppRemoteConfig> watchConfig();
  Future<void> saveConfig(AppRemoteConfig config);

  // Announcements
  Stream<List<Announcement>> watchAnnouncements();
  Future<void> postAnnouncement({
    required String title,
    required String body,
    required bool active,
  });
  Future<void> setAnnouncementActive(String id, bool active);
  Future<void> deleteAnnouncement(String id);
}
