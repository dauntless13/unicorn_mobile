import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';

import '../core/widget/my_regular_text.dart';

void showToast(BuildContext context, String message,
    String description,
    {ToastificationType type = ToastificationType.success,ToastificationStyle style = ToastificationStyle.flatColored,bool? dragToClose = true}) {
  Toastification().show(
    context: context,
    title:  MyRegularText(label: message.tr),
    description: MyRegularText(label: description.tr,maxlines: 4,align: TextAlign.start,),
    type: type,
    style: style,

    showProgressBar: false,
    dragToClose: dragToClose,
    alignment: Alignment.bottomCenter,
    applyBlurEffect: false,
    autoCloseDuration: const Duration(seconds: 3),
    animationDuration: const Duration(milliseconds: 300),
    boxShadow: const [
      BoxShadow(
        color: Color(0x07000000),
        blurRadius: 16,
        offset: Offset(0, 16),
        spreadRadius: 0,
      )
    ],
  );
}

void showAppSnackbar(
  String title,
  String message, {
  SnackPosition snackPosition = SnackPosition.BOTTOM,
  Duration duration = const Duration(seconds: 3),
}) {
  Get.snackbar(
    title.tr,
    message.tr,
    snackPosition: snackPosition,
    duration: duration,
  );
}
