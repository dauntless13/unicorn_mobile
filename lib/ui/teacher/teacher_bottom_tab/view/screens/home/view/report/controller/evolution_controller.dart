import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';

import '../../../../../../../../../service/api_service/api_worker.dart';
import '../../../../../../../../../translation/language_controller.dart';
import '../../../../../../../../../widget/common_toastification.dart';
import '../model/evaluation_area/evaluation_area_request.dart';
import '../model/evaluation_area/evaluation_area_response.dart';
import '../model/evaluation_forms_list/evaluation_forms_list_request.dart';
import '../model/evaluation_forms_list/evaluation_forms_list_response.dart';
import '../model/evaluation_question/evaluation_question_request.dart';
import '../model/evaluation_question/evaluation_question_response.dart';
import '../model/save_evaluation/save_evaluation_request.dart';

class EvolutionController extends GetxController {
  final ApiWorker apiWorker = Get.put(ApiWorker());

  final RxBool isLoading = false.obs;
  final RxBool isFormsLoading = false.obs;
  final RxBool isSubmitting = false.obs;

  final RxList<Areas> areas = <Areas>[].obs;
  final RxList<Questions> questions = <Questions>[].obs;
  final RxList<Evaluations> forms = <Evaluations>[].obs;
  final RxMap<String, String> answers = <String, String>{}.obs;

  final RxInt currentQuestionIndex = 0.obs;
  final Rxn<DateTime> evaluationDate = Rxn<DateTime>();
  final Rxn<DateTime> reportingStartDate = Rxn<DateTime>();
  final Rxn<DateTime> reportingEndDate = Rxn<DateTime>();
  final Rxn<DateTime> formsStartDate = Rxn<DateTime>();
  final Rxn<DateTime> formsEndDate = Rxn<DateTime>();

  final RxString selectedFormStatus = 'SUBMITTED'.obs;

  final TextEditingController formsSearchController = TextEditingController();
  final TextEditingController teacherNoteController = TextEditingController();

  final int page = 1;
  final int limit = 10;

  Questions? get currentQuestion {
    if (questions.isEmpty) return null;
    final index = currentQuestionIndex.value;
    if (index < 0 || index >= questions.length) return null;
    return questions[index];
  }

  Areas? get currentArea {
    final questionArea = currentQuestion?.area;
    if (questionArea == null) return null;
    return areas.firstWhereOrNull((area) => area.area == questionArea);
  }

  double get progress {
    if (questions.isEmpty) return 0;
    return (currentQuestionIndex.value + 1) / questions.length;
  }

  bool get hasAllAnswers =>
      questions.isNotEmpty && answers.length == questions.length;

