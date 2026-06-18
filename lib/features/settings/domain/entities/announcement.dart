import 'package:equatable/equatable.dart';

/// An in-app announcement (the `announcements` collection) shown on the mobile
/// home screen when [active].
class Announcement with EquatableMixin {
  final String id;
  final String title;
  final String body;
  final bool active;
  final DateTime? createdAt;

  const Announcement({
    required this.id,
    required this.title,
    required this.body,
    this.active = true,
    this.createdAt,
  });

  @override
  List<Object?> get props => [id, title, body, active, createdAt];
}
