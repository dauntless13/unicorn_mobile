import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';

import '../../../../../../../../../core/ColorUtils.dart';
import '../../../../../../../../../core/utils/report_time_utils.dart';
import '../../../../../../../../../service/api_service/api_worker.dart';
import '../../../../../../../../../translation/language_controller.dart';
import '../../../../../../../../../widget/app_date_picker_helper.dart';
import '../../../../../../../../../widget/common_toastification.dart';
import '../../../../profile/model/get_all_class/get_all_class_request.dart';
import '../../../../profile/model/get_all_class/get_all_class_response.dart';
import '../../add_post/mode/list_student_by_class/list_student_by_class_request.dart';
import '../../add_post/mode/list_student_by_class/list_student_by_class_response.dart';
import '../model/mood_update/mood_update_request.dart';
import '../model/report_details_by_student_slug/report_details_by_student_slug_request.dart';
import '../model/report_details_by_student_slug/report_details_by_student_slug_response.dart';
import '../model/student_log_draft.dart';
import '../view/category_screens/hygiene/model/add_hygiene/add_hygiene_request.dart';
import '../view/category_screens/meal_snack/model/add_meal_snack/add_meal_snack_request.dart';
import '../view/category_screens/nap/model/add_nap/add_nap_request.dart';

class QuickLogController extends GetxController {
  final ApiWorker apiWorker = Get.put(ApiWorker());

