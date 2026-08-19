import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../../../../../../core/ColorUtils.dart';
import '../../../../../../../../../../../core/utils/report_time_utils.dart';
import '../../../../../../../../../../../core/widget/back_button.dart';
import '../../../../../../../../../../../core/widget/my_regular_text.dart';
import '../../../../../../../../../../../core/widget/select_option_chips.dart';
import '../../../../../../../../../../../widget/my_regular_button.dart';
import '../../log_confirm_dialog.dart';
import 'controller/nap_controller.dart';

class AddNapScreen extends StatefulWidget {
  final String? initialDate;
  const AddNapScreen({super.key, this.initialDate});

  @override
  State<AddNapScreen> createState() => _AddNapScreenState();
}

class _AddNapScreenState extends State<AddNapScreen> {
  final NapController controller = Get.put(NapController());
  String? slug;
  int selectedMinutes = 60;

  @override
  void initState() {
    super.initState();
    slug = Get.arguments is String ? Get.arguments as String : Get.arguments?.toString();
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
                    label: 'add_nap'.tr,
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
                      SelectOption(value: '30', label: 'duration_30'.tr),
                      SelectOption(value: '45', label: 'duration_45'.tr),
                      SelectOption(value: '60', label: 'duration_60'.tr),
                      SelectOption(value: '90', label: 'duration_90'.tr),
                      SelectOption(value: '120', label: 'duration_120'.tr),
                    ],
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
                      final confirmed = await confirmLogAdd(
                        context,
                        title: 'add_nap'.tr,
                        details: [
                          selectedMinutes == 30
                              ? 'duration_30'.tr
                              : selectedMinutes == 45
                                  ? 'duration_45'.tr
                                  : selectedMinutes == 60
                                      ? 'duration_60'.tr
                                      : selectedMinutes == 90
                                          ? 'duration_90'.tr
                                          : 'duration_120'.tr,
                        ],
                      );
                      if (!confirmed || !context.mounted) return;
                      controller.addNap(
                        context,
                        slug ?? '',
                        date: _date,
                        startTime: range.start,
                        endTime: range.end,
                        description: '',
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
