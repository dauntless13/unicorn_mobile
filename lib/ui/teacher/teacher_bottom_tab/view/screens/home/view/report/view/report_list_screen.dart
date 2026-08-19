import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unicorn/ui/teacher/teacher_bottom_tab/view/screens/home/view/report/view/report_details_screen.dart';

import '../../../../../../../../../core/ColorUtils.dart';
import '../../../../../../../../../core/widget/back_button.dart';
import '../../../../../../../../../core/widget/my_regular_text.dart';
import '../../../../../../../../../core/widget/empty_state.dart';
import '../../../../../../../../../core/widget/profile_avatar.dart';
import '../../../../../../../../../routes/app_routs.dart';
import '../../../../profile/model/get_all_class/get_all_class_response.dart';
import '../../../../profile/view/common_selection_bottomsheet.dart';
import '../../add_post/mode/list_student_by_class/list_student_by_class_response.dart';
import '../../attendance/model/get_student_list_by_class/get_student_list_by_class_response.dart';
import '../controller/report_controller.dart';

class ReportListScreen extends StatefulWidget {
  const ReportListScreen({super.key});

  @override
  State<ReportListScreen> createState() => _ReportListScreenState();
}

class _ReportListScreenState extends State<ReportListScreen> {
  bool isLight(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light;

  final ReportController controller = Get.put(ReportController());

  @override
  Widget build(BuildContext context) {
    final light = isLight(context);

    return Scaffold(
      backgroundColor:
      light ? const Color(0xFFF6F7FB) : const Color(0xFF0F0F0F),

      /// ================= BODY =================
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  appBackButton(context),
                  SizedBox(width: 14),
                  MyRegularText(
                    label: 'report'.tr,
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: primaryText(context),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            /// CLASS DROPDOWN
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

            const SizedBox(height: 12),

            /// STUDENT LIST
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
                  itemBuilder: (context, index) {
                    final student = controller.studentList[index];
                    return _studentTile(context, student);
                  },
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: () => Get.toNamed(Routes.QUICK_LOG),
                  icon: const Icon(Icons.people_alt_outlined, color: primaryColor),
                  label: Text(
                    'daily_log'.tr,
                    style: const TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: primaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
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
  // ================= STUDENT TILE =================
  Widget _studentTile(BuildContext context, StudentData student) {
    final light = isLight(context);

    return GestureDetector(
      onTap: () {
        Get.to(ReportDetailsScreen(slug: student.slug ?? ""));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: light ? Colors.white : const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: light
                ? Colors.grey.shade200
                : Colors.grey.shade800,
          ),
        ),
        child: Row(
          children: [
            /// AVATAR
            ProfileAvatar(
              radius: 24,
              imageUrl: student.profileLink,
              backgroundColor: Colors.grey.shade300,
              iconColor: Colors.white,
            ),

            const SizedBox(width: 12),

            /// NAME + ROLL
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyRegularText(
                    label: '${student.firstName} ${student.lastName}',
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    align: TextAlign.start,
                    color:
                    light ? Colors.black87 : Colors.white,
                  ),
                  const SizedBox(height: 4),
                  MyRegularText(
                    label:
                    "${"roll_no".tr} : ${student.rollNumber ?? ""}",
                    fontSize: 12,
                    align: TextAlign.start,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),

            /// ARROW
            Icon(
              Icons.arrow_right,
              size: 24,
              color: light ? Colors.black : Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }
}
