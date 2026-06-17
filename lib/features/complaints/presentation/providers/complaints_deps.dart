import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:polyglot_admin/features/complaints/data/providers.dart';
import 'package:polyglot_admin/features/complaints/domain/entities/complaint.dart';

abstract class ComplaintsDeps {
  ComplaintsDeps._();

  /// Currently selected status filter (null = all).
  static final statusFilterProvider =
      NotifierProvider<StatusFilterNotifier, ComplaintStatus?>(
    StatusFilterNotifier.new,
  );

  /// Realtime complaints for the current filter.
  static final complaintsStreamProvider =
      StreamProvider<List<Complaint>>((ref) {
    final filter = ref.watch(statusFilterProvider);
    return ref
        .watch(complaintsRepositoryProvider)
        .watchComplaints(status: filter);
  });

  /// Count of open complaints (used by the filter and the dashboard).
  static final openCountProvider = StreamProvider<int>((ref) {
    return ref
        .watch(complaintsRepositoryProvider)
        .watchComplaints(status: ComplaintStatus.open)
        .map((list) => list.length);
  });

  static final controllerProvider =
      NotifierProvider<ComplaintsController, AsyncValue<void>>(
    ComplaintsController.new,
  );
}

class StatusFilterNotifier extends Notifier<ComplaintStatus?> {
  @override
  ComplaintStatus? build() => null;

  void select(ComplaintStatus? status) => state = status;
}

class ComplaintsController extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<bool> updateStatus(
    String id,
    ComplaintStatus status, {
    String? adminNote,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref
          .read(complaintsRepositoryProvider)
          .updateStatus(id, status, adminNote: adminNote),
    );
    return !state.hasError;
  }
}
