import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:polyglot_admin/features/users/domain/entities/managed_user.dart';

/// Manual (de)serialization for the `users/{uid}` profile document — same
/// approach as the mobile app's models (defensive defaults + Timestamp coercion).
class ManagedUserModel {
  static DateTime? _toDate(dynamic v) {
    if (v is Timestamp) return v.toDate();
    if (v is DateTime) return v;
    return null;
  }

  static ManagedUser fromDoc(String id, Map<String, dynamic>? json) {
    final email = json?['email'] as String? ?? '';
    return ManagedUser(
      id: id,
      email: email,
      name: json?['name'] as String? ?? (email.contains('@') ? email.split('@').first : ''),
      createdAt: _toDate(json?['createdAt']),
      disabled: json?['disabled'] as bool? ?? false,
    );
  }
}

class UserStatsModel {
  static int _toInt(dynamic v, [int fallback = 0]) =>
      v is num ? v.toInt() : fallback;

  static UserStats fromJson(Map<String, dynamic>? json) {
    return UserStats(
      currentStreak: _toInt(json?['currentStreak']),
      longestStreak: _toInt(json?['longestStreak']),
      totalXp: _toInt(json?['totalXp']),
      lastActiveDate: json?['lastActiveDate'] as String?,
    );
  }
}
