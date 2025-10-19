import 'package:intl/intl.dart';

/// A utility class for formatting and handling date/time in the app.
class DateUtilsHelper {
  /// Formats a [DateTime] to a readable date like: `July 26, 2024`
  static String formatReadableDate(DateTime date) {
    return DateFormat('MMMM d, y').format(date);
  }

  /// Formats a [DateTime] to a short date: `26 Jul 2024`
  static String formatShortDate(DateTime date) {
    return DateFormat('d MMM y').format(date);
  }

  /// Returns formatted time like: `2:45 PM`
  static String formatTime(DateTime date) {
    return DateFormat('h:mm a').format(date);
  }

  /// Parses a date string safely — returns `null` if parsing fails.
  static DateTime? tryParse(String? dateString) {
    if (dateString == null || dateString.isEmpty) return null;
    try {
      return DateTime.parse(dateString);
    } catch (_) {
      return null;
    }
  }

  /// Returns true if two dates represent the same day.
  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  /// Returns a human-friendly label for recent dates (e.g., “Today”, “Yesterday”).
  static String relativeDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (isSameDay(date, now)) {
      return 'Today';
    } else if (difference == 1) {
      return 'Yesterday';
    } else if (difference < 7) {
      return '${difference} days ago';
    } else {
      return formatShortDate(date);
    }
  }
}
