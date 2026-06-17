import 'package:equatable/equatable.dart';

/// What the user is reporting about.
enum ComplaintCategory {
  bug('bug'),
  wrongTranslation('wrong_translation'),
  offensive('offensive'),
  other('other');

  const ComplaintCategory(this.key);
  final String key;

  static ComplaintCategory fromKey(String? key) => values.firstWhere(
    (c) => c.key == key,
    orElse: () => ComplaintCategory.other,
  );
}

/// The kind of item the complaint targets.
enum ComplaintTargetType {
  app('app'),
  word('word'),
  sentence('sentence'),
  video('video');

  const ComplaintTargetType(this.key);
  final String key;

  static ComplaintTargetType fromKey(String? key) => values.firstWhere(
    (t) => t.key == key,
    orElse: () => ComplaintTargetType.app,
  );
}

/// Moderation lifecycle.
enum ComplaintStatus {
  open('open'),
  resolved('resolved'),
  dismissed('dismissed');

  const ComplaintStatus(this.key);
  final String key;

  static ComplaintStatus fromKey(String? key) => values.firstWhere(
    (s) => s.key == key,
    orElse: () => ComplaintStatus.open,
  );
}

/// A problem report submitted from the mobile app (top-level `complaints` doc).
class Complaint with EquatableMixin {
  final String id;
  final String userId;
  final String userEmail;
  final ComplaintCategory category;
  final ComplaintTargetType targetType;
  final String? targetId;
  final String message;
  final ComplaintStatus status;
  final String? adminNote;
  final DateTime? createdAt;
  final DateTime? resolvedAt;

  const Complaint({
    required this.id,
    required this.userId,
    required this.userEmail,
    required this.category,
    required this.targetType,
    this.targetId,
    required this.message,
    required this.status,
    this.adminNote,
    this.createdAt,
    this.resolvedAt,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    userEmail,
    category,
    targetType,
    targetId,
    message,
    status,
    adminNote,
    createdAt,
    resolvedAt,
  ];
}
