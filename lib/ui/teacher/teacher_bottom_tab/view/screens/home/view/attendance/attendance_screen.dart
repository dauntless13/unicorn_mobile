import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../../../core/ColorUtils.dart';
import '../../../../../../../../core/widget/back_button.dart';
import '../../../../../../../../core/widget/empty_state.dart';
import '../../../../../../../../core/widget/my_regular_text.dart';
import '../../../../../../../../core/widget/profile_avatar.dart';
import '../../../profile/model/get_all_class/get_all_class_response.dart';
import '../../../profile/view/common_selection_bottomsheet.dart';
import '../add_post/mode/list_student_by_class/list_student_by_class_response.dart';
import 'controller/attendance_controller.dart';

class AttendanceScreen extends StatefulWidget {
  AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  bool isLight(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light;

  final AttendanceController controller = Get.put(AttendanceController());

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      controller.fetchHolidayStatus(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final light = isLight(context);

    return Scaffold(
      backgroundColor:
          light ? const Color(0xFFF5F5F5) : const Color(0xFF0F0F0F),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  appBackButton(context),
                  SizedBox(width: 6),
                  MyRegularText(
                    label: 'attendance_title'.tr,
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: primaryText(context),
                  ),
                ],
              ),
            ),
            // _classDropdown(context),
            Obx(() => _dropdownTile(
                  context,
                  light,
                  icon: Icons.class_outlined,
                  label: 'Select Classes'.tr,
                  value: controller.selectedClass.value?.name,
                  enabled: true,
                  isMultiline: true,
                  onTap: () async {
                    await controller.fetchClasses(context);
                    showSelectionBottomSheet<Class>(
                      context: context,
                      title: "Select Class".tr,
                      items: controller.classList,
                      itemLabel: (e) => e.name ?? "",
                      isMultiSelect: false,
                      selectedItems: controller.selectedClass.value != null
                          ? [controller.selectedClass.value!]
                          : [],
                      onSelect: (value) {
                        controller.selectClass(value);
                        controller.fetchStudentsByClass(context);
                      },
                    );
                  },
                )),
            _searchBar(context),
            // Obx(() {
            //   if (!controller.isHolidayToday.value) {
            //     return const SizedBox.shrink();
            //   }
            //
            //   final holidayName = controller.activeHolidayName.value;
            //   return Container(
            //     width: double.infinity,
            //     margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            //     padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            //     decoration: BoxDecoration(
            //       color: light
            //           ? const Color(0xFFFFF3E0)
            //           : const Color(0xFF3A2B12),
            //       borderRadius: BorderRadius.circular(12),
            //       border: Border.all(
            //         color: light
            //             ? const Color(0xFFFFCC80)
            //             : const Color(0xFF8D6E63),
            //       ),
            //     ),
            //     child: Row(
            //       children: [
            //         const Icon(
            //           Icons.event_busy_rounded,
            //           color: Color(0xFFE65100),
            //         ),
            //         const SizedBox(width: 10),
            //         Expanded(
            //           child: Text(
            //             holidayName.isNotEmpty
            //                 ? "$holidayName - attendance disabled today"
            //                 : "Attendance disabled today due to holiday",
            //             style: TextStyle(
            //               fontSize: 13,
            //               fontWeight: FontWeight.w500,
            //               color: light ? Colors.black87 : Colors.white,
            //             ),
            //           ),
            //         ),
            //       ],
            //     ),
            //   );
            // }),
            SizedBox(height: 12),
            Expanded(
              child: Obx(() {
                if (controller.isStudentLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.studentList.isEmpty) {
                  return const Center(child: EmptyState());
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: controller.studentList.length,
                  itemBuilder: (_, i) =>
                      _studentTile(context, controller.studentList[i]),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dropdownTile(
    BuildContext context,
    bool light, {
    required IconData icon,
    required String label,
    String? value,
    bool enabled = true,
    bool isMultiline = false,
    VoidCallback? onTap,
  }) {
    final hasValue = value != null && value.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
          color: light ? Colors.white : const Color(0xFF1A1A1A),
        ),
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// LABEL

                      /// VALUE
                      Text(
                        hasValue ? value! : 'Tap to select'.tr,
                        maxLines: isMultiline ? 2 : 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight:
                              hasValue ? FontWeight.w500 : FontWeight.w400,
                          color: hasValue
                              ? (light ? Colors.black87 : Colors.white)
                              : Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: enabled ? Colors.grey : Colors.grey.shade300,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================= CLASS DROPDOWN =================
  Widget _classDropdown(BuildContext context) {
    final light = isLight(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: light ? Colors.white : const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: light ? Colors.grey.shade300 : Colors.grey.shade700,
          ),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            style: TextStyle(color: secondaryText(context)),
            value: 'class_nursery_b'.tr,
            isExpanded: true,
            items: [
              DropdownMenuItem(
                value: 'class_nursery_b'.tr,
                child: Text('class_nursery_b'.tr),
              ),
            ],
            onChanged: (_) {},
          ),
        ),
      ),
    );
  }

  // ================= SEARCH BAR =================
  Widget _searchBar(BuildContext context) {
    final light = isLight(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: light ? Colors.white : const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: light ? Colors.grey.shade300 : Colors.grey.shade700,
          ),
        ),
        child: TextField(
          controller: controller.searchController,
          onChanged: (value) {
            controller.fetchStudentsByClass(context); // 🔥 trigger API
          },
          decoration: InputDecoration(
            fillColor: light ? Colors.white : const Color(0xFF1E1E1E),
            icon: Icon(
              Icons.search,
              size: 22,
              color: light ? Colors.grey : Colors.grey[400],
            ),
            hintText: 'search_student'.tr,
            border: InputBorder.none,
          ),
          style: TextStyle(
            color: light ? Colors.black : Colors.white,
          ),
        ),
      ),
    );
  }

  // ================= STUDENT TILE =================
  Widget _studentTile(BuildContext context, StudentData student) {
    final light = isLight(context);
    final fullName = "${student.firstName ?? ""} ${student.lastName ?? ""}";

    return Obx(() {
      final status = controller.attendanceStatus[student.id ?? ""] ?? "";
      final isUpdatingThisStudent =
          controller.activeAttendanceStudentId.value == (student.id ?? "");
      final holidayBlocked = controller.isHolidayToday.value;
      final isCheckInDone = status == "checkin" || status == "checkout";
      final isCheckOutDone = status == "checkout";
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: light ? Colors.white : const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              ProfileAvatar(
                radius: 24,
                imageUrl: student.profileLink,
                backgroundColor: Colors.grey.shade300,
                iconColor: Colors.white,
              ),
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fullName,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: light ? Colors.black87 : Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          "roll_no".tr,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[500],
                          ),
                        ),
                        Text(
                          " : ${student.rollNumber ?? "-"}",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              /// CHECK IN
              GestureDetector(
                onTap: holidayBlocked || isCheckInDone || isUpdatingThisStudent
                    ? null
                    : () {
                        controller.markAttendance(
                          context: context,
                          student: student,
                          checkIn: true,
                          checkOut: false,
                        );
                      },
                child: _statusButton(
                  context,
                  icon: Icons.login,
                  color: const Color(0xFF21C58E),
                  active: isCheckInDone,
                  enabled: !holidayBlocked,
                  isLoading: isUpdatingThisStudent && !isCheckOutDone,
                ),
              ),
              const SizedBox(width: 8),

              /// CHECK OUT
              GestureDetector(
                onTap: holidayBlocked ||
                        isCheckOutDone ||
                        !isCheckInDone ||
                        isUpdatingThisStudent
                    ? null
                    : () {
                        controller.markAttendance(
                          context: context,
                          student: student,
                          checkIn: false,
                          checkOut: true,
                        );
                      },
                child: _statusButton(
                  context,
                  icon: Icons.logout,
                  color: const Color(0xFFE53935),
                  active: isCheckOutDone,
                  enabled: !holidayBlocked,
                  isLoading: isUpdatingThisStudent && isCheckInDone,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  // ================= STATUS BUTTON =================
  Widget _statusButton(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required bool active,
    bool enabled = true,
    bool isLoading = false,
  }) {
    final displayColor = enabled ? color : color.withOpacity(0.35);

    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active ? displayColor : Colors.transparent,
        border: Border.all(color: displayColor),
      ),
      child: isLoading
          ? const Padding(
              padding: EdgeInsets.all(7),
              child: CircularProgressIndicator(),
            )
          : Icon(
              icon,
              size: 18,
              color: active ? Colors.white : displayColor,
            ),
    );
  }
}
