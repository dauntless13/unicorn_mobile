import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';

import '../../../../../../../../../../../../core/utils/report_time_utils.dart';
import '../../../../../../../../../../../../service/api_service/api_worker.dart';
import '../../../../../../../../../../../../translation/language_controller.dart';
import '../../../../../../../../../../../../widget/common_toastification.dart';
import '../model/add_hygiene/add_hygiene_request.dart';
import '../model/hygiene_list/hygiene_list_request.dart';
import '../model/hygiene_list/hygiene_list_response.dart';

class HygieneController extends GetxController {
  final ApiWorker apiWorker = Get.put(ApiWorker());

  RxBool isLoading = false.obs;

  Future<void> addHygiene(
    BuildContext context,
    String slug, {
    required String hygiene,
    required String otherText,
    required String date,
    required String time,
    required String description,
  }) async {
    try {
      /// ================= VALIDATION =================
      if (hygiene.isEmpty) {
        showAppSnackbar("Error", "Please select hygiene type");
        return;
      }

      if (time.isEmpty) {
        showAppSnackbar("Error", "Please select time");
        return;
      }

      if (date.isEmpty) {
        showAppSnackbar("Error", "Please select date");
        return;
      }

      final parsedDate = DateFormat("d-M-yyyy").parse(date);
      final formattedDate = DateFormat("yyyy-MM-dd").format(parsedDate);

      isLoading.value = true;

      final response = await apiWorker.addHygieneApi(
        AddHygieneRequest(
          hygiene: hygiene, // Already correct ENUM
          otherText: otherText,
          time: time, // hh:mm AM/PM (already correct from picker)
          description: description,
          date: formattedDate,
          lang: LanguageController.to.apiLanguage,
        ),
        context,
        slug,
      );

      if (response?.success == true) {
        showToast(
          context,
          "Success",
          response?.message ?? "Hygiene added successfully",
          type: ToastificationType.success,
        );

        Get.back(); // Go back after success
      } else {
        showToast(
          context,
          "Error",
          response?.message ?? "Failed to add hygiene",
          type: ToastificationType.error,
        );
      }
    } catch (e) {
      debugPrint("Add Hygiene Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  RxList<HygieneItem> hygieneList = <HygieneItem>[].obs;

  /// ================= FETCH HYGIENE LIST =================
  Future<void> fetchHygieneList(BuildContext context, String slug,
      {String? date}) async {
    try {
      hygieneList.clear(); // clear old data before every fetch
      isLoading.value = true;

      final response = await apiWorker.hygieneListingApi(
        HygieneListRequest(
          lang: LanguageController.to.apiLanguage,
          date: ReportTimeUtils.resolveIsoDate(date),
        ),
        context,
        slug,
      );

      if (response?.success == true) {
        hygieneList.value = response?.data?.hygiene ?? [];
      } else {
        showAppSnackbar("Error", response?.message ?? "Failed to load hygiene");
      }
    } catch (e) {
      debugPrint("Fetch Hygiene Error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
