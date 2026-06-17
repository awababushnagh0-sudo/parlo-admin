import 'package:flutter/material.dart';
import 'package:polyglot_admin/core/theme/app_colors.dart';

/// A row of 5 stars showing [value] filled stars.
class StarRow extends StatelessWidget {
  const StarRow({super.key, required this.value, this.size = 16});

  final int value;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 1; i <= 5; i++)
          Icon(
            i <= value ? Icons.star_rounded : Icons.star_outline_rounded,
            size: size,
            color: i <= value
                ? AppColors.warning
                : Theme.of(context).colorScheme.onSurfaceVariant
                      .withValues(alpha: .5),
          ),
      ],
    );
  }
}
