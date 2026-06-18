import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:polyglot_admin/features/audit/presentation/providers/audit_deps.dart';
import 'package:polyglot_admin/features/settings/data/providers.dart';
import 'package:polyglot_admin/features/settings/domain/entities/announcement.dart';
import 'package:polyglot_admin/features/settings/domain/entities/app_remote_config.dart';

abstract class SettingsDeps {
  SettingsDeps._();

  static final configStreamProvider = StreamProvider<AppRemoteConfig>((ref) {
    return ref.watch(settingsRepositoryProvider).watchConfig();
  });

  static final announcementsStreamProvider =
      StreamProvider<List<Announcement>>((ref) {
    return ref.watch(settingsRepositoryProvider).watchAnnouncements();
  });

  static final controllerProvider =
      NotifierProvider<SettingsController, AsyncValue<void>>(
        SettingsController.new,
      );
}

class SettingsController extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<bool> saveConfig(AppRemoteConfig config) async {
    final ok = await _run(
      () => ref.read(settingsRepositoryProvider).saveConfig(config),
    );
    if (ok) {
      await ref.read(AuditDeps.loggerProvider).log('config_update', targetType: 'config');
    }
    return ok;
  }

  Future<bool> postAnnouncement({
    required String title,
    required String body,
    required bool active,
  }) async {
    final ok = await _run(
      () => ref.read(settingsRepositoryProvider).postAnnouncement(
        title: title,
        body: body,
        active: active,
      ),
    );
    if (ok) {
      await ref
          .read(AuditDeps.loggerProvider)
          .log('announcement_post', targetType: 'announcement');
    }
    return ok;
  }

  Future<bool> setAnnouncementActive(String id, bool active) => _run(
        () => ref.read(settingsRepositoryProvider).setAnnouncementActive(id, active),
      );

  Future<bool> deleteAnnouncement(String id) async {
    final ok = await _run(
      () => ref.read(settingsRepositoryProvider).deleteAnnouncement(id),
    );
    if (ok) {
      await ref.read(AuditDeps.loggerProvider).log(
        'announcement_delete',
        targetType: 'announcement',
        targetId: id,
      );
    }
    return ok;
  }

  Future<bool> _run(Future<void> Function() action) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(action);
    return !state.hasError;
  }
}
