import 'package:flutter/material.dart';
import 'package:polyglot_admin/core/theme/app_radius.dart';

/// Primary / destructive / default button, mirroring the mobile app's
/// `ActionButton`. Colour rides on the variant; disabled when [onTap] is null.
class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    this.icon,
    this.onTap,
    required this.variant,
    required this.child,
  });

  final IconData? icon;
  final Widget child;
  final VoidCallback? onTap;
  final ActionButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    final schema = Theme.of(context).colorScheme;
    final isDisabled = onTap == null;
    final (bgColor, borderColor, fgColor) = switch (variant) {
      ActionButtonVariant.primary => (
        schema.primaryContainer,
        schema.primary,
        schema.onPrimaryContainer,
      ),
      ActionButtonVariant.destructive => (
        schema.errorContainer,
        schema.error,
        schema.onErrorContainer,
      ),
      ActionButtonVariant.default_ => (
        schema.surface,
        schema.outlineVariant,
        schema.onSurface,
      ),
    };
    return Opacity(
      opacity: isDisabled ? 0.45 : 1,
      child: Material(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: Container(
            width: double.infinity,
            height: 52,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: borderColor, width: 0.8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 18, color: fgColor.withValues(alpha: .7)),
                  const SizedBox(width: 10),
                ],
                child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum ActionButtonVariant { default_, primary, destructive }
