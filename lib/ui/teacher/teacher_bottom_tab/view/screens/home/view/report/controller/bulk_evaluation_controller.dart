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
import '../model/evaluation_question/evaluation_question_request.dart';
import '../model/evaluation_question/evaluation_question_response.dart';
import '../model/evaluation_forms_list/evaluation_forms_list_request.dart';
import '../model/save_evaluation/save_evaluation_request.dart';
import '../model/student_eval_draft.dart';

class EvalRatingOption {
  final String code;
  final String titleKey;
  final String subtitleKey;
  final String meaning;
  final Color color;

  const EvalRatingOption({
    required this.code,
    required this.titleKey,
    required this.subtitleKey,
    required this.meaning,
    required this.color,
  });

  EvalRatingOption withMeaning(String next) {
    final label = next.trim();
    return EvalRatingOption(
      code: code,
      titleKey: titleKey,
      subtitleKey: subtitleKey,
      meaning: label.isEmpty ? meaning : label,
      color: color,
    );
  }
}

class BulkEvaluationController extends GetxController {
  final ApiWorker apiWorker = Get.put(ApiWorker());

  static const ratings = [
    EvalRatingOption(
      code: 'A',
      titleKey: 'achieved_title',
      subtitleKey: 'achieved_subtitle',
      meaning: 'Doing it well',
      color: Color(0xFF22C55E),
    ),
    EvalRatingOption(
      code: 'D',
      titleKey: 'developing_title',
      subtitleKey: 'developing_subtitle',
      meaning: 'Learning it',
      color: Color(0xFFF59E0B),
    ),
    EvalRatingOption(
      code: 'E',
      titleKey: 'emerging_title',
      subtitleKey: 'emerging_subtitle',
      meaning: 'Just starting',
      color: Color(0xFF6366F1),
    ),
  ];

  final RxList<Class> classList = <Class>[].obs;
  final Rxn<Class> selectedClass = Rxn<Class>();
  final RxList<StudentData> studentList = <StudentData>[].obs;
  final RxList<Questions> questions = <Questions>[].obs;
  final RxString kidSearch = ''.obs;
  final RxnString expandedSlug = RxnString();
  final Rx<DateTime> selectedDate = ReportTimeUtils.todayDate().obs;
  final Rxn<DateTime> reportingFrom = Rxn<DateTime>();
  final Rxn<DateTime> reportingTo = Rxn<DateTime>();

  final RxBool isClassLoading = false.obs;
  final RxBool isStudentLoading = false.obs;
  final RxBool isQuestionsLoading = false.obs;
  final RxBool isExistingLoading = false.obs;
  final RxBool isSaving = false.obs;
  final RxInt saveDone = 0.obs;
  final RxInt saveTotal = 0.obs;
  final RxInt tick = 0.obs;

  final Map<String, StudentEvalDraft> drafts = {};
  int _loadToken = 0;

  void _changed() => tick.value++;

  int get questionCount => questions.length;

  String get selectedDateIso => ReportTimeUtils.todayIso(selectedDate.value);

  bool get isToday =>
      ReportTimeUtils.isSameDay(selectedDate.value, DateTime.now());

  bool get canGoNext => !isToday;

  String get dateLabel {
    if (isToday) return 'today_label'.tr;
    return DateFormat('EEE d MMM').format(selectedDate.value);
  }

  String get periodLabel {
    final from = reportingFrom.value ?? _monthStart(selectedDate.value);
    final to = reportingTo.value ?? selectedDate.value;
    return '${DateFormat('d MMM').format(from)} – ${DateFormat('d MMM').format(to)}';
  }

  List<EvalRatingOption> optionsFor(Questions question) {
    final palette = {for (final item in ratings) item.code: item};
    final fromApi = question.answerOptions;
    if (fromApi.isNotEmpty) {
      return fromApi.map((item) {
        final base = palette[item.code] ?? ratings.first;
        return base.withMeaning(item.label);
      }).toList();
    }
    final codes = question.optionCodes;
    final filtered =
        ratings.where((item) => codes.contains(item.code)).toList();
    return filtered.isEmpty ? ratings.toList() : filtered;
  }

