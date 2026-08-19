import 'package:get/get.dart';

class ReportDisplayUtils {
  static const _moodKeys = [
    'happy',
    'cool',
    'amazed',
    'peaceful',
    'confused',
    'stressed',
    'sad',
    'angry',
    'excited',
    'calm',
  ];

  static String mealLabel(String? raw) {
    switch (_enumKey(raw)) {
      case 'BREAKFAST':
        return 'breakfast'.tr;
      case 'LUNCH':
        return 'lunch'.tr;
      case 'SNACKS':
      case 'SNACK':
        return 'snacks'.tr;
      case 'MILK':
        return 'milk'.tr;
      case 'OATS_AND_MILK':
        return 'OATS_AND_MILK'.tr;
      default:
        return _titleCase(raw);
    }
  }

  static String hygieneLabel(String? raw) {
    switch (_enumKey(raw)) {
      case 'URINE':
        return 'Urine'.tr;
      case 'POOP':
        return 'Poop'.tr;
      default:
        return _titleCase(raw);
    }
  }

  static String activityLabel(String? raw) {
    final key = _enumKey(raw).toLowerCase();
    if (key.isEmpty) return '';
    final translated = key.tr;
    if (translated != key) return translated;
    return _titleCase(raw);
  }

  static String moodKey(String? raw) {
    final compact = (raw ?? '')
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[\s_-]'), '');
    for (final key in _moodKeys) {
      if (compact == key) return key;
    }
    return compact;
  }

  static String moodLabel(String? raw) {
    final key = moodKey(raw);
    if (key.isEmpty) return '';
    final translated = key.tr;
    return translated == key ? _titleCase(raw) : translated;
  }

  static String portionLabel(String? raw) {
    switch (_enumKey(raw)) {
      case 'FULL':
        return 'full'.tr;
      case 'HALF':
        return 'half'.tr;
      case 'QUARTER':
        return 'quarter'.tr;
      case 'NONE':
        return 'none'.tr;
      default:
        return '';
    }
  }

  static String mealLine(String? mealName, {String? portion}) {
    final meal = mealLabel(mealName);
    final amount = portionLabel(portion);
    if (amount.isEmpty) return meal;
    return '$meal · $amount';
  }

  static String _enumKey(String? raw) {
    return (raw ?? '').trim().toUpperCase().replaceAll(' ', '_');
  }

  static String _titleCase(String? raw) {
    final value = (raw ?? '').trim();
    if (value.isEmpty) return value;
    return value
        .toLowerCase()
        .split(RegExp(r'[_\s]+'))
        .where((word) => word.isNotEmpty)
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }
}
