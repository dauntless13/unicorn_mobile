import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../../../../../../core/ColorUtils.dart';
import '../../../../../../../../../../../core/utils/report_time_utils.dart';
import '../../../../../../../../../../../core/widget/back_button.dart';
import '../../../../../../../../../../../core/widget/my_regular_text.dart';
import '../../../../../../../../../../../core/widget/select_option_chips.dart';
import '../../../../../../../../../../../widget/common_toastification.dart';
import '../../../../../../../../../../../widget/my_regular_button.dart';
import '../../log_confirm_dialog.dart';
import 'controller/meal_snack_controller.dart';

class AddMealSnacks extends StatefulWidget {
  final String slug;
  final String? initialDate;
  const AddMealSnacks({super.key, required this.slug, this.initialDate});

  @override
  State<AddMealSnacks> createState() => _AddMealSnacksState();
}

class _AddMealSnacksState extends State<AddMealSnacks> {
  String selectedMeal = 'BREAKFAST';
  String selectedPortion = 'FULL';
  final MealSnackController controller = Get.put(MealSnackController());

  String get _date {
    final parsed = ReportTimeUtils.parseIsoDate(widget.initialDate);
    return ReportTimeUtils.todayDisplay(parsed ?? ReportTimeUtils.todayDate());
  }

  @override
  Widget build(BuildContext context) {
    final light = isLight(context);

    return Scaffold(
      backgroundColor: light ? const Color(0xFFF6F8FB) : const Color(0xFF0F0F0F),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Row(
                children: [
                  appBackButton(context),
                  const SizedBox(width: 14),
                  MyRegularText(
                    label: 'add_meal_snacks'.tr,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: primaryText(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                children: [
                  MyRegularText(
                    label: 'meals_snacks'.tr,
                    fontWeight: FontWeight.w700,
                    align: TextAlign.start,
                    color: primaryText(context),
                  ),
                  const SizedBox(height: 10),
                  SelectOptionChips(
                    selected: selectedMeal,
                    onSelected: (v) => setState(() => selectedMeal = v),
                    options: [
                      SelectOption(value: 'BREAKFAST', label: 'breakfast'.tr),
                      SelectOption(value: 'LUNCH', label: 'lunch'.tr),
                      SelectOption(value: 'SNACKS', label: 'snacks'.tr),
                    ],
                  ),
                  const SizedBox(height: 22),
                  MyRegularText(
                    label: 'how_much'.tr,
                    fontWeight: FontWeight.w700,
                    align: TextAlign.start,
                    color: primaryText(context),
                  ),
                  const SizedBox(height: 10),
                  SelectOptionChips(
                    selected: selectedPortion,
                    onSelected: (v) => setState(() => selectedPortion = v),
                    options: [
                      SelectOption(value: 'FULL', label: 'full'.tr),
                      SelectOption(value: 'HALF', label: 'half'.tr),
                      SelectOption(value: 'QUARTER', label: 'quarter'.tr),
                      SelectOption(value: 'NONE', label: 'none'.tr),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Obx(
                () => MyThemeButton(
                  title: 'Save'.tr,
                  isLoading: controller.isLoading.value,
                  onPressed: () async {
                    if (selectedMeal.isEmpty) {
                      showAppSnackbar('Error', 'Please select meal');
                      return;
                    }
                    final mealLabel = selectedMeal == 'BREAKFAST'
                        ? 'breakfast'.tr
                        : selectedMeal == 'LUNCH'
                            ? 'lunch'.tr
                            : 'snacks'.tr;
                    final portionLabel = selectedPortion == 'FULL'
                        ? 'full'.tr
                        : selectedPortion == 'HALF'
                            ? 'half'.tr
                            : selectedPortion == 'QUARTER'
                                ? 'quarter'.tr
                                : 'none'.tr;
                    final confirmed = await confirmLogAdd(
                      context,
                      title: 'add_meal_snacks'.tr,
                      details: [mealLabel, portionLabel],
                    );
                    if (!confirmed || !context.mounted) return;
                    controller.addMealSnack(
                      context,
                      widget.slug,
                      meal: selectedMeal,
                      portion: selectedPortion,
                      date: _date,
                      time: ReportTimeUtils.nowTime(),
                      description: '',
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
