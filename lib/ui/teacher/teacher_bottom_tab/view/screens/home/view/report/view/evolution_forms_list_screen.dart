import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../../../../controller/nursery_module_controller.dart';
import '../../../../../../../../../core/ColorUtils.dart';
import '../../../../../../../../../core/utils/media_open_helper.dart';
import '../../../../../../../../../core/widget/back_button.dart';
import '../../../../../../../../../core/widget/empty_state.dart';
import '../../../../../../../../../core/widget/my_form_field.dart';
import '../../../../../../../../../core/widget/my_regular_text.dart';
import '../../../../../../../../../core/widget/profile_avatar.dart';
import '../../../../../../../../../routes/app_routs.dart';
import '../../../../../../../../../widget/app_date_picker_helper.dart';
import '../../../../../../../../../widget/common_toastification.dart';
import '../controller/evolution_controller.dart';
import '../model/evaluation_forms_list/evaluation_forms_list_response.dart';

class EvolutionFormsListScreen extends StatefulWidget {
  final String studentSlug;
  final String classSlug;
  final String? studentName;
  final String? studentRoll;
  final String? studentClassName;
  final String? studentProfileLink;

  const EvolutionFormsListScreen({
    super.key,
    required this.studentSlug,
    required this.classSlug,
    this.studentName,
    this.studentRoll,
    this.studentClassName,
    this.studentProfileLink,
  });

  @override
  State<EvolutionFormsListScreen> createState() =>
      _EvolutionFormsListScreenState();
}

class _EvolutionFormsListScreenState extends State<EvolutionFormsListScreen> {
  final EvolutionController controller = Get.isRegistered<EvolutionController>()
      ? Get.find<EvolutionController>()
      : Get.put(EvolutionController());
  bool _showDateFilter = false;

