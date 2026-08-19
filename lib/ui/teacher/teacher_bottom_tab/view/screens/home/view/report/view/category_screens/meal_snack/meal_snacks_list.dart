import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../../../../../../../../core/ColorUtils.dart';
import '../../../../../../../../../../../core/utils/report_display_utils.dart';
import '../../../../../../../../../../../core/utils/report_time_utils.dart';
import '../../../../../../../../../../../core/widget/back_button.dart';
import '../../../../../../../../../../../core/widget/my_regular_text.dart';
import '../../../../../../../../../../../core/widget/empty_state.dart';
import 'add_meal_snacks.dart';
import 'controller/meal_snack_controller.dart';
import 'model/meal_snack/meal_snack_response.dart';

class MealSnacksList extends StatefulWidget {

  const MealSnacksList({super.key});

  @override
  State<MealSnacksList> createState() => _MealSnacksListState();
}

class _MealSnacksListState extends State<MealSnacksList> {
  bool isLight(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light;

  final MealSnackController controller = Get.put(MealSnackController());
  String? slug = '';
  String? selectedDate;
  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    if (args is Map) {
      slug = args["slug"];
      selectedDate = ReportTimeUtils.resolveIsoDate(args["date"]?.toString());
    } else {
      slug = args;
      selectedDate = ReportTimeUtils.todayIso();
    }
    Future.delayed(const Duration(seconds: 0), () {
      controller.getMealSnacks(context, slug!, date: selectedDate);
    });
  }
  @override
  Widget build(BuildContext context) {
    final light = isLight(context);

    return Scaffold(
      backgroundColor: light ? Colors.white : const Color(0xFF0F0F0F),

      /// ================= LIST =================
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      appBackButton(context),
                      SizedBox(width: 14),
                      MyRegularText(
                        label: 'meals_snacks'.tr,
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: primaryText(context),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(AddMealSnacks(
                        slug: slug ?? '',
                        initialDate: selectedDate,
                      ))?.then((value) {
                        controller.getMealSnacks(context, slug!, date: selectedDate);
                      });
                    },
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: light
                            ? Colors.white
                            : Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: light
                              ? Colors.grey.shade300
                              : Colors.white.withOpacity(0.15),
                        ),
                      ),
                      child: Icon(
                        Icons.add,
                        size: 22,
                        color: light ? Colors.black : Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Obx(() {

                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.meals.isEmpty) {
                  return const Center(child: EmptyState());
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.meals.length,
                  itemBuilder: (_, i) =>
                      _mealTile(context, controller.meals[i]),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  // ================= TILE =================
  Widget _mealTile(BuildContext context, MealList meal) {
    final light = isLight(context);
print('Meal ${meal.mealName}');
    final locale = Get.locale?.languageCode ?? 'en';
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 6),
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.green,
                    width: 2.5,
                  ),
                ),
              ),
              const SizedBox(width: 8),


              MyRegularText(
              label:
              "${DateFormat('dd-MMM-yyyy', locale).format(meal.date!)} at ${meal.time ?? ''}",
              fontSize: 12,
              color: Colors.grey,
              align: TextAlign.start,
              ),
            ],
          ),

          const SizedBox(height: 6),

          Row(
            children: [
              SvgPicture.asset(
                'assets/svg/snoop.svg',
                color: light ? Colors.black87 : Colors.white,
              ),
              const SizedBox(width: 10),
              MyRegularText(
                label: ReportDisplayUtils.mealLabel(meal.mealName),
                fontWeight: FontWeight.w600,
                align: TextAlign.start,
                fontSize: 15,
                color: light ? Colors.black87 : Colors.white,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
