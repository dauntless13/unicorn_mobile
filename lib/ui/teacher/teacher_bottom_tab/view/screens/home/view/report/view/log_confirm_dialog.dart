import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../../../../core/ColorUtils.dart';

Future<bool> confirmLogAdd(
  BuildContext context, {
  required String title,
  required List<String> details,
}) async {
  final light = Theme.of(context).brightness == Brightness.light;
  final result = await showDialog<bool>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.45),
    builder: (ctx) {
      return AlertDialog(
        backgroundColor: light ? Colors.white : const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'confirm_add_title'.tr,
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: light ? const Color(0xFF0F172A) : Colors.white,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: light ? const Color(0xFF0F172A) : Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            ...details.map(
              (line) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('•  ', style: TextStyle(color: primaryColor)),
                    Expanded(
                      child: Text(
                        line,
                        style: TextStyle(
                          height: 1.3,
                          color: light ? const Color(0xFF334155) : Colors.white70,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              'Cancel'.tr,
              style: TextStyle(
                color: light ? const Color(0xFF64748B) : Colors.white70,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text('confirm_save'.tr),
          ),
        ],
      );
    },
  );
  return result == true;
}
