import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../../../../../../../../core/ColorUtils.dart';
import '../../../../../../../../../../../core/utils/report_time_utils.dart';
import '../../../../../../../../../../../core/widget/back_button.dart';
import '../../../../../../../../../../../core/widget/empty_state.dart';
import '../../../../../../../../../../../core/widget/my_regular_text.dart';
import 'add_activity_screen.dart';
import 'controller/activity_controller.dart';

class ActivityListScreen extends StatefulWidget {
  const ActivityListScreen({super.key});

  @override
  State<ActivityListScreen> createState() => _ActivityListScreenState();
}

class _ActivityListScreenState extends State<ActivityListScreen> {
  bool isLight(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light;
  final ActivityController controller = Get.put(ActivityController());
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
      controller.fetchActivityList(context, slug!, date: selectedDate);
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
                        label: 'activity'.tr,
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: primaryText(context),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(
                        AddActivityScreen(initialDate: selectedDate),
                        arguments: slug,
                      )?.then(
                        (value) {
                          controller.fetchActivityList(context, slug!,
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

                if (controller.activityList.isEmpty) {
                  return const Center(child: EmptyState());
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.activityList.length,
                  itemBuilder: (_, i) {
                    final activity = controller.activityList[i];
                    final data = activity.data;

                    final locale = Get.locale?.languageCode ?? 'en';

                    String formattedDate = "";

                    if (data?.date != null) {
                      final dateStr =
                          DateFormat('dd-MMM-yyyy', locale).format(data!.date!);

                      String timeStr = "";
                      if (data.startTime != null &&
                          data.startTime!.isNotEmpty) {
                        final parsed =
                            DateFormat("HH:mm").parse(data.startTime!);
                        timeStr = DateFormat.jm(locale).format(parsed);
                      }

                      formattedDate = "$dateStr ${'at'.tr} $timeStr";
                    }
                    return _mealTile(
                      context,
                      {
                        "time": formattedDate,
                        "title": (activity.type ?? "").replaceAll('_', ' '),
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
                'assets/svg/candle.svg',
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
            ],
          ),
        ],
      ),
    );
  }
}