  List<MapEntry<String, List<Questions>>> get questionGroups {
    final grouped = <String, List<Questions>>{};
    for (final question in questions) {
      final area = (question.area ?? question.description ?? '').trim();
      final key = area.isEmpty ? 'evaluation'.tr : area;
      grouped.putIfAbsent(key, () => []).add(question);
    }
    return grouped.entries.toList();
  }

  List<StudentData> get visibleStudents {
    final query = kidSearch.value.trim().toLowerCase();
    if (query.isEmpty) return studentList.toList();
    return studentList.where((student) {
      return studentName(student).toLowerCase().contains(query) ||
          (student.rollNumber ?? '').toLowerCase().contains(query);
    }).toList();
  }

  List<StudentEvalDraft> get readyDrafts {
    return drafts.values
        .where(
          (draft) =>
              !draft.locked &&
              draft.isComplete(questionCount) &&
              (draft.isDirty || !draft.hadExisting),
        )
        .toList();
  }

  int get kidsReady => readyDrafts.length;

  StudentEvalDraft draftOf(String slug) {
    return drafts.putIfAbsent(slug, () => StudentEvalDraft(slug));
  }

  String studentName(StudentData student) {
    return '${student.firstName ?? ''} ${student.lastName ?? ''}'.trim();
  }

  StudentData? studentBySlug(String slug) {
    return studentList.firstWhereOrNull((item) => item.slug == slug);
  }

  static DateTime _monthStart(DateTime date) => DateTime(date.year, date.month, 1);

  static String ratingCode(String? raw) {
    final value = (raw ?? '').trim().toUpperCase();
    if (value == 'A' || value == 'ACHIEVED') return 'A';
    if (value == 'D' || value == 'DEVELOPING') return 'D';
    if (value == 'E' || value == 'EMERGING') return 'E';
    return '';
  }

  Future<void> load(BuildContext context) async {
    _syncPeriod(selectedDate.value);
    await Future.wait([
      fetchClasses(context),
      loadQuestions(context),
    ]);
  }

