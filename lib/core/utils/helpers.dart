/// A collection of helper functions used throughout the app.
class Helpers {
  /// Capitalizes the first letter of a string.
  /// Example: "butchee" → "Butchee"
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  /// Capitalizes each word in a sentence.
  /// Example: "fresh meat shop" → "Fresh Meat Shop"
  static String capitalizeEachWord(String text) {
    if (text.isEmpty) return text;
    return text
        .split(' ')
        .map((word) =>
            word.isEmpty ? '' : word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  /// Checks if a string is null, empty, or contains only whitespace.
  static bool isNullOrEmpty(String? text) {
    return text == null || text.trim().isEmpty;
  }

  /// Returns a fallback value if the string is null or empty.
  /// Example: Helpers.orDefault(user.name, "Guest")
  static String orDefault(String? text, String fallback) {
    return isNullOrEmpty(text) ? fallback : text!;
  }

  /// Truncates text to a given [maxLength] and adds ellipsis if needed.
  /// Example: "Butchee is amazing" → "Butchee is..."
  static String truncate(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  /// Safely parses a string to an integer.
  static int parseInt(String? value, {int defaultValue = 0}) {
    return int.tryParse(value ?? '') ?? defaultValue;
  }

  /// Safely parses a string to a double.
  static double parseDouble(String? value, {double defaultValue = 0.0}) {
    return double.tryParse(value ?? '') ?? defaultValue;
  }

  /// Returns true if a list is null or empty.
  static bool isListEmpty(List? list) {
    return list == null || list.isEmpty;
  }

  /// Returns true if a map is null or empty.
  static bool isMapEmpty(Map? map) {
    return map == null || map.isEmpty;
  }

  /// Returns a formatted string like: “Hi, Ruth 👋”
  static String greetUser(String name) {
    return "Hi, ${capitalize(name)} 👋";
  }

  /// Returns true if the app is running in debug mode.
  static bool isDebugMode() {
    bool inDebug = false;
    assert(inDebug = true);
    return inDebug;
  }
}
