import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:polyglot_admin/features/admins/data/providers.dart';
import 'package:polyglot_admin/features/admins/domain/entities/admin_entry.dart';
import 'package:polyglot_admin/features/audit/presentation/providers/audit_deps.dart';

abstract class AdminsDeps {
  AdminsDeps._();

  /// Realtime list of administrators.
  static final adminsStreamProvider = StreamProvider<List<AdminEntry>>((ref) {
    return ref.watch(adminsRepositoryProvider).watchAdmins();
  });

  /// Whether a given uid is currently an admin (derived from the live list).
  static final isUserAdminProvider = Provider.family<bool, String>((ref, uid) {
    final admins = ref.watch(adminsStreamProvider).value ?? const [];
    return admins.any((a) => a.uid == uid);
  });

  static final controllerProvider =
      NotifierProvider<AdminsController, AsyncValue<void>>(
        AdminsController.new,
      );
}

class AdminsController extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<bool> addAdmin({required String uid, required String email}) async {
    final ok = await _run(
      () => ref.read(adminsRepositoryProvider).addAdmin(uid: uid, email: email),
    );
    if (ok) await _log('admin_add', uid);
    return ok;
  }

  Future<bool> removeAdmin(String uid) async {
    final ok = await _run(
      () => ref.read(adminsRepositoryProvider).removeAdmin(uid),
    );
    if (ok) await _log('admin_remove', uid);
    return ok;
  }

  Future<void> _log(String action, String uid) => ref
      .read(AuditDeps.loggerProvider)
      .log(action, targetType: 'admin', targetId: uid);

  Future<bool> _run(Future<void> Function() action) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(action);
    return !state.hasError;
  }
}
