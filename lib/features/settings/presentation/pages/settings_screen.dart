import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:polyglot_admin/core/l10n/generated/translations.g.dart';
import 'package:polyglot_admin/core/theme/app_colors.dart';
import 'package:polyglot_admin/core/theme/app_spacing.dart';
import 'package:polyglot_admin/core/theme/app_snack_bar.dart';
import 'package:polyglot_admin/core/ui/format.dart';
import 'package:polyglot_admin/core/ui/widgets/app_card.dart';
import 'package:polyglot_admin/core/ui/widgets/async_value_view.dart';
import 'package:polyglot_admin/core/ui/widgets/confirm_dialog.dart';
import 'package:polyglot_admin/core/ui/widgets/empty_state.dart';
import 'package:polyglot_admin/core/ui/widgets/page_header.dart';
import 'package:polyglot_admin/core/ui/widgets/status_badge.dart';
import 'package:polyglot_admin/features/audit/presentation/pages/audit_log_view.dart';
import 'package:polyglot_admin/features/settings/domain/entities/announcement.dart';
import 'package:polyglot_admin/features/settings/domain/entities/app_remote_config.dart';
import 'package:polyglot_admin/features/settings/presentation/providers/settings_deps.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    return DefaultTabController(
      length: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PageHeader(title: t.nav.settings),
          TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: [
              Tab(text: t.settings.remoteConfig),
              Tab(text: t.settings.announcements),
              Tab(text: t.settings.auditLog),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          const Expanded(
            child: TabBarView(
              children: [
                _RemoteConfigTab(),
                _AnnouncementsTab(),
                AuditLogView(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Remote config ───────────────────────────────────────────────────────────
class _RemoteConfigTab extends ConsumerStatefulWidget {
  const _RemoteConfigTab();

  @override
  ConsumerState<_RemoteConfigTab> createState() => _RemoteConfigTabState();
}

class _RemoteConfigTabState extends ConsumerState<_RemoteConfigTab> {
  bool _seeded = false;
  bool _maintenance = false;
  final _goalController = TextEditingController();
  final _versionController = TextEditingController();

  @override
  void dispose() {
    _goalController.dispose();
    _versionController.dispose();
    super.dispose();
  }

  void _seed(AppRemoteConfig c) {
    _maintenance = c.maintenanceMode;
    _goalController.text = '${c.dailyGoalDefault}';
    _versionController.text = c.minAppVersion;
    _seeded = true;
  }

  Future<void> _save() async {
    final t = Translations.of(context);
    final config = AppRemoteConfig(
      maintenanceMode: _maintenance,
      dailyGoalDefault: int.tryParse(_goalController.text.trim()) ?? 10,
      minAppVersion: _versionController.text.trim(),
    );
    final ok = await ref
        .read(SettingsDeps.controllerProvider.notifier)
        .saveConfig(config);
    if (!mounted) return;
    AppSnackBar.show(
      context,
      message: ok ? t.settings.saved : t.auth.somethingWrong,
      type: ok ? AppSnackBarType.success : AppSnackBarType.error,
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final configAsync = ref.watch(SettingsDeps.configStreamProvider);
    final busy = ref.watch(SettingsDeps.controllerProvider).isLoading;

    return AsyncValueView(
      value: configAsync,
      data: (config) {
        if (!_seeded) _seed(config);
        return ListView(
          children: [
            Text(
              t.settings.remoteConfigDesc,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppCard(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    value: _maintenance,
                    onChanged: (v) => setState(() => _maintenance = v),
                    title: Text(t.settings.maintenanceMode),
                    subtitle: Text(t.settings.maintenanceModeDesc),
                  ),
                  const Divider(),
                  const SizedBox(height: AppSpacing.sm),
                  TextField(
                    controller: _goalController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: t.settings.dailyGoalDefault),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextField(
                    controller: _versionController,
                    decoration: InputDecoration(
                      labelText: t.settings.minAppVersion,
                      hintText: '1.0.0',
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FilledButton.icon(
                      onPressed: busy ? null : _save,
                      icon: const Icon(Icons.save_outlined, size: 18),
                      label: Text(t.common.save),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

// ── Announcements ─────────────────────────────────────────────────────────--
class _AnnouncementsTab extends ConsumerWidget {
  const _AnnouncementsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final announcements = ref.watch(SettingsDeps.announcementsStreamProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: FilledButton.icon(
            onPressed: () => _showPostDialog(context, ref),
            icon: const Icon(Icons.campaign_outlined, size: 18),
            label: Text(t.settings.post),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Expanded(
          child: AsyncValueView(
            value: announcements,
            data: (list) {
              if (list.isEmpty) {
                return EmptyState(
                  icon: Icons.campaign_outlined,
                  title: t.settings.noAnnouncements,
                );
              }
              return ListView.separated(
                itemCount: list.length,
                separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
                itemBuilder: (context, i) =>
                    _AnnouncementCard(announcement: list[i]),
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _showPostDialog(BuildContext context, WidgetRef ref) async {
    final t = Translations.of(context);
    final titleController = TextEditingController();
    final bodyController = TextEditingController();
    var active = true;
    final posted = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(t.settings.post),
          content: SizedBox(
            width: 460,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  autofocus: true,
                  decoration: InputDecoration(labelText: t.settings.announcementTitle),
                ),
                const SizedBox(height: AppSpacing.md),
                TextField(
                  controller: bodyController,
                  maxLines: 3,
                  decoration: InputDecoration(labelText: t.settings.announcementBody),
                ),
                const SizedBox(height: AppSpacing.sm),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: active,
                  onChanged: (v) => setState(() => active = v),
                  title: Text(t.settings.active),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(t.common.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(t.settings.post),
            ),
          ],
        ),
      ),
    );
    if (posted != true) return;
    if (titleController.text.trim().isEmpty) return;
    final ok = await ref
        .read(SettingsDeps.controllerProvider.notifier)
        .postAnnouncement(
          title: titleController.text.trim(),
          body: bodyController.text.trim(),
          active: active,
        );
    if (!context.mounted) return;
    AppSnackBar.show(
      context,
      message: ok ? t.settings.posted : t.auth.somethingWrong,
      type: ok ? AppSnackBarType.success : AppSnackBarType.error,
    );
  }
}

class _AnnouncementCard extends ConsumerWidget {
  const _AnnouncementCard({required this.announcement});

  final Announcement announcement;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        announcement.title,
                        style: theme.textTheme.titleSmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    if (announcement.active)
                      StatusBadge(label: t.settings.active, color: AppColors.success),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  announcement.body,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  Format.date(announcement.createdAt),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: announcement.active,
            onChanged: (v) => ref
                .read(SettingsDeps.controllerProvider.notifier)
                .setAnnouncementActive(announcement.id, v),
          ),
          IconButton(
            tooltip: t.common.delete,
            icon: const Icon(Icons.delete_outline_rounded, size: 20),
            color: AppColors.error,
            onPressed: () async {
              final confirmed = await showConfirmDialog(
                context,
                title: t.settings.deleteAnnouncement,
                message: announcement.title,
                confirmLabel: t.common.delete,
                destructive: true,
              );
              if (!confirmed) return;
              await ref
                  .read(SettingsDeps.controllerProvider.notifier)
                  .deleteAnnouncement(announcement.id);
            },
          ),
        ],
      ),
    );
  }
}