  final RxList<Class> classList = <Class>[].obs;
  final Rxn<Class> selectedClass = Rxn<Class>();
  final RxList<StudentData> studentList = <StudentData>[].obs;
  final RxString kidSearch = ''.obs;
  final RxnString expandedSlug = RxnString();
  final Rx<DateTime> selectedDate = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  ).obs;

  final RxBool isClassLoading = false.obs;
  final RxBool isStudentLoading = false.obs;
  final RxBool isReportsLoading = false.obs;
  final RxBool isSaving = false.obs;
  final RxInt saveDone = 0.obs;
  final RxInt saveTotal = 0.obs;
  final RxInt tick = 0.obs;

  final Map<String, StudentLogDraft> drafts = {};
  int _loadToken = 0;

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

  void _changed() => tick.value++;

  String _newId() => DateTime.now().microsecondsSinceEpoch.toString();

  String get selectedDateIso => ReportTimeUtils.todayIso(selectedDate.value);

  bool get isToday =>
      ReportTimeUtils.isSameDay(selectedDate.value, DateTime.now());

  bool get canGoNext => !isToday;

  String get dateLabel {
    if (isToday) return 'today_label'.tr;
    return DateFormat('EEE d MMM').format(selectedDate.value);
  }

  StudentLogDraft draftOf(String slug) {
    return drafts.putIfAbsent(slug, () => StudentLogDraft(slug));
  }

  Future<void> load(BuildContext context) async {
    await fetchClasses(context);
  }

  Future<void> fetchClasses(BuildContext context) async {
    try {
      isClassLoading.value = true;
      final response = await apiWorker.getAllClassApi(
        GetAllClassRequest(
          page: 1,
          limit: 100,
          lang: LanguageController.to.apiLanguage,
        ),
        context,
      );

      if (response?.success == true) {
        classList.assignAll(response?.data?.classes ?? []);
        if (classList.isNotEmpty && selectedClass.value == null) {
          if (!context.mounted) return;
          await selectClass(context, classList.first);
        }
      }
    } catch (e) {
      debugPrint('Quick log classes error: $e');
    } finally {
      isClassLoading.value = false;
    }
  }

  Future<void> selectClass(BuildContext context, Class value) async {
    selectedClass.value = value;
    drafts.clear();
    expandedSlug.value = null;
    _changed();
    await fetchStudents(context);
  }

  Future<void> pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: buildAppDatePickerThemeBuilder(
        context,
        primaryColor: primaryColor,
      ),
    );
    if (picked == null || !context.mounted) return;
    await setDate(context, picked);
  }

  Future<void> previousDay(BuildContext context) async {
    await setDate(
      context,
      selectedDate.value.subtract(const Duration(days: 1)),
    );
  }

  Future<void> nextDay(BuildContext context) async {
    if (!canGoNext) return;
    await setDate(context, selectedDate.value.add(const Duration(days: 1)));
  }

  Future<void> setDate(BuildContext context, DateTime date) async {
    final next = DateTime(date.year, date.month, date.day);
    if (ReportTimeUtils.isSameDay(next, selectedDate.value)) return;
    selectedDate.value = next;
    _resetDrafts();
    await loadReports(context);
  }

  Future<void> fetchStudents(BuildContext context) async {
    final classSlug = selectedClass.value?.slug;
    if (classSlug == null || classSlug.isEmpty) return;

    try {
      isStudentLoading.value = true;
      studentList.clear();
      drafts.clear();

      final response = await apiWorker.listStudentByClassApi(
        ListStudentByClassRequest(
          page: 1,
          limit: 100,
          lang: LanguageController.to.apiLanguage,
          search: '',
        ),
        context,
        classSlug,
      );

      if (response?.success == true) {
        studentList.assignAll(response?.data?.students ?? []);
        _resetDrafts();
      }
    } catch (e) {
      debugPrint('Quick log students error: $e');
    } finally {
      isStudentLoading.value = false;
    }

    if (!context.mounted) return;
    await loadReports(context);
  }

  void _resetDrafts() {
    drafts.clear();
    for (final student in studentList) {
      final slug = student.slug;
      if (slug != null && slug.isNotEmpty) {
        draftOf(slug);
      }
    }
    _changed();
  }

  Future<void> loadReports(BuildContext context) async {
    final token = ++_loadToken;
    final date = selectedDateIso;
    final slugs = studentList
        .map((s) => s.slug)
        .whereType<String>()
        .where((slug) => slug.isNotEmpty)
        .toList();

    if (slugs.isEmpty) {
      isReportsLoading.value = false;
      return;
    }

    isReportsLoading.value = true;
    const batchSize = 3;
    for (var i = 0; i < slugs.length; i += batchSize) {
      if (token != _loadToken || !context.mounted) return;
      final chunk = slugs.skip(i).take(batchSize);
      await Future.wait(
        chunk.map((slug) => _loadStudentReport(context, slug, date, token)),
      );
    }
    if (token == _loadToken) {
      isReportsLoading.value = false;
      _changed();
    }
  }

  Future<void> _loadStudentReport(
    BuildContext context,
    String slug,
    String date,
    int token,
  ) async {
    try {
      final response = await apiWorker.reportStudentDetails(
        ReportDetailsByStudentSlugRequest(lang: 'EN', date: date),
        context,
        slug,
      );
      if (token != _loadToken) return;
      if (response?.success == true && response?.data != null) {
        _applyReport(slug, response!.data!);
      }
    } catch (e) {
      debugPrint('Quick log report load error ($slug): $e');
    }
  }

  void _applyReport(String slug, StudentReportDetailsData data) {
    final draft = draftOf(slug);
    draft.meals.clear();
    draft.hygiene.clear();
    draft.naps.clear();
    draft.moods.clear();
    draft.originalMoods.clear();
    draft.removedMeals.clear();
    draft.removedHygiene.clear();
    draft.removedNaps.clear();

    for (final meal in data.mealsAndSnacks ?? []) {
      final mealName = _normalizeMeal(meal.mealName);
      if (mealName.isEmpty) continue;
      final portion = _normalizePortion(meal.portion);
      draft.meals.add(
        MealEntry(
          id: meal.mealId ?? _newId(),
          serverId: meal.mealId,
          meal: mealName,
          portion: portion ?? 'FULL',
          portionKnown: portion != null,
          time: _cleanTime(meal.time),
          originalMeal: mealName,
          originalPortion: portion,
          originalTime: _cleanTime(meal.time),
        ),
      );
    }

    for (final mood in data.todaysMood?.mood ?? []) {
      final key = _normalizeMood(mood);
      if (key != null && !draft.moods.contains(key)) {
        draft.moods.add(key);
      }
    }
    draft.originalMoods.addAll(draft.moods);

    for (final item in data.hygiene ?? []) {
      final type = _normalizeHygiene(item.hygieneType);
      if (type == null) continue;
      draft.hygiene.add(
        HygieneEntry(
          id: item.hygieneId ?? _newId(),
          serverId: item.hygieneId,
          type: type,
          time: _cleanTime(item.time),
          originalType: type,
          originalTime: _cleanTime(item.time),
        ),
      );
    }

    for (final nap in data.nap ?? []) {
      final start = _cleanTime(nap.startTime);
      final end = _cleanTime(nap.endTime);
      final minutes = (start != null && end != null)
          ? ReportTimeUtils.minutesBetween(start, end)
          : 60;
      draft.naps.add(
        NapEntry(
          id: nap.napId ?? _newId(),
          serverId: nap.napId,
          minutes: minutes,
          startTime: start,
          originalMinutes: minutes,
          originalStartTime: start,
        ),
      );
    }

    draft.hadExistingReport = draft.hasData;
    _changed();
  }

  String _normalizeMeal(String? raw) {
    final value = (raw ?? '').trim().toUpperCase().replaceAll(' ', '_');
    if (value.isEmpty) return '';
    if (value == 'SNACK') return 'SNACKS';
    return value;
  }

  String? _normalizePortion(String? raw) {
    final value = (raw ?? '').trim().toUpperCase();
    if (value == 'FULL' ||
        value == 'HALF' ||
        value == 'QUARTER' ||
        value == 'NONE') {
      return value;
    }
    return null;
  }

  String? _normalizeHygiene(String? raw) {
    final value = (raw ?? '').trim().toUpperCase();
    if (value.contains('POOP') || value.contains('BOWEL')) return 'POOP';
    if (value.contains('URINE') || value.contains('WEE')) return 'URINE';
    return null;
  }

  String? _normalizeMood(String raw) {
    final compact = raw.trim().toLowerCase().replaceAll(RegExp(r'[\s_-]'), '');
    for (final key in _moodKeys) {
      if (compact == key) return key;
    }
    return null;
  }

  String? _cleanTime(String? raw) {
    final value = raw?.trim();
    if (value == null || value.isEmpty) return null;
    return value;
  }

  List<StudentData> get visibleStudents {
    final query = kidSearch.value.trim().toLowerCase();
    if (query.isEmpty) return studentList.toList();
    return studentList.where((s) {
      final name = '${s.firstName ?? ''} ${s.lastName ?? ''}'.toLowerCase();
      return name.contains(query);
    }).toList();
  }

  List<StudentLogDraft> get filledDrafts {
    return drafts.values.where((d) => d.hasData).toList();
  }

  List<StudentLogDraft> get changedDrafts {
    return drafts.values.where((d) => d.hasChanges).toList();
  }

  int get totalEntries =>
      filledDrafts.fold(0, (sum, draft) => sum + draft.itemCount);

  int get kidsWithLogs => filledDrafts.length;

  int get changeCount =>
      changedDrafts.fold(0, (sum, draft) => sum + draft.changeCount);

  int get kidsWithChanges => changedDrafts.length;

  void toggleExpanded(String slug) {
    expandedSlug.value = expandedSlug.value == slug ? null : slug;
  }

  void addMeal(String slug, String meal) {
    draftOf(slug).meals.add(MealEntry(id: _newId(), meal: meal));
    _changed();
  }

  void removeMeal(String slug, String id) {
    final draft = draftOf(slug);
    final entry = draft.meals.firstWhereOrNull((e) => e.id == id);
    if (entry == null) return;
    draft.meals.remove(entry);
    if (entry.isExisting) {
      draft.removedMeals.add(entry);
    }
    _changed();
  }

  void setMealPortion(String slug, String id, String portion) {
    final entry = draftOf(slug).meals.firstWhereOrNull((e) => e.id == id);
    if (entry == null) return;
    entry.portion = portion;
    entry.portionKnown = true;
    _changed();
  }

  void setMealTime(String slug, String id, String? time) {
    final entry = draftOf(slug).meals.firstWhereOrNull((e) => e.id == id);
    if (entry == null) return;
    entry.time = time;
    _changed();
  }

  void toggleMood(String slug, String mood) {
    final list = draftOf(slug).moods;
    if (list.contains(mood)) {
      list.remove(mood);
    } else {
      list.add(mood);
    }
    _changed();
  }

  void addHygiene(String slug, String type) {
    draftOf(slug).hygiene.add(HygieneEntry(id: _newId(), type: type));
    _changed();
  }

  void removeHygiene(String slug, String id) {
    final draft = draftOf(slug);
    final entry = draft.hygiene.firstWhereOrNull((e) => e.id == id);
    if (entry == null) return;
    draft.hygiene.remove(entry);
    if (entry.isExisting) {
      draft.removedHygiene.add(entry);
    }
    _changed();
  }

  void setHygieneTime(String slug, String id, String? time) {
    final entry = draftOf(slug).hygiene.firstWhereOrNull((e) => e.id == id);
    if (entry == null) return;
    entry.time = time;
    _changed();
  }

  void addNap(String slug) {
    draftOf(slug).naps.add(NapEntry(id: _newId()));
    _changed();
  }

  void removeNap(String slug, String id) {
    final draft = draftOf(slug);
    final entry = draft.naps.firstWhereOrNull((e) => e.id == id);
    if (entry == null) return;
    draft.naps.remove(entry);
    if (entry.isExisting) {
      draft.removedNaps.add(entry);
    }
    _changed();
  }

  void setNapMinutes(String slug, String id, int minutes) {
    final entry = draftOf(slug).naps.firstWhereOrNull((e) => e.id == id);
    if (entry == null) return;
    entry.minutes = minutes;
    _changed();
  }

  void setNapStart(String slug, String id, String? start) {
    final entry = draftOf(slug).naps.firstWhereOrNull((e) => e.id == id);
    if (entry == null) return;
    entry.startTime = start;
    _changed();
  }

  String mealLabel(String meal) {
    switch (meal) {
      case 'BREAKFAST':
        return 'breakfast'.tr;
      case 'LUNCH':
        return 'lunch'.tr;
      case 'SNACKS':
        return 'snacks'.tr;
      case 'MILK':
        return 'milk'.tr;
      default:
        return meal;
    }
  }

  String portionLabel(String portion) {
    switch (portion) {
      case 'FULL':
        return 'full'.tr;
      case 'HALF':
        return 'half'.tr;
      case 'QUARTER':
        return 'quarter'.tr;
      case 'NONE':
        return 'none'.tr;
      default:
        return portion;
    }
  }

  String durationLabel(int minutes) {
    switch (minutes) {
      case 30:
        return 'duration_30'.tr;
      case 45:
        return 'duration_45'.tr;
      case 60:
        return 'duration_60'.tr;
      case 90:
        return 'duration_90'.tr;
      case 120:
        return 'duration_120'.tr;
      default:
        return '$minutes min';
    }
  }

  IconData mealIcon(String meal) {
    switch (meal) {
      case 'BREAKFAST':
        return Icons.free_breakfast_rounded;
      case 'LUNCH':
        return Icons.lunch_dining_rounded;
      case 'SNACKS':
        return Icons.icecream_rounded;
      case 'MILK':
        return Icons.local_drink_rounded;
      default:
        return Icons.restaurant_rounded;
    }
  }

  String studentName(StudentData student) {
    return '${student.firstName ?? ''} ${student.lastName ?? ''}'.trim();
  }

  StudentData? studentBySlug(String slug) {
    return studentList.firstWhereOrNull((s) => s.slug == slug);
  }

  ({String start, String end}) _napRange(NapEntry nap) {
    if (nap.startTime == null || nap.startTime!.isEmpty) {
      return ReportTimeUtils.rangeFromMinutes(nap.minutes);
    }
    return (
      start: nap.startTime!,
      end: ReportTimeUtils.addMinutesToTime(nap.startTime!, nap.minutes),
    );
  }

  bool validate(BuildContext context) {
    if (selectedClass.value == null) {
      showToast(
        context,
        'Error',
        'please_select_class'.tr,
        type: ToastificationType.error,
      );
      return false;
    }
    if (changedDrafts.isEmpty) {
      showToast(
        context,
        'Error',
        'no_changes_yet'.tr,
        type: ToastificationType.error,
      );
      return false;
    }
    return true;
  }

  Future<void> submit(BuildContext context) async {
    if (isSaving.value) return;
    FocusManager.instance.primaryFocus?.unfocus();
    if (!validate(context)) return;

    final toSave = changedDrafts.toList();
    saveDone.value = 0;
    saveTotal.value = toSave.fold(0, (sum, d) => sum + d.apiCount);
    if (saveTotal.value == 0) return;

    isSaving.value = true;
    var ok = 0;
    var fail = 0;
    final lang = LanguageController.to.apiLanguage;
    final date = selectedDateIso;

    for (final draft in toSave) {
      for (final meal in List<MealEntry>.from(draft.removedMeals)) {
        final success = await _safe(() async {
          return apiWorker.deleteMealApi(context, meal.serverId!, lang: lang);
        });
        success ? ok++ : fail++;
        saveDone.value += 1;
      }

      for (final meal in List<MealEntry>.from(draft.meals.where((e) => e.isDirty))) {
        final success = await _safe(() async {
          final request = MealRequest(
            meal: meal.meal,
            portion: meal.portionKnown ? meal.portion : null,
            date: date,
            time: meal.time ?? '',
            description: '',
            lang: lang,
          );
          if (meal.isExisting) {
            return apiWorker.updateMealApi(request, context, meal.serverId!);
          }
          final res = await apiWorker.addMealSnacks(request, context, draft.slug);
          return res?.success == true;
        });
        success ? ok++ : fail++;
        saveDone.value += 1;
      }

      for (final item in List<HygieneEntry>.from(draft.removedHygiene)) {
        final success = await _safe(() async {
          return apiWorker.deleteHygieneApi(
            context,
            item.serverId!,
            lang: lang,
          );
        });
        success ? ok++ : fail++;
        saveDone.value += 1;
      }

      for (final item
          in List<HygieneEntry>.from(draft.hygiene.where((e) => e.isDirty))) {
        final success = await _safe(() async {
          final request = AddHygieneRequest(
            hygiene: item.type,
            otherText: '',
            time: item.time?.isNotEmpty == true
                ? item.time
                : ReportTimeUtils.nowTime(),
            description: '',
            date: date,
            lang: lang,
          );
          if (item.isExisting) {
            return apiWorker.updateHygieneApi(request, context, item.serverId!);
          }
          final res = await apiWorker.addHygieneApi(
            request,
            context,
            draft.slug,
          );
          return res?.success == true;
        });
        success ? ok++ : fail++;
        saveDone.value += 1;
      }

      for (final nap in List<NapEntry>.from(draft.removedNaps)) {
        final success = await _safe(() async {
          return apiWorker.deleteNapApi(context, nap.serverId!, lang: lang);
        });
        success ? ok++ : fail++;
        saveDone.value += 1;
      }

      for (final nap in List<NapEntry>.from(draft.naps.where((e) => e.isDirty))) {
        final success = await _safe(() async {
          final range = _napRange(nap);
          final request = AddNapRequest(
            startTime: range.start,
            endTime: range.end,
            description: '',
            date: date,
            lang: lang,
          );
          if (nap.isExisting) {
            return apiWorker.updateNapApi(request, context, nap.serverId!);
          }
          final res = await apiWorker.addNapApi(request, context, draft.slug);
          return res?.success == true;
        });
        success ? ok++ : fail++;
        saveDone.value += 1;
      }

      if (draft.moodsChanged && draft.moods.isNotEmpty) {
        final success = await _safe(() async {
          final res = await apiWorker.moodUpdateApi(
            MoodUpdateRequest(
              mood: draft.moods.map((m) => m.toUpperCase()).toList(),
              lang: lang,
              date: date,
            ),
            context,
            draft.slug,
          );
          return res?.success == true;
        });
        success ? ok++ : fail++;
        saveDone.value += 1;
      }
    }

    isSaving.value = false;
    if (!context.mounted) return;

    if (ok > 0) {
      showToast(
        context,
        'Success',
        fail == 0
            ? 'saved_changes'.tr
            : 'partial_save'.trParams({'ok': '$ok', 'fail': '$fail'}),
      );
      if (Get.isBottomSheetOpen ?? false) {
        Get.back();
      }
      await loadReports(context);
      return;
    }

    showToast(
      context,
      'Error',
      'failed_to_save_log'.tr,
      type: ToastificationType.error,
    );
  }

  Future<bool> _safe(Future<bool> Function() action) async {
    try {
      return await action();
    } catch (e) {
      debugPrint('Quick log save error: $e');
      return false;
    }
  }
}
