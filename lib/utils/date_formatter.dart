import 'package:intl/intl.dart';

class DateFormatter {
  // Format DateTime to dd/mm/yy string
  static String formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('dd/MM/yy').format(date);
  }

  // Format DateTime to dd/mm/yy string with fallback
  static String formatDateOrEmpty(DateTime? date, {String fallback = 'N/A'}) {
    if (date == null) return fallback;
    return formatDate(date);
  }

  // Parse dd/mm/yy string to DateTime
  static DateTime? parseDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return null;
    try {
      return DateFormat('dd/MM/yy').parse(dateString);
    } catch (e) {
      // Try parsing ISO format as fallback
      try {
        return DateTime.parse(dateString);
      } catch (e2) {
        return null;
      }
    }
  }

  // Format date string from API (ISO format) to dd/mm/yy
  static String formatDateString(String? dateString) {
    if (dateString == null || dateString.isEmpty) return '';
    try {
      final date = DateTime.parse(dateString);
      return formatDate(date);
    } catch (e) {
      return dateString; // Return original if parsing fails
    }
  }

  // Format date string from API (ISO format) to dd/mm/yy with fallback
  static String formatDateStringOrEmpty(String? dateString, {String fallback = 'N/A'}) {
    if (dateString == null || dateString.isEmpty) return fallback;
    return formatDateString(dateString);
  }
}

