import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'language_controller.dart';

void showLanguageBottomSheet() {
  Get.bottomSheet(
    Builder(
      builder: (context) {
        final isLight =
            Theme.of(context).brightness == Brightness.light;

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isLight
                ? Colors.white
                : const Color(0xFF1E1E1E),
            borderRadius:
            const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _languageTile(
                context: context,
                title: 'English',
                locale: const Locale('en', 'US'),
              ),
              const SizedBox(height: 12),
              _languageTile(
                context: context,
                title: 'Arabic',
                locale: const Locale('ar', 'SA'),
              ),
            ],
          ),
        );
      },
    ),
    isScrollControlled: true,
  );
}

Widget _languageTile({
  required BuildContext context,
  required String title,
  required Locale locale,
}) {
  final controller = LanguageController.to;
  final isLight =
      Theme.of(context).brightness == Brightness.light;

  final isSelected =
      controller.currentLocale.languageCode == locale.languageCode;

  final borderColor = isSelected
      ? Colors.teal
      : isLight
      ? Colors.grey.shade300
      : Colors.grey.shade700;

  final textColor = isSelected
      ? Colors.teal
      : isLight
      ? Colors.black87
      : Colors.white;

  return InkWell(
    borderRadius: BorderRadius.circular(12),
    onTap: () {
      controller.changeLanguage(locale);
      Get.back();

    },
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: borderColor,
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ),
          if (isSelected)
            const Icon(
              Icons.check_circle,
              color: Colors.teal,
            ),
        ],
      ),
    ),
  );
}
