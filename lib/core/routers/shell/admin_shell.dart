import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:polyglot_admin/core/l10n/generated/translations.g.dart';
import 'package:polyglot_admin/core/providers/app_theme_deps.dart';
import 'package:polyglot_admin/core/theme/app_colors.dart';
import 'package:polyglot_admin/core/theme/app_spacing.dart';
import 'package:polyglot_admin/features/auth/presentation/providers/auth_deps.dart';

/// A navigation destination in the dashboard sidebar.
class _NavItem {
  const _NavItem({required this.path, required this.icon, required this.label});
  final String path;
  final IconData icon;
  final String Function(Translations t) label;
}

final _navItems = <_NavItem>[
  _NavItem(path: '/', icon: Icons.dashboard_outlined, label: (t) => t.nav.dashboard),
  _NavItem(path: '/users', icon: Icons.people_outline_rounded, label: (t) => t.nav.users),
  _NavItem(
    path: '/complaints',
    icon: Icons.report_gmailerrorred_outlined,
    label: (t) => t.nav.complaints,
  ),
  _NavItem(path: '/ratings', icon: Icons.star_outline_rounded, label: (t) => t.nav.ratings),
];

/// Persistent sidebar shell that wraps every authenticated dashboard screen.
/// Mirrors the mobile `MainShell` (location-aware tab highlighting) but uses a
/// left [NavigationRail] for the web/desktop layout.
class AdminShell extends ConsumerWidget {
  const AdminShell({super.key, required this.child});

  final Widget child;

  int _activeIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    // Longest-prefix match so /users/:id keeps the Users tab active.
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
    final t = Translations.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final extended = width >= 1100;
    final selectedIndex = _activeIndex(context);

    return Scaffold(
      body: Row(
        children: [
          _Sidebar(
            extended: extended,
            selectedIndex: selectedIndex,
            onSelect: (i) => context.go(_navItems[i].path),
            t: t,
          ),
          const VerticalDivider(width: 1, thickness: 1),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: child,
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
    required this.t,
  });

  final bool extended;
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final Translations t;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final adminEmail = ref.watch(AuthDeps.currentAdminProvider).valueOrNull?.email;

    return SizedBox(
      width: extended ? 248 : 80,
      child: Column(
        children: [
          // Brand header
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.lg,
              AppSpacing.md,
              AppSpacing.md,
            ),
            child: Row(
              mainAxisAlignment:
                  extended ? MainAxisAlignment.start : MainAxisAlignment.center,
              children: [
                const Icon(Icons.shield_rounded, color: AppColors.primary, size: 28),
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
          // Destinations
          Expanded(
            child: NavigationRail(
              extended: extended,
              minWidth: 80,
              minExtendedWidth: 248,
              backgroundColor: Colors.transparent,
              selectedIndex: selectedIndex,
              onDestinationSelected: onSelect,
              labelType: extended
                  ? NavigationRailLabelType.none
                  : NavigationRailLabelType.all,
              destinations: [
                for (final item in _navItems)
                  NavigationRailDestination(
                    icon: Icon(item.icon),
                    label: Text(item.label(t)),
                  ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Footer: theme toggle + admin identity + sign out
          Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: Column(
              children: [
                IconButton(
                  tooltip: t.nav.toggleTheme,
                  onPressed: () => ref.read(themeProvider.notifier).toggle(),
                  icon: const Icon(Icons.brightness_6_outlined),
                ),
                if (extended && adminEmail != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                    child: Text(
                      adminEmail,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                const SizedBox(height: AppSpacing.xs),
                if (extended)
                  TextButton.icon(
                    onPressed: () =>
                        ref.read(AuthDeps.authControllerProvider.notifier).signOut(),
                    icon: const Icon(Icons.logout_rounded, size: 18),
                    label: Text(t.nav.signOut),
                  )
                else
                  IconButton(
                    tooltip: t.nav.signOut,
                    onPressed: () =>
                        ref.read(AuthDeps.authControllerProvider.notifier).signOut(),
                    icon: const Icon(Icons.logout_rounded),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
