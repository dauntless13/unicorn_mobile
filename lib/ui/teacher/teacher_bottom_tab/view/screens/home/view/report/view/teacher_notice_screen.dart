import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../../../../core/ColorUtils.dart';
import '../../../../../../../../../core/widget/back_button.dart';
import '../../../../../../../../../core/widget/my_regular_text.dart';
import '../../../../../../../../../core/widget/empty_state.dart';
import '../../../../../../../../../routes/app_routs.dart';
import '../controller/report_controller.dart';
import '../model/teacher_holiday_event_list/teacher_holiday_event_list_response.dart';

class TeacherNoticeScreen extends StatefulWidget {
  const TeacherNoticeScreen({super.key});

  @override
  State<TeacherNoticeScreen> createState() => _TeacherNoticeScreenState();
}

class _TeacherNoticeScreenState extends State<TeacherNoticeScreen> {
  bool isLight(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light;


  final ReportController controller = Get.put(ReportController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 0), () {
      controller.teacherHolidayEventListing(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final light = isLight(context);

    return Scaffold(
      backgroundColor: light ? Colors.white : const Color(0xFF0F0F0F),
      // appBar: AppBar(
      //   elevation: 0,
      //   backgroundColor: light ? Colors.white : const Color(0xFF0F0F0F),
      //   foregroundColor: light ? Colors.black : Colors.white,
      //   leading: IconButton(
      //     icon: const Icon(Icons.arrow_back),
      //     onPressed: () => Get.back(),
      //   ),
      //   title: MyRegularText(
      //     label: 'teacher_notice'.tr,
      //     fontWeight: FontWeight.w600,
      //     fontSize: 16,
      //   ),
      // ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  appBackButton(context),
                  SizedBox(width: 14),
                  MyRegularText(
                    label: 'teacher_notice'.tr,
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: primaryText(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child:Obx(() {
                /// ===== Loading First Time =====
                if (controller.isLoading.value &&
                    controller.eventList.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                /// ===== No Data Found =====
                if (controller.eventList.isEmpty) {
                  return const Center(child: EmptyState());
                }

                /// ===== Data Available =====
                return EasyRefresh(
                  header: const ClassicHeader(showText: false),
                  footer: const ClassicFooter(showText: false),
                  onRefresh: () async {
                    await controller.teacherHolidayEventListing(
                      context,
                      isRefresh: true,
                    );
                  },
                  onLoad: controller.hasMore
                      ? () async {
                    await controller.teacherHolidayEventListing(context);
                  }
                      : null,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: controller.eventList.length,
                    itemBuilder: (context, index) {
                      final notice = controller.eventList[index];
                      return _noticeTile(context, notice);
                    },
                  ),
                );
              })
            ),
          ],
        ),
      ),
    );
  }

  // ================= NOTICE TILE =================
  Widget _noticeTile(BuildContext context, TeacherHolidayListElement notice) {
    final light = isLight(context);

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () {
        Get.toNamed(Routes.REPORT_LIST);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
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
                        label: notice.startDate ?? "",
                        fontSize: 12,
                        color: Colors.grey,
                        align: TextAlign.start,
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  MyRegularText(
                    label: notice.name ?? "",
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    align: TextAlign.start,
                    color: light ? Colors.black87 : Colors.white,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_right,
              size: 22,
              color: light ? Colors.grey : Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }
}
