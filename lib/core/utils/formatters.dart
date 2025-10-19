import 'package:intl/intl.dart';

/// A utility class for handling common text and number formatting.
class Formatters {
  /// Formats a [DateTime] into a human-readable date like "July 26, 2024"
  static String formatDate(DateTime date) {
    final formatter = DateFormat('MMMM d, yyyy');
    return formatter.format(date);
  }

  /// Formats a number into currency with a dollar sign, e.g. "$1,250.00"
  static String formatCurrency(double value, {String symbol = '\$'}) {
    final format = NumberFormat.currency(symbol: symbol, decimalDigits: 2);
    return format.format(value);
  }

  /// Formats a number into a readable string with commas, e.g. "12,345"
  static String formatNumber(num value) {
    final format = NumberFormat.decimalPattern();
    return format.format(value);
  }

  /// Formats a decimal into a percentage string, e.g. 0.25 -> "25%"
  static String formatPercentage(double value, {int decimalDigits = 0}) {
    final percentValue = (value * 100).toStringAsFixed(decimalDigits);
    return "$percentValue%";
  }

  /// Shortens large numbers for display, e.g. 1200 -> "1.2K", 2500000 -> "2.5M"
  static String formatShortNumber(num number) {
    if (number >= 1000000) {
      return "${(number / 1000000).toStringAsFixed(1)}M";
    } else if (number >= 1000) {
      return "${(number / 1000).toStringAsFixed(1)}K";
    } else {
      return number.toString();
    }
  }
}
