import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../../../../core/ColorUtils.dart';
import '../../../../../../../../../core/widget/profile_avatar.dart';
import '../../../../../../../../../widget/my_regular_button.dart';
import '../controller/bulk_evaluation_controller.dart';
import '../model/student_eval_draft.dart';

class BulkEvaluationConfirmSheet extends StatelessWidget {
  final BulkEvaluationController ctrl;
  final VoidCallback onConfirm;

  const BulkEvaluationConfirmSheet({
    super.key,
    required this.ctrl,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final light = isLight(context);
    final drafts = ctrl.readyDrafts;

    return SafeArea(
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.86,
        ),
        decoration: BoxDecoration(
          color: light ? Colors.white : const Color(0xFF161616),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: light ? const Color(0xFFD9DEE7) : Colors.white24,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 8, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'confirm_add_title'.tr,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: light ? const Color(0xFF0F172A) : Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${ctrl.dateLabel} · ${'review_evaluations'.trParams({
                            'kids': '${drafts.length}',
                          })}',
                          style: TextStyle(
                            fontSize: 13.5,
                            color: light
                                ? const Color(0xFF64748B)
                                : Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(
                      Icons.close_rounded,
                      color: light ? const Color(0xFF64748B) : Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                itemCount: drafts.length,
                itemBuilder: (_, i) => _studentReview(light, drafts[i]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Obx(() {
                final saving = ctrl.isSaving.value;
                final title = saving
                    ? 'saving_progress'.trParams({
                        'done': '${ctrl.saveDone.value}',
                        'total': '${ctrl.saveTotal.value}',
                      })
                    : 'confirm_save'.tr;
                return MyThemeButton(
                  title: title,
                  isLoading: saving,
                  onPressed: onConfirm,
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _studentReview(bool light, StudentEvalDraft draft) {
    final student = ctrl.studentBySlug(draft.slug);
    final name = student == null ? draft.slug : ctrl.studentName(student);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: light ? const Color(0xFFF8FAFC) : const Color(0xFF222222),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          ProfileAvatar(
            radius: 16,
            imageUrl: student?.profileLink,
            backgroundColor: Colors.grey.shade300,
            iconColor: Colors.white,
            iconSize: 14,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 14.5,
                color: light ? const Color(0xFF0F172A) : Colors.white,
              ),
            ),
          ),
          Text(
            'evaluation_progress'.trParams({
              'done': '${draft.answeredCount}',
              'total': '${ctrl.questionCount}',
            }),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: light ? const Color(0xFF64748B) : Colors.white54,
            ),
          ),
        ],
      ),
    );
  }
}
