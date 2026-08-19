class MealEntry {
  MealEntry({
    required this.id,
    required this.meal,
    this.portion = 'FULL',
    this.time,
    this.serverId,
    this.portionKnown = true,
    this.originalMeal,
    this.originalPortion,
    this.originalTime,
  });

  final String id;
  final String? serverId;
  String meal;
  String portion;
  String? time;
  bool portionKnown;
  final String? originalMeal;
  final String? originalPortion;
  final String? originalTime;

  bool get isExisting => serverId != null && serverId!.isNotEmpty;

  bool get isDirty {
    if (!isExisting) return true;
    final mealChanged = meal != (originalMeal ?? meal);
    final timeChanged = (time ?? '') != (originalTime ?? '');
    final portionChanged =
        portionKnown && portion != (originalPortion ?? portion);
    return mealChanged || timeChanged || portionChanged;
  }
}

class HygieneEntry {
  HygieneEntry({
    required this.id,
    required this.type,
    this.time,
    this.serverId,
    this.originalType,
    this.originalTime,
  });

  final String id;
  final String? serverId;
  String type;
  String? time;
  final String? originalType;
  final String? originalTime;

  bool get isExisting => serverId != null && serverId!.isNotEmpty;

  bool get isDirty {
    if (!isExisting) return true;
    return type != (originalType ?? type) ||
        (time ?? '') != (originalTime ?? '');
  }
}

class NapEntry {
  NapEntry({
    required this.id,
    this.minutes = 60,
    this.startTime,
    this.serverId,
    this.originalMinutes,
    this.originalStartTime,
  });

  final String id;
  final String? serverId;
  int minutes;
  String? startTime;
  final int? originalMinutes;
  final String? originalStartTime;

  bool get isExisting => serverId != null && serverId!.isNotEmpty;

  bool get isDirty {
    if (!isExisting) return true;
    return minutes != (originalMinutes ?? minutes) ||
        (startTime ?? '') != (originalStartTime ?? '');
  }
}

class StudentLogDraft {
  StudentLogDraft(this.slug);

  final String slug;
  final List<MealEntry> meals = [];
  final List<String> moods = [];
  final List<HygieneEntry> hygiene = [];
  final List<NapEntry> naps = [];
  final List<MealEntry> removedMeals = [];
  final List<HygieneEntry> removedHygiene = [];
  final List<NapEntry> removedNaps = [];
  final List<String> originalMoods = [];
  bool hadExistingReport = false;

  int get mealCount => meals.length;
  int get moodCount => moods.length;
  int get hygieneCount => hygiene.length;
  int get napCount => naps.length;
  int get itemCount => mealCount + moodCount + hygieneCount + napCount;
  bool get hasData => itemCount > 0;

  bool get moodsChanged {
    final current = [...moods]..sort();
    final original = [...originalMoods]..sort();
    return current.join('|') != original.join('|');
  }

  bool get hasChanges =>
      meals.any((e) => e.isDirty) ||
      hygiene.any((e) => e.isDirty) ||
      naps.any((e) => e.isDirty) ||
      removedMeals.isNotEmpty ||
      removedHygiene.isNotEmpty ||
      removedNaps.isNotEmpty ||
      (moodsChanged && moods.isNotEmpty);

  int get changeCount {
    var count = 0;
    count += meals.where((e) => e.isDirty).length;
    count += hygiene.where((e) => e.isDirty).length;
    count += naps.where((e) => e.isDirty).length;
    count += removedMeals.length;
    count += removedHygiene.length;
    count += removedNaps.length;
    if (moodsChanged && moods.isNotEmpty) count += 1;
    return count;
  }

  int get apiCount => changeCount;
}
