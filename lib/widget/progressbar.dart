import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/widget/my_regular_text.dart';

class ProgressBar {
  static bool _isShowing = false;

  static void showProgressBarApi(BuildContext context) {
    if (_isShowing) return;

    _isShowing = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (_) => const _ProgressDialog(),
    );
  }

  static void hideProgressBar(BuildContext context) {
    if (_isShowing) {
      _isShowing = false;
      final navigator = Navigator.of(context, rootNavigator: true);
      if (navigator.canPop()) {
        navigator.pop();
      }
    }
  }
}

class _ProgressDialog extends StatelessWidget {
  const _ProgressDialog();

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 168,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
          decoration: BoxDecoration(
            color: isLight ? Colors.white : const Color(0xFF1A2530),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isLight
                  ? const Color(0xFFE2E8F0)
                  : Colors.white.withOpacity(0.08),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isLight ? 0.10 : 0.24),
                blurRadius: 28,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF0A6C7D).withOpacity(0.10),
                ),
                alignment: Alignment.center,
                child: const SizedBox(
                  width: 26,
                  height: 26,
                  child: CircularProgressIndicator(),
                ),
              ),
              const SizedBox(height: 16),
              MyRegularText(
                label: "Loading...".tr,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isLight ? const Color(0xFF0F172A) : Colors.white,
              ),
              const SizedBox(height: 6),
              Text(
                'Please wait'.tr,
                style: TextStyle(
                  fontSize: 12.5,
                  color: isLight
                      ? const Color(0xFF64748B)
                      : Colors.white.withOpacity(0.70),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
