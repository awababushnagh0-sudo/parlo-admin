import 'package:intl/intl.dart';

/// Small formatting helpers shared across the dashboard.
class Format {
  const Format._();

  static final _date = DateFormat.yMMMd();
  static final _dateTime = DateFormat.yMMMd().add_jm();

  /// e.g. "Jun 17, 2026" — em dash for null.
  static String date(DateTime? value) =>
      value == null ? '—' : _date.format(value.toLocal());

  /// e.g. "Jun 17, 2026 9:41 PM" — em dash for null.
  static String dateTime(DateTime? value) =>
      value == null ? '—' : _dateTime.format(value.toLocal());

  /// Up to two initials from an email or name, for avatars.
  static String initials(String value) {
    final cleaned = value.trim();
    if (cleaned.isEmpty) return '?';
    final namePart = cleaned.contains('@') ? cleaned.split('@').first : cleaned;
    final parts = namePart
        .split(RegExp(r'[ ._-]+'))
        .where((p) => p.isNotEmpty)
        .toList();
    if (parts.isEmpty) return namePart[0].toUpperCase();
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }
}
