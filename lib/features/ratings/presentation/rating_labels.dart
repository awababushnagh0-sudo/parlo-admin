import 'package:polyglot_admin/core/l10n/generated/translations.g.dart';
import 'package:polyglot_admin/features/ratings/domain/entities/rating.dart';

extension RatingTypeX on RatingType {
  String label(Translations t) => switch (this) {
    RatingType.app => t.ratings.type_app,
    RatingType.word => t.ratings.type_word,
    RatingType.sentence => t.ratings.type_sentence,
    RatingType.video => t.ratings.type_video,
  };
}
