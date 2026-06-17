import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:polyglot_admin/core/l10n/generated/translations.g.dart';
import 'package:polyglot_admin/core/theme/app_spacing.dart';
import 'package:polyglot_admin/core/ui/widgets/empty_state.dart';

/// Renders an [AsyncValue] with consistent loading / error / data handling so
/// every screen treats async state the same way. Pattern-matches with `when`,
/// exactly like the mobile screens do.
class AsyncValueView<T> extends StatelessWidget {
  const AsyncValueView({
    super.key,
    required this.value,
    required this.data,
    this.onRetry,
  });

  final AsyncValue<T> value;
  final Widget Function(T data) data;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    return value.when(
      data: data,
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: EmptyState(
          icon: Icons.error_outline_rounded,
          title: t.auth.somethingWrong,
          message: '$error',
          actionLabel: onRetry != null ? t.common.retry : null,
          onAction: onRetry,
        ),
      ),
    );
  }
}
