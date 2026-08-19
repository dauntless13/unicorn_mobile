import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';

import '../../../../../../../../../controller/nursery_module_controller.dart';
import '../../../../../../../../../core/ColorUtils.dart';
import '../../../../../../../../../core/widget/back_button.dart';
import '../../../../../../../../../core/widget/empty_state.dart';
import '../../../../../../../../../core/widget/my_form_field.dart';
import '../../../../../../../../../core/widget/my_regular_text.dart';
import '../../../../../../../../../core/widget/profile_avatar.dart';
import '../../../../../../../../../widget/app_date_picker_helper.dart';
import '../../../../../../../../../widget/common_toastification.dart';
import '../controller/evolution_controller.dart';
import '../model/evaluation_question/evaluation_question_response.dart';

class EvolutionReportScreen extends StatefulWidget {
  final String slug;
  final String? studentName;
  final String? studentRoll;
  final String? studentClassName;
  final String? studentProfileLink;

  const EvolutionReportScreen({
    super.key,
    required this.slug,
    this.studentName,
    this.studentRoll,
    this.studentClassName,
    this.studentProfileLink,
  });

  @override
  State<EvolutionReportScreen> createState() => _EvolutionReportScreenState();
}

class _EvolutionReportScreenState extends State<EvolutionReportScreen> {
  final EvolutionController controller = Get.isRegistered<EvolutionController>()
      ? Get.find<EvolutionController>()
      : Get.put(EvolutionController());

  bool _isReportingPeriodExpanded = false;

