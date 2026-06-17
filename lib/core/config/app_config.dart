/// Static, compile-time configuration for the admin dashboard.
abstract class AppConfig {
  /// The Firebase project this dashboard manages (shared with the mobile app).
  static const String firebaseProjectId = 'parlo-ec41a';

  /// Top-level Firestore collection names (kept in one place so the mobile app
  /// and dashboard never drift).
  static const String usersCollection = 'users';
  static const String adminsCollection = 'admins';
  static const String ratingsCollection = 'ratings';
  static const String complaintsCollection = 'complaints';

  /// Per-user subcollections (under users/{uid}).
  static const String wordsSub = 'words';
  static const String sentencesSub = 'sentences';
  static const String videosSub = 'videos';
  static const String decksSub = 'decks';
  static const String statsSub = 'stats';
  static const String activitySub = 'activity';

  /// The single stats document id under users/{uid}/stats.
  static const String statsSummaryDoc = 'summary';
}
