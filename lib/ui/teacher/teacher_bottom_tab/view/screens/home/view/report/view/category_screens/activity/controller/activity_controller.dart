import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';

import '../../../../../../../../../../../../core/utils/report_time_utils.dart';
import '../../../../../../../../../../../../service/api_service/api_worker.dart';
import '../../../../../../../../../../../../translation/language_controller.dart';
import '../../../../../../../../../../../../widget/common_toastification.dart';
import '../model/activity_listing/activity_listing_request.dart';
import '../model/activity_listing/activity_listing_response.dart';
import '../model/add_activity/add_activity_request.dart';

class ActivityController extends GetxController {
  final ApiWorker apiWorker = Get.put(ApiWorker());

  RxBool isLoading = false.obs;

  Future<void> createActivity(
    BuildContext context,
    String slug, {
    required String activity,
    required String date,
    required String startTime,
    required String endTime,
    required String description,
  }) async {
    try {
      /// ================= VALIDATION =================

      if (activity.isEmpty) {
        showAppSnackbar("Error", "Please select activity");
        return;
      }

      if (date.isEmpty) {
        showAppSnackbar("Error", "Please select date");
        return;
      }

      if (startTime.isEmpty) {
        showAppSnackbar("Error", "Please select start time");
        return;
      }

      if (endTime.isEmpty) {
        showAppSnackbar("Error", "Please select end time");
        return;
      }

      /// Validate Start < End
      DateTime start = DateFormat("hh:mm a").parse(startTime);
      DateTime end = DateFormat("hh:mm a").parse(endTime);

      if (!end.isAfter(start)) {
        showAppSnackbar("Error", "End time must be after start time");
        return;
      }

      isLoading.value = true;

      /// Map UI value → API ENUM
      String apiActivity = _mapActivityToApi(activity);
      final parsedDate = DateFormat("d-M-yyyy").parse(date);
      final formattedDate = DateFormat("yyyy-MM-dd").format(parsedDate);

      final response = await apiWorker.createActivityApi(
        AddActivityRequest(
          activity: apiActivity,
          startTime: startTime,
          endTime: endTime,
          description: description,
          lang: LanguageController.to.apiLanguage,
          date: formattedDate,
        ),
        context,
        slug,
      );

      if (response?.success == true) {
        showToast(
          context,
          "Success",
          response?.message ?? "Activity created successfully",
          type: ToastificationType.success,
        );

        Get.back();
      } else {
        showToast(
          context,
          "Error",
          response?.message ?? "Failed to create activity",
          type: ToastificationType.error,
        );
      }
    } catch (e) {
      debugPrint("Create Activity Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// ================= MAP UI TEXT TO API ENUM =================
  String _mapActivityToApi(String activity) {
    switch (activity) {
      case "PE":
        return "PE";
      case "CIRCLE_TIME":
        return "CIRCLE_TIME";
      case "MISS_PLAY":
        return "MISS_PLAY";
      case "STORY_TIME":
        return "STORY_TIME";
      case "DAILY_ACTIVITY":
        return "DAILY_ACTIVITY";
      case "ARABIC_AND_ISLAMIC":
        return "ARABIC_AND_ISLAMIC";
      case "OTHERS":
        return "OTHERS";
      default:
        return "OTHERS";
    }
  }

  /// ================= LIST DATA =================
  RxList<ActivityList> activityList = <ActivityList>[].obs;

  /// ================= FETCH ACTIVITY LIST =================
  Future<void> fetchActivityList(BuildContext context, String slug,
      {String? date}) async {
    try {
      isLoading.value = true;
      final response = await apiWorker.activityListingApi(
        ActivityListingRequest(
          lang: LanguageController.to.apiLanguage,
          date: ReportTimeUtils.resolveIsoDate(date),
        ),
        context,
        slug,
      );

      if (response?.success == true) {
        activityList.value = response?.data?.activity ?? [];
      } else {
        showAppSnackbar(
            "Error", response?.message ?? "Failed to load activities");
      }
    } catch (e) {
      debugPrint("Fetch Activity Error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
