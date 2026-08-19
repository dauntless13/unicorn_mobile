import 'package:flutter/material.dart';

import '../ColorUtils.dart';

class SelectOption {
  final String value;
  final String label;
  final IconData? icon;

  const SelectOption({
    required this.value,
    required this.label,
    this.icon,
  });
}

class SelectOptionChips extends StatelessWidget {
  final List<SelectOption> options;
  final String? selected;
  final ValueChanged<String> onSelected;
  final bool expanded;
  final Color? color;

  const SelectOptionChips({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelected,
    this.expanded = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final light = isLight(context);

    final accent = color ?? primaryColor;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((option) {
        final isSelected = selected == option.value;
        final chip = Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => onSelected(option.value),
            borderRadius: BorderRadius.circular(14),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? accent
                    : (light ? Colors.white : const Color(0xFF1A1A1A)),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected
                      ? accent
                      : (light ? const Color(0xFFE2E8F0) : Colors.white12),
                  width: isSelected ? 1.6 : 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
                children: [
                  if (option.icon != null) ...[
                    Icon(
                      option.icon,
                      size: 18,
                      color: isSelected
                          ? Colors.white
                          : (light ? const Color(0xFF334155) : Colors.white),
                    ),
                    const SizedBox(width: 8),
                  ],
                  Flexible(
                    child: Text(
                      option.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? Colors.white
                            : (light ? const Color(0xFF1E293B) : Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        if (!expanded) return chip;
        return SizedBox(
          width: (MediaQuery.of(context).size.width - 48 - 8) / 2,
          child: chip,
        );
      }).toList(),
    );
  }
}
