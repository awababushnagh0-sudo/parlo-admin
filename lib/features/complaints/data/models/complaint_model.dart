import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:polyglot_admin/features/complaints/domain/entities/complaint.dart';

/// Manual (de)serialization for `complaints/{id}` documents.
class ComplaintModel {
  static DateTime? _toDate(dynamic v) {
    if (v is Timestamp) return v.toDate();
    if (v is DateTime) return v;
    return null;
  }

  static Complaint fromDoc(String id, Map<String, dynamic>? json) {
    return Complaint(
      id: id,
      userId: json?['userId'] as String? ?? '',
      userEmail: json?['userEmail'] as String? ?? '',
      category: ComplaintCategory.fromKey(json?['category'] as String?),
      targetType: ComplaintTargetType.fromKey(json?['targetType'] as String?),
      targetId: json?['targetId'] as String?,
      message: json?['message'] as String? ?? '',
      status: ComplaintStatus.fromKey(json?['status'] as String?),
      adminNote: json?['adminNote'] as String?,
      assignedTo: json?['assignedTo'] as String?,
      createdAt: _toDate(json?['createdAt']),
      resolvedAt: _toDate(json?['resolvedAt']),
    );
  }
}
