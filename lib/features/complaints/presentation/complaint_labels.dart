import 'package:flutter/material.dart';
import 'package:polyglot_admin/core/l10n/generated/translations.g.dart';
import 'package:polyglot_admin/core/theme/app_colors.dart';
import 'package:polyglot_admin/features/complaints/domain/entities/complaint.dart';

/// Localized labels + theming for complaint enums, kept in one place so the
/// list, filter and detail render them identically.
extension ComplaintStatusX on ComplaintStatus {
  String label(Translations t) => switch (this) {
    ComplaintStatus.open => t.complaints.status_open,
    ComplaintStatus.resolved => t.complaints.status_resolved,
    ComplaintStatus.dismissed => t.complaints.status_dismissed,
  };

  Color get color => switch (this) {
    ComplaintStatus.open => AppColors.warning,
    ComplaintStatus.resolved => AppColors.success,
    ComplaintStatus.dismissed => AppColors.onSurfaceVariantLight,
  };

  IconData get icon => switch (this) {
    ComplaintStatus.open => Icons.error_outline_rounded,
    ComplaintStatus.resolved => Icons.check_circle_outline_rounded,
    ComplaintStatus.dismissed => Icons.cancel_outlined,
  };
}

extension ComplaintCategoryX on ComplaintCategory {
  String label(Translations t) => switch (this) {
    ComplaintCategory.bug => t.complaints.category_bug,
    ComplaintCategory.wrongTranslation => t.complaints.category_wrong_translation,
    ComplaintCategory.offensive => t.complaints.category_offensive,
    ComplaintCategory.other => t.complaints.category_other,
  };
}

extension ComplaintTargetTypeX on ComplaintTargetType {
  String label(Translations t) => switch (this) {
    ComplaintTargetType.app => t.complaints.target_app,
    ComplaintTargetType.word => t.complaints.target_word,
    ComplaintTargetType.sentence => t.complaints.target_sentence,
    ComplaintTargetType.video => t.complaints.target_video,
  };
}
