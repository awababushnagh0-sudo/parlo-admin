import 'package:polyglot_admin/features/complaints/data/datasources/complaints_firestore_data_source.dart';
import 'package:polyglot_admin/features/complaints/domain/entities/complaint.dart';
import 'package:polyglot_admin/features/complaints/domain/repositories/complaints_repository.dart';

class ComplaintsRepositoryImpl implements ComplaintsRepository {
  const ComplaintsRepositoryImpl(this._source);

  final ComplaintsFirestoreDataSource _source;

  @override
  Stream<List<Complaint>> watchComplaints({ComplaintStatus? status}) =>
      _source.watchComplaints(status: status);

  @override
  Future<void> updateStatus(
    String id,
    ComplaintStatus status, {
    String? adminNote,
  }) =>
      _source.updateStatus(id, status, adminNote: adminNote);

  @override
  Future<void> assign(String id, String? adminEmail) =>
      _source.assign(id, adminEmail);
}
