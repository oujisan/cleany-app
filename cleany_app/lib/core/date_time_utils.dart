import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeUtils {
  // Format date for display in Indonesian
  static String formatDateIndonesian(DateTime date) {
    return DateFormat('dd MMMM yyyy', 'id_ID').format(date);
  }

  // Format date for API (ISO format)
  static String formatDateForAPI(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  // Format time for display
  static String formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  // Convert TimeOfDay to string for API
  static String timeOfDayToString(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  // Parse string time to TimeOfDay
  static TimeOfDay? parseTimeString(String timeString) {
    try {
      final parts = timeString.split(':');
      if (parts.length == 2) {
        final hour = int.parse(parts[0]);
        final minute = int.parse(parts[1]);
        return TimeOfDay(hour: hour, minute: minute);
      }
    } catch (e) {
      debugPrint('Error parsing time string: $e');
    }
    return null;
  }

  // Get day names in Indonesian
  static const Map<int, String> dayNamesIndonesian = {
    0: 'Minggu',
    1: 'Senin',
    2: 'Selasa',
    3: 'Rabu',
    4: 'Kamis',
    5: 'Jumat',
    6: 'Sabtu',
  };

  // Get short day names in Indonesian
  static const Map<int, String> shortDayNamesIndonesian = {
    0: 'Min',
    1: 'Sen',
    2: 'Sel',
    3: 'Rab',
    4: 'Kam',
    5: 'Jum',
    6: 'Sab',
  };

  // Get day name from value
  static String getDayName(int dayValue) {
    return dayNamesIndonesian[dayValue] ?? '';
  }

  // Get short day name from value
  static String getShortDayName(int dayValue) {
    return shortDayNamesIndonesian[dayValue] ?? '';
  }

  // Format selected days for display
  static String formatSelectedDays(List<int> selectedDays) {
    if (selectedDays.isEmpty) return 'Tidak ada hari dipilih';
    
    selectedDays.sort(); // Sort the days
    final dayNames = selectedDays.map((dayValue) => getShortDayName(dayValue)).toList();
    return dayNames.join(', ');
  }

  // Check if date range is valid
  static bool isValidDateRange(DateTime? startDate, DateTime? endDate) {
    if (startDate == null || endDate == null) return false;
    return endDate.isAfter(startDate) || endDate.isAtSameMomentAs(startDate);
  }

  // Get formatted date range string
  static String formatDateRange(DateTime? startDate, DateTime? endDate) {
    if (startDate == null || endDate == null) return '';
    return '${formatDateIndonesian(startDate)} - ${formatDateIndonesian(endDate)}';
  }

  // Check if date is in the past
  static bool isDateInPast(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final checkDate = DateTime(date.year, date.month, date.day);
    return checkDate.isBefore(today);
  }

  // Get days between two dates
  static int getDaysBetween(DateTime startDate, DateTime endDate) {
    return endDate.difference(startDate).inDays;
  }

  // Get all dates between start and end date that match selected days
  static List<DateTime> getScheduledDates(
    DateTime startDate,
    DateTime endDate,
    List<int> selectedDays,
  ) {
    final List<DateTime> scheduledDates = [];
    DateTime currentDate = startDate;

    while (currentDate.isBefore(endDate) || currentDate.isAtSameMomentAs(endDate)) {
      final weekday = currentDate.weekday % 7; // Convert to 0-6 format
      if (selectedDays.contains(weekday)) {
        scheduledDates.add(currentDate);
      }
      currentDate = currentDate.add(const Duration(days: 1));
    }

    return scheduledDates;
  }

  // Format duration in Indonesian
  static String formatDuration(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays} hari';
    } else if (duration.inHours > 0) {
      return '${duration.inHours} jam';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes} menit';
    } else {
      return '${duration.inSeconds} detik';
    }
  }
}

// Extension methods for convenience
extension DateTimeExtension on DateTime {
  String toIndonesianFormat() {
    return DateTimeUtils.formatDateIndonesian(this);
  }

  String toAPIFormat() {
    return DateTimeUtils.formatDateForAPI(this);
  }

  bool isToday() {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  bool isTomorrow() {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year && month == tomorrow.month && day == tomorrow.day;
  }

  bool isYesterday() {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year && month == yesterday.month && day == yesterday.day;
  }
}

extension TimeOfDayExtension on TimeOfDay {
  String toFormattedString() {
    return DateTimeUtils.formatTime(this);
  }

  String toAPIString() {
    return DateTimeUtils.timeOfDayToString(this);
  }

  // Convert TimeOfDay to DateTime for comparison
  DateTime toDateTime([DateTime? date]) {
    final baseDate = date ?? DateTime.now();
    return DateTime(baseDate.year, baseDate.month, baseDate.day, hour, minute);
  }

  // Check if time is in the past (today)
  bool isPastToday() {
    final now = DateTime.now();
    final timeToday = DateTime(now.year, now.month, now.day, hour, minute);
    return timeToday.isBefore(now);
  }
}