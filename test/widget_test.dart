// Unit tests for pure-Dart domain logic (no Firebase needed).
import 'package:flutter_test/flutter_test.dart';
import 'package:polyglot_admin/core/ui/format.dart';
import 'package:polyglot_admin/features/ratings/domain/entities/rating.dart';
import 'package:polyglot_admin/features/ratings/domain/entities/rating_summary.dart';

Rating _rating(int stars) => Rating(
  id: 's$stars',
  userId: 'u',
  userEmail: 'u@example.com',
  type: RatingType.app,
  stars: stars,
);

void main() {
  group('RatingSummary.fromRatings', () {
    test('empty list yields zero average and empty distribution', () {
      final summary = RatingSummary.fromRatings([]);
      expect(summary.total, 0);
      expect(summary.average, 0);
      expect(summary.distribution.values.every((c) => c == 0), isTrue);
    });

    test('computes average and per-star distribution', () {
      final summary = RatingSummary.fromRatings([
        _rating(5),
        _rating(5),
        _rating(3),
        _rating(2),
      ]);
      expect(summary.total, 4);
      expect(summary.average, closeTo(3.75, 0.0001));
      expect(summary.distribution[5], 2);
      expect(summary.distribution[3], 1);
      expect(summary.distribution[2], 1);
      expect(summary.distribution[1], 0);
    });
  });

  group('Format.initials', () {
    test('derives up to two initials from an email', () {
      expect(Format.initials('adam.abushnagh@gmail.com'), 'AA');
      expect(Format.initials('solo@example.com'), 'S');
      expect(Format.initials(''), '?');
    });
  });
}
