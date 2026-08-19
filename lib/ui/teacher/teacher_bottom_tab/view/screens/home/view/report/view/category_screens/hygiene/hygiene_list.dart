import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../../../../../../../../core/ColorUtils.dart';
import '../../../../../../../../../../../core/utils/report_display_utils.dart';
import '../../../../../../../../../../../core/utils/report_time_utils.dart';
import '../../../../../../../../../../../core/widget/back_button.dart';
import '../../../../../../../../../../../core/widget/empty_state.dart';
import '../../../../../../../../../../../core/widget/my_regular_text.dart';
import 'add_hygiene_screen.dart';
import 'controller/hygiene_controller.dart';

class HygieneListScreen extends StatefulWidget {
  const HygieneListScreen({super.key});

  @override
  State<HygieneListScreen> createState() => _HygieneListScreenState();
}

class _HygieneListScreenState extends State<HygieneListScreen> {
  bool isLight(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light;

  final HygieneController controller = Get.put(HygieneController());
  String? slug;
  String? selectedDate;
  @override
  void initState() {
    // TODO: implement initState
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
      controller.fetchHygieneList(context, slug!, date: selectedDate);
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
                        label: 'hygiene'.tr,
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: primaryText(context),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(
                        AddHygieneScreen(initialDate: selectedDate),
                        arguments: slug,
                      )?.then(
                        (value) {
                          controller.fetchHygieneList(context, slug!,
                              date: selectedDate);
                        },
                      );
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
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (controller.hygieneList.isEmpty) {
                  return const Center(child: EmptyState());
                }

                return ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.hygieneList.length,
                  itemBuilder: (_, i) {
                    final item = controller.hygieneList[i];
                    final detail = item.description;

                    final locale = Get.locale?.languageCode ?? 'en';

                    String formattedDateTime = "";

                    if (item.date != null) {
                      DateTime parsedDate = DateTime.parse(item!.date!);

                      final dateStr =
                          DateFormat('dd-MMM-yyyy', locale).format(parsedDate);

                      String timeStr = "";
                      if (item.time != null && item.time!.isNotEmpty) {
                        final parsedTime =
                            DateFormat("HH:mm").parse(item.time!);
                        timeStr = DateFormat.jm(locale).format(parsedTime);
                      }

                      formattedDateTime = timeStr.isNotEmpty
                          ? "$dateStr ${'at'.tr} $timeStr"
                          : dateStr;
                    }
                    return _mealTile(
                      context,
                      {
                        "time": formattedDateTime,
                        "title": _formatTitle(item.hygieneType ?? ""),
                        "subTitle": item.otherText!.isNotEmpty
                            ? _formatTitle(item.otherText ?? "")
                            : "",
                      },
                    );
                  },
                );
              }),
            )
          ],
        ),
      ),
    );
  }

  String _formatTitle(String type) {
    return ReportDisplayUtils.hygieneLabel(type);
  }

  // ================= TILE =================
  Widget _mealTile(BuildContext context, Map<String, String> meal) {
    final light = isLight(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// DATE ROW
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
                label: meal['time']!,
                fontSize: 12,
                color: Colors.grey,
                align: TextAlign.start,
              ),
            ],
          ),

          const SizedBox(height: 6),

          /// MEAL TITLE
          Row(
            children: [
              SvgPicture.asset(
                'assets/svg/handwash.svg',
                color: light ? Colors.black87 : Colors.white,
              ),
              const SizedBox(width: 10),
              MyRegularText(
                label: meal['title']!,
                fontWeight: FontWeight.w600,
                align: TextAlign.start,
                fontSize: 15,
                color: light ? Colors.black87 : Colors.white,
              ),
              if (meal['subTitle']!.isNotEmpty)
                MyRegularText(
                  label: "(${meal['subTitle']!})",
                  fontWeight: FontWeight.w600,
                  align: TextAlign.start,
                  fontSize: 14,
                  color: light ? Colors.black87 : Colors.white,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
