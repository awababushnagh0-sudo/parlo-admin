import 'package:polyglot_admin/features/complaints/domain/entities/complaint.dart';

abstract class ComplaintsRepository {
  /// Realtime list of complaints, optionally filtered by [status].
  Stream<List<Complaint>> watchComplaints({ComplaintStatus? status});

  /// Updates a complaint's moderation status (and optional internal note).
  /// Stamps `resolvedAt` when moving out of [ComplaintStatus.open].
  Future<void> updateStatus(
    String id,
    ComplaintStatus status, {
    String? adminNote,
  });
}
