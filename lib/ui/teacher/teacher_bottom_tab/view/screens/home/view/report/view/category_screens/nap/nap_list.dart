import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../../../../../../../../core/ColorUtils.dart';
import '../../../../../../../../../../../core/utils/report_time_utils.dart';
import '../../../../../../../../../../../core/widget/back_button.dart';
import '../../../../../../../../../../../core/widget/my_regular_text.dart';
import '../../../../../../../../../../../core/widget/empty_state.dart';
import 'add_nap.dart';
import 'controller/nap_controller.dart';
import 'model/nap_list/nap_list_response.dart';

class NapListScreen extends StatefulWidget {
  const NapListScreen({super.key});

  @override
  State<NapListScreen> createState() => _NapListScreenState();
}

class _NapListScreenState extends State<NapListScreen> {
  bool isLight(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light;

  String? slug;
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
      controller.getNapList(context, slug!, date: selectedDate);
    });
  }

  final NapController controller = Get.put(NapController());

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
                        label: 'nap'.tr,
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: primaryText(context),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(
                        AddNapScreen(initialDate: selectedDate),
                        arguments: slug,
                      )?.then(
                            (value) {
                          controller.getNapList(context, slug!, date: selectedDate);
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
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.napList.isEmpty) {
                  return const Center(child: EmptyState());
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.napList.length,
                  itemBuilder: (_, i) =>
                      _mealTile(context, controller.napList[i]),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  // ================= TILE =================
  Widget _mealTile(BuildContext context, NapList nap) {
    final light = isLight(context);

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
                "${nap.startTime ?? ''} ${'to'.tr} ${nap.endTime ?? ''}",
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
                'assets/svg/sleep.svg',
                color: light ? Colors.black87 : Colors.white,
              ),
              const SizedBox(width: 10),
              MyRegularText(
                label: "nap".tr,
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