  void _syncPeriod(DateTime date) {
    reportingFrom.value = _monthStart(date);
    reportingTo.value = date;
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
      debugPrint('Bulk evaluation classes error: $e');
    } finally {
      isClassLoading.value = false;
    }
  }

  Future<void> loadQuestions(BuildContext context) async {
    try {
      isQuestionsLoading.value = true;
      final response = await apiWorker.evaluationQuestionList(
        EvaluationQuestionRequest(lang: LanguageController.to.apiLanguage),
        context,
      );
      if (response?.success == true) {
        final sorted = List<Questions>.from(
          response?.data?.questions ?? <Questions>[],
        )..sort((a, b) => (a.sortOrder ?? 0).compareTo(b.sortOrder ?? 0));
        questions.assignAll(sorted);
        for (final draft in drafts.values) {
          for (final question in sorted) {
            final questionId = question.id ?? '';
            if (questionId.isEmpty) continue;
            final selected = draft.answers[questionId];
            if (selected != null &&
                !question.optionCodes.contains(selected)) {
              draft.answers.remove(questionId);
            }
          }
        }
        _changed();
      } else {
        questions.clear();
        if (context.mounted) {
          showToast(
            context,
            'Error',
            response?.message ?? 'Failed to load questions',
            type: ToastificationType.error,
          );
        }
      }
    } catch (e) {
      debugPrint('Bulk evaluation questions error: $e');
      questions.clear();
    } finally {
      isQuestionsLoading.value = false;
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
      lastDate: ReportTimeUtils.todayDate(),
      builder: buildAppDatePickerThemeBuilder(
        context,
        primaryColor: primaryColor,
      ),
    );
    if (picked == null || !context.mounted) return;
    await setDate(context, picked);
  }

  Future<void> pickPeriodDate(BuildContext context, {required bool isStart}) async {
    final currentFrom = reportingFrom.value ?? _monthStart(selectedDate.value);
    final currentTo = reportingTo.value ?? selectedDate.value;
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? currentFrom : currentTo,
      firstDate: isStart ? DateTime(2020) : currentFrom,
      lastDate: ReportTimeUtils.todayDate(),
      builder: buildAppDatePickerThemeBuilder(
        context,
        primaryColor: primaryColor,
      ),
    );
    if (picked == null) return;
    final next = ReportTimeUtils.dateOnly(picked);
    if (isStart) {
      reportingFrom.value = next;
      if (currentTo.isBefore(next)) reportingTo.value = next;
    } else {
      reportingTo.value = next;
    }
    _changed();
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
    final next = ReportTimeUtils.dateOnly(date);
    if (ReportTimeUtils.isSameDay(next, selectedDate.value)) return;
    selectedDate.value = next;
    _syncPeriod(next);
    expandedSlug.value = null;
    _resetDrafts();
    await loadExisting(context);
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
      debugPrint('Bulk evaluation students error: $e');
    } finally {
      isStudentLoading.value = false;
    }

    if (!context.mounted) return;
    await loadExisting(context);
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

  Future<void> loadExisting(BuildContext context) async {
    final token = ++_loadToken;
    final classSlug = selectedClass.value?.slug ?? '';
    if (classSlug.isEmpty || studentList.isEmpty) {
      isExistingLoading.value = false;
      return;
    }

    isExistingLoading.value = true;
    try {
      final response = await apiWorker.evaluationFormsList(
        EvaluationFormsListRequest(
          lang: LanguageController.to.apiLanguage,
          classSlug: classSlug,
          startDate: selectedDateIso,
          endDate: selectedDateIso,
          page: 1,
          limit: 100,
        ),
        context,
      );
      if (token != _loadToken) return;

      final bySlug = <String, String>{};
      final statusBySlug = <String, String>{};
      for (final item in response?.data?.evaluations ?? []) {
        final slug = item.studentSlug ?? '';
        final id = item.id ?? '';
        if (slug.isEmpty || id.isEmpty) continue;
        bySlug[slug] = id;
        statusBySlug[slug] = (item.status ?? '').toUpperCase();
      }

      for (final student in studentList) {
        final slug = student.slug ?? '';
        if (slug.isEmpty) continue;
        final draft = draftOf(slug);
        final existingId = bySlug[slug];
        draft.existingId = existingId;
        draft.hadExisting = existingId != null;
        draft.status = statusBySlug[slug] ?? '';
        draft.locked = draft.status == 'APPROVED';
        draft.answersLoaded = false;
        draft.answers.clear();
        draft.originalAnswers.clear();
      }

      final ids = bySlug.entries.toList();
      const batchSize = 3;
      for (var i = 0; i < ids.length; i += batchSize) {
        if (token != _loadToken || !context.mounted) return;
        final chunk = ids.skip(i).take(batchSize);
        await Future.wait(
          chunk.map(
            (entry) => _loadDetail(context, entry.key, entry.value, token),
          ),
        );
      }
    } catch (e) {
      debugPrint('Bulk evaluation existing error: $e');
    } finally {
      if (token == _loadToken) {
        isExistingLoading.value = false;
        _changed();
      }
    }
  }

  Future<void> _loadDetail(
    BuildContext context,
    String slug,
    String evaluationId,
    int token,
  ) async {
    try {
      final response = await apiWorker.evaluationFormDetail(
        evaluationId,
        context,
        lang: LanguageController.to.apiLanguage,
      );
      if (token != _loadToken) return;
      if (response?.success != true) return;

      final draft = draftOf(slug);
      draft.answers.clear();
      for (final answer in response?.data?.answers ?? []) {
        final questionId = answer.questionId ?? '';
        final code = ratingCode(answer.ratingCode ?? answer.rating);
        if (questionId.isEmpty || code.isEmpty) continue;
        draft.answers[questionId] = code;
      }
      draft.setOriginalFromCurrent();
      draft.answersLoaded = true;
    } catch (e) {
      debugPrint('Bulk evaluation detail error ($slug): $e');
    }
  }

  Future<void> toggleExpanded(BuildContext context, String slug) async {
    if (expandedSlug.value == slug) {
      expandedSlug.value = null;
      return;
    }
    expandedSlug.value = slug;
  }

  void selectAnswer(String slug, String questionId, String code) {
    final draft = draftOf(slug);
    if (draft.locked) return;
    if (draft.answers[questionId] == code) {
      draft.answers.remove(questionId);
    } else {
      draft.answers[questionId] = code;
    }
    _changed();
  }

  bool validate(BuildContext context) {
    if (selectedClass.value == null) {
      showToast(
        context,
        'Error',
        'pick_class_first'.tr,
        type: ToastificationType.error,
      );
      return false;
    }
    if (questionCount == 0) {
      showToast(
        context,
        'Error',
        'Failed to load questions',
        type: ToastificationType.error,
      );
      return false;
    }
    if (readyDrafts.isEmpty) {
      showToast(
        context,
        'Error',
        'please_complete_one_eval'.tr,
        type: ToastificationType.error,
      );
      return false;
    }
    return true;
  }

  Future<void> submit(BuildContext context) async {
    if (!validate(context)) return;

    final targets = readyDrafts.toList();
    isSaving.value = true;
    saveDone.value = 0;
    saveTotal.value = targets.length;

    var ok = 0;
    var fail = 0;
    final from = reportingFrom.value ?? _monthStart(selectedDate.value);
    final to = reportingTo.value ?? selectedDate.value;

    try {
      for (final draft in targets) {
        try {
          final response = await apiWorker.saveEvaluationForm(
            SaveEvaluationRequest(
              lang: LanguageController.to.apiLanguage,
              studentSlug: draft.slug,
              evaluationDate: selectedDateIso,
              reportingFromDate: ReportTimeUtils.todayIso(from),
              reportingToDate: ReportTimeUtils.todayIso(to),
              status: 'SUBMITTED',
              teacherNote: '',
              answers: questions
                  .where((question) => (question.id ?? '').isNotEmpty)
                  .map(
                    (question) => SaveEvaluationAnswer(
                      questionId: question.id,
                      rating: draft.answers[question.id],
                    ),
                  )
                  .toList(),
            ),
            context,
          );
          if (response?.success == true) {
            ok++;
            draft.hadExisting = true;
            draft.existingId = response?.data?.id ?? draft.existingId;
            draft.status = 'SUBMITTED';
            draft.setOriginalFromCurrent();
          } else {
            fail++;
            if (context.mounted) {
              showToast(
                context,
                'Error',
                response?.message ?? 'Failed to submit evaluation',
                type: ToastificationType.error,
              );
            }
          }
        } catch (e) {
          fail++;
          debugPrint('Bulk evaluation save error (${draft.slug}): $e');
        }
        saveDone.value++;
      }

      if (!context.mounted) return;
      if (ok > 0 && fail == 0) {
        showToast(context, 'Success', 'saved_evaluations'.tr);
        if (Get.isBottomSheetOpen ?? false) Get.back();
      } else if (ok > 0) {
        showToast(
          context,
          'Success',
          'partial_save'.trParams({'ok': '$ok', 'fail': '$fail'}),
        );
        if (Get.isBottomSheetOpen ?? false) Get.back();
      } else {
        showToast(
          context,
          'Error',
          'failed_to_save_log'.tr,
          type: ToastificationType.error,
        );
      }
    } finally {
      isSaving.value = false;
      _changed();
    }
  }
}
