import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:polyglot_admin/core/providers/firebase_deps.dart';
import 'package:polyglot_admin/features/audit/data/datasources/audit_firestore_data_source.dart';
import 'package:polyglot_admin/features/audit/data/repositories/audit_repository_impl.dart';
import 'package:polyglot_admin/features/audit/domain/repositories/audit_repository.dart';

final auditDataSourceProvider = Provider<AuditFirestoreDataSource>((ref) {
  return AuditFirestoreDataSource(ref.watch(firebaseFirestoreProvider));
});

final auditRepositoryProvider = Provider<AuditRepository>((ref) {
  return AuditRepositoryImpl(ref.watch(auditDataSourceProvider));
});
