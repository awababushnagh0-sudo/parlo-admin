import 'package:equatable/equatable.dart';

/// One recorded admin action (the `audit` collection).
class AuditEntry with EquatableMixin {
  final String id;
  final String adminUid;
  final String adminEmail;

  /// Action key, e.g. `user_disable` — mapped to a label in the UI.
  final String action;
  final String? targetType;
  final String? targetId;
  final DateTime? createdAt;

  const AuditEntry({
    required this.id,
    required this.adminUid,
    required this.adminEmail,
    required this.action,
    this.targetType,
    this.targetId,
    this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    adminUid,
    adminEmail,
    action,
    targetType,
    targetId,
    createdAt,
  ];
}
