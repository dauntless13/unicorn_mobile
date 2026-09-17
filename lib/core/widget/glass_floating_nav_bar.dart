import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

const double kFloatingNavReserve = 110;

class GlassNavItem {
  const GlassNavItem({
    required this.icon,
    required this.label,
  });

  final String icon;
  final String label;
}

class GlassFloatingNavBar extends StatelessWidget {
  const GlassFloatingNavBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  final List<GlassNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  static const _accent = Color(0xFF0C7189);

  @override
  Widget build(BuildContext context) {
    final light = Theme.of(context).brightness == Brightness.light;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, (bottomInset > 8 ? bottomInset : 12) + 6),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: light
                  ? Colors.white.withValues(alpha: 0.72)
                  : const Color(0xFF141414).withValues(alpha: 0.62),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: light
                    ? Colors.white.withValues(alpha: 0.7)
                    : Colors.white.withValues(alpha: 0.12),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: light ? 0.1 : 0.35),
                  blurRadius: 28,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
              child: Row(
                children: [
                  for (var i = 0; i < items.length; i++)
                    Expanded(
                      flex: currentIndex == i ? 18 : 12,
                      child: _GlassNavButton(
                        item: items[i],
                        selected: currentIndex == i,
                        light: light,
                        accent: _accent,
                        onTap: () => onTap(i),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GlassNavButton extends StatelessWidget {
  const _GlassNavButton({
    required this.item,
    required this.selected,
    required this.light,
    required this.accent,
    required this.onTap,
  });

  final GlassNavItem item;
  final bool selected;
  final bool light;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final idle = light ? const Color(0xFF64748B) : const Color(0xFF94A3B8);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(22),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 240),
            curve: Curves.easeOutCubic,
            height: 48,
            padding: EdgeInsets.symmetric(horizontal: selected ? 10 : 0),
            decoration: BoxDecoration(
              color: selected ? accent : Colors.transparent,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  item.icon,
                  width: 22,
                  height: 22,
                  colorFilter: ColorFilter.mode(
                    selected ? Colors.white : idle,
                    BlendMode.srcIn,
                  ),
                ),
                if (selected) ...[
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      item.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
