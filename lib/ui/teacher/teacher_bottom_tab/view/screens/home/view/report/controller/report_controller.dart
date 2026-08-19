import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';
import 'package:unicorn/service/api_service/api_worker.dart';

import '../../../../../../../../../core/utils/report_display_utils.dart';
import '../../../../../../../../../core/utils/report_time_utils.dart';
import '../../../../../../../../../translation/language_controller.dart';
import '../../../../../../../../../widget/common_toastification.dart';
import '../../../../profile/model/get_all_class/get_all_class_request.dart';
import '../../../../profile/model/get_all_class/get_all_class_response.dart';
import '../../add_post/mode/list_student_by_class/list_student_by_class_request.dart';
import '../../add_post/mode/list_student_by_class/list_student_by_class_response.dart';
import '../model/mood_update/mood_update_request.dart';
import '../model/notes/add_notes/add_notes_request.dart';
import '../model/notes/notes_list/notes_list_request.dart';
import '../model/notes/notes_list/notes_list_response.dart';
import '../model/report_details_by_student_slug/report_details_by_student_slug_request.dart';
import '../model/report_details_by_student_slug/report_details_by_student_slug_response.dart';
import '../model/teacher_holiday_event_list/teacher_holiday_event_list_request.dart';
import '../model/teacher_holiday_event_list/teacher_holiday_event_list_response.dart';

class ReportController extends GetxController {
  final ApiWorker apiWorker = Get.put(ApiWorker());

  RxBool isLoading = false.obs;
  RxBool isLoadMore = false.obs;

  RxList<TeacherHolidayListElement> eventList =
      <TeacherHolidayListElement>[].obs;

  int page = 1;
  int limit = 10;
  bool hasMore = true;

  /// ================= INITIAL LOAD =================
  Future<void> teacherHolidayEventListing(BuildContext context,
      {bool isRefresh = false}) async {
    try {
      if (isRefresh) {
        page = 1;
        hasMore = true;
      }

      if (!hasMore) return;

      if (page == 1) {
        isLoading.value = true;
      } else {
        isLoadMore.value = true;
      }

      TeacherHolidayEventListRequest request = TeacherHolidayEventListRequest(
        lang: LanguageController.to.apiLanguage,
        sort: "ASC",
        page: page,
        limit: limit,
        search: "",
        type: "",
        startDate: "",
        endDate: "",
      );

      final response =
          await apiWorker.holidayEventListResponse(request, context);

      if (response != null && response.success == true) {
        final newList = response.data?.list ?? [];

        if (page == 1) {
          eventList.assignAll(newList);
        } else {
          eventList.addAll(newList);
        }

        if (newList.length < limit) {
          hasMore = false;
        } else {
          page++;
        }
      }
    } catch (e) {
      debugPrint("Holiday Event Error: $e");
    } finally {
      isLoading.value = false;
      isLoadMore.value = false;
    }
  }

  Rxn<Class> selectedClass = Rxn<Class>();
  RxList<Class> classList = <Class>[].obs;
  RxBool isClassLoading = false.obs;

  Future<void> fetchClasses(BuildContext context) async {
    try {
      isClassLoading.value = true;

      final response = await apiWorker.getAllClassApi(
        GetAllClassRequest(
            page: 1, limit: 100, lang: LanguageController.to.apiLanguage),
        context,
      );

      if (response?.success == true) {
        classList.assignAll(response?.data?.classes ?? []);
      }
    } finally {
      isClassLoading.value = false;
    }
  }

  void selectClass(Class value) {
    selectedClass.value = value;
  }

  RxBool isStudentLoading = false.obs;
  RxList<StudentData> studentList = <StudentData>[].obs;
  RxList<StudentData> selectedStudents = <StudentData>[].obs;
TextEditingController searchController = TextEditingController();
  Future<void> fetchStudentsByClass(BuildContext context) async {
    studentList.clear();
    if (selectedClass.value == null) {
      showToast(
        context,
        "Error",
        "Please select class first",
        type: ToastificationType.error,
      );
      return;
    }

    try {
      isStudentLoading.value = true;

      final response = await apiWorker.listStudentByClassApi(
        ListStudentByClassRequest(
            page: 1, limit: 100, lang: LanguageController.to.apiLanguage ,search:searchController.text ),
        context,
        selectedClass.value!.slug ?? "",
      );

      if (response?.success == true) {
        studentList.assignAll(response?.data?.students ?? []);
      } else {
        print(response?.message);
      }
    } catch (e) {
      print(e);
    } finally {
      isStudentLoading.value = false;
    }
  }

  RxBool isReportDetailsLoading = false.obs;
  Rxn<StudentReportDetailsData> studentDetails =
      Rxn<StudentReportDetailsData>();
  Rx<DateTime> selectedDate = ReportTimeUtils.todayDate().obs;

