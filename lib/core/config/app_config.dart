/// Static, compile-time configuration for the admin dashboard.
abstract class AppConfig {
  /// The Firebase project this dashboard manages (shared with the mobile app).
  static const String firebaseProjectId = 'parlo-ec41a';

  /// Base URL of the Parlo backend (FastAPI). Used for the health check.
  /// Override per environment: `--dart-define=API_BASE_URL=http://host:8000`.
  static const String backendBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8000',
  );

  /// Top-level Firestore collection names (kept in one place so the mobile app
  /// and dashboard never drift).
  static const String usersCollection = 'users';
  static const String adminsCollection = 'admins';
  static const String ratingsCollection = 'ratings';
  static const String complaintsCollection = 'complaints';
  static const String auditCollection = 'audit';
  static const String configCollection = 'config';
  static const String announcementsCollection = 'announcements';

  /// The single remote-config document id under `config`.
  static const String configDoc = 'app';

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
