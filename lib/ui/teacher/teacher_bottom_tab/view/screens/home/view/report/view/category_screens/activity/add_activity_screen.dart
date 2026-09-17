import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../../../../../../core/ColorUtils.dart';
import '../../../../../../../../../../../core/utils/report_time_utils.dart';
import '../../../../../../../../../../../core/widget/back_button.dart';
import '../../../../../../../../../../../core/widget/my_regular_text.dart';
import '../../../../../../../../../../../core/widget/select_option_chips.dart';
import '../../../../../../../../../../../widget/my_regular_button.dart';
import '../../log_confirm_dialog.dart';
import 'controller/activity_controller.dart';

class AddActivityScreen extends StatefulWidget {
  final String? initialDate;
  const AddActivityScreen({super.key, this.initialDate});

  @override
  State<AddActivityScreen> createState() => _AddActivityScreenState();
}

class _AddActivityScreenState extends State<AddActivityScreen> {
  final ActivityController controller = Get.put(ActivityController());
  final TextEditingController notesController = TextEditingController();
  String selectedActivity = 'PE';
  int selectedMinutes = 30;
  String? slug;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    if (args is Map) {
      slug = args['slug']?.toString();
    } else if (args is String) {
      slug = args;
    }
  }

  @override
  void dispose() {
    notesController.dispose();
    super.dispose();
  }

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
                    label: 'add_activity'.tr,
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
                    label: 'activity'.tr,
                    fontWeight: FontWeight.w700,
                    align: TextAlign.start,
                    color: primaryText(context),
                  ),
                  const SizedBox(height: 10),
                  SelectOptionChips(
                    selected: selectedActivity,
                    onSelected: (v) => setState(() => selectedActivity = v),
                    options: [
                      SelectOption(value: 'PE', label: 'PE'.tr),
                      SelectOption(value: 'CIRCLE_TIME', label: 'CIRCLE_TIME'.tr),
                      SelectOption(value: 'MISS_PLAY', label: 'MISS_PLAY'.tr),
                      SelectOption(value: 'STORY_TIME', label: 'STORY_TIME'.tr),
                      SelectOption(value: 'DAILY_ACTIVITY', label: 'DAILY_ACTIVITY'.tr),
                      SelectOption(
                        value: 'ARABIC_AND_ISLAMIC',
                        label: 'ARABIC_AND_ISLAMIC'.tr,
                      ),
                      SelectOption(value: 'OTHERS', label: 'OTHERS'.tr),
                    ],
                  ),
                  const SizedBox(height: 22),
                  MyRegularText(
                    label: 'how_long'.tr,
                    fontWeight: FontWeight.w700,
                    align: TextAlign.start,
                    color: primaryText(context),
                  ),
                  const SizedBox(height: 10),
                  SelectOptionChips(
                    selected: '$selectedMinutes',
                    onSelected: (v) => setState(() => selectedMinutes = int.parse(v)),
                    options: [
                      SelectOption(value: '15', label: 'duration_15'.tr),
                      SelectOption(value: '30', label: 'duration_30'.tr),
                      SelectOption(value: '45', label: 'duration_45'.tr),
                      SelectOption(value: '60', label: 'duration_60'.tr),
                    ],
                  ),
                  const SizedBox(height: 22),
                  MyRegularText(
                    label: 'notes'.tr,
                    fontWeight: FontWeight.w700,
                    align: TextAlign.start,
                    color: primaryText(context),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: light ? Colors.white : const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: light
                            ? const Color(0xFFE2E8F0)
                            : Colors.white.withValues(alpha: 0.12),
                      ),
                    ),
                    child: TextField(
                      controller: notesController,
                      maxLines: 4,
                      minLines: 3,
                      textInputAction: TextInputAction.newline,
                      style: TextStyle(
                        color: light ? const Color(0xFF0F172A) : Colors.white,
                        fontSize: 14.5,
                        height: 1.4,
                      ),
                      decoration: InputDecoration(
                        hintText: 'note_hint'.tr,
                        hintStyle: TextStyle(
                          color: light
                              ? const Color(0xFF94A3B8)
                              : Colors.white38,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Obx(
                () {
                  final range = ReportTimeUtils.rangeFromMinutes(selectedMinutes);
                  return MyThemeButton(
                    title: 'Save'.tr,
                    isLoading: controller.isLoading.value,
                    onPressed: () async {
                      final duration = selectedMinutes == 15
                          ? 'duration_15'.tr
                          : selectedMinutes == 30
                              ? 'duration_30'.tr
                              : selectedMinutes == 45
                                  ? 'duration_45'.tr
                                  : 'duration_60'.tr;
                      final note = notesController.text.trim();
                      final confirmed = await confirmLogAdd(
                        context,
                        title: 'add_activity'.tr,
                        details: [
                          selectedActivity.tr,
                          duration,
                          if (note.isNotEmpty) note,
                        ],
                      );
                      if (!confirmed || !context.mounted) return;
                      controller.createActivity(
                        context,
                        slug ?? '',
                        activity: selectedActivity,
                        date: _date,
                        startTime: range.start,
                        endTime: range.end,
                        notes: note,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
