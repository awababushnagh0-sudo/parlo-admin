import 'package:flutter/material.dart';
import 'package:polyglot_admin/core/theme/app_radius.dart';
import 'package:polyglot_admin/core/theme/app_spacing.dart';

/// The single card surface used across the dashboard — one radius, one hairline
/// border, one tap affordance. Mirrors the mobile app's `AppCard`, and adds a
/// subtle hover lift on web/desktop when the card is tappable.
class AppCard extends StatefulWidget {
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
  State<AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final radius = BorderRadius.circular(AppRadius.lg);
    final background = widget.color ?? scheme.surface;
    final interactive = widget.onTap != null;
    final lifted = interactive && _hovered;

    return Padding(
      padding: widget.margin ?? EdgeInsets.zero,
      child: MouseRegion(
        cursor: interactive ? SystemMouseCursors.click : MouseCursor.defer,
        onEnter: interactive ? (_) => setState(() => _hovered = true) : null,
        onExit: interactive ? (_) => setState(() => _hovered = false) : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            borderRadius: radius,
            boxShadow: lifted
                ? [
                    BoxShadow(
                      color: scheme.shadow.withValues(alpha: 0.06),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : const [],
          ),
          child: Material(
            color: background,
            borderRadius: radius,
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: widget.onTap,
              borderRadius: radius,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeOut,
                padding: widget.padding,
                decoration: BoxDecoration(
                  borderRadius: radius,
                  border: widget.bordered
                      ? Border.all(
                          color: lifted
                              ? scheme.outline
                              : scheme.outlineVariant.withValues(alpha: 1),
                          width: lifted ? 0.9 : 0.6,
                        )
                      : null,
                ),
                child: widget.child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
