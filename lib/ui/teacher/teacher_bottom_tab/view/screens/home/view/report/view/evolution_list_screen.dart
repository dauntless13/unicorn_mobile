import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../../../../controller/nursery_module_controller.dart';
import '../../../../../../../../../core/ColorUtils.dart';
import '../../../../../../../../../core/widget/back_button.dart';
import '../../../../../../../../../core/widget/empty_state.dart';
import '../../../../../../../../../core/widget/my_regular_text.dart';
import '../../../../../../../../../core/widget/profile_avatar.dart';
import '../../../../../../../../../routes/app_routs.dart';
import '../../../../profile/model/get_all_class/get_all_class_response.dart';
import '../../../../profile/view/common_selection_bottomsheet.dart';
import '../../add_post/mode/list_student_by_class/list_student_by_class_response.dart';
import '../controller/report_controller.dart';

class EvolutionListScreen extends StatefulWidget {
  const EvolutionListScreen({super.key});

  @override
  State<EvolutionListScreen> createState() => _EvolutionListScreenState();
}

class _EvolutionListScreenState extends State<EvolutionListScreen> {
  final ReportController controller = Get.put(ReportController());

  bool isLight(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      leaveIfTeacherEvaluationDisabled();
    });
  }

  @override
  Widget build(BuildContext context) {
    final light = isLight(context);

    return Scaffold(
      backgroundColor:
          light ? const Color(0xFFF6F7FB) : const Color(0xFF0F0F0F),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  appBackButton(context),
                  const SizedBox(width: 14),
                  MyRegularText(
                    label: 'evaluation'.tr,
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: primaryText(context),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Obx(
              () => _dropdownTile(
                context,
                light,
                value: controller.selectedClass.value?.name,
                onTap: () async {
                  await controller.fetchClasses(context);
                  showSelectionBottomSheet<Class>(
                    context: context,
                    title: 'Select Class'.tr,
                    items: controller.classList,
                    itemLabel: (e) => e.name ?? '',
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
              ),
            ),
            const SizedBox(height: 12),
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
          ],
        ),
      ),
    );
  }

  Widget _dropdownTile(
    BuildContext context,
    bool light, {
    String? value,
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
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    hasValue ? value! : 'Tap to select'.tr,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: hasValue ? FontWeight.w500 : FontWeight.w400,
                      color: hasValue
                          ? (light ? Colors.black87 : Colors.white)
                          : Colors.grey.shade400,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: Colors.grey,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _studentTile(BuildContext context, StudentData student) {
    final light = isLight(context);

    return GestureDetector(
      onTap: () {
        Get.toNamed(
          Routes.EVOLUTION_FORMS_LIST,
          arguments: {
            'slug': student.slug ?? '',
            'classSlug': controller.selectedClass.value?.slug ?? '',
            'studentName': '${student.firstName ?? ''} ${student.lastName ?? ''}'
                .trim(),
            'studentRoll': student.rollNumber ?? '',
            'studentClassName': controller.selectedClass.value?.name ?? '',
            'studentProfileLink': student.profileLink,
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: light ? Colors.white : const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: light ? Colors.grey.shade200 : Colors.grey.shade800,
          ),
          boxShadow: light
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [],
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
                  MyRegularText(
                    label:
                        '${student.firstName ?? ''} ${student.lastName ?? ''}'
                            .trim(),
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    align: TextAlign.start,
                    color: light ? Colors.black87 : Colors.white,
                  ),
                  const SizedBox(height: 4),
                  MyRegularText(
                    label: '${"roll_no".tr} : ${student.rollNumber ?? ""}',
                    fontSize: 12,
                    align: TextAlign.start,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
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
