import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../../../core/ColorUtils.dart';
import '../../../../../../core/widget/back_button.dart';
import '../../../../../../core/widget/my_regular_text.dart';
import '../../../../../../core/widget/profile_avatar.dart';
import 'controller/teacher_kids_controller.dart';

class StudentDetailsScreen extends StatefulWidget {
  final String? slug;

  const StudentDetailsScreen({super.key, required this.slug});

  @override
  State<StudentDetailsScreen> createState() => _StudentDetailsScreenState();
}

class _StudentDetailsScreenState extends State<StudentDetailsScreen> {
  bool isLight(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light;

  Color pageBg(BuildContext context) =>
      isLight(context) ? Colors.white : const Color(0xFF0F0F0F);

  Color cardBg(BuildContext context) =>
      isLight(context) ? Colors.white : const Color(0xFF1A1A1A);

  Color softBg(BuildContext context) =>
      isLight(context) ? Colors.grey.shade100 : const Color(0xFF242424);

  Color primaryText(BuildContext context) =>
      isLight(context) ? Colors.black87 : Colors.white;

  Color secondaryText(BuildContext context) =>
      isLight(context) ? Colors.black : Colors.grey.shade400;

  Color borderClr(BuildContext context) =>
      isLight(context) ? Colors.grey.shade300 : Colors.white.withOpacity(0.12);

  Color dividerClr(BuildContext context) =>
      isLight(context) ? Colors.grey.shade200 : Colors.white.withOpacity(0.08);
  final TeacherKidsController controller = Get.put(TeacherKidsController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 0), () {
      controller.fetchStudentsBySlug(context, widget.slug!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBg(context),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    appBackButton(context),
                    SizedBox(width: 6),
                    MyRegularText(
                      label: 'Student Details'.tr,
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: primaryText(context),
                    ),
                  ],
                ),
                Obx(() {
                  if (controller.isStudentDetailsLoading.value) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 100),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (controller.studentDetails.value == null) {
                    return const SizedBox();
                  }

                  return _buildInfoTab();
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // TAB 1: INFO
  Widget _buildInfoTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          _buildKidInfoCard(true),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: softBg(context),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _buildInfoSection(
                  'date_of_birth'.tr,
                  controller.studentDetails.value?.dateOfBirth != null
                      ? "${controller.studentDetails.value!.dateOfBirth!.day}-${controller.studentDetails.value!.dateOfBirth!.month}-${controller.studentDetails.value!.dateOfBirth!.year}"
                      :   "-".tr,
                ),
                _buildInfoSection('gender'.tr,
                    controller.studentDetails.value?.gender ??   "-".tr,),
                _buildInfoSection('class_name'.tr,
                    controller.studentDetails.value?.className ??   "-".tr,),
                _buildInfoSection('roll_no'.tr,
                    controller.studentDetails.value?.rollNo ??   "-".tr,),
                _buildInfoSection(
                    'phone_no'.tr,
                    '${controller.studentDetails.value?.parentProfile?.countryCode} ${controller
                        .studentDetails.value?.parentProfile?.phoneNumber ??
                        "-".tr}',
                    isPhone: true),
                _buildInfoSection(
                    'father_name'.tr,
                    "${controller.studentDetails.value?.parentProfile?.firstName ??   "-".tr} "
                            "${controller.studentDetails.value?.parentProfile?.lastName ??   "-".tr}"
                        .trim()),
                _buildInfoSection('address'.tr,
                    controller.studentDetails.value?.address ??   "-".tr,),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionHeader('parent_information'.tr),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: softBg(context),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _buildInfoSection(
                  'Name'.tr,
                  "${controller.studentDetails.value?.parentProfile?.firstName ??   "-".tr} "
                          "${controller.studentDetails.value?.parentProfile?.lastName ??   "-".tr}"
                      .trim(),
                ),
                _buildInfoSection(
                  'Phone No'.tr,
                  '${controller.studentDetails.value?.parentProfile?.countryCode} ${controller.studentDetails.value?.parentProfile?.phoneNumber ??
                  "-".tr}',
                  isPhone: true,
                ),
                _buildInfoSection(
                  'Relationship'.tr,
                  controller
                          .studentDetails.value?.parentProfile?.relationship ??
                      "-".tr,
                ),
                _buildInfoSection(
                  'Occupation'.tr,
                  controller.studentDetails.value?.parentProfile?.occupation ??
                      "-".tr,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionHeader('emergency_contact'.tr),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: softBg(context),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _buildInfoSection(
                  'Name'.tr,
                  "${controller.studentDetails.value?.emergencyContact?.firstName ??   "-".tr} "
                          "${controller.studentDetails.value?.emergencyContact?.lastName ??   "-".tr}"
                      .trim(),
                ),
                _buildInfoSection(
                  'Phone No'.tr,
                  '${controller.studentDetails.value?.emergencyContact?.countryCode} ${controller.studentDetails.value?.emergencyContact
                      ?.phoneNumber ??
                      "-".tr }',
                  isPhone: true,
                ),
                _buildInfoSection(
                  'Relationship'.tr,
                  controller.studentDetails.value?.emergencyContact?.relation ??
                      "-".tr,
                ),
                _buildInfoSection(
                  'Occupation'.tr,
                  controller
                          .studentDetails.value?.emergencyContact?.occupation ??
                      "-".tr,
                ),
              ],
            ),
          ),

          Visibility(
            visible:
                controller.studentDetails.value?.medicalInfo?.note?.trim().isNotEmpty ??
                    false,
            child: Column(
              children: [
                const SizedBox(height: 24),
                _buildSectionHeader('medical_info'.tr),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: softBg(context),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      // _buildInfoSection('Cold Allergy', ''),
                      // _buildInfoSection('Dust Allergy', ''),
                      // _buildInfoSection('Keep away from dust and dry places', ''),
                      _buildInfoSection(
                        controller.studentDetails.value?.medicalInfo?.note?.trim() ??
                            "-".tr,
                        "-".tr,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // Widget _buildKidInfoCard(bool isEdit) {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
  //     decoration: BoxDecoration(
  //       color: cardBg(context),
  //       borderRadius: BorderRadius.circular(12),
  //       border: Border.all(
  //         color: borderClr(context),
  //         width: 1,
  //       ),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withOpacity(0.04),
  //           blurRadius: 8,
  //           offset: const Offset(0, 2),
  //         ),
  //       ],
  //     ),
  //     child: Row(
  //       children: [
  //         CircleAvatar(
  //           radius: 26,
  //           backgroundImage: NetworkImage(kids[_selectedKidIndex]['image']!),
  //         ),
  //         const SizedBox(width: 14),
  //         Expanded(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               MyRegularText(
  //                 label: kids[_selectedKidIndex]['name']!,
  //                 fontSize: 16,
  //                 fontWeight: FontWeight.w600,
  //                 color: primaryText(context),
  //               ),
  //               const SizedBox(height: 2),
  //               MyRegularText(
  //                 label: 'Roll No: 142',
  //                 fontSize: 13,
  //                 color: secondaryText(context),
  //               ),
  //               const SizedBox(height: 2),
  //               MyRegularText(
  //                 label: 'Class Nursery 07',
  //                 fontSize: 13,
  //                 color: secondaryText(context),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  Widget _buildKidInfoCard(bool isEdit) {
    final student = controller.studentDetails.value;

    if (student == null) return const SizedBox();

    final fullName =
        "${student.firstName ?? ""} ${student.lastName ?? ""}".trim();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: cardBg(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: borderClr(context),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ProfileAvatar(
            radius: 26,
            imageUrl: student.profileLink,
            backgroundColor: Colors.grey.shade300,
            iconColor: Colors.white,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyRegularText(
                  label: fullName,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: primaryText(context),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    MyRegularText(
                        label: "roll_no".tr,
                        fontSize: 13,
                        color: secondaryText(context)),
                    MyRegularText(
                      label: " : ${student.rollNo ??  "-".tr}",
                      fontSize: 13,
                      color: secondaryText(context),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    MyRegularText(
                      label: "Class".tr,
                      fontSize: 13,
                      color: secondaryText(context),
                    ),
                    MyRegularText(
                      label: " : ${student.className ??   "-".tr}",
                      fontSize: 13,
                      color: secondaryText(context),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String label, String value, {bool isPhone = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MyRegularText(
            label: label.tr,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: secondaryText(context),
          ),
          Flexible(
            child: MyRegularText(
              label: displayValue(value),
              fontSize: 14,
              color: isPhone ? Colors.blue : primaryText(context),
              fontWeight: FontWeight.bold,
              maxlines: 2,
              align: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      decoration: BoxDecoration(
        color: pageBg(context),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: MyRegularText(
        label: title,
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: primaryText(context),
      ),
    );
  }
  String displayValue(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "-".tr;
    }
    return value;
  }
}
