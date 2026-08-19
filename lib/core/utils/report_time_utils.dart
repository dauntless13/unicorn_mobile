import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReportTimeUtils {
  static DateTime dateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  static DateTime todayDate() => dateOnly(DateTime.now());

  static DateTime? parseIsoDate(String? value) {
    final trimmed = (value ?? '').trim();
    if (trimmed.isEmpty) return null;

    final iso = RegExp(r'^(\d{4})-(\d{2})-(\d{2})').firstMatch(trimmed);
    if (iso != null) {
      return DateTime(
        int.parse(iso.group(1)!),
        int.parse(iso.group(2)!),
        int.parse(iso.group(3)!),
      );
    }

    final parsed = DateTime.tryParse(trimmed);
    if (parsed == null) return null;
    return dateOnly(parsed.toLocal());
  }

  static String resolveIsoDate(String? value) {
    return todayIso(parseIsoDate(value) ?? todayDate());
  }

  static String todayDisplay([DateTime? date]) {
    final now = date ?? DateTime.now();
    return "${now.day}-${now.month}-${now.year}";
  }

  static String todayIso([DateTime? date]) {
    return DateFormat("yyyy-MM-dd").format(date ?? DateTime.now());
  }

  static String formatTime(DateTime dateTime) {
    final time = TimeOfDay.fromDateTime(dateTime);
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final suffix = time.period == DayPeriod.am ? 'AM' : 'PM';
    return "${hour.toString().padLeft(2, '0')}:$minute $suffix";
  }

  static String nowTime() => formatTime(DateTime.now());

  static ({String start, String end}) rangeFromMinutes(int minutes) {
    final start = DateTime.now();
    var end = start.add(Duration(minutes: minutes));
    if (end.day != start.day) {
      end = DateTime(start.year, start.month, start.day, 23, 59);
    }
    return (start: formatTime(start), end: formatTime(end));
  }

  static String formatTimeOfDay(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final suffix = time.period == DayPeriod.am ? 'AM' : 'PM';
    return "${hour.toString().padLeft(2, '0')}:$minute $suffix";
  }

  static DateTime? parseAmPm(String value) {
    try {
      return DateFormat("hh:mm a").parse(value.trim().toUpperCase());
    } catch (_) {
      return null;
    }
  }

  static String addMinutesToTime(String start, int minutes) {
    final parsed = parseAmPm(start);
    if (parsed == null) return rangeFromMinutes(minutes).end;
    return formatTime(parsed.add(Duration(minutes: minutes)));
  }

  static int minutesBetween(String start, String end) {
    final parsedStart = parseAmPm(start);
    final parsedEnd = parseAmPm(end);
    if (parsedStart == null || parsedEnd == null) return 60;
    var diff = parsedEnd.difference(parsedStart).inMinutes;
    if (diff <= 0) diff += 24 * 60;
    return diff;
  }

  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
