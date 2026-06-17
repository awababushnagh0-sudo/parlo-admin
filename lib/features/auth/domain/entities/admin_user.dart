import 'package:equatable/equatable.dart';

/// The signed-in administrator operating the dashboard.
class AdminUser with EquatableMixin {
  final String id;
  final String email;

  const AdminUser({required this.id, required this.email});

  @override
  List<Object?> get props => [id, email];
}
