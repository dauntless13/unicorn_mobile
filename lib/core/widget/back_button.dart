import 'package:flutter/material.dart';

Widget appBackButton(BuildContext context) {
  final isLight =
      Theme.of(context).brightness == Brightness.light;

  return GestureDetector(
    onTap: () => Navigator.pop(context),
    child: Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: isLight
            ? Colors.white
            : Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isLight
              ? Colors.grey.shade300
              : Colors.white.withOpacity(0.15),
        ),
      ),
      child: Icon(
        Icons.arrow_back_rounded,
        size: 22,
        color: isLight ? Colors.black : Colors.white,
      ),
    ),
  );
}

