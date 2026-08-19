import 'package:flutter/material.dart';

TransitionBuilder buildAppDatePickerThemeBuilder(
  BuildContext parentContext, {
  Color primaryColor = const Color(0xFF0A6C7D),
}) {
  return (context, child) {
    final base = Theme.of(context);
    final light = Theme.of(parentContext).brightness == Brightness.light;
    final scheme = base.colorScheme.copyWith(
      brightness: light ? Brightness.light : Brightness.dark,
      primary: primaryColor,
      onPrimary: Colors.white,
      surface: light ? Colors.white : const Color(0xFF1E1E1E),
      onSurface: light ? Colors.black87 : Colors.white,
    );

    Color? resolveForeground(Set<WidgetState> states) {
      if (states.contains(WidgetState.disabled)) {
        return scheme.onSurface.withOpacity(0.28);
      }
      if (states.contains(WidgetState.selected)) {
        return scheme.onPrimary;
      }
      return scheme.onSurface;
    }

    return Theme(
      data: base.copyWith(
        dialogBackgroundColor: scheme.surface,
        colorScheme: scheme,
        datePickerTheme: DatePickerThemeData(
          backgroundColor: scheme.surface,
          headerBackgroundColor: scheme.surface,
          headerForegroundColor: scheme.onSurface,
          weekdayStyle: TextStyle(color: scheme.onSurface.withOpacity(0.7)),
          dayStyle: TextStyle(color: scheme.onSurface),
          yearStyle: TextStyle(color: scheme.onSurface),
          dayForegroundColor:
              WidgetStateProperty.resolveWith(resolveForeground),
          yearForegroundColor:
              WidgetStateProperty.resolveWith(resolveForeground),
          todayForegroundColor: WidgetStatePropertyAll(primaryColor),
          todayBackgroundColor:
              WidgetStatePropertyAll(primaryColor.withOpacity(0.12)),
          todayBorder: BorderSide(color: primaryColor.withOpacity(0.35)),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: primaryColor,
          ),
        ),
      ),
      child: child ?? const SizedBox.shrink(),
    );
  };
}
