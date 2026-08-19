import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../../../../core/ColorUtils.dart';
import '../../../../../../../../../core/widget/profile_avatar.dart';
import '../../../../../../../../../widget/my_regular_button.dart';
import '../controller/quick_log_controller.dart';
import '../model/student_log_draft.dart';

class QuickLogConfirmSheet extends StatelessWidget {
  final QuickLogController ctrl;
  final VoidCallback onConfirm;

  const QuickLogConfirmSheet({
    super.key,
    required this.ctrl,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final light = isLight(context);
    final drafts = ctrl.changedDrafts;

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
                          '${ctrl.dateLabel} · ${'confirm_add_subtitle'.trParams({
                            'kids': '${ctrl.kidsWithChanges}',
                            'items': '${ctrl.changeCount}',
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
                itemBuilder: (_, i) {
                  return _studentReview(light, drafts[i]);
                },
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

  Widget _studentReview(bool light, StudentLogDraft draft) {
    final student = ctrl.studentBySlug(draft.slug);
    final name = student == null ? draft.slug : ctrl.studentName(student);
    final lines = <Widget>[];

    for (final meal in draft.meals.where((e) => e.isDirty)) {
      final time = meal.time == null || meal.time!.isEmpty ? '' : ' · ${meal.time}';
      final portion = meal.portionKnown ? ' · ${ctrl.portionLabel(meal.portion)}' : '';
      lines.add(
        _line(
          ctrl.mealIcon(meal.meal),
          const Color(0xFFF97316),
          '${ctrl.mealLabel(meal.meal)}$portion$time',
          tag: meal.isExisting ? 'edited_entry'.tr : 'new_entry'.tr,
        ),
      );
    }
    if (draft.moods.isNotEmpty && draft.moodsChanged) {
      lines.add(
        _line(
          Icons.emoji_emotions_rounded,
          const Color(0xFFEC4899),
          draft.moods.map((m) => m.tr).join(', '),
          tag: 'edited_entry'.tr,
        ),
      );
    }
    for (final item in draft.hygiene.where((e) => e.isDirty)) {
      final time = item.time == null || item.time!.isEmpty ? '' : ' · ${item.time}';
      lines.add(
        _line(
          item.type == 'POOP'
              ? Icons.baby_changing_station_rounded
              : Icons.water_drop_rounded,
          item.type == 'POOP' ? const Color(0xFFB45309) : const Color(0xFF0EA5E9),
          '${item.type == 'POOP' ? 'Poop'.tr : 'Urine'.tr}$time',
          tag: item.isExisting ? 'edited_entry'.tr : 'new_entry'.tr,
        ),
      );
    }
    for (final nap in draft.naps.where((e) => e.isDirty)) {
      final time =
          nap.startTime == null || nap.startTime!.isEmpty ? '' : ' · ${nap.startTime}';
      lines.add(
        _line(
          Icons.hotel_rounded,
          const Color(0xFF6366F1),
          '${ctrl.durationLabel(nap.minutes)}$time',
          tag: nap.isExisting ? 'edited_entry'.tr : 'new_entry'.tr,
        ),
      );
    }
    for (final meal in draft.removedMeals) {
      lines.add(
        _line(
          ctrl.mealIcon(meal.meal),
          const Color(0xFF94A3B8),
          ctrl.mealLabel(meal.meal),
          tag: 'removed_entry'.tr,
          removed: true,
        ),
      );
    }
    for (final item in draft.removedHygiene) {
      lines.add(
        _line(
          item.type == 'POOP'
              ? Icons.baby_changing_station_rounded
              : Icons.water_drop_rounded,
          const Color(0xFF94A3B8),
          item.type == 'POOP' ? 'Poop'.tr : 'Urine'.tr,
          tag: 'removed_entry'.tr,
          removed: true,
        ),
      );
    }
    for (final nap in draft.removedNaps) {
      lines.add(
        _line(
          Icons.hotel_rounded,
          const Color(0xFF94A3B8),
          ctrl.durationLabel(nap.minutes),
          tag: 'removed_entry'.tr,
          removed: true,
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: light ? const Color(0xFFF8FAFC) : const Color(0xFF222222),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
                '${draft.changeCount}',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: light ? const Color(0xFF64748B) : Colors.white54,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...lines,
        ],
      ),
    );
  }

  Widget _line(
    IconData icon,
    Color color,
    String text, {
    String? tag,
    bool removed = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 15, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                decoration: removed ? TextDecoration.lineThrough : null,
                color: removed ? const Color(0xFF94A3B8) : null,
              ),
            ),
          ),
          if (tag != null)
            Text(
              tag,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: removed ? const Color(0xFFEF4444) : primaryColor,
              ),
            ),
        ],
      ),
    );
  }
}
