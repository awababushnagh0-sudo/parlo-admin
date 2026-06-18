import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:polyglot_admin/core/config/app_config.dart';
import 'package:polyglot_admin/features/settings/domain/entities/announcement.dart';
import 'package:polyglot_admin/features/settings/domain/entities/app_remote_config.dart';

class SettingsFirestoreDataSource {
  SettingsFirestoreDataSource(this._db);

  final FirebaseFirestore _db;

  DocumentReference<Map<String, dynamic>> get _configDoc => _db
      .collection(AppConfig.configCollection)
      .doc(AppConfig.configDoc);

  CollectionReference<Map<String, dynamic>> get _announcements =>
      _db.collection(AppConfig.announcementsCollection);

  static DateTime? _toDate(dynamic v) {
    if (v is Timestamp) return v.toDate();
    if (v is DateTime) return v;
    return null;
  }

  // ── Remote config ────────────────────────────────────────────────────────
  Stream<AppRemoteConfig> watchConfig() {
    return _configDoc.snapshots().map((snap) {
      final data = snap.data();
      if (data == null) return AppRemoteConfig.empty;
      return AppRemoteConfig(
        maintenanceMode: data['maintenanceMode'] as bool? ?? false,
        dailyGoalDefault: (data['dailyGoalDefault'] as num?)?.toInt() ?? 10,
        minAppVersion: data['minAppVersion'] as String? ?? '',
      );
    });
  }

  Future<void> saveConfig(AppRemoteConfig config) {
    return _configDoc.set({
      'maintenanceMode': config.maintenanceMode,
      'dailyGoalDefault': config.dailyGoalDefault,
      'minAppVersion': config.minAppVersion,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  // ── Announcements ────────────────────────────────────────────────────────
  Stream<List<Announcement>> watchAnnouncements() {
    return _announcements.snapshots().map((snap) {
      final items = snap.docs
          .map(
            (d) => Announcement(
              id: d.id,
              title: d.data()['title'] as String? ?? '',
              body: d.data()['body'] as String? ?? '',
              active: d.data()['active'] as bool? ?? false,
              createdAt: _toDate(d.data()['createdAt']),
            ),
          )
          .toList();
      items.sort((a, b) {
        final ad = a.createdAt;
        final bd = b.createdAt;
        if (ad == null && bd == null) return 0;
        if (ad == null) return 1;
        if (bd == null) return -1;
        return bd.compareTo(ad);
      });
      return items;
    });
  }

  Future<void> postAnnouncement({
    required String title,
    required String body,
    required bool active,
  }) {
    return _announcements.add({
      'title': title,
      'body': body,
      'active': active,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> setAnnouncementActive(String id, bool active) {
    return _announcements.doc(id).set({'active': active}, SetOptions(merge: true));
  }

  Future<void> deleteAnnouncement(String id) => _announcements.doc(id).delete();
}