  bool isLight(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light;

  Color get _accent => const Color(0xFF0C7189);

  final List<_EvaluationOption> _options = const [
    _EvaluationOption(
      code: 'A',
      titleKey: 'achieved_title',
      subtitleKey: 'achieved_subtitle',
      meaning: 'Doing it well',
      color: Color(0xFF22C55E),
    ),
    _EvaluationOption(
      code: 'D',
      titleKey: 'developing_title',
      subtitleKey: 'developing_subtitle',
      meaning: 'Learning it',
      color: Color(0xFFF59E0B),
    ),
    _EvaluationOption(
      code: 'E',
      titleKey: 'emerging_title',
      subtitleKey: 'emerging_subtitle',
      meaning: 'Just starting',
      color: Color(0xFF6366F1),
    ),
  ];

  List<_EvaluationOption> _optionsFor(Questions question) {
    final palette = {for (final item in _options) item.code: item};
    final fromApi = question.answerOptions;
    if (fromApi.isNotEmpty) {
      return fromApi.map((item) {
        final base = palette[item.code] ?? _options.first;
        final label = item.label.trim();
        return _EvaluationOption(
          code: item.code,
          titleKey: base.titleKey,
          subtitleKey: base.subtitleKey,
          meaning: label.isEmpty ? base.meaning : label,
          color: base.color,
        );
      }).toList();
    }
    return _options
        .where((option) => question.optionCodes.contains(option.code))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!isTeacherEvaluationEnabled()) {
        Get.back();
        return;
      }
      controller.prepareNewEvaluation();
      controller.loadEvaluationData(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final light = isLight(context);

    return Scaffold(
      backgroundColor:
          light ? const Color(0xFFF6F7FB) : const Color(0xFF0F0F0F),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.questions.isEmpty) {
            return _buildEmptyState(context);
          }

          final question = controller.currentQuestion;
          if (question == null) {
            return _buildEmptyState(context);
          }

          final selectedAnswer = controller.selectedAnswerForCurrent();
          final currentIndex = controller.currentQuestionIndex.value;
          final totalQuestions = controller.questions.length;
          final currentArea = controller.currentArea?.area ?? '';

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        appBackButton(context),
                        const SizedBox(width: 14),
                        Expanded(
                          child: MyRegularText(
                            label: 'add_evaluation'.tr,
                            fontSize: 21,
                            fontWeight: FontWeight.w500,
                            color: primaryText(context),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildTopSummary(context),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildQuestionCard(
                        context,
                        title: question.title ?? '',
                        subtitle: question.description ?? '',
                        currentArea: currentArea,
                        currentIndex: currentIndex,
                        totalQuestions: totalQuestions,
                      ),
                      const SizedBox(height: 14),
                      ..._optionsFor(question).map(
                        (option) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _buildOptionCard(
                            context,
                            option: option,
                            isSelected: selectedAnswer == option.code,
                            onTap: () {
                              if (question.id == null) return;
                              controller.selectAnswer(
                                  question.id!, option.code);
                            },
                          ),
                        ),
                      ),
                      // const SizedBox(height: 10),
                      // _buildTeacherNoteCard(context),
                    ],
                  ),
                ),
              ),
              _buildBottomBar(context),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              appBackButton(context),
              const SizedBox(width: 14),
              MyRegularText(
                label: 'add_evaluation'.tr,
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: primaryText(context),
              ),
            ],
          ),
        ),
        const Expanded(child: Center(child: EmptyState())),
      ],
    );
  }

  Widget _buildTopSummary(BuildContext context) {
    final light = isLight(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: light ? Colors.white : const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: light ? Colors.grey.shade200 : Colors.grey.shade800,
        ),
      ),
      child: Column(
        children: [
          Row(
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
                      fontSize: 14,
                      align: TextAlign.start,
                      color: light ? Colors.black : Colors.white,
                    ),
                    const SizedBox(height: 3),
                    MyRegularText(
                      label:
                          '${"roll_no".tr} : ${widget.studentRoll ?? "-"}   ${"class".tr} : ${widget.studentClassName ?? "-"}',
                      fontSize: 11.5,
                      color: Colors.grey,
                      align: TextAlign.start,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildDateCard(context),
        ],
      ),
    );
  }

  Widget _buildDateCard(BuildContext context) {
    final light = isLight(context);
    final hasDates = controller.reportingStartDate.value != null &&
        controller.reportingEndDate.value != null;
    final rangeText = hasDates
        ? '${controller.displayDate(controller.reportingStartDate.value)} - ${controller.displayDate(controller.reportingEndDate.value)}'
        : 'Required';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: light ? const Color(0xFFF8FAFC) : const Color(0xFF151515),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: hasDates
              ? (light ? Colors.grey.shade300 : Colors.grey.shade800)
              : const Color(0xFFEF4444).withOpacity(0.55),
        ),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _isReportingPeriodExpanded = !_isReportingPeriodExpanded;
              });
            },
            borderRadius: BorderRadius.circular(12),
            child: Row(
              children: [
                const Icon(Icons.date_range_outlined, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: MyRegularText(
                    label: 'reporting_period'.tr,
                    fontWeight: FontWeight.w600,
                    color: light ? Colors.black : Colors.white,
                  ),
                ),
                MyRegularText(
                  label: rangeText,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: hasDates
                      ? (light ? Colors.grey.shade700 : Colors.grey.shade400)
                      : const Color(0xFFEF4444),
                ),
                const SizedBox(width: 6),
                Icon(
                  _isReportingPeriodExpanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: light ? Colors.black54 : Colors.white70,
                ),
              ],
            ),
          ),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 220),
            crossFadeState: _isReportingPeriodExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                children: [
                  Expanded(
                    child: _buildDateField(
                      context,
                      label: 'start_date'.tr,
                      value: controller.displayDate(
                        controller.reportingStartDate.value,
                      ),
                      onTap: () =>
                          _pickDate(context, type: _DateType.reportingStart),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildDateField(
                      context,
                      label: 'end_date'.tr,
                      value: controller.displayDate(
                        controller.reportingEndDate.value,
                      ),
                      onTap: () =>
                          _pickDate(context, type: _DateType.reportingEnd),
                    ),
                  ),
                ],
              ),
            ),
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
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
        decoration: BoxDecoration(
          color: light ? Colors.white : const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(12),
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
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: light ? Colors.black87 : Colors.white,
              align: TextAlign.start,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String currentArea,
    required int currentIndex,
    required int totalQuestions,
  }) {
    final light = isLight(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: light ? Colors.white : const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: light ? Colors.grey.shade200 : Colors.grey.shade800,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: MyRegularText(
                  label: currentArea.isEmpty ? 'evaluation'.tr : currentArea,
                  maxlines: 1,
                  overflow: TextOverflow.ellipsis,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: _accent,
                  align: TextAlign.start,
                ),
              ),
              MyRegularText(
                label: '${currentIndex + 1}/$totalQuestions',
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: _accent,
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: controller.progress,
              minHeight: 6,
              backgroundColor:
                  light ? Colors.grey.shade200 : Colors.grey.shade800,
              valueColor: AlwaysStoppedAnimation<Color>(_accent),
            ),
          ),
          const SizedBox(height: 12),
          MyRegularText(
            label: 'evaluation_question'.tr,
            fontSize: 12,
            color: Colors.grey,
          ),
          const SizedBox(height: 8),
          MyRegularText(
            label: title,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: light ? Colors.black : Colors.white,
            align: TextAlign.start,
            style: TextStyle(
              fontFamily: 'GramatikaTrial',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: light ? Colors.black : Colors.white,
              height: 1.35,
            ),
          ),
          if (subtitle.isNotEmpty) ...[
            const SizedBox(height: 10),
            MyRegularText(
              label: subtitle,
              align: TextAlign.start,
              style: TextStyle(
                fontFamily: 'GramatikaTrial',
                fontSize: 13,
                color: light ? Colors.grey.shade700 : Colors.grey.shade400,
                height: 1.45,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOptionCard(
    BuildContext context, {
    required _EvaluationOption option,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final light = isLight(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected
              ? option.color.withOpacity(light ? 0.12 : 0.20)
              : (light ? Colors.white : const Color(0xFF1A1A1A)),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? option.color
                : (light ? Colors.grey.shade200 : Colors.grey.shade800),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: option.color.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: MyRegularText(
                  label: option.code,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: option.color,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyRegularText(
                    label: option.meaning,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: light ? Colors.black : Colors.white,
                    align: TextAlign.start,
                  ),
                ],
              ),
            ),
            Icon(
              isSelected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_off_rounded,
              color: isSelected ? option.color : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeacherNoteCard(BuildContext context) {
    final light = isLight(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: light ? Colors.white : const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: light ? Colors.grey.shade200 : Colors.grey.shade800,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyRegularText(
            label: 'teacher_note'.tr,
            fontWeight: FontWeight.w600,
            color: light ? Colors.black : Colors.white,
          ),
          const SizedBox(height: 10),
          MyFormField(
            controller: controller.teacherNoteController,
            hintText: 'teacher_note_hint'.tr,
            minLines: 3,
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    final light = isLight(context);
    final isFirst = controller.currentQuestionIndex.value == 0;
    final isLast = controller.currentQuestionIndex.value ==
        controller.questions.length - 1;
    final canGoNext = controller.hasAnsweredCurrent();

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
      decoration: BoxDecoration(
        color: light ? Colors.white : const Color(0xFF141414),
        border: Border(
          top: BorderSide(
            color: light ? Colors.grey.shade200 : Colors.grey.shade800,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: isFirst || controller.isSubmitting.value
                  ? null
                  : controller.goPrevious,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                side: BorderSide(
                  color: light ? Colors.grey.shade300 : Colors.grey.shade700,
                ),
              ),
              child: MyRegularText(
                label: 'previous_question'.tr,
                color: light ? Colors.black87 : Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: !canGoNext || controller.isSubmitting.value
                  ? null
                  : () async {
                      if (!isLast) {
                        controller.goNext();
                        return;
                      }

                      if (controller.reportingStartDate.value == null ||
                          controller.reportingEndDate.value == null) {
                        setState(() {
                          _isReportingPeriodExpanded = true;
                        });
                      }

                      if (controller.reportingStartDate.value == null ||
                          controller.reportingEndDate.value == null) {
                        showToast(
                          context,
                          "Error",
                          "Please select date range",
                          type: ToastificationType.error,
                        );
                        return;
                      }

                      final shouldSubmit =
                          await _showTeacherNoteDialog(context);

                      if (!shouldSubmit) return;

// Then submit
                      final success = await controller.submitEvaluation(
                        context,
                        studentSlug: widget.slug,
                      );
                      if (success && mounted) {
                        Get.back(result: true);
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: _accent,
                disabledBackgroundColor: _accent.withOpacity(0.35),
                minimumSize: const Size.fromHeight(48),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: controller.isSubmitting.value
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : MyRegularText(
                      label: isLast ? 'submit'.tr : 'next_question'.tr,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickDate(BuildContext context,
      {required _DateType type}) async {
    if (type == _DateType.reportingEnd &&
        controller.reportingStartDate.value == null) {
      showAppSnackbar('Error', 'Please select start date first');
      setState(() {
        _isReportingPeriodExpanded = true;
      });
      return;
    }

    final initialDate = type == _DateType.reportingStart
        ? (controller.reportingStartDate.value ?? DateTime.now())
        : (controller.reportingEndDate.value ??
            controller.reportingStartDate.value ??
            DateTime.now());
    final firstDate = type == _DateType.reportingStart
        ? DateTime(2020)
        : controller.reportingStartDate.value ?? DateTime(2020);
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

    if (type == _DateType.reportingStart) {
      controller.reportingStartDate.value = picked;
      if (controller.reportingEndDate.value != null &&
          controller.reportingEndDate.value!.isBefore(picked)) {
        controller.reportingEndDate.value = picked;
      }
      return;
    }

    controller.reportingEndDate.value = picked;
  }

  Future<bool> _showTeacherNoteDialog(BuildContext context) async {
    final TextEditingController noteController =
        controller.teacherNoteController;

    final light = Theme.of(context).brightness == Brightness.light;

    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: light ? Colors.white : const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 🔹 Top Icon
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0C7189).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.edit_note_rounded,
                        color: Color(0xFF0C7189),
                        size: 26,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // 🔹 Title
                    MyRegularText(
                      label: 'Add Teacher Note',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: light ? Colors.black : Colors.white,
                    ),

                    const SizedBox(height: 6),

                    // 🔹 Subtitle
                    MyRegularText(
                      label:
                          'You can add final remarks before submitting evaluation',
                      align: TextAlign.center,
                      fontSize: 12.5,
                      color: Colors.grey.shade600,
                    ),

                    const SizedBox(height: 16),

                    // 🔹 Input Field
                    Container(
                      decoration: BoxDecoration(
                        color: light
                            ? const Color(0xFFF8FAFC)
                            : const Color(0xFF141414),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: light
                              ? Colors.grey.shade300
                              : Colors.grey.shade800,
                        ),
                      ),
                      child: TextField(
                        controller: noteController,
                        maxLines: 4,
                        style: TextStyle(
                          color: light ? Colors.black : Colors.white,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Write teacher note...',
                          hintStyle: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 13,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // 🔹 Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context, false),
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size.fromHeight(45),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const MyRegularText(
                              label: 'Cancel',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context, true);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0C7189),
                              minimumSize: const Size.fromHeight(45),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const MyRegularText(
                              label: 'Submit',
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ) ??
        false;
  }
}

enum _DateType {
  reportingStart,
  reportingEnd,
}

class _EvaluationOption {
  final String code;
  final String titleKey;
  final String subtitleKey;
  final String meaning;
  final Color color;

  const _EvaluationOption({
    required this.code,
    required this.titleKey,
    required this.subtitleKey,
    required this.meaning,
    required this.color,
  });
}
