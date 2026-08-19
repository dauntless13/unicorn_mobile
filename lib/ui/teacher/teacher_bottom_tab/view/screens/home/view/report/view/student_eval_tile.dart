import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../../../../core/ColorUtils.dart';
import '../../../../../../../../../core/widget/profile_avatar.dart';
import '../../../../../../../../../routes/app_routs.dart';
import '../../add_post/mode/list_student_by_class/list_student_by_class_response.dart';
import '../controller/bulk_evaluation_controller.dart';
import '../model/evaluation_question/evaluation_question_response.dart';

class StudentEvalTile extends StatelessWidget {
  final StudentData student;
  final BulkEvaluationController ctrl;

  const StudentEvalTile({
    super.key,
    required this.student,
    required this.ctrl,
  });

  String get _slug => student.slug ?? '';

  @override
  Widget build(BuildContext context) {
    final light = isLight(context);

    return Obx(() {
      ctrl.tick.value;
      final expanded = ctrl.expandedSlug.value == _slug;
      final draft = ctrl.draftOf(_slug);
      final total = ctrl.questionCount;
      final answered = draft.answeredCount;
      final complete = draft.isComplete(total);

      return Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: light ? Colors.white : const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: expanded
                ? primaryColor.withValues(alpha: 0.45)
                : (light ? const Color(0xFFE2E8F0) : Colors.white12),
          ),
        ),
        child: Column(
          children: [
            InkWell(
              onTap: () => ctrl.toggleExpanded(context, _slug),
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 8, 8),
                child: Row(
                  children: [
                    ProfileAvatar(
                      radius: 18,
                      imageUrl: student.profileLink,
                      backgroundColor: Colors.grey.shade300,
                      iconColor: Colors.white,
                      iconSize: 16,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  ctrl.studentName(student),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14.5,
                                    color: light
                                        ? const Color(0xFF0F172A)
                                        : Colors.white,
                                  ),
                                ),
                              ),
                              if (draft.hadExisting) ...[
                                const SizedBox(width: 6),
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: draft.locked
                                        ? const Color(0xFF94A3B8)
                                        : secondaryColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            total == 0
                                ? 'evaluation'.tr
                                : 'evaluation_progress'.trParams({
                                    'done': '$answered',
                                    'total': '$total',
                                  }),
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: complete
                                  ? secondaryColor
                                  : (light
                                      ? const Color(0xFF64748B)
                                      : Colors.white54),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      tooltip: 'evolution_forms'.tr,
                      onPressed: () {
                        Get.toNamed(
                          Routes.EVOLUTION_FORMS_LIST,
                          arguments: {
                            'slug': _slug,
                            'classSlug': ctrl.selectedClass.value?.slug ?? '',
                            'studentName': ctrl.studentName(student),
                            'studentRoll': student.rollNumber ?? '',
                            'studentClassName':
                                ctrl.selectedClass.value?.name ?? '',
                            'studentProfileLink': student.profileLink,
                          },
                        );
                      },
                      icon: Icon(
                        Icons.history_rounded,
                        size: 18,
                        color: light
                            ? const Color(0xFF94A3B8)
                            : Colors.white38,
                      ),
                    ),
                    Icon(
                      expanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      color: light
                          ? const Color(0xFF64748B)
                          : Colors.white54,
                    ),
                  ],
                ),
              ),
            ),
            if (expanded) _expandedBody(context, light, draft.locked),
          ],
        ),
      );
    });
  }

  Widget _expandedBody(BuildContext context, bool light, bool locked) {
    final groups = ctrl.questionGroups;
    if (ctrl.isQuestionsLoading.value) {
      return const Padding(
        padding: EdgeInsets.fromLTRB(12, 0, 12, 16),
        child: LinearProgressIndicator(minHeight: 3),
      );
    }
    if (groups.isEmpty) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Text(
          'Failed to load questions',
          style: TextStyle(
            color: light ? const Color(0xFF64748B) : Colors.white70,
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (locked)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                'evaluation_locked'.tr,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFEF4444),
                ),
              ),
            ),
          _legend(light),
          const SizedBox(height: 12),
          IgnorePointer(
            ignoring: locked,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...groups.map((group) => _areaBlock(light, group.key, group.value)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _legend(bool light) {
    final byCode = <String, EvalRatingOption>{};
    for (final question in ctrl.questions) {
      for (final option in ctrl.optionsFor(question)) {
        byCode.putIfAbsent(option.code, () => option);
      }
    }
    final items = byCode.values.toList()
      ..sort((a, b) => a.code.compareTo(b.code));

    return Wrap(
      spacing: 8,
      runSpacing: 6,
      children: (items.isEmpty ? BulkEvaluationController.ratings : items)
          .map((option) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          decoration: BoxDecoration(
            color: option.color.withValues(alpha: light ? 0.1 : 0.18),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '${option.code} · ${option.meaning}',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: option.color,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _areaBlock(bool light, String area, List<Questions> items) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            area,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w800,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 8),
          ...items.map((question) => _questionRow(light, question)),
        ],
      ),
    );
  }

  Widget _questionRow(bool light, Questions question) {
    final questionId = question.id ?? '';
    final selected = ctrl.draftOf(_slug).answers[questionId];

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      decoration: BoxDecoration(
        color: light ? const Color(0xFFF8FAFC) : const Color(0xFF151515),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question.title ?? '',
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              height: 1.3,
              color: light ? const Color(0xFF0F172A) : Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: ctrl.optionsFor(question).map((option) {
              final isSelected = selected == option.code;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: InkWell(
                    onTap: questionId.isEmpty
                        ? null
                        : () => ctrl.selectAnswer(_slug, questionId, option.code),
                    borderRadius: BorderRadius.circular(10),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 160),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? option.color
                            : option.color.withValues(alpha: light ? 0.08 : 0.16),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: option.color.withValues(alpha: isSelected ? 1 : 0.35),
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            option.code,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: isSelected ? Colors.white : option.color,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            option.meaning,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? Colors.white.withValues(alpha: 0.92)
                                  : option.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
