import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Shared Firebase infrastructure providers. Every feature's datasource depends
/// on these (mirrors the per-feature `firebaseFirestoreProvider` in the mobile
/// app, hoisted here so the whole dashboard shares one instance).
final firebaseAuthProvider = Provider<FirebaseAuth>(
  (ref) => FirebaseAuth.instance,
);

final firebaseFirestoreProvider = Provider<FirebaseFirestore>(
  (ref) => FirebaseFirestore.instance,
);
