import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:polyglot_admin/core/config/app_config.dart';
import 'package:polyglot_admin/features/complaints/data/models/complaint_model.dart';
import 'package:polyglot_admin/features/complaints/domain/entities/complaint.dart';

class ComplaintsFirestoreDataSource {
  ComplaintsFirestoreDataSource(this._db);

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> get _complaints =>
      _db.collection(AppConfig.complaintsCollection);

  Stream<List<Complaint>> watchComplaints({ComplaintStatus? status}) {
    Query<Map<String, dynamic>> query = _complaints;
    if (status != null) {
      query = query.where('status', isEqualTo: status.key);
    }
    return query.snapshots().map((snapshot) {
      final items = snapshot.docs
          .map((doc) => ComplaintModel.fromDoc(doc.id, doc.data()))
          .toList();
      // Newest first; client-side so docs missing `createdAt` aren't dropped.
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

  Future<void> updateStatus(
    String id,
    ComplaintStatus status, {
    String? adminNote,
  }) {
    final data = <String, dynamic>{
      'status': status.key,
      'resolvedAt': status == ComplaintStatus.open
          ? null
          : FieldValue.serverTimestamp(),
    };
    if (adminNote != null) data['adminNote'] = adminNote;
    return _complaints.doc(id).set(data, SetOptions(merge: true));
  }
}