  String get selectedDateIso => ReportTimeUtils.todayIso(selectedDate.value);

  Future<void> studentDetailsBySlug(BuildContext context, String slug,
      {String? date}) async {
    try {
      isReportDetailsLoading.value = true;
      final resolvedDate = (date != null && date.trim().isNotEmpty)
          ? ReportTimeUtils.resolveIsoDate(date)
          : selectedDateIso;

      final response = await apiWorker.reportStudentDetails(
        ReportDetailsByStudentSlugRequest(
          lang: LanguageController.to.apiLanguage,
          date: resolvedDate,
        ),
        context,
        slug,
      );
      if (response?.success == true) {
        studentDetails.value = response?.data;

        /// 🔥 update moods when date changes
        setInitialMoods(
          response?.data?.todaysMood?.mood ?? [],
        );
      } else {
        showToast(
          context,
          "Error",
          response?.message ?? "Failed to load report",
          type: ToastificationType.error,
        );
      }
    } catch (e) {
      debugPrint("Student Details Error: $e");
    } finally {
      isReportDetailsLoading.value = false;
    }
  }

  RxBool isAddNotesLoading = false.obs;

  Future<void> addNotes(
    BuildContext context,
    String slug,
    String content,
  ) async {
    if (content.trim().isEmpty) {
      showToast(
        context,
        "Error",
        "Please enter notes",
        type: ToastificationType.error,
      );
      return;
    }

    try {
      isAddNotesLoading.value = true;
      final formattedDate = selectedDateIso;

      final response = await apiWorker.addNotesApi(
        AddNotesRequest(
          lang: LanguageController.to.apiLanguage,
          content: content.trim(),
          date: formattedDate,
        ),
        context,
        slug,
      );

      if (response?.success == true) {
        showToast(
          context,
          "Success",
          response?.message ?? "Notes added successfully",
          type: ToastificationType.success,
        );

        Get.back(); // Close dialog
      } else {
        showToast(
          context,
          "Error",
          response?.message ?? "Failed to add notes",
          type: ToastificationType.error,
        );
      }
    } catch (e) {
      debugPrint("Add Notes Error: $e");
    } finally {
      isAddNotesLoading.value = false;
    }
  }

  RxList<NoteList> notesList = <NoteList>[].obs;

  Future<void> fetchNotes(
    BuildContext context,
    String slug,
    {String? date}
  ) async {
    try {
      isLoading.value = true;

      final response = await apiWorker.notesListingApi(
        NotesListRequest(
          lang: LanguageController.to.apiLanguage,
          date: (date != null && date.trim().isNotEmpty)
              ? ReportTimeUtils.resolveIsoDate(date)
              : selectedDateIso,
        ),
        context,
        slug,
      );

      if (response?.success == true) {
        notesList.value = response?.data?.notes ?? [];
      } else {
        showAppSnackbar("Error", response?.message ?? "Failed to load notes");
      }
    } catch (e) {
      debugPrint("Notes Fetch Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  RxList<String> selectedMoods = <String>[].obs;
  RxBool isMoodUpdating = false.obs;

  /// initialize moods from API
  void setInitialMoods(List<String> moods) {
    selectedMoods.assignAll(
      moods
          .map(ReportDisplayUtils.moodKey)
          .where((key) => key.isNotEmpty)
          .toSet()
          .toList(),
    );
  }

  /// toggle mood + auto update API
  Future<void> toggleMood(
      BuildContext context,
      String slug,
      String moodKey,
      ) async {
    if (isMoodUpdating.value) return; // prevent multiple taps

    try {
      isMoodUpdating.value = true;

      /// 🔥 Create temp list (DO NOT update UI yet)
      List<String> updatedMoods = List<String>.from(selectedMoods);
      if (updatedMoods.contains(moodKey) && updatedMoods.length == 1) {
        updatedMoods.clear();
      } else {
        updatedMoods = [moodKey];
      }

      final formattedDate = selectedDateIso;

      final response = await apiWorker.moodUpdateApi(
        MoodUpdateRequest(
          mood: updatedMoods.map((e) => e.toUpperCase()).toList(),
          lang: LanguageController.to.apiLanguage,
          date: formattedDate,
        ),
        context,
        slug,
      );

      if (response?.success == true) {
        /// ✅ Update UI ONLY after success
        selectedMoods.assignAll(updatedMoods);
      } else {
        showToast(
          context,
          "Error",
          response?.message ?? "Failed to update mood",
          type: ToastificationType.error,
        );
      }
    } catch (e) {
      debugPrint("Mood Update Error: $e");
    } finally {
      isMoodUpdating.value = false;
    }
  }

  @override
  void onClose() {
    searchController.clear();
    super.onClose();
  }
}
