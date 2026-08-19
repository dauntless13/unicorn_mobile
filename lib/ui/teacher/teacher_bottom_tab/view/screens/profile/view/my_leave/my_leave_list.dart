import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../../../core/ColorUtils.dart';
import '../../../../../../../../core/widget/back_button.dart';
import '../../../../../../../../core/widget/empty_state.dart';
import '../../../../../../../../core/widget/my_regular_text.dart';
import 'add_leave.dart';
import 'controller/teacher_leave_controller.dart';
import 'model/teacher_leave_list/teacher_leave_list_response.dart';

class MyLeaveList extends StatefulWidget {
  const MyLeaveList({super.key});

  @override
  State<MyLeaveList> createState() => _MyLeaveListState();
}

class _MyLeaveListState extends State<MyLeaveList> {
  bool isLight(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light;

  final TeacherLeaveController controller = Get.put(TeacherLeaveController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 0), () {
      controller.teacherLeaveListing(context);
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
                        label: 'leave'.tr,
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: primaryText(context),
                      ),
                    ],
                  ),
                  _iconBox(
                    context,
                    Icons.add,
                    onTap: () {
                      Get.to(AddLeave())?.then(
                        (value) {
                          controller.teacherLeaveListing(context);
                        },
                      );
                    },
                  ),
                  // IconButton(
                  //   onPressed: () {
                  //     Get.to(AddLeave())?.then(
                  //       (value) {
                  //         controller.teacherLeaveListing(context);
                  //       },
                  //     );
                  //   },
                  //   icon: const Icon(
                  //     Icons.add,
                  //     size: 28,
                  //   ),
                  // ),
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.leaveList.isEmpty) {
                  return const Center(child: EmptyState());
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.leaveList.length,
                  itemBuilder: (_, i) {
                    final leave = controller.leaveList[i];
                    return _leaveTile(context, leave);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  // ================= TILE =================
  Widget _leaveTile(BuildContext context, TeacherLeaveListData leave) {
    final light = isLight(context);
    final typeLabel = _leaveTypeLabel(leave.leaveType);

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
              Expanded(
                child: MyRegularText(
                  label: "${leave.startDate ?? ""} - ${leave.endDate ?? ""}",
                  fontSize: 12,
                  color: Colors.grey,
                  align: TextAlign.start,
                ),
              ),
              _statusChip(leave.status ?? ""),
            ],
          ),
          const SizedBox(height: 6),
          MyRegularText(
            label: "${leave.totalDays ?? 0} ${'days_leave'.tr}",
            fontWeight: FontWeight.w600,
            fontSize: 15,
            align: TextAlign.start,
            color: light ? Colors.black87 : Colors.white,
          ),
          const SizedBox(height: 2),
          MyRegularText(
            label: typeLabel,
            fontSize: 12,
            color: Colors.grey,
            align: TextAlign.start,
          ),
        ],
      ),
    );
  }

  String _leaveTypeLabel(String? type) {
    if (type == null || type.trim().isEmpty) return "";
    final key = type.toLowerCase().trim();
    return key.tr;
  }

  // ================= STATUS CHIP =================
  Widget _statusChip(String status) {
    final normalizedStatus = status.toLowerCase().trim();

    Color bg;
    Color text = Colors.white;

    switch (normalizedStatus) {
      case "approved":
        bg = const Color(0xFF34A853);
        break;

      case "rejected":
        bg = const Color(0xFFFF3B30);
        break;

      case "pending":
      case "waiting":
        bg = const Color(0xFF1A73E8);
        break;

      default:
        bg = Colors.grey; // fallback color
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: MyRegularText(
        label: normalizedStatus.tr,
        color: text,
        fontSize: 11,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _iconBox(BuildContext context, IconData icon, {VoidCallback? onTap}) {
    final light = isLight(context);

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: light ? Colors.grey.shade300 : Colors.grey.shade700,
        ),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(icon, size: 18, color: light ? Colors.black : Colors.white),
        onPressed: onTap,
      ),
    );
  }
}
