import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../../../../core/ColorUtils.dart';
import '../../../../../../../../../core/utils/report_time_utils.dart';
import '../../../../../../../../../core/widget/profile_avatar.dart';
import '../../add_post/mode/list_student_by_class/list_student_by_class_response.dart';
import '../controller/quick_log_controller.dart';
import '../model/student_log_draft.dart';

class StudentLogTile extends StatelessWidget {
  final StudentData student;
  final QuickLogController ctrl;

  const StudentLogTile({
    super.key,
    required this.student,
    required this.ctrl,
  });

  static const _moods = [
    {'key': 'happy', 'asset': 'assets/png/happy.png'},
    {'key': 'cool', 'asset': 'assets/png/cool.png'},
    {'key': 'amazed', 'asset': 'assets/png/amazed.png'},
    {'key': 'peaceful', 'asset': 'assets/png/peaceful.png'},
    {'key': 'confused', 'asset': 'assets/png/confused.png'},
    {'key': 'stressed', 'asset': 'assets/png/stressed.png'},
  ];

  String get _slug => student.slug ?? '';

  @override
  Widget build(BuildContext context) {
    final light = isLight(context);

    return Obx(() {
      ctrl.tick.value;
      final expanded = ctrl.expandedSlug.value == _slug;
      final draft = ctrl.draftOf(_slug);

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
              onTap: () => ctrl.toggleExpanded(_slug),
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
                      child: Row(
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
                          if (draft.hadExistingReport) ...[
                            const SizedBox(width: 6),
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: secondaryColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    _countBadge(
                      Icons.restaurant_rounded,
                      draft.mealCount,
                      const Color(0xFFF97316),
                    ),
                    _countBadge(
                      Icons.emoji_emotions_rounded,
                      draft.moodCount,
                      const Color(0xFFEC4899),
                    ),
                    _countBadge(
                      Icons.wc_rounded,
                      draft.hygieneCount,
                      const Color(0xFF0EA5E9),
                    ),
                    _countBadge(
                      Icons.hotel_rounded,
                      draft.napCount,
                      const Color(0xFF6366F1),
                    ),
                    Icon(
                      expanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      color: light ? const Color(0xFF64748B) : Colors.white54,
                    ),
                  ],
                ),
              ),
            ),
            if (expanded)
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 12),
                child: Column(
                  children: [
                    const Divider(height: 1),
                    const SizedBox(height: 10),
                    _foodSection(context, light, draft),
                    const SizedBox(height: 12),
                    _moodSection(light, draft),
                    const SizedBox(height: 12),
                    _pottySection(context, light, draft),
                    const SizedBox(height: 12),
                    _napSection(context, light, draft),
                  ],
                ),
              ),
          ],
        ),
      );
    });
  }

  Widget _countBadge(IconData icon, int count, Color color) {
    if (count <= 0) return const SizedBox(width: 4);
    return Container(
      margin: const EdgeInsetsDirectional.only(end: 6),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 3),
          Text(
            '$count',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String label, Color color, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _foodSection(BuildContext context, bool light, StudentLogDraft draft) {
    const color = Color(0xFFF97316);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('log_meal'.tr, color, Icons.restaurant_rounded),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            _addTypeBtn(
              light,
              color,
              Icons.free_breakfast_rounded,
              'breakfast'.tr,
              () => ctrl.addMeal(_slug, 'BREAKFAST'),
            ),
            _addTypeBtn(
              light,
              color,
              Icons.lunch_dining_rounded,
              'lunch'.tr,
              () => ctrl.addMeal(_slug, 'LUNCH'),
            ),
            _addTypeBtn(
              light,
              color,
              Icons.icecream_rounded,
              'snacks'.tr,
              () => ctrl.addMeal(_slug, 'SNACKS'),
            ),
            _addTypeBtn(
              light,
              color,
              Icons.local_drink_rounded,
              'milk'.tr,
              () => ctrl.addMeal(_slug, 'MILK'),
            ),
          ],
        ),
        ...draft.meals.map((entry) {
          return _entryCard(
            light,
            color,
            icon: ctrl.mealIcon(entry.meal),
            title: ctrl.mealLabel(entry.meal),
            time: entry.time,
            onRemove: () => ctrl.removeMeal(_slug, entry.id),
            onToggleTime: () => _pickOrClearTime(
              context,
              entry.time,
              (time) => ctrl.setMealTime(_slug, entry.id, time),
            ),
            extra: _portionRow(entry),
          );
        }),
      ],
    );
  }

  Widget _portionRow(MealEntry entry) {
    const options = ['FULL', 'HALF', 'QUARTER', 'NONE'];
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Wrap(
        spacing: 4,
        children: options.map((p) {
          final selected = entry.portionKnown && entry.portion == p;
          return GestureDetector(
            onTap: () => ctrl.setMealPortion(_slug, entry.id, p),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: selected ? const Color(0xFFF97316) : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: selected
                      ? const Color(0xFFF97316)
                      : const Color(0xFFCBD5E1),
                ),
              ),
              child: Text(
                ctrl.portionLabel(p),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: selected ? Colors.white : const Color(0xFF64748B),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _moodSection(bool light, StudentLogDraft draft) {
    const color = Color(0xFFEC4899);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('log_mood'.tr, color, Icons.emoji_emotions_rounded),
        const SizedBox(height: 8),
        Row(
          children: _moods.map((mood) {
            final selected = draft.moods.contains(mood['key']);
            return Expanded(
              child: GestureDetector(
                onTap: () => ctrl.toggleMood(_slug, mood['key']!),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                    color: selected
                        ? color.withValues(alpha: 0.14)
                        : (light ? const Color(0xFFF8FAFC) : const Color(0xFF111111)),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: selected ? color : Colors.transparent,
                    ),
                  ),
                  child: Image.asset(mood['asset']!, width: 22, height: 22),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _pottySection(BuildContext context, bool light, StudentLogDraft draft) {
    const color = Color(0xFF0EA5E9);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('log_hygiene'.tr, color, Icons.wc_rounded),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _addTypeBtn(
                light,
                color,
                Icons.water_drop_rounded,
                'Urine'.tr,
                () => ctrl.addHygiene(_slug, 'URINE'),
                filled: true,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _addTypeBtn(
                light,
                const Color(0xFFB45309),
                Icons.baby_changing_station_rounded,
                'Poop'.tr,
                () => ctrl.addHygiene(_slug, 'POOP'),
                filled: true,
              ),
            ),
          ],
        ),
        ...draft.hygiene.map((entry) {
          final isPoop = entry.type == 'POOP';
          return _entryCard(
            light,
            isPoop ? const Color(0xFFB45309) : color,
            icon: isPoop
                ? Icons.baby_changing_station_rounded
                : Icons.water_drop_rounded,
            title: isPoop ? 'Poop'.tr : 'Urine'.tr,
            time: entry.time,
            onRemove: () => ctrl.removeHygiene(_slug, entry.id),
            onToggleTime: () => _pickOrClearTime(
              context,
              entry.time,
              (time) => ctrl.setHygieneTime(_slug, entry.id, time),
            ),
          );
        }),
      ],
    );
  }

  Widget _napSection(BuildContext context, bool light, StudentLogDraft draft) {
    const color = Color(0xFF6366F1);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _sectionTitle('log_nap'.tr, color, Icons.hotel_rounded),
            ),
            _addTypeBtn(
              light,
              color,
              Icons.add_rounded,
              'add_nap'.tr,
              () => ctrl.addNap(_slug),
            ),
          ],
        ),
        ...draft.naps.map((entry) {
          return _entryCard(
            light,
            color,
            icon: Icons.hotel_rounded,
            title: ctrl.durationLabel(entry.minutes),
            time: entry.startTime,
            onRemove: () => ctrl.removeNap(_slug, entry.id),
            onToggleTime: () => _pickOrClearTime(
              context,
              entry.startTime,
              (time) => ctrl.setNapStart(_slug, entry.id, time),
            ),
            extra: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Wrap(
                spacing: 4,
                children: [30, 45, 60, 90, 120].map((m) {
                  final selected = entry.minutes == m;
                  return GestureDetector(
                    onTap: () => ctrl.setNapMinutes(_slug, entry.id, m),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: selected ? color : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: selected ? color : const Color(0xFFCBD5E1),
                        ),
                      ),
                      child: Text(
                        ctrl.durationLabel(m),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: selected ? Colors.white : const Color(0xFF64748B),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _addTypeBtn(
    bool light,
    Color color,
    IconData icon,
    String label,
    VoidCallback onTap, {
    bool filled = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: filled
                ? color.withValues(alpha: 0.12)
                : (light ? const Color(0xFFF8FAFC) : const Color(0xFF111111)),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withValues(alpha: 0.35)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _entryCard(
    bool light,
    Color color, {
    required IconData icon,
    required String title,
    required String? time,
    required VoidCallback onRemove,
    required VoidCallback onToggleTime,
    Widget? extra,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.fromLTRB(8, 8, 4, 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: light ? 0.06 : 0.14),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: light ? const Color(0xFF0F172A) : Colors.white,
                  ),
                ),
              ),
              if (time != null && time.isNotEmpty)
                Padding(
                  padding: const EdgeInsetsDirectional.only(end: 4),
                  child: Text(
                    time,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                ),
              IconButton(
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                onPressed: onToggleTime,
                icon: Icon(
                  time == null || time.isEmpty
                      ? Icons.schedule_outlined
                      : Icons.schedule_rounded,
                  size: 18,
                  color: time == null || time.isEmpty
                      ? const Color(0xFF94A3B8)
                      : color,
                ),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                onPressed: onRemove,
                icon: const Icon(Icons.close_rounded, size: 18, color: Color(0xFF94A3B8)),
              ),
            ],
          ),
          if (extra != null) extra,
        ],
      ),
    );
  }

  Future<void> _pickOrClearTime(
    BuildContext context,
    String? current,
    ValueChanged<String?> onChanged,
  ) async {
    if (current != null && current.isNotEmpty) {
      onChanged(null);
      return;
    }
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked == null) return;
    onChanged(ReportTimeUtils.formatTimeOfDay(picked));
  }
}