  bool isLight(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!isTeacherEvaluationEnabled()) {
        Get.back();
        return;
      }
      controller.fetchEvolutionForms(
        context,
        studentSlug: widget.studentSlug,
        classSlug: widget.classSlug,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final light = isLight(context);

    return Scaffold(
      backgroundColor:
          light ? const Color(0xFFF6F7FB) : const Color(0xFF0F0F0F),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddEvolution,
        backgroundColor: primaryColor,
        icon: const Icon(Icons.add, color: Colors.white),
        label: MyRegularText(
          label: 'add_evaluation'.tr,
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Column(
                children: [
                  Row(
                    children: [
                      appBackButton(context),
                      const SizedBox(width: 14),
                      Expanded(
                        child: MyRegularText(
                          label: 'evolution_forms'.tr,
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: primaryText(context),
                        ),
                      ),
                      InkWell(
                        onTap: _openAddEvolution,
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color:
                                light ? Colors.white : const Color(0xFF1A1A1A),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: light
                                  ? Colors.grey.shade300
                                  : Colors.grey.shade800,
                            ),
                          ),
                          child: Icon(
                            Icons.add_rounded,
                            color: light ? Colors.black : Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildStudentCard(context),
                  const SizedBox(height: 14),
                  _buildSearchRow(context),
                  if (_showDateFilter) ...[
                    const SizedBox(height: 12),
                    Obx(() => _buildDateFilterCard(context)),
                  ],
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
                if (controller.isFormsLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.forms.isEmpty) {
                  return _buildEmptyState(context);
                }

                return RefreshIndicator(
                  onRefresh: () => controller.fetchEvolutionForms(
                    context,
                    studentSlug: widget.studentSlug,
                    classSlug: widget.classSlug,
                  ),
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                    itemCount: controller.forms.length,
                    itemBuilder: (context, index) {
                      return _buildFormCard(context, controller.forms[index]);
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentCard(BuildContext context) {
    final light = isLight(context);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: light ? Colors.white : const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: light ? Colors.grey.shade200 : Colors.grey.shade800,
        ),
      ),
      child: Row(
        children: [
          ProfileAvatar(
            radius: 24,
            imageUrl: widget.studentProfileLink,
            backgroundColor: Colors.grey.shade300,
            iconColor: Colors.white,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyRegularText(
                  label: widget.studentName ?? '-',
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: light ? Colors.black : Colors.white,
                  align: TextAlign.start,
                ),
                const SizedBox(height: 4),
                MyRegularText(
                  label: '${"roll_no".tr} : ${widget.studentRoll ?? "-"}',
                  fontSize: 12,
                  color: Colors.grey,
                  align: TextAlign.start,
                ),
                const SizedBox(height: 2),
                MyRegularText(
                  label: '${"class".tr} : ${widget.studentClassName ?? "-"}',
                  fontSize: 12,
                  color: Colors.grey,
                  align: TextAlign.start,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchRow(BuildContext context) {
    final light = isLight(context);

    return Row(
      children: [
        Expanded(
          child: MyFormField(
            controller: controller.formsSearchController,
            hintText: 'search_evolution'.tr,
            suffixIcon: InkWell(
              onTap: () {
                FocusScope.of(context).unfocus();
                controller.fetchEvolutionForms(
                  context,
                  studentSlug: widget.studentSlug,
                  classSlug: widget.classSlug,
                );
              },
              child: const Icon(Icons.search_rounded),
            ),
            onSubmitted: (_) {
              controller.fetchEvolutionForms(
                context,
                studentSlug: widget.studentSlug,
                classSlug: widget.classSlug,
              );
            },
          ),
        ),
        const SizedBox(width: 10),
        InkWell(
          onTap: () {
            FocusScope.of(context).unfocus();
            if (_showDateFilter) {
              controller.formsStartDate.value = null;
              controller.formsEndDate.value = null;
              setState(() {
                _showDateFilter = false;
              });
              controller.fetchEvolutionForms(
                context,
                studentSlug: widget.studentSlug,
                classSlug: widget.classSlug,
              );
              return;
            }

            setState(() {
              _showDateFilter = true;
            });
          },
          borderRadius: BorderRadius.circular(14),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: _showDateFilter
                  ? primaryColor.withOpacity(light ? 0.10 : 0.20)
                  : (light ? Colors.white : const Color(0xFF1A1A1A)),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: _showDateFilter
                    ? primaryColor
                    : (light ? Colors.grey.shade300 : Colors.grey.shade800),
              ),
            ),
            child: Icon(
              Icons.calendar_month_outlined,
              color: _showDateFilter
                  ? primaryColor
                  : (light ? Colors.black87 : Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateFilterCard(BuildContext context) {
    final light = isLight(context);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: light ? Colors.white : const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: light ? Colors.grey.shade200 : Colors.grey.shade800,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.date_range_outlined, size: 18),
              const SizedBox(width: 8),
              MyRegularText(
                label: 'evaluation_date_range'.tr,
                fontWeight: FontWeight.w600,
                color: light ? Colors.black : Colors.white,
              ),
              const Spacer(),
              if (controller.formsStartDate.value != null ||
                  controller.formsEndDate.value != null)
                MyRegularText(
                  label:
                      '${controller.displayDate(controller.formsStartDate.value)} - ${controller.displayDate(controller.formsEndDate.value)}',
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: light ? Colors.grey.shade700 : Colors.grey.shade400,
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildDateField(
                  context,
                  label: 'start_date'.tr,
                  value:
                      controller.displayDate(controller.formsStartDate.value),
                  onTap: () => _pickDate(context, isStart: true),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildDateField(
                  context,
                  label: 'end_date'.tr,
                  value: controller.displayDate(controller.formsEndDate.value),
                  onTap: () => _pickDate(context, isStart: false),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateField(
    BuildContext context, {
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    final light = isLight(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: light ? const Color(0xFFF8FAFC) : const Color(0xFF151515),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: light ? Colors.grey.shade300 : Colors.grey.shade800,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyRegularText(
              label: label,
              fontSize: 11,
              color: Colors.grey.shade600,
              align: TextAlign.start,
            ),
            const SizedBox(height: 4),
            MyRegularText(
              label: value,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: light ? Colors.black87 : Colors.white,
              align: TextAlign.start,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormCard(BuildContext context, Evaluations form) {
    final light = isLight(context);
    final submittedAt = _formatDateTime(form.submittedAt);
    final approvedAt = _formatDateTime(form.approvedAt);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: light ? Colors.white : const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: light ? Colors.grey.shade200 : Colors.grey.shade800,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileAvatar(
                radius: 22,
                imageUrl: form.profileLink,
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
                          form.studentName ?? widget.studentName ?? 'evaluation'.tr,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: light ? Colors.black : Colors.white,
                      align: TextAlign.start,
                    ),
                    const SizedBox(height: 4),
                    MyRegularText(
                      label:
                          '${'evaluation_date'.tr} : ${form.evaluationDate ?? '-'}',
                      fontSize: 12.5,
                      color:
                          light ? Colors.grey.shade700 : Colors.grey.shade400,
                      align: TextAlign.start,
                    ),
                    const SizedBox(height: 3),
                    MyRegularText(
                      label: '${'teacher_name'.tr} : ${form.teacherName ?? '-'}',
                      fontSize: 12.5,
                      color:
                          light ? Colors.grey.shade700 : Colors.grey.shade400,
                      align: TextAlign.start,
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(light ? 0.10 : 0.20),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: MyRegularText(
                  label: form.status ?? '-',
                  color: primaryColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildMetaChip(
                context,
                icon: Icons.tag_outlined,
                label: '${'roll_no'.tr} : ${form.rollNumber ?? '-'}',
              ),
              _buildMetaChip(
                context,
                icon: Icons.class_outlined,
                label: form.className ?? widget.studentClassName ?? '-',
              ),
              _buildMetaChip(
                context,
                icon: Icons.quiz_outlined,
                label: '${'answers_count'.tr} : ${form.answerCount ?? 0}',
              ),
            ],
          ),
          if ((form.teacherNote ?? '').isNotEmpty) ...[
            const SizedBox(height: 14),
            MyRegularText(
              label: form.teacherNote ?? '',
              align: TextAlign.start,
              style: TextStyle(
                fontFamily: 'GramatikaTrial',
                fontSize: 13,
                color: light ? Colors.grey.shade700 : Colors.grey.shade400,
                height: 1.4,
              ),
            ),
          ],
          if ((form.adminNote ?? '').isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color:
                    light ? const Color(0xFFF8FAFC) : const Color(0xFF151515),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyRegularText(
                    label: 'note'.tr,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: primaryColor,
                    align: TextAlign.start,
                  ),
                  const SizedBox(height: 6),
                  MyRegularText(
                    label: form.adminNote ?? '',
                    align: TextAlign.start,
                    style: TextStyle(
                      fontFamily: 'GramatikaTrial',
                      fontSize: 13,
                      color:
                          light ? Colors.grey.shade700 : Colors.grey.shade400,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: MyRegularText(
                  label:
                      submittedAt == null ? '' : '${'submitted_on'.tr} : $submittedAt',
                  fontSize: 12,
                  color: light ? Colors.grey.shade600 : Colors.grey.shade500,
                  align: TextAlign.start,
                ),
              ),
              if (approvedAt != null && approvedAt.isNotEmpty)
                MyRegularText(
                  label: '${'approved_on'.tr} : $approvedAt',
                  fontSize: 12,
                  color: light ? Colors.grey.shade600 : Colors.grey.shade500,
                ),
            ],
          ),
          if ((form.reportPdfLink ?? '').trim().isNotEmpty) ...[
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => openDownloadableMedia(
                  url: form.reportPdfLink,
                  title: 'view_report'.tr,
                  kind: DownloadableKind.pdf,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                icon: const Icon(Icons.visibility_rounded, color: Colors.white),
                label: Text(
                  'view_report'.tr,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMetaChip(
    BuildContext context, {
    required IconData icon,
    required String label,
  }) {
    final light = isLight(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: light ? const Color(0xFFF8FAFC) : const Color(0xFF151515),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: light ? Colors.grey.shade300 : Colors.grey.shade800,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 15,
            color: primaryColor,
          ),
          const SizedBox(width: 6),
          MyRegularText(
            label: label,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: light ? Colors.black87 : Colors.white,
            align: TextAlign.start,
          ),
        ],
      ),
    );
  }

  String? _formatDateTime(String? value) {
    if (value == null || value.isEmpty) return null;
    final parsed = DateTime.tryParse(value);
    if (parsed == null) return value;
    final local = parsed.toLocal();
    final day = local.day.toString().padLeft(2, '0');
    final month = local.month.toString().padLeft(2, '0');
    final year = local.year.toString();
    final hour = (local.hour % 12 == 0 ? 12 : local.hour % 12)
        .toString()
        .padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    final period = local.hour >= 12 ? 'PM' : 'AM';
    return '$day/$month/$year $hour:$minute $period';
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const EmptyState(),
            // const SizedBox(height: 16),
            // ElevatedButton.icon(
            //   onPressed: _openAddEvolution,
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: primaryColor,
            //     padding:
            //         const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(14),
            //     ),
            //   ),
            //   icon: const Icon(Icons.add, color: Colors.white),
            //   label: Text(
            //     'add_evaluation'.tr,
            //     style: const TextStyle(
            //       color: Colors.white,
            //       fontWeight: FontWeight.w700,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Future<void> _openAddEvolution() async {
    controller.prepareNewEvaluation();
    final result = await Get.toNamed(
      Routes.EVOLUTION_REPORT,
      arguments: {
        'slug': widget.studentSlug,
        'studentName': widget.studentName,
        'studentRoll': widget.studentRoll,
        'studentClassName': widget.studentClassName,
        'studentProfileLink': widget.studentProfileLink,
      },
    );

    if (result == true && mounted) {
      controller.fetchEvolutionForms(
        context,
        studentSlug: widget.studentSlug,
        classSlug: widget.classSlug,
      );
    }
  }

  Future<void> _pickDate(BuildContext context, {required bool isStart}) async {
    if (!isStart && controller.formsStartDate.value == null) {
      showAppSnackbar('Error', 'Please select start date first');
      return;
    }

    final initialDate = isStart
        ? (controller.formsStartDate.value ?? DateTime.now())
        : (controller.formsEndDate.value ??
            controller.formsStartDate.value ??
            DateTime.now());
    final firstDate = isStart
        ? DateTime(2020)
        : controller.formsStartDate.value ?? DateTime(2020);
    final lastDate = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: buildAppDatePickerThemeBuilder(
        context,
        primaryColor: primaryColor,
      ),
    );

    if (picked == null) return;

    if (isStart) {
      controller.formsStartDate.value = picked;
      if (controller.formsEndDate.value != null &&
          controller.formsEndDate.value!.isBefore(picked)) {
        controller.formsEndDate.value = picked;
      }
    } else {
      controller.formsEndDate.value = picked;
    }

    controller.fetchEvolutionForms(
      context,
      studentSlug: widget.studentSlug,
      classSlug: widget.classSlug,
    );
  }
}
