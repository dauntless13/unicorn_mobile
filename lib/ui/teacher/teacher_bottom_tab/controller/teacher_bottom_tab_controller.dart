import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../view/screens/calendar/view/teacher_calendar_screen.dart';
import '../view/screens/home/view/teacher_home_screen.dart';
import '../view/screens/kids/teacher_kids_screen.dart';
import '../view/screens/profile/view/teacher_profile_screen.dart';
import '../view/screens/teacher_chat/teacher_chat.dart';

class TeacherBottomTabController extends GetxController {
  final selectedIndex = 0.obs;

  final bucket = PageStorageBucket();

  // ✅ IMPORTANT: generic Widget
  var currentScreen = Rx<Widget>(TeacherHomeScreen());

  void resetToHome() {
    selectedIndex.value = 0;
    currentScreen.value = TeacherHomeScreen();
  }

  void changeTab(int index) {
    selectedIndex.value = index;

    switch (index) {
      case 0:
        currentScreen.value = TeacherHomeScreen();
        break;
      case 1:
        currentScreen.value = TeacherCalendarScreen();
        break;
      case 2:
        currentScreen.value = TeacherKidsScreen();
        break;
      case 3:
        currentScreen.value = TeacherChat();
        break;
      case 4:
        currentScreen.value = TeacherProfileScreen();
        break;
    }
  }
}
