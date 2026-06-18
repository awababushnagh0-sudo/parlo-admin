import 'package:equatable/equatable.dart';

/// An entry in the `admins` collection — a user granted dashboard access.
class AdminEntry with EquatableMixin {
  final String uid;
  final String email;
  final DateTime? addedAt;

  const AdminEntry({required this.uid, required this.email, this.addedAt});

  @override
  List<Object?> get props => [uid, email, addedAt];
}
