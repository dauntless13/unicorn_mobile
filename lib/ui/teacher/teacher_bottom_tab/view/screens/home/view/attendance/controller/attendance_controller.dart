import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';

import '../../../../../../../../../service/api_service/api_worker.dart';
import '../../../../../../../../../translation/language_controller.dart';
import '../../../../../../../../../widget/common_toastification.dart';
import '../../../../profile/model/get_all_class/get_all_class_request.dart';
import '../../../../profile/model/get_all_class/get_all_class_response.dart';
import '../../add_post/mode/list_student_by_class/list_student_by_class_request.dart';
import '../../add_post/mode/list_student_by_class/list_student_by_class_response.dart';
import '../../report/model/teacher_holiday_event_list/teacher_holiday_event_list_request.dart';
import '../../report/model/teacher_holiday_event_list/teacher_holiday_event_list_response.dart';
import '../model/mark_attendance/mark_attendance_request.dart';

class AttendanceController extends GetxController {
  final ApiWorker apiWorker = Get.put(ApiWorker());

  Rxn<Class> selectedClass = Rxn<Class>();
  RxList<Class> classList = <Class>[].obs;
  RxBool isClassLoading = false.obs;

  RxBool isStudentLoading = false.obs;
  RxList<StudentData> studentList = <StudentData>[].obs;
  RxMap<String, String> attendanceStatus = <String, String>{}.obs;
  RxString activeAttendanceStudentId = ''.obs;
  RxBool isHolidayToday = false.obs;
  RxString activeHolidayName = ''.obs;
  final TextEditingController searchController = TextEditingController();

  Future<void> fetchHolidayStatus(BuildContext context) async {
    try {
      final response = await apiWorker.holidayEventListResponse(
        TeacherHolidayEventListRequest(
          lang: LanguageController.to.apiLanguage,
          sort: "ASC",
          page: 1,
          limit: 100,
          search: "",
          type: "HOLIDAY",
          startDate: "",
          endDate: "",
        ),
        context,
      );

      final holidays = response?.data?.list ?? <TeacherHolidayListElement>[];
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      TeacherHolidayListElement? activeHoliday;
      for (final holiday in holidays) {
        final start = _parseDateOnly(holiday.startDate);
        if (start == null) continue;

        final end = _parseDateOnly(holiday.endDate) ?? start;
        if (!today.isBefore(start) && !today.isAfter(end)) {
          activeHoliday = holiday;
          break;
        }
      }

      isHolidayToday.value = activeHoliday != null;
      activeHolidayName.value = activeHoliday?.name ?? '';
    } catch (e) {
      debugPrint("Holiday Status Error: $e");
      isHolidayToday.value = false;
      activeHolidayName.value = '';
    }
  }

