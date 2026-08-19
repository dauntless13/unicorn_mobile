import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../../../../../../core/ColorUtils.dart';
import '../../../../../../../../../core/widget/back_button.dart';
import '../../../../../../../../../core/widget/empty_state.dart';
import '../../../../../../../../../core/widget/my_regular_text.dart';
import '../controller/student_leave_controller.dart';
import '../model/student_leave_listing/student_leave_listing_response.dart';
import 'add_student_leave.dart';

class StudentLeaveListing extends StatefulWidget {
  const StudentLeaveListing({super.key});

  @override
  State<StudentLeaveListing> createState() => _StudentLeaveListingState();
}

class _StudentLeaveListingState extends State<StudentLeaveListing> {
  bool isLight(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light;

  final StudentLeaveController controller = Get.put(StudentLeaveController());

  static final DateFormat _dateFormat = DateFormat('dd-MM-yyyy');

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 0), () {
      controller.studentLeaveListing(context);
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
                      const SizedBox(width: 14),
                      MyRegularText(
                        label: 'leave'.tr,
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: primaryText(context),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {
                      Get.to(const AddStudentLeave())?.then((value) {
                        controller.studentLeaveListing(context);
                      });
                    },
                    icon: const Icon(
                      Icons.add,
                      size: 28,
                    ),
                  ),
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
  Widget _leaveTile(BuildContext context, Datum leave) {
    final light = isLight(context);
    final days = _totalDays(leave.leaveFrom, leave.leaveTo);
    final typeLabel = _leaveTypeLabel(leave.leaveType);
    final title = days != null
        ? "${days} ${'days_leave'.tr}"
        : (typeLabel.isEmpty ? 'leave'.tr : typeLabel);
    final subtitle = days != null ? typeLabel : (leave.name ?? "");

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
                  label: "${leave.leaveFrom ?? ""} - ${leave.leaveTo ?? ""}",
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
            label: title,
            fontWeight: FontWeight.w600,
            fontSize: 15,
            align: TextAlign.start,
            color: light ? Colors.black87 : Colors.white,
          ),
          const SizedBox(height: 2),
          MyRegularText(
            label: subtitle,
            fontSize: 12,
            color: Colors.grey,
            align: TextAlign.start,
          ),
        ],
      ),
    );
  }

  int? _totalDays(String? fromDate, String? toDate) {
    if (fromDate == null || toDate == null) return null;
    try {
      final start = _dateFormat.parseStrict(fromDate);
      final end = _dateFormat.parseStrict(toDate);
      return end.difference(start).inDays + 1;
    } catch (_) {
      return null;
    }
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
        bg = Colors.grey;
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
}
