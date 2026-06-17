import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:polyglot_admin/features/ratings/domain/entities/rating.dart';

/// Manual (de)serialization for `ratings/{id}` documents.
class RatingModel {
  static DateTime? _toDate(dynamic v) {
    if (v is Timestamp) return v.toDate();
    if (v is DateTime) return v;
    return null;
  }

  static int _toInt(dynamic v, [int fallback = 0]) =>
      v is num ? v.toInt() : fallback;

  static Rating fromDoc(String id, Map<String, dynamic>? json) {
    return Rating(
      id: id,
      userId: json?['userId'] as String? ?? '',
      userEmail: json?['userEmail'] as String? ?? '',
      type: RatingType.fromKey(json?['type'] as String?),
      targetId: json?['targetId'] as String?,
      stars: _toInt(json?['stars']).clamp(0, 5),
      comment: json?['comment'] as String?,
      appVersion: json?['appVersion'] as String?,
      createdAt: _toDate(json?['createdAt']),
    );
  }
}