  DateTime? _parseDateOnly(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;

    try {
      final value = raw.trim();
      final datePortion = value.split('T').first.split(' ').first;

      final dashParts = datePortion.split('-');
      if (dashParts.length == 3) {
        if (dashParts[0].length == 2) {
          return DateTime(
            int.parse(dashParts[2]),
            int.parse(dashParts[1]),
            int.parse(dashParts[0]),
          );
        }

        if (dashParts[0].length == 4) {
          return DateTime(
            int.parse(dashParts[0]),
            int.parse(dashParts[1]),
            int.parse(dashParts[2]),
          );
        }
      }

      final slashParts = datePortion.split('/');
      if (slashParts.length == 3) {
        if (slashParts[2].length == 4) {
          return DateTime(
            int.parse(slashParts[2]),
            int.parse(slashParts[1]),
            int.parse(slashParts[0]),
          );
        }
      }

      final parsed = DateTime.parse(value).toLocal();
      return DateTime(parsed.year, parsed.month, parsed.day);
    } catch (_) {
      return null;
    }
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
      }
    } finally {
      isClassLoading.value = false;
    }
  }

  void selectClass(Class value) {
    selectedClass.value = value;
  }

  bool _hasAttendanceValue(String? value) {
    final normalized = value?.trim().toLowerCase() ?? '';
    if (normalized.isEmpty ||
        normalized == 'false' ||
        normalized == 'null' ||
        normalized == '0') {
      return false;
    }
    return true;
  }

  String _resolveAttendanceStatus(StudentData student) {
    final hasCheckIn = _hasAttendanceValue(student.checkIn);
    final hasCheckOut = _hasAttendanceValue(student.checkOut);

    if (hasCheckIn && hasCheckOut) return "checkout";
    if (hasCheckIn) return "checkin";
    return "";
  }

  Future<void> fetchStudentsByClass(BuildContext context) async {
    if (selectedClass.value == null) {
      showAppSnackbar("Error", "Please select class first");
      return;
    }

    try {
      isStudentLoading.value = true;
      studentList.clear();
      attendanceStatus.clear();

      final response = await apiWorker.listStudentByClassApi(
        ListStudentByClassRequest(
            page: 1,
            limit: 100,
            lang: LanguageController.to.apiLanguage,
            search: searchController.text),
        context,
        selectedClass.value!.slug ?? "",
      );

      if (response?.success == true && response?.data?.students != null) {
        studentList.assignAll(response!.data!.students!);

        for (final student in studentList) {
          final id = student.id ?? "";
          attendanceStatus[id] = _resolveAttendanceStatus(student);
        }
        attendanceStatus.refresh();
      } else {
        showAppSnackbar("Error", response?.message ?? "No students found");
      }
    } catch (e) {
      showAppSnackbar("Error", e.toString());
    } finally {
      isStudentLoading.value = false;
    }
  }

  Future<void> markAttendance({
    required BuildContext context,
    required StudentData student,
    required bool checkIn,
    required bool checkOut,
  }) async {
    if (isHolidayToday.value) {
      showToast(
        context,
        activeHolidayName.value.isNotEmpty
            ? "${activeHolidayName.value} holiday"
            : "Attendance disabled on holidays",
        "",
        type: ToastificationType.info,
      );
      return;
    }

    final id = student.id ?? "";
    if (selectedClass.value == null) return;

    final currentStatus = attendanceStatus[id] ?? "";

    if (checkIn &&
        (currentStatus == "checkin" || currentStatus == "checkout")) {
      showToast(
        context,
        "Already checked in",
        "",
        type: ToastificationType.info,
      );
      return;
    }

    if (checkOut && currentStatus == "checkout") {
      showToast(
        context,
        "Already checked out",
        "",
        type: ToastificationType.info,
      );
      return;
    }

    if (checkOut && currentStatus != "checkin") {
      showToast(
        context,
        "Please check-in first",
        "",
        type: ToastificationType.error,
      );
      return;
    }

    try {
      activeAttendanceStudentId.value = id;
      final formatted = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
          .format(DateTime.now().toUtc());

      final response = await apiWorker.markAttendanceApi(
        MarkAttendanceRequest(
          classId: selectedClass.value!.id,
          studentId: student.id,
          checkIn: checkIn,
          checkOut: checkOut,
          status: "PRESENT",
          lang: LanguageController.to.apiLanguage,
          checkInTime: checkIn ? formatted : '',
          checkOutTime: checkOut ? formatted : '',
        ),
        context,
        selectedClass.value!.slug ?? "",
      );

      final isSuccess = response?.success == true ||
          response?.success.toString().toLowerCase() == 'true';

      if (!isSuccess) {
        showToast(
          context,
          response?.message?.toString() ?? "Failed",
          "",
          type: ToastificationType.error,
        );
        return;
      }

      attendanceStatus[id] = checkIn ? "checkin" : "checkout";
      attendanceStatus.refresh();
      await fetchStudentsByClass(context);
    } catch (e) {
      showToast(
        context,
        e.toString(),
        "",
        type: ToastificationType.error,
      );
    } finally {
      activeAttendanceStudentId.value = '';
    }
  }

  String formatDate(String input) {
    final parsed = DateTime.parse(input);
    return DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(parsed.toUtc());
  }

  @override
  void onClose() {
    searchController.clear();
    super.onClose();
  }
}
