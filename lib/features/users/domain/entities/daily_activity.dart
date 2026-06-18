import 'package:equatable/equatable.dart';

/// One day of a user's activity (users/{uid}/activity/{yyyy-MM-dd}).
class DailyActivity with EquatableMixin {
  final String date; // "yyyy-MM-dd"
  final int reviews;
  final int wordsSaved;
  final int xp;
  final int secondsStudied;

  const DailyActivity({
    required this.date,
    this.reviews = 0,
    this.wordsSaved = 0,
    this.xp = 0,
    this.secondsStudied = 0,
  });

  /// Total "touches" for the day — used to colour the heatmap.
  int get total => reviews + wordsSaved;

  @override
  List<Object?> get props => [date, reviews, wordsSaved, xp, secondsStudied];
}
