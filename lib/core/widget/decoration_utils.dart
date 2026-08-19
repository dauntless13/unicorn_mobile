import 'package:flutter/material.dart';

class DecorationUtils {
  final BuildContext context;

  DecorationUtils(this.context);

  InputDecoration getInputDecoration({
    String? labelText,
    String? hintText,
    bool isRequire = false,
    bool isEnable = true,
    bool isIconDisplay = true,
    Widget? icon,
    Widget? suffixIcon,
    double borderRadius = 12,
  }) {
    final isLight =
        Theme.of(context).brightness == Brightness.light;

    return InputDecoration(
      prefixIcon: icon,
      suffixIcon: suffixIcon == null
          ? null
          : IconTheme(
        data: IconThemeData(
          color: isLight
              ? Colors.grey[600]
              : Colors.grey[400],
        ),
        child: suffixIcon!,
      ),
      filled: true,
      fillColor: isLight
          ? Colors.white
          : const Color(0xFF1A1A1A),
      isDense: true,
      counterText: "",
      hintText: hintText,
      labelText: labelText,
      hintStyle: TextStyle(
        color: isLight
            ? Colors.grey[400]
            : Colors.grey[500],
        fontSize: 14,
      ),
      labelStyle: TextStyle(
        color: isLight
            ? Colors.grey[600]
            : Colors.grey[400],
        fontSize: 14,
      ),
      floatingLabelBehavior: FloatingLabelBehavior.never,

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(
          color: isLight
              ? Colors.grey.shade300
              : Colors.white.withOpacity(0.12),
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: const BorderSide(
          color: Color(0xFF0C7189),
          width: 1.4,
        ),
      ),

      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(
          color: Colors.grey.withOpacity(0.3),
        ),
      ),

      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),

      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),

      errorStyle: const TextStyle(letterSpacing: 0.4),
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }
}
