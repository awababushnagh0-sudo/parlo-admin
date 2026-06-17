import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:polyglot_admin/core/config/app_config.dart';
import 'package:polyglot_admin/features/ratings/data/models/rating_model.dart';
import 'package:polyglot_admin/features/ratings/domain/entities/rating.dart';

class RatingsFirestoreDataSource {
  RatingsFirestoreDataSource(this._db);

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> get _ratings =>
      _db.collection(AppConfig.ratingsCollection);

  Stream<List<Rating>> watchRatings() {
    return _ratings.snapshots().map((snapshot) {
      final items = snapshot.docs
          .map((doc) => RatingModel.fromDoc(doc.id, doc.data()))
          .toList();
      items.sort((a, b) {
        final ad = a.createdAt;
        final bd = b.createdAt;
        if (ad == null && bd == null) return 0;
        if (ad == null) return 1;
        if (bd == null) return -1;
        return bd.compareTo(ad);
      });
      return items;
    });
  }
}
