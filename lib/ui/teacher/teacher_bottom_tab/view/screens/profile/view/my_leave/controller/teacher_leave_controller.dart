import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';
import 'package:unicorn/service/api_service/api_worker.dart';

import '../../../../../../../../../translation/language_controller.dart';
import '../../../../../../../../../widget/common_toastification.dart';
import '../model/add_teacher_leave/add_teacher_leave_request.dart';
import '../model/teacher_leave_list/teacher_leave_list_request.dart';
import '../model/teacher_leave_list/teacher_leave_list_response.dart';

class TeacherLeaveController extends GetxController {
  final ApiWorker apiWorker = Get.put(ApiWorker());

  RxBool isLoading = false.obs;
  RxList<TeacherLeaveListData> leaveList = <TeacherLeaveListData>[].obs;

  Future<void> teacherLeaveListing(BuildContext context) async {
    try {
      isLoading.value = true;

      TeacherLeaveListRequest request = TeacherLeaveListRequest(
        lang: LanguageController.to.apiLanguage,
        endDate: "",
        search: "",
        startDate: "",
        status: "",
        leaveType: "",
        studentId: "",
      );

      final response = await apiWorker.teacherLiveListingApi(request, context);

      if (response != null && response.success == true) {
        /// 🔥 FIX HERE
        leaveList.value = response.data?.data ?? [];
      } else {
        leaveList.clear();
      }
    } catch (e) {
      debugPrint("Leave List Error: $e");
      leaveList.clear();
    } finally {
      isLoading.value = false;
    }
  }

  /// ======================================================
  /// 🔹 ADD TEACHER LEAVE
  /// ======================================================
  RxBool isAddLoading = false.obs;

  Future<void> addTeacherLeave({
    required BuildContext context,
    required String type,
    required String fromDate,
    required String toDate,
    required String description,
  }) async {
    try {
      isAddLoading.value = true;

      AddTeacherLeaveRequest request = AddTeacherLeaveRequest(
        lang: LanguageController.to.apiLanguage,
        type: type,
        fromDate: fromDate,
        toDate: toDate,
        description: description,
      );

      print(request.toJson());

      final response = await apiWorker.addTeacherLeave(request, context);

      if (response != null && response.success == true) {
        /// ✅ Success
        Get.back();
        showToast(
          context,
          "Success",
          response.message ?? "Leave added successfully",
          type: ToastificationType.success,
        );
      } else {
        /// ❌ API returned success = false
        showToast(
          context,
          "Error",
          response?.message ?? "Something went wrong",
          type: ToastificationType.error,
        );
      }
    } catch (e) {
      debugPrint("Add Leave Error: $e");

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
