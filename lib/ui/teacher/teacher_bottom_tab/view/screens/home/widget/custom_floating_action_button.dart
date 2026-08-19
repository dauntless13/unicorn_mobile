import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../../../../controller/nursery_module_controller.dart';
import '../../../../../../../../../core/ColorUtils.dart';
import '../../../../../../../../../routes/app_routs.dart';

class CustomFloatingActionButton extends StatelessWidget {
  final VoidCallback? onPostAdded;

  const CustomFloatingActionButton({super.key, this.onPostAdded});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: primaryColor,
      elevation: 4,
      onPressed: () => showTeacherAddDialog(context, onPostAdded: onPostAdded),
      child: const Icon(Icons.add, color: Colors.white, size: 28),
    );
  }
}

Future<void> showTeacherAddDialog(
  BuildContext context, {
  VoidCallback? onPostAdded,
}) {
  final light = Theme.of(context).brightness == Brightness.light;

  return showDialog<void>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.46),
    builder: (dialogContext) {
      return Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 28),
        backgroundColor: Colors.transparent,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: Container(
            padding: const EdgeInsets.fromLTRB(18, 20, 18, 12),
            decoration: BoxDecoration(
              color: light ? Colors.white : const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'add_something'.tr,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: light ? const Color(0xFF0F172A) : Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'what_do_you_want'.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13.5,
                    color: light ? const Color(0xFF64748B) : Colors.white70,
                  ),
                ),
                const SizedBox(height: 18),
                Obx(() {
                  final showEvaluation = ensureNurseryModuleController()
                      .evaluationEnabledForTeachers
                      .value;
                  return GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1.55,
                  children: [
                    _AddActionTile(
                      icon: Icons.photo_outlined,
                      label: 'Post'.tr,
                      onTap: () {
                        Navigator.pop(dialogContext);
                        Get.toNamed(Routes.Add_POST_TEACHER)?.then((value) {
                          if (value == true) onPostAdded?.call();
                        });
                      },
                    ),
                    _AddActionTile(
                      icon: Icons.auto_awesome_outlined,
                      label: 'Story'.tr,
                      onTap: () {
                        Navigator.pop(dialogContext);
                        Get.toNamed(Routes.ADD_STORY_TEACHER)?.then((value) {
                          if (value == true) onPostAdded?.call();
                        });
                      },
                    ),
                    _AddActionTile(
                      icon: Icons.check_circle_outline,
                      label: 'Attendance'.tr,
                      onTap: () {
                        Navigator.pop(dialogContext);
                        Get.toNamed(Routes.TEACHER_ATTENDANCE);
                      },
                    ),
                    _AddActionTile(
                      icon: Icons.edit_note_rounded,
                      label: 'report'.tr,
                      highlight: true,
                      onTap: () {
                        Navigator.pop(dialogContext);
                        Get.toNamed(Routes.QUICK_LOG);
                      },
                    ),
                    if (showEvaluation)
                      _AddActionTile(
                        icon: Icons.auto_graph_outlined,
                        label: 'evaluation'.tr,
                        onTap: () {
                          Navigator.pop(dialogContext);
                          Get.toNamed(Routes.EVOLUTION_LIST);
                        },
                      ),
                  ],
                );
                }),
                const SizedBox(height: 6),
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: Text(
                    'Cancel'.tr,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: light ? const Color(0xFF64748B) : Colors.white70,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

class _AddActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool highlight;

  const _AddActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    final light = Theme.of(context).brightness == Brightness.light;
    final bg = highlight
        ? primaryColor
        : (light ? const Color(0xFFF8FAFC) : const Color(0xFF242424));
    final fg = highlight
        ? Colors.white
        : (light ? const Color(0xFF0F172A) : Colors.white);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(16),
            border: highlight
                ? null
                : Border.all(
                    color: light ? const Color(0xFFE2E8F0) : Colors.white12,
                  ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: fg, size: 24),
              const SizedBox(height: 6),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: fg,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
