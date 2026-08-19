import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';
import 'package:unicorn/service/api_service/api_worker.dart';
import 'package:unicorn/service/session/session_helper.dart';

import '../../../../../../../../../translation/language_controller.dart';
import '../../../../../../../../../widget/common_toastification.dart';
import '../../../../../../../../teacher/teacher_bottom_tab/view/screens/kids/model/student_by_slug/student_by_slug_request.dart';
import '../../../../../../../../teacher/teacher_bottom_tab/view/screens/kids/model/student_by_slug/student_by_slug_response.dart';
import '../model/add_student_leave/student_leave_request.dart';
import '../model/student_leave_listing/student_leave_listing_request.dart';
import '../model/student_leave_listing/student_leave_listing_response.dart';

class StudentLeaveController extends GetxController {
  final ApiWorker apiWorker = Get.put(ApiWorker());

  RxBool isLoading = false.obs;
  RxBool isAddLoading = false.obs;
  RxList<Datum> leaveList = <Datum>[].obs;

  String? studentId;
  String? studentSlug;

  Future<bool> _ensureStudentContext(BuildContext context) async {
    if (studentId != null && studentId!.isNotEmpty) return true;

    try {
      final loginResponse = await SessionHelper().getLoginResponse();
      final String? parentSlug = loginResponse?.data?.user?.slug;
      if (parentSlug == null || parentSlug.isEmpty) {
        throw Exception("Parent slug not found");
      }

      final parentResponse = await apiWorker.parentBySlug(parentSlug, context);
      final students = parentResponse?.data?.students ?? [];
      if (students.isEmpty) {
        throw Exception("Student not found");
      }

      studentSlug = students.first.studentSlug;
      if (studentSlug == null || studentSlug!.isEmpty) {
        throw Exception("Student slug not found");
      }

      final StudentBySlugResponse? studentResponse =
          await apiWorker.studentBySlug(
        StudentBySlugRequest(lang: LanguageController.to.apiLanguage),
        context,
        studentSlug!,
      );

      studentId = studentResponse?.data?.studentId;
      if (studentId == null || studentId!.isEmpty) {
        throw Exception("Student id not found");
      }

      return true;
    } catch (e) {
      debugPrint("Student context error: $e");
      return false;
    }
  }

  Future<void> studentLeaveListing(BuildContext context) async {
    try {
      isLoading.value = true;

      final ok = await _ensureStudentContext(context);
      if (!ok) {
        leaveList.clear();
        return;
      }

      StudentLeaveListingRequest request = StudentLeaveListingRequest(
        lang: LanguageController.to.apiLanguage,
        endDate: "",
        search: "",
        startDate: "",
        status: "",
        leaveType: "",
        studentId: studentId,
      );

      final response =
          await apiWorker.studentLeaveListing(request, "", context);

      if (response != null && response.success == true) {
        leaveList.value = response.data?.data ?? [];
      } else {
        leaveList.clear();
      }
    } catch (e) {
      debugPrint("Student Leave List Error: $e");
      leaveList.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addStudentLeave({
    required BuildContext context,
    required String type,
    required String fromDate,
    required String toDate,
    required String description,
  }) async {
    try {
      isAddLoading.value = true;

      final ok = await _ensureStudentContext(context);
      if (!ok) {
        showToast(
          context,
          "Error",
          "Student not found",
          type: ToastificationType.error,
        );
        return;
      }

      AddStudentLeaveRequest request = AddStudentLeaveRequest(
        lang: LanguageController.to.apiLanguage,
        studentId: studentId,
        studentSlug: studentSlug,
        leaveType: type,
        fromDate: fromDate,
        toDate: toDate,
        description: description,
      );

      final response = await apiWorker.addStudentLeave(request, "", context);

      if (response != null && response.success == true) {
        Get.back();
        showToast(
          context,
          "Success",
          response.message ?? "Leave added successfully",
          type: ToastificationType.success,
        );
      } else {
        showToast(
          context,
          "Error",
          response?.message ?? "Something went wrong",
          type: ToastificationType.error,
        );
      }
    } catch (e) {
      debugPrint("Add Student Leave Error: $e");
      showToast(
        context,
        "Error",
        "Failed to add leave",
        type: ToastificationType.error,
      );
    } finally {
      isAddLoading.value = false;
    }
  }
}
