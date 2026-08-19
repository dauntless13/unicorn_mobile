import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';

import '../../../../../../../../../../../../core/utils/report_time_utils.dart';
import '../../../../../../../../../../../../service/api_service/api_worker.dart';
import '../../../../../../../../../../../../translation/language_controller.dart';
import '../../../../../../../../../../../../widget/common_toastification.dart';
import '../model/add_nap/add_nap_request.dart';
import '../model/nap_list/nap_list_request.dart';
import '../model/nap_list/nap_list_response.dart';

class NapController extends GetxController {

  final ApiWorker apiWorker = Get.put(ApiWorker());

  RxBool isLoading = false.obs;

  Future<void> addNap(
      BuildContext context,
      String slug, {
        required String date,
        required String startTime,
        required String endTime,
        required String description,
      }) async {

    try {

      /// ================= VALIDATION =================

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

      // Convert date to YYYY-MM-DD
      DateTime parsedDate = DateFormat("d-M-yyyy").parse(date);
      String formattedDate = DateFormat("yyyy-MM-dd").format(parsedDate);

      /// Validate Start < End
      DateTime start = DateFormat("hh:mm a").parse(startTime);
      DateTime end = DateFormat("hh:mm a").parse(endTime);

      if (!end.isAfter(start)) {
        showAppSnackbar("Error", "End time must be after start time");
        return;
      }

      isLoading.value = true;

      final response = await apiWorker.addNapApi(
        AddNapRequest(
          startTime: startTime,
          endTime: endTime,
          description: description,
          date: formattedDate,
          lang:LanguageController.to.apiLanguage,
        ),
        context,
        slug,
      );

      if (response?.success == true) {

        showToast(
          context,
          "Success",
          response?.message ?? "Nap added successfully",
          type: ToastificationType.success,
        );

        Get.back();

      } else {
        showToast(
          context,
          "Error",
          response?.message ?? "Failed to add nap",
          type: ToastificationType.error,
        );
      }

    } catch (e) {
      debugPrint("Add Nap Error: $e");
    } finally {
      isLoading.value = false;
    }
  }
  RxList<NapList> napList = <NapList>[].obs;
  Future<void> getNapList(
      BuildContext context,
      String slug,
      {String? date}
      ) async {
    try {
      isLoading.value = true;

      final response = await apiWorker.napListingApi(
        NapListRequest(
          lang: LanguageController.to.apiLanguage,
          date: ReportTimeUtils.resolveIsoDate(date),
        ),
        context,
        slug,
      );

      if (response?.success == true) {
        napList.value = response?.data?.naps ?? [];
      } else {
        showAppSnackbar("Error", response?.message ?? "Failed to load naps");
      }

    } catch (e) {
      debugPrint("Nap Listing Error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
