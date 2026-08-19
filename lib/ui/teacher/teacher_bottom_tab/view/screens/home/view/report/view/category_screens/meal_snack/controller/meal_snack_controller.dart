import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';

import '../../../../../../../../../../../../core/utils/report_time_utils.dart';
import '../../../../../../../../../../../../service/api_service/api_worker.dart';
import '../../../../../../../../../../../../translation/language_controller.dart';
import '../../../../../../../../../../../../widget/common_toastification.dart';
import '../model/add_meal_snack/add_meal_snack_request.dart';
import '../model/meal_snack/meal_snack_request.dart';
import '../model/meal_snack/meal_snack_response.dart';

class MealSnackController extends GetxController {
  final ApiWorker apiWorker = Get.put(ApiWorker());

  Future<void> addMealSnack(
    BuildContext context,
    String slug, {
    required String meal,
    required String portion,
    required String date,
    required String time,
    required String description,
  }) async {
    try {
      isLoading.value = true;

      // Convert date to YYYY-MM-DD
      DateTime parsedDate = DateFormat("d-M-yyyy").parse(date);
      String formattedDate = DateFormat("yyyy-MM-dd").format(parsedDate);

      // Map dropdown text to API enum
      String apiMeal = meal;

      final response = await apiWorker.addMealSnacks(
        MealRequest(
          meal: apiMeal,
          portion: portion,
          date: formattedDate,
          time: time,
          description: description,
          lang: LanguageController.to.apiLanguage,
        ),
        context,
        slug,
      );

      if (response?.success == true) {
        showToast(
          context,
          "Success",
          response?.message ?? "Meal Added Successfully",
          type: ToastificationType.success,
        );

        Get.back();
      } else {
        showToast(
          context,
          "Error",
          response?.message ?? "Failed to add meal",
          type: ToastificationType.error,
        );
      }
    } catch (e) {
      debugPrint("Add Meal Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Map UI meal to API value
  // String _mapMealToApiValue(String meal) {
  //
  //   switch (meal) {
  //     case "Breakfast":
  //       return "OATS_AND_MILK";
  //
  //     case "Lunch":
  //       return "RICE_AND_DAL";
  //
  //     case "Snacks":
  //       return "SNACKS";
  //
  //     default:
  //       return "SNACKS";
  //   }
  // }
  RxBool isLoading = false.obs;
  RxList<MealList> meals = <MealList>[].obs;

  Future<void> getMealSnacks(BuildContext context, String slug,
      {String? date}) async {
    try {
      isLoading.value = true;

      final response = await apiWorker.mealSnacksListing(
        MealSnackRequest(
          lang: LanguageController.to.apiLanguage,
          date: ReportTimeUtils.resolveIsoDate(date),
        ),
        context,
        slug,
      );

      if (response?.success == true) {
        meals.value = response?.data?.meals ?? [];
      } else {
        showAppSnackbar("Error", response?.message ?? "Failed to load meals");
      }
    } catch (e) {
      debugPrint("Meal List Error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
