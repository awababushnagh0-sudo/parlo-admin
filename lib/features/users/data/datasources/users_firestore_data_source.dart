import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:polyglot_admin/core/config/app_config.dart';
import 'package:polyglot_admin/features/users/data/models/managed_user_model.dart';
import 'package:polyglot_admin/features/users/domain/entities/managed_user.dart';

/// Talks to the `users` collection and its subcollections. Admin reads/writes
/// are permitted by the `isAdmin()` Firestore rule.
class UsersFirestoreDataSource {
  UsersFirestoreDataSource(this._db);

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> get _users =>
      _db.collection(AppConfig.usersCollection);

  /// Realtime users list. Sorted client-side by join date (descending) so that
  /// legacy documents missing `createdAt` aren't dropped by a server orderBy.
  Stream<List<ManagedUser>> watchUsers() {
    return _users.snapshots().map((snapshot) {
      final users = snapshot.docs
          .map((doc) => ManagedUserModel.fromDoc(doc.id, doc.data()))
          .toList();
      users.sort((a, b) {
        final ad = a.createdAt;
        final bd = b.createdAt;
        if (ad == null && bd == null) return a.email.compareTo(b.email);
        if (ad == null) return 1;
        if (bd == null) return -1;
        return bd.compareTo(ad);
      });
      return users;
    });
  }

  Future<UserStats?> getStats(String userId) async {
    final snap = await _users
        .doc(userId)
        .collection(AppConfig.statsSub)
        .doc(AppConfig.statsSummaryDoc)
        .get();
    if (!snap.exists) return null;
    return UserStatsModel.fromJson(snap.data());
  }

  Future<UserContentCounts> getContentCounts(String userId) async {
    final userRef = _users.doc(userId);
    final results = await Future.wait([
      _count(userRef.collection(AppConfig.wordsSub)),
      _count(userRef.collection(AppConfig.sentencesSub)),
      _count(userRef.collection(AppConfig.videosSub)),
      _count(userRef.collection(AppConfig.decksSub)),
    ]);
    return UserContentCounts(
      words: results[0],
      sentences: results[1],
      videos: results[2],
      decks: results[3],
    );
  }

  Future<int> _count(CollectionReference<Map<String, dynamic>> ref) async {
    final agg = await ref.count().get();
    return agg.count ?? 0;
  }

  Future<void> updateName(String userId, String name) {
    return _users.doc(userId).set({'name': name}, SetOptions(merge: true));
  }

  Future<void> setDisabled(String userId, bool disabled) {
    return _users.doc(userId).set(
      {'disabled': disabled},
      SetOptions(merge: true),
    );
  }

  /// Deletes every subcollection then the profile doc. The Firebase Auth
  /// account itself is not removed (that requires the Admin SDK).
  Future<void> deleteUserData(String userId) async {
    final userRef = _users.doc(userId);

    for (final sub in const [
      AppConfig.wordsSub,
      AppConfig.sentencesSub,
      AppConfig.videosSub,
      AppConfig.statsSub,
      AppConfig.activitySub,
    ]) {
      await _deleteCollection(userRef.collection(sub));
    }

    // Decks carry a nested `cards` subcollection — clear it before the deck doc.
    final decks = await userRef.collection(AppConfig.decksSub).get();
    for (final deck in decks.docs) {
      await _deleteCollection(deck.reference.collection('cards'));
      await deck.reference.delete();
    }

    await userRef.delete();
  }

  Future<void> _deleteCollection(
    CollectionReference<Map<String, dynamic>> ref,
  ) async {
    const pageSize = 300;
    while (true) {
      final snap = await ref.limit(pageSize).get();
      if (snap.docs.isEmpty) break;
      final batch = _db.batch();
      for (final doc in snap.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
      if (snap.docs.length < pageSize) break;
    }
  }
}