  String formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('yyyy-MM-dd').format(date);
  }

  String displayDate(DateTime? date) {
    if (date == null) return '-';
    return DateFormat('dd MMM yyyy').format(date);
  }

  void prepareNewEvaluation() {
    currentQuestionIndex.value = 0;
    answers.clear();
    teacherNoteController.clear();
    evaluationDate.value = DateTime.now();
    reportingStartDate.value = null;
    reportingEndDate.value = null;
  }

  Future<void> loadEvaluationData(BuildContext context) async {
    try {
      isLoading.value = true;

      final areaResponse = await apiWorker.evaluationAreaList(
        EvaluationAreaRequest(lang: LanguageController.to.apiLanguage),
        context,
      );
      final questionResponse = await apiWorker.evaluationQuestionList(
        EvaluationQuestionRequest(lang: LanguageController.to.apiLanguage),
        context,
      );

      if (areaResponse?.success == true) {
        areas.assignAll(areaResponse?.data?.areas ?? []);
      } else {
        showToast(
          context,
          "Error",
          areaResponse?.message ?? "Failed to load data",
          type: ToastificationType.error,
        );
      }

      if (questionResponse?.success == true) {
        final List<Questions> sortedQuestions = List<Questions>.from(
          questionResponse?.data?.questions ?? <Questions>[],
        )..sort((a, b) => (a.sortOrder ?? 0).compareTo(b.sortOrder ?? 0));
        questions.assignAll(sortedQuestions);
      } else {
        showToast(
          context,
          "Error",
          questionResponse?.message ?? "Failed to load questions",
          type: ToastificationType.error,
        );
      }
    } catch (e) {
      debugPrint("Evolution load error: $e");
      showToast(
        context,
        "Error",
        "Failed to load questions",
        type: ToastificationType.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchEvolutionForms(
    BuildContext context, {
    required String studentSlug,
    required String classSlug,
  }) async {
    try {
      isFormsLoading.value = true;

      final response = await apiWorker.evaluationFormsList(
        EvaluationFormsListRequest(
          lang: LanguageController.to.apiLanguage,
          status: selectedFormStatus.value,
          classSlug: classSlug,
          studentSlug: studentSlug,
          startDate: formatDate(formsStartDate.value),
          endDate: formatDate(formsEndDate.value),
          search: formsSearchController.text.trim(),
          page: page,
          limit: limit,
        ),
        context,
      );

      if (response?.success == true) {
        forms.assignAll(response?.data?.evaluations ?? []);
      } else {
        forms.clear();
        showToast(
          context,
          "Error",
          response?.message ?? "Failed to load evolution forms",
          type: ToastificationType.error,
        );
      }
    } catch (e) {
      debugPrint("Evolution forms error: $e");
      forms.clear();
      showToast(
        context,
        "Error",
        "Failed to load evolution forms",
        type: ToastificationType.error,
      );
    } finally {
      isFormsLoading.value = false;
    }
  }

  void selectAnswer(String questionId, String value) {
    answers[questionId] = value;
  }

  bool hasAnsweredCurrent() {
    final questionId = currentQuestion?.id;
    if (questionId == null) return false;
    return answers.containsKey(questionId);
  }

  String? selectedAnswerForCurrent() {
    final questionId = currentQuestion?.id;
    if (questionId == null) return null;
    return answers[questionId];
  }

  void goNext() {
    if (!hasAnsweredCurrent()) return;
    if (currentQuestionIndex.value < questions.length - 1) {
      currentQuestionIndex.value++;
    }
  }

  void goPrevious() {
    if (currentQuestionIndex.value > 0) {
      currentQuestionIndex.value--;
    }
  }

  Future<bool> submitEvaluation(
    BuildContext context, {
    required String studentSlug,
  }) async {
    evaluationDate.value ??= DateTime.now();

    if (reportingStartDate.value == null || reportingEndDate.value == null) {
      showToast(
        context,
        "Error",
        "Please select date range",
        type: ToastificationType.error,
      );
      return false;
    }

    if (!hasAllAnswers) {
      showToast(
        context,
        "Error",
        "Please answer all questions",
        type: ToastificationType.error,
      );
      return false;
    }

    try {
      isSubmitting.value = true;

      final response = await apiWorker.saveEvaluationForm(
        SaveEvaluationRequest(
          lang: LanguageController.to.apiLanguage,
          studentSlug: studentSlug,
          evaluationDate: formatDate(evaluationDate.value),
          reportingFromDate: formatDate(reportingStartDate.value),
          reportingToDate: formatDate(reportingEndDate.value),
          status: "SUBMITTED",
          teacherNote: teacherNoteController.text.trim(),
          answers: questions
              .where((question) => question.id != null)
              .map(
                (question) => SaveEvaluationAnswer(
                  questionId: question.id,
                  rating: answers[question.id],
                ),
              )
              .toList(),
        ),
        context,
      );

      if (response?.success == true) {
        showToast(
          context,
          "Success",
          response?.message ?? "Evaluation completed",
        );
        return true;
      }

      showToast(
        context,
        "Error",
        response?.message ?? "Failed to submit evaluation",
        type: ToastificationType.error,
      );
      return false;
    } catch (e) {
      debugPrint("Submit evaluation error: $e");
      showToast(
        context,
        "Error",
        "Failed to submit evaluation",
        type: ToastificationType.error,
      );
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  void onClose() {
    formsSearchController.dispose();
    teacherNoteController.dispose();
    super.onClose();
  }
}
