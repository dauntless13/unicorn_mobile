import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unicorn/core/widget/my_regular_text.dart';
import 'package:unicorn/core/widget/empty_state.dart';
import 'package:unicorn/core/widget/profile_avatar.dart';
import 'package:unicorn/ui/teacher/teacher_bottom_tab/view/screens/kids/student_details_screen.dart';

import '../../../../../../core/ColorUtils.dart';
import '../home/view/add_post/mode/list_student_by_class/list_student_by_class_response.dart';
import '../profile/model/get_all_class/get_all_class_response.dart';
import '../profile/view/common_selection_bottomsheet.dart';
import 'controller/teacher_kids_controller.dart';

class TeacherKidsScreen extends StatefulWidget {
  const TeacherKidsScreen({super.key});

  @override
  State<TeacherKidsScreen> createState() =>
      _TeacherKidsScreenState();
}

class _TeacherKidsScreenState
    extends State<TeacherKidsScreen> {
  final TextEditingController searchController =
  TextEditingController();
final TeacherKidsController controller = Get.put(TeacherKidsController());

  bool isLight(BuildContext context) =>
      Theme.of(context).brightness ==
          Brightness.light;

  @override
  void initState() {
    super.initState();
    controller.clearKidsScreenData();
  }

  @override
  Widget build(BuildContext context) {
    final light = isLight(context);

    return Scaffold(
      backgroundColor:
      light ? Colors.white : const Color(0xFF0F0F0F),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              /// CLASS DROPDOWN
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
              const SizedBox(height: 12),

              /// SEARCH
              _searchBar(context),

              const SizedBox(height: 16),

              /// STUDENT LIST
              Expanded(
                child: Obx(() {
                  if (controller.isStudentLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (controller.studentList.isEmpty) {
                    return const Center(child: EmptyState());
                  }

                  return ListView.separated(
                    itemCount: controller.studentList.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final student = controller.studentList[index];
                      return _studentCard(context, student);
                    },
                  );
                }),
              ),
            ],
          ),
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

    return Container(
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
    );
  }

  // ================= CLASS DROPDOWN =================
  Widget _classDropdown(BuildContext context) {
    final light = isLight(context);

    return Container(
      padding:
      const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border:
        Border.all(color: textFieldBorderColor),
        color:
        light ? Colors.white : const Color(0xFF1E1E1E),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          icon: Icon(
            Icons.arrow_drop_down,
            color:
            light ? Colors.black : Colors.white,
          ),
          value: 'class_nursery_b'.tr,
          isExpanded: true,
          items: [
            DropdownMenuItem(
              value: 'class_nursery_b'.tr,
              child: MyRegularText(
                label: 'class_nursery_b'.tr,
                color: light
                    ? Colors.black
                    : Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
                align: TextAlign.start,
              ),
            ),
          ],
          onChanged: (_) {},
        ),
      ),
    );
  }

  // ================= SEARCH =================
  Widget _searchBar(BuildContext context) {
    final light = isLight(context);

    return Container(
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
          controller.fetchStudentsByClass(context); // 🔥 LIVE SEARCH
        },
        decoration: InputDecoration(
          fillColor: light ? Colors.white : const Color(0xFF1E1E1E),
          icon: Icon(
            Icons.search,
            size: 22,
            color: light ? Colors.grey : Colors.grey[400],
          ),
          hintText: 'search_hint'.tr,
          border: InputBorder.none,
        ),
        style: TextStyle(
          color: light ? Colors.black : Colors.white,
        ),
      ),
    );
  }

  // ================= STUDENT CARD =================
  // Widget _studentCard(BuildContext context, Map<String, String> student) {
  //   final light = isLight(context);
  //
  //   return GestureDetector(
  //     onTap: () =>
  //         Get.to(() => StudentDetailsScreen()),
  //     child: Container(
  //       padding: const EdgeInsets.all(12),
  //       decoration: BoxDecoration(
  //         color:
  //         light ? Colors.white : const Color(0xFF1A1A1A),
  //         borderRadius: BorderRadius.circular(16),
  //         boxShadow: light
  //             ? [
  //           BoxShadow(
  //             color:
  //             Colors.black.withOpacity(0.05),
  //             blurRadius: 8,
  //             offset: const Offset(0, 4),
  //           ),
  //         ]
  //             : [],
  //         border: Border.all(
  //           color: light
  //               ? Colors.grey.shade200
  //               : Colors.grey.shade800,
  //         ),
  //       ),
  //       child: Row(
  //         children: [
  //           /// AVATAR
  //           CircleAvatar(
  //             radius: 24,
  //             backgroundImage:
  //             NetworkImage(student["image"]!),
  //           ),
  //
  //           const SizedBox(width: 12),
  //
  //           /// NAME + ROLL
  //           Expanded(
  //             child: Column(
  //               crossAxisAlignment:
  //               CrossAxisAlignment.start,
  //               children: [
  //                 MyRegularText(
  //                   label: student["name"]!,
  //                   fontWeight: FontWeight.w600,
  //                   align: TextAlign.start,
  //                   color: light
  //                       ? Colors.black
  //                       : Colors.white,
  //                 ),
  //                 const SizedBox(height: 4),
  //                 MyRegularText(
  //                   label: student["roll"]!,
  //                   align: TextAlign.start,
  //                   color: Colors.grey,
  //                 ),
  //               ],
  //             ),
  //           ),
  //
  //           /// ARROW
  //           Icon(
  //             Icons.chevron_right,
  //             color: light
  //                 ? Colors.black54
  //                 : Colors.white70,
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  Widget _studentCard(
      BuildContext context,
      StudentData student) {

    final light = isLight(context);

    final fullName =
    "${student.firstName ?? ""} ${student.lastName ?? ""}".trim();

    return GestureDetector(
      onTap: () => Get.to(() => StudentDetailsScreen(slug: student.slug,)),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: light ? Colors.white : const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(16),
          boxShadow: light
              ? [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ]
              : [],
          border: Border.all(
            color: light
                ? Colors.grey.shade200
                : Colors.grey.shade800,
          ),
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
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  MyRegularText(
                    label: fullName.isNotEmpty
                        ? fullName
                        : "No Name",
                    fontWeight: FontWeight.w600,
                    align: TextAlign.start,
                    color: light
                        ? Colors.black
                        : Colors.white,
                  ),
                  const SizedBox(height: 4),
                  MyRegularText(
                    label:
                    '${'roll_no'.tr} : ${student.rollNumber ?? "No Roll"}',
                    align: TextAlign.start,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),

            Icon(
              Icons.arrow_right,
              color: light
                  ? Colors.black54
                  : Colors.white70,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
