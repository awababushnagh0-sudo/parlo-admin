import 'package:flutter/material.dart';
import 'package:polyglot_admin/core/theme/app_radius.dart';
import 'package:polyglot_admin/core/theme/app_spacing.dart';

/// The single card surface used across the dashboard — one radius, one hairline
/// border, one tap affordance. Mirrors the mobile app's `AppCard`.
///
/// Pass [onTap] to make it pressable (ripple only appears when tappable).
/// Pass [color] for an emphasized/filled card; [bordered] = false drops the
/// hairline border (used by filled cards).
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(AppSpacing.md),
    this.margin,
    this.color,
    this.bordered = true,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final bool bordered;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final radius = BorderRadius.circular(AppRadius.lg);
    final background = color ?? scheme.surface;

    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: Material(
        color: background,
        borderRadius: radius,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              borderRadius: radius,
              border: bordered
                  ? Border.all(
                      color: scheme.outlineVariant.withValues(alpha: 1),
                      width: 0.6,
                    )
                  : null,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
