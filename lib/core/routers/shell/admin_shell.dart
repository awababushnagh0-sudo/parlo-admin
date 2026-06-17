import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:polyglot_admin/core/l10n/generated/translations.g.dart';
import 'package:polyglot_admin/core/providers/app_theme_deps.dart';
import 'package:polyglot_admin/core/theme/app_colors.dart';
import 'package:polyglot_admin/core/theme/app_radius.dart';
import 'package:polyglot_admin/core/theme/app_spacing.dart';
import 'package:polyglot_admin/core/ui/format.dart';
import 'package:polyglot_admin/features/auth/presentation/providers/auth_deps.dart';

class _NavItem {
  const _NavItem({
    required this.path,
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });
  final String path;
  final IconData icon;
  final IconData selectedIcon;
  final String Function(Translations t) label;
}

final _navItems = <_NavItem>[
  _NavItem(
    path: '/',
    icon: Icons.dashboard_outlined,
    selectedIcon: Icons.dashboard_rounded,
    label: (t) => t.nav.dashboard,
  ),
  _NavItem(
    path: '/users',
    icon: Icons.people_outline_rounded,
    selectedIcon: Icons.people_rounded,
    label: (t) => t.nav.users,
  ),
  _NavItem(
    path: '/complaints',
    icon: Icons.report_gmailerrorred_outlined,
    selectedIcon: Icons.report_rounded,
    label: (t) => t.nav.complaints,
  ),
  _NavItem(
    path: '/ratings',
    icon: Icons.star_outline_rounded,
    selectedIcon: Icons.star_rounded,
    label: (t) => t.nav.ratings,
  ),
];

/// Persistent app shell: a custom left sidebar (brand → nav tiles → admin chip)
/// plus the content surface. Mirrors the mobile `MainShell`'s location-aware
/// highlighting but is purpose-built for a web/desktop console.
class AdminShell extends ConsumerWidget {
  const AdminShell({super.key, required this.child});

  final Widget child;

  int _activeIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    var best = 0;
    var bestLen = -1;
    for (var i = 0; i < _navItems.length; i++) {
      final path = _navItems[i].path;
      final matches = path == '/'
          ? location == '/'
          : location == path || location.startsWith('$path/');
      if (matches && path.length > bestLen) {
        best = i;
        bestLen = path.length;
      }
    }
    return best;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final extended = width >= 1100;
    final selectedIndex = _activeIndex(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Row(
        children: [
          _Sidebar(
            extended: extended,
            selectedIndex: selectedIndex,
            onSelect: (i) => context.go(_navItems[i].path),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1280),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl,
                    vertical: AppSpacing.lg,
                  ),
                  child: child,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Sidebar extends ConsumerWidget {
  const _Sidebar({
    required this.extended,
    required this.selectedIndex,
    required this.onSelect,
  });

  final bool extended;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final adminEmail = ref.watch(AuthDeps.currentAdminProvider).value?.email;
    final pad = extended ? AppSpacing.md : AppSpacing.sm;

    return Container(
      width: extended ? 256 : 76,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          right: BorderSide(color: theme.colorScheme.outlineVariant, width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Brand
          Padding(
            padding: EdgeInsets.fromLTRB(pad, AppSpacing.lg, pad, AppSpacing.md),
            child: Row(
              mainAxisAlignment:
                  extended ? MainAxisAlignment.start : MainAxisAlignment.center,
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: const Icon(
                    Icons.shield_rounded,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                if (extended) ...[
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      t.app.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          // Nav tiles
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: pad),
              children: [
                for (var i = 0; i < _navItems.length; i++)
                  _NavTile(
                    item: _navItems[i],
                    label: _navItems[i].label(t),
                    selected: i == selectedIndex,
                    extended: extended,
                    onTap: () => onSelect(i),
                  ),
              ],
            ),
          ),
          Divider(height: 1, color: theme.colorScheme.outlineVariant),
          // Footer: admin chip + theme toggle + sign out
          Padding(
            padding: EdgeInsets.all(pad),
            child: extended
                ? _FooterExtended(email: adminEmail)
                : const _FooterCollapsed(),
          ),
        ],
      ),
    );
  }
}

class _NavTile extends StatefulWidget {
  const _NavTile({
    required this.item,
    required this.label,
    required this.selected,
    required this.extended,
    required this.onTap,
  });

  final _NavItem item;
  final String label;
  final bool selected;
  final bool extended;
  final VoidCallback onTap;

  @override
  State<_NavTile> createState() => _NavTileState();
}

class _NavTileState extends State<_NavTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selected = widget.selected;
    final Color bg = selected
        ? AppColors.primary.withValues(alpha: 0.12)
        : _hovered
        ? theme.colorScheme.onSurface.withValues(alpha: 0.04)
        : Colors.transparent;
    final Color fg = selected
        ? AppColors.primary
        : theme.colorScheme.onSurfaceVariant;

    final content = Row(
      mainAxisAlignment:
          widget.extended ? MainAxisAlignment.start : MainAxisAlignment.center,
      children: [
        Icon(selected ? widget.item.selectedIcon : widget.item.icon, size: 20, color: fg),
        if (widget.extended) ...[
          const SizedBox(width: AppSpacing.sm + 2),
          Expanded(
            child: Text(
              widget.label,
              style: theme.textTheme.labelLarge?.copyWith(
                color: selected ? AppColors.primary : theme.colorScheme.onSurface,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ],
    );

    final tile = Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          behavior: HitTestBehavior.opaque,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            curve: Curves.easeOut,
            height: 42,
            padding: EdgeInsets.symmetric(
              horizontal: widget.extended ? AppSpacing.sm + 2 : 0,
            ),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: content,
          ),
        ),
      ),
    );

    return widget.extended
        ? tile
        : Tooltip(message: widget.label, child: tile);
  }
}

class _FooterExtended extends ConsumerWidget {
  const _FooterExtended({this.email});

  final String? email;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primary.withValues(alpha: 0.14),
              child: Text(
                email == null ? '?' : Format.initials(email!),
                style: theme.textTheme.labelMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                email ?? '—',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () =>
                    ref.read(AuthDeps.authControllerProvider.notifier).signOut(),
                icon: const Icon(Icons.logout_rounded, size: 16),
                label: Text(t.nav.signOut),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  textStyle: theme.textTheme.labelMedium,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            IconButton(
              tooltip: t.nav.toggleTheme,
              onPressed: () => ref.read(themeProvider.notifier).toggle(),
              icon: const Icon(Icons.brightness_6_outlined, size: 20),
            ),
          ],
        ),
      ],
    );
  }
}

class _FooterCollapsed extends ConsumerWidget {
  const _FooterCollapsed();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    return Column(
      children: [
        IconButton(
          tooltip: t.nav.toggleTheme,
          onPressed: () => ref.read(themeProvider.notifier).toggle(),
          icon: const Icon(Icons.brightness_6_outlined),
        ),
        IconButton(
          tooltip: t.nav.signOut,
          onPressed: () =>
              ref.read(AuthDeps.authControllerProvider.notifier).signOut(),
          icon: const Icon(Icons.logout_rounded),
        ),
      ],
    );
  }
}
