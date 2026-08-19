import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../../../../controller/nursery_module_controller.dart';
import '../../../../../../../../../core/ColorUtils.dart';
import '../../../../../../../../../core/widget/back_button.dart';
import '../../../../../../../../../core/widget/empty_state.dart';
import '../../../../../../../../../core/widget/my_regular_text.dart';
import '../../../../../../../../../core/widget/select_option_chips.dart';
import '../../../../../../../../../widget/my_regular_button.dart';
import '../controller/bulk_evaluation_controller.dart';
import 'bulk_evaluation_confirm_sheet.dart';
import 'student_eval_tile.dart';

class BulkEvaluationScreen extends StatefulWidget {
  const BulkEvaluationScreen({super.key});

  @override
  State<BulkEvaluationScreen> createState() => _BulkEvaluationScreenState();
}

class _BulkEvaluationScreenState extends State<BulkEvaluationScreen> {
  late final BulkEvaluationController ctrl;
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<BulkEvaluationController>()) {
      Get.delete<BulkEvaluationController>();
    }
    ctrl = Get.put(BulkEvaluationController());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!isTeacherEvaluationEnabled()) {
        Get.back();
        return;
      }
      ctrl.load(context);
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    if (Get.isRegistered<BulkEvaluationController>()) {
      Get.delete<BulkEvaluationController>();
    }
    super.dispose();
  }

  void _openConfirm() {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!ctrl.validate(context)) return;
    Get.bottomSheet(
      BulkEvaluationConfirmSheet(
        ctrl: ctrl,
        onConfirm: () => ctrl.submit(context),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  @override
  Widget build(BuildContext context) {
    final light = isLight(context);

    return Scaffold(
      backgroundColor: light ? const Color(0xFFF6F8FB) : const Color(0xFF0F0F0F),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Row(
                children: [
                  appBackButton(context),
                  const SizedBox(width: 12),
                  Expanded(
                    child: MyRegularText(
                      label: 'evaluation'.tr,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      align: TextAlign.start,
                      color: primaryText(context),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
                if (ctrl.isClassLoading.value && ctrl.classList.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyRegularText(
                            label: 'Class'.tr,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            align: TextAlign.start,
                            color: primaryText(context),
                          ),
                          const SizedBox(height: 8),
                          if (ctrl.classList.isEmpty)
                            Text(
                              'no_classes_yet'.tr,
                              style: TextStyle(
                                color: light
                                    ? const Color(0xFF64748B)
                                    : Colors.white70,
                              ),
                            )
                          else
                            SelectOptionChips(
                              selected: ctrl.selectedClass.value?.slug,
                              onSelected: (slug) {
                                final match = ctrl.classList
                                    .firstWhereOrNull((c) => c.slug == slug);
                                if (match != null) {
                                  ctrl.selectClass(context, match);
                                }
                              },
                              options: ctrl.classList
                                  .map(
                                    (c) => SelectOption(
                                      value: c.slug ?? '',
                                      label: c.name ?? '',
                                    ),
                                  )
                                  .toList(),
                            ),
                          const SizedBox(height: 12),
                          _dateRow(light),
                          const SizedBox(height: 8),
                          _periodRow(light),
                          const SizedBox(height: 10),
                          TextField(
                            key: const ValueKey('eval-kid-search'),
                            controller: _searchCtrl,
                            onChanged: (v) => ctrl.kidSearch.value = v,
                            style: TextStyle(
                              fontSize: 14,
                              color: light
                                  ? const Color(0xFF0F172A)
                                  : Colors.white,
                            ),
                            decoration: InputDecoration(
                              hintText: 'search_kids'.tr,
                              hintStyle: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 13,
                              ),
                              prefixIcon: Icon(
                                Icons.search,
                                color: Colors.grey.shade500,
                                size: 20,
                              ),
                              isDense: true,
                              filled: true,
                              fillColor:
                                  light ? Colors.white : const Color(0xFF1A1A1A),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: light
                                      ? const Color(0xFFE2E8F0)
                                      : Colors.white12,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: light
                                      ? const Color(0xFFE2E8F0)
                                      : Colors.white12,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: primaryColor,
                                  width: 1.4,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            ctrl.isExistingLoading.value
                                ? 'loading_evaluations'.tr
                                : 'tap_kid_to_evaluate'.tr,
                            style: TextStyle(
                              fontSize: 12,
                              color: light
                                  ? const Color(0xFF64748B)
                                  : Colors.white60,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(child: _studentList(light)),
                  ],
                );
              }),
            ),
            _bottomBar(light),
          ],
        ),
      ),
    );
  }

  Widget _dateRow(bool light) {
    return Row(
      children: [
        _dateArrow(
          light,
          Icons.chevron_left_rounded,
          () => ctrl.previousDay(context),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: GestureDetector(
            onTap: () => ctrl.pickDate(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: light ? Colors.white : const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: light ? const Color(0xFFE2E8F0) : Colors.white12,
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.calendar_month_rounded,
                    size: 18,
                    color: primaryColor,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      ctrl.dateLabel,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: light ? const Color(0xFF0F172A) : Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    'pick_evaluation_day'.tr,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        _dateArrow(
          light,
          Icons.chevron_right_rounded,
          ctrl.canGoNext ? () => ctrl.nextDay(context) : null,
        ),
      ],
    );
  }

  Widget _periodRow(bool light) {
    return Row(
      children: [
        Expanded(
          child: _periodChip(
            light,
            'reporting_period'.tr,
            ctrl.periodLabel,
            onFrom: () => ctrl.pickPeriodDate(context, isStart: true),
            onTo: () => ctrl.pickPeriodDate(context, isStart: false),
          ),
        ),
      ],
    );
  }

  Widget _periodChip(
    bool light,
    String label,
    String value, {
    required VoidCallback onFrom,
    required VoidCallback onTo,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: light ? Colors.white : const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: light ? const Color(0xFFE2E8F0) : Colors.white12,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.date_range_rounded,
            size: 18,
            color: light ? const Color(0xFF64748B) : Colors.white54,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: light ? const Color(0xFF64748B) : Colors.white54,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: light ? const Color(0xFF0F172A) : Colors.white,
                  ),
                ),
              ],
            ),
          ),
            TextButton(
            onPressed: onFrom,
            child: Text('from_date'.tr, style: const TextStyle(fontSize: 12)),
          ),
          TextButton(
            onPressed: onTo,
            child: Text('to'.tr, style: const TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _dateArrow(bool light, IconData icon, VoidCallback? onTap) {
    final enabled = onTap != null;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: light ? Colors.white : const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: light ? const Color(0xFFE2E8F0) : Colors.white12,
          ),
        ),
        child: Icon(
          icon,
          color: enabled
              ? (light ? const Color(0xFF0F172A) : Colors.white)
              : (light ? const Color(0xFFCBD5E1) : Colors.white24),
        ),
      ),
    );
  }

  Widget _studentList(bool light) {
    if (ctrl.isStudentLoading.value || ctrl.isQuestionsLoading.value) {
      return const Center(child: CircularProgressIndicator());
    }
    final kids = ctrl.visibleStudents;
    if (ctrl.studentList.isEmpty) {
      return const Center(child: EmptyState());
    }
    if (kids.isEmpty) {
      return Center(
        child: Text(
          'No Students Found'.tr,
          style: TextStyle(
            color: light ? const Color(0xFF64748B) : Colors.white70,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      itemCount: kids.length + (ctrl.isExistingLoading.value ? 1 : 0),
      itemBuilder: (_, i) {
        if (ctrl.isExistingLoading.value && i == 0) {
          return const Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: LinearProgressIndicator(minHeight: 3),
          );
        }
        final index = ctrl.isExistingLoading.value ? i - 1 : i;
        return StudentEvalTile(student: kids[index], ctrl: ctrl);
      },
    );
  }

  Widget _bottomBar(bool light) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
      decoration: BoxDecoration(
        color: light ? Colors.white : const Color(0xFF111111),
        border: Border(
          top: BorderSide(
            color: light ? const Color(0xFFE2E8F0) : Colors.white10,
          ),
        ),
      ),
      child: Obx(() {
        ctrl.tick.value;
        final kids = ctrl.kidsReady;
        final title = kids == 0
            ? 'confirm_save'.tr
            : 'review_evaluations'.trParams({'kids': '$kids'});
        return MyThemeButton(
          title: title,
          isLoading: ctrl.isSaving.value,
          onPressed: _openConfirm,
        );
      }),
    );
  }
}
