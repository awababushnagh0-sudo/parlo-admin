import 'package:equatable/equatable.dart';

/// A Parlo end-user as seen by the admin (the `users/{uid}` profile document).
class ManagedUser with EquatableMixin {
  final String id;
  final String email;
  final String name;
  final DateTime? createdAt;
  final bool disabled;

  const ManagedUser({
    required this.id,
    required this.email,
    required this.name,
    this.createdAt,
    this.disabled = false,
  });

  @override
  List<Object?> get props => [id, email, name, createdAt, disabled];
}

/// Streak / XP summary for a user (users/{uid}/stats/summary).
class UserStats with EquatableMixin {
  final int currentStreak;
  final int longestStreak;
  final int totalXp;
  final String? lastActiveDate; // "yyyy-MM-dd" local

  const UserStats({
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.totalXp = 0,
    this.lastActiveDate,
  });

  static const empty = UserStats();

  @override
  List<Object?> get props => [
    currentStreak,
    longestStreak,
    totalXp,
    lastActiveDate,
  ];
}

/// Counts of a user's saved content (via Firestore count aggregations).
class UserContentCounts with EquatableMixin {
  final int words;
  final int sentences;
  final int videos;
  final int decks;

  const UserContentCounts({
    this.words = 0,
    this.sentences = 0,
    this.videos = 0,
    this.decks = 0,
  });

  @override
  List<Object?> get props => [words, sentences, videos, decks];
}
