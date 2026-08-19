import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unicorn/core/ColorUtils.dart';
import 'package:unicorn/core/widget/my_regular_text.dart';

enum FileOpenAction { view, download }

Future<FileOpenAction?> showViewOrDownloadSheet({
  String? title,
  String? subtitle,
}) {
  return Get.bottomSheet<FileOpenAction>(
    _FileActionSheet(
      title: title,
      subtitle: subtitle,
    ),
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
  );
}

class _FileActionSheet extends StatelessWidget {
  final String? title;
  final String? subtitle;

  const _FileActionSheet({
    this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedTitle = title?.trim();
    final resolvedSubtitle = subtitle?.trim();
    final light = Theme.of(context).brightness == Brightness.light;
    final sheetColor = light ? Colors.white : const Color(0xFF1A1A1A);
    final textColor = light ? const Color(0xFF0F172A) : Colors.white;
    final mutedColor = light ? const Color(0xFF64748B) : Colors.white70;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: sheetColor,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: light ? 0.08 : 0.35),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: light ? const Color(0xFFE2E8F0) : const Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
                MyRegularText(
                  label: (resolvedTitle == null || resolvedTitle.isEmpty)
                      ? 'choose_file_action'.tr
                      : resolvedTitle,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: textColor,
                  align: TextAlign.center,
                ),
                const SizedBox(height: 6),
                MyRegularText(
                  label: (resolvedSubtitle == null || resolvedSubtitle.isEmpty)
                      ? 'choose_file_action_hint'.tr
                      : resolvedSubtitle,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: mutedColor,
                  align: TextAlign.center,
                  maxlines: 3,
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: _ActionCard(
                        icon: Icons.visibility_rounded,
                        label: 'view_file'.tr,
                        hint: 'view_file_hint'.tr,
                        highlighted: true,
                        onTap: () => Get.back(result: FileOpenAction.view),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _ActionCard(
                        icon: Icons.download_rounded,
                        label: 'download_file'.tr,
                        hint: 'download_file_hint'.tr,
                        highlighted: false,
                        onTap: () => Get.back(result: FileOpenAction.download),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => Get.back(),
                  child: MyRegularText(
                    label: 'cancel'.tr,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: mutedColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String hint;
  final bool highlighted;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.label,
    required this.hint,
    required this.highlighted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final light = Theme.of(context).brightness == Brightness.light;
    final bg = highlighted
        ? primaryColor
        : (light ? const Color(0xFFF8FAFC) : const Color(0xFF242424));
    final fg = highlighted
        ? Colors.white
        : (light ? const Color(0xFF0F172A) : Colors.white);
    final hintColor = highlighted
        ? Colors.white.withValues(alpha: 0.86)
        : (light ? const Color(0xFF64748B) : Colors.white70);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          padding: const EdgeInsets.fromLTRB(14, 18, 14, 16),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(18),
            border: highlighted
                ? null
                : Border.all(
                    color: light ? const Color(0xFFE2E8F0) : const Color(0xFF333333),
                  ),
          ),
          child: Column(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: highlighted
                      ? Colors.white.withValues(alpha: 0.16)
                      : primaryColor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: highlighted ? Colors.white : primaryColor,
                  size: 22,
                ),
              ),
              const SizedBox(height: 12),
              MyRegularText(
                label: label,
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: fg,
                align: TextAlign.center,
              ),
              const SizedBox(height: 4),
              MyRegularText(
                label: hint,
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: hintColor,
                align: TextAlign.center,
                maxlines: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
