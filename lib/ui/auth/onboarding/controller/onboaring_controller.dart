import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../../routes/app_routs.dart';

class OnboardingController extends GetxController {
  final pageController = PageController();
  var currentIndex = 0.obs;

  void onPageChanged(int index) {
    currentIndex.value = index;
  }

  void nextPage() {
    if (currentIndex.value < 2) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // DONE
      Get.offAllNamed(Routes.LOGINSCREEN); // or HOME
    }
  }
}
