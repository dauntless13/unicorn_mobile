import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../../../../../../core/ColorUtils.dart';
import '../../../../../../../../../../../core/utils/report_time_utils.dart';
import '../../../../../../../../../../../core/widget/back_button.dart';
import '../../../../../../../../../../../core/widget/my_regular_text.dart';
import '../../../../../../../../../../../core/widget/select_option_chips.dart';
import '../../../../../../../../../../../widget/my_regular_button.dart';
import '../../log_confirm_dialog.dart';
import 'controller/hygiene_controller.dart';

class AddHygieneScreen extends StatefulWidget {
  final String? initialDate;
  const AddHygieneScreen({super.key, this.initialDate});

  @override
  State<AddHygieneScreen> createState() => _AddHygieneScreenState();
}

class _AddHygieneScreenState extends State<AddHygieneScreen> {
  final HygieneController controller = Get.put(HygieneController());
  String selectedActivity = 'URINE';
  String? slug;

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
                    label: 'add_hygiene'.tr,
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
                    label: 'hygiene_activity'.tr,
                    fontWeight: FontWeight.w700,
                    align: TextAlign.start,
                    color: primaryText(context),
                  ),
                  const SizedBox(height: 10),
                  SelectOptionChips(
                    selected: selectedActivity,
                    onSelected: (v) => setState(() => selectedActivity = v),
                    options: [
                      SelectOption(value: 'URINE', label: 'Urine'.tr),
                      SelectOption(value: 'POOP', label: 'Poop'.tr),
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
                    if (slug == null) return;
                    final confirmed = await confirmLogAdd(
                      context,
                      title: 'add_hygiene'.tr,
                      details: [
                        selectedActivity == 'POOP' ? 'Poop'.tr : 'Urine'.tr,
                      ],
                    );
                    if (!confirmed || !context.mounted) return;
                    controller.addHygiene(
                      context,
                      slug!,
                      hygiene: selectedActivity,
                      otherText: '',
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
