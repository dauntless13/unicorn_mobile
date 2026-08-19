import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../../../../../core/ColorUtils.dart';
import '../../../../../../../../core/widget/back_button.dart';
import '../../../../../../../../core/widget/my_form_field.dart';
import '../../../../../../../../core/widget/my_regular_text.dart';
import '../../../../../../../../translation/language_controller.dart';
import '../../../../../../../../widget/app_date_picker_helper.dart';
import '../../../../../../../../widget/common_toastification.dart';
import '../../../../../../../../widget/my_regular_button.dart';
import '../common_selection_bottomsheet.dart';
import 'controller/teacher_leave_controller.dart';

class AddLeave extends StatefulWidget {
  const AddLeave({super.key});

  @override
  State<AddLeave> createState() => _AddLeaveState();
}

class _AddLeaveState extends State<AddLeave> {
  final TextEditingController fromCtrl = TextEditingController();
  final TextEditingController toCtrl = TextEditingController();
  final TextEditingController descCtrl = TextEditingController();

  String leaveType = 'CASUAL';

  bool halfDay = false;
  bool fullDay = true;

  bool isLight(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light;

  final TeacherLeaveController controller = Get.put(TeacherLeaveController());

  static final DateFormat _dateFormat = DateFormat('dd-MM-yyyy');

  @override
  Widget build(BuildContext context) {
    final light = isLight(context);

    return Scaffold(
      backgroundColor: light ? Colors.white : const Color(0xFF0F0F0F),

      /// ================= BODY =================
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    appBackButton(context),
                    SizedBox(width: 14),
                    MyRegularText(
                      label: 'add_leave'.tr,
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: primaryText(context),
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// TYPE DROPDOWN
                    _label('type'.tr),
                    _leaveTypeSheet(),

                    const SizedBox(height: 14),

                    /// FROM DATE
                    _label('from_date'.tr),
                    MyFormField(
                      controller: fromCtrl,
                      hintText: 'from_date'.tr,
                      isReadOnly: true,
                      suffixIcon: const Icon(Icons.calendar_month),
                      onTap: () => _pickDate(fromCtrl),
                    ),

                    const SizedBox(height: 14),

                    /// TO DATE
                    _label('to_date'.tr),
                    MyFormField(
                      controller: toCtrl,
                      hintText: 'to_date'.tr,
                      isReadOnly: true,
                      suffixIcon: const Icon(Icons.calendar_month),
                      onTap: () => _pickDate(toCtrl),
                    ),

                    const SizedBox(height: 14),

                    /// DESCRIPTION
                    _label('description'.tr),
                    MyFormField(
                      controller: descCtrl,
                      hintText: 'description'.tr,
                      maxLines: 4,
                    ),

                    const SizedBox(height: 14),
                    //
                    // /// CHECKBOXES
                    // Row(
                    //   children: [
                    //     Checkbox(
                    //       value: halfDay,
                    //       onChanged: (v) {
                    //         setState(() {
                    //           halfDay = v!;
                    //           if (v) fullDay = false;
                    //         });
                    //       },
                    //     ),
                    //     MyRegularText(
                    //       label: 'half_day_leave'.tr,
                    //       align: TextAlign.start,
                    //       color:light ? Colors.black : Colors.white,
                    //     ),
                    //
                    //     const SizedBox(width: 20),
                    //
                    //     Checkbox(
                    //       value: fullDay,
                    //       onChanged: (v) {
                    //         setState(() {
                    //           fullDay = v!;
                    //           if (v) halfDay = false;
                    //         });
                    //       },
                    //     ),
                    //     MyRegularText(
                    //       label: 'full_day_leave'.tr,
                    //       align: TextAlign.start,
                    //       color:light ? Colors.black : Colors.white,
                    //     ),
                    //   ],
                    // ),
                    //
                    // const SizedBox(height: 24),

                    /// SUBMIT BUTTON
                    Obx(
                      () => MyThemeButton(
                        title: 'Submit'.tr,
                        isLoading: controller.isAddLoading.value,
                        onPressed: () {
                          final today = _dateOnly(DateTime.now());
                          final fromDate = _parseSelectedDate(fromCtrl.text);
                          final toDate = _parseSelectedDate(toCtrl.text);

                          if (fromDate == null) {
                            showAppSnackbar("Error", "Please select from date");
                            return;
                          }
                          if (fromDate.isBefore(today)) {
                            showAppSnackbar(
                                "Error", "From date cannot be in the past");
                            return;
                          }
                          if (toDate == null) {
                            showAppSnackbar("Error", "Please select to date");
                            return;
                          }
                          if (toDate.isBefore(fromDate)) {
                            showAppSnackbar(
                                "Error", "To date cannot be before from date");
                            return;
                          }

                          controller.addTeacherLeave(
                            context: context,
                            type: leaveType,
                            fromDate: fromCtrl.text,
                            toDate: toCtrl.text,
                            description: descCtrl.text,
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= LABEL =================
  Widget _label(String text) {
    final light = isLight(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: MyRegularText(
        label: text,
        align: TextAlign.start,
        fontWeight: FontWeight.w500,
        color: light ? Colors.black : Colors.white,
      ),
    );
  }

  // ================= TYPE SHEET =================
  Widget _leaveTypeSheet() {
    final light = isLight(context);
    final selectedLabel = leaveTypes[leaveType] ?? leaveType;

    return InkWell(
      onTap: () {
        showSelectionBottomSheet<String>(
          context: context,
          title: 'type'.tr,
          items: leaveTypes.keys.toList(),
          itemLabel: (e) => leaveTypes[e] ?? e,
          isMultiSelect: false,
          selectedItems: [leaveType],
          onSelect: (v) {
            setState(() {
              leaveType = v;
            });
          },
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                selectedLabel,
                style: TextStyle(
                  color: light ? Colors.black87 : Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
            const Icon(Icons.keyboard_arrow_down_rounded),
          ],
        ),
      ),
    );
  }

  final Map<String, String> leaveTypes = {
    'SICK': 'sick'.tr,
    'CASUAL': 'casual'.tr,
    'EMERGENCY': 'emergency'.tr,
    'VACATION': 'vacation'.tr,
    'OTHER': 'other'.tr,
  };

  // ================= DATE PICKER =================
  Future<void> _pickDate(TextEditingController controller) async {
    final today = _dateOnly(DateTime.now());
    final fromDate = _parseSelectedDate(fromCtrl.text);
    final minDate = controller == toCtrl ? (fromDate ?? today) : today;
    final initial = controller == toCtrl ? (fromDate ?? today) : today;

    final date = await showDatePicker(
      context: context,
      locale: LanguageController.to.currentLocale,
      builder: buildAppDatePickerThemeBuilder(context),
      firstDate: minDate,
      lastDate: DateTime(2100),
      initialDate: initial.isBefore(minDate) ? minDate : initial,
      selectableDayPredicate: (day) {
        if (controller == toCtrl) {
          final cutoff = fromDate ?? today;
          return !day.isBefore(cutoff);
        }
        return !day.isBefore(today);
      },
    );

    if (date != null) {
      // Proper DD-MM-YYYY format with leading zeros
      final formattedDate = _dateFormat.format(date);

      controller.text = formattedDate;

      if (controller == fromCtrl) {
        final updatedFrom = _dateOnly(date);
        final existingTo = _parseSelectedDate(toCtrl.text);
        if (existingTo != null && existingTo.isBefore(updatedFrom)) {
          toCtrl.clear();
        }
      }
    }
  }

  DateTime _dateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  DateTime? _parseSelectedDate(String value) {
    if (value.trim().isEmpty) return null;
    try {
      return _dateFormat.parseStrict(value);
    } catch (_) {
      return null;
    }
  }
}
