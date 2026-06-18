import 'package:equatable/equatable.dart';

/// A kind of saved content under a user (maps to a Firestore subcollection).
enum ContentKind { words, sentences, videos, decks }

/// A generic, display-ready view of one saved item (word/sentence/video/deck),
/// mapped defensively so the admin can browse content without coupling to each
/// subcollection's exact schema.
class ContentItem with EquatableMixin {
  final String id;
  final String primary;
  final String secondary;
  final String? language;
  final DateTime? createdAt;

  const ContentItem({
    required this.id,
    required this.primary,
    required this.secondary,
    this.language,
    this.createdAt,
  });

  @override
  List<Object?> get props => [id, primary, secondary, language, createdAt];
}
