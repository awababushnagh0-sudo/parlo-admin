import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_radius.dart';
import 'app_sizes.dart';

/// Snack bar types — each has its own color + icon
enum AppSnackBarType { success, error, warning, info }

/// A clean, pro-grade snack bar matching the mobile app. Static [show] — call
/// from anywhere.
class AppSnackBar {
  const AppSnackBar._();

  static void show(
    BuildContext context, {
    required String message,
    AppSnackBarType type = AppSnackBarType.success,
    SnackBarAction? action,
    Duration duration = const Duration(seconds: 3),
    EdgeInsets? margin,
  }) {
    ScaffoldMessenger.of(context).clearSnackBars();

    final finalMargin = margin ?? const EdgeInsets.fromLTRB(16, 0, 16, 24);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: _AppSnackBarContent(
          message: message,
          type: type,
          action: action,
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        duration: duration,
        padding: EdgeInsets.zero,
        margin: finalMargin,
        width: 420,
      ),
    );
  }
}

class _AppSnackBarContent extends StatelessWidget {
  const _AppSnackBarContent({
    required this.message,
    required this.type,
    this.action,
  });

  final String message;
  final AppSnackBarType type;
  final SnackBarAction? action;

  @override
  Widget build(BuildContext context) {
    final style = _AppSnackBarStyle.of(context, type);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: style.backgroundColor,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: style.backgroundColor.withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: style.iconBackgroundColor,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(style.icon, color: style.iconColor, size: AppSizes.iconSm),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: style.textColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 1.3,
              ),
            ),
          ),
          if (action != null) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: action!.onPressed,
              child: Text(
                action!.label,
                style: TextStyle(
                  color: style.actionColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _AppSnackBarStyle {
  const _AppSnackBarStyle({
    required this.backgroundColor,
    required this.textColor,
    required this.icon,
    required this.iconColor,
    required this.iconBackgroundColor,
    required this.actionColor,
  });

  final Color backgroundColor;
  final Color textColor;
  final IconData icon;
  final Color iconColor;
  final Color iconBackgroundColor;
  final Color actionColor;

  static _AppSnackBarStyle of(BuildContext context, AppSnackBarType type) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    switch (type) {
      case AppSnackBarType.success:
        return _AppSnackBarStyle(
          backgroundColor: AppColors.success,
          textColor: Colors.white,
          icon: Icons.check_rounded,
          iconColor: Colors.white,
          iconBackgroundColor: Colors.white.withValues(alpha: 0.2),
          actionColor: Colors.white,
        );
      case AppSnackBarType.error:
        return _AppSnackBarStyle(
          backgroundColor: AppColors.error,
          textColor: Colors.white,
          icon: Icons.error_outline_rounded,
          iconColor: Colors.white,
          iconBackgroundColor: Colors.white.withValues(alpha: 0.2),
          actionColor: Colors.white,
        );
      case AppSnackBarType.warning:
        return const _AppSnackBarStyle(
          backgroundColor: AppColors.warning,
          textColor: Colors.black87,
          icon: Icons.warning_amber_rounded,
          iconColor: Colors.black87,
          iconBackgroundColor: Colors.black12,
          actionColor: Colors.black,
        );
      case AppSnackBarType.info:
        return _AppSnackBarStyle(
          backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          textColor: isDark ? Colors.white : Colors.black87,
          icon: Icons.info_outline_rounded,
          iconColor: AppColors.info,
          iconBackgroundColor: AppColors.info.withValues(alpha: 0.1),
          actionColor: AppColors.info,
        );
    }
  }
}
