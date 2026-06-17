import 'package:equatable/equatable.dart';

/// What the rating is about.
enum RatingType {
  app('app'),
  word('word'),
  sentence('sentence'),
  video('video');

  const RatingType(this.key);
  final String key;

  static RatingType fromKey(String? key) => values.firstWhere(
    (r) => r.key == key,
    orElse: () => RatingType.app,
  );
}

/// A rating submitted from the mobile app (top-level `ratings` doc).
class Rating with EquatableMixin {
  final String id;
  final String userId;
  final String userEmail;
  final RatingType type;
  final String? targetId;
  final int stars; // 1..5
  final String? comment;
  final String? appVersion;
  final DateTime? createdAt;

  const Rating({
    required this.id,
    required this.userId,
    required this.userEmail,
    required this.type,
    this.targetId,
    required this.stars,
    this.comment,
    this.appVersion,
    this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    userEmail,
    type,
    targetId,
    stars,
    comment,
    appVersion,
    createdAt,
  ];
}
