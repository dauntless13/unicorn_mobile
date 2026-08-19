import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common_screens/chat/view/chats_screen.dart';
import '../view/screeen/home/view/home_screen.dart';
import '../view/screeen/kids/view/kids_screen.dart';
import '../view/screeen/profile/view/profile_screen.dart';

class MainTabController extends GetxController {
  final selectedIndex = 0.obs;
  final kidsInitialTabIndex = 0.obs;
  final selectedKidsStudentSlug = RxnString();

  final bucket = PageStorageBucket();

  late Rx<Widget> currentScreen;

  @override
  void onInit() {
    super.onInit();

    // ✅ FIX: explicitly define type
    currentScreen = Rx<Widget>(HomeScreen());
  }

  void resetToHome() {
    selectedIndex.value = 0;
    kidsInitialTabIndex.value = 0;
    selectedKidsStudentSlug.value = null;
    currentScreen.value = HomeScreen();
  }

  void changeTab(
    int index, {
    int? kidsTabIndex,
    String? studentSlug,
  }) {
    selectedIndex.value = index;

    switch (index) {
      case 0:
        kidsInitialTabIndex.value = 0;
        selectedKidsStudentSlug.value = null;
        currentScreen.value = HomeScreen();
        break;
      case 1:
        kidsInitialTabIndex.value = 0;
        selectedKidsStudentSlug.value = null;
        currentScreen.value = const KidsScreen(
          key: ValueKey('parent-gallery-tab'),
          galleryOnly: true,
        );
        break;
      case 2:
        kidsInitialTabIndex.value = kidsTabIndex ?? kidsInitialTabIndex.value;
        selectedKidsStudentSlug.value = studentSlug?.trim().isEmpty == true
            ? null
            : studentSlug?.trim();
        currentScreen.value = KidsScreen(
          key: ValueKey(
            'parent-kids-tab-${kidsInitialTabIndex.value}-${selectedKidsStudentSlug.value ?? 'default'}',
          ),
          galleryOnly: false,
          initialTabIndex: kidsInitialTabIndex.value,
          initialStudentSlug: selectedKidsStudentSlug.value,
        );
        break;
      case 3:
        kidsInitialTabIndex.value = 0;
        selectedKidsStudentSlug.value = null;
        currentScreen.value = ParentChatScreen();
        break;
      case 4:
        kidsInitialTabIndex.value = 0;
        selectedKidsStudentSlug.value = null;
        currentScreen.value = ProfileScreen();
        break;
    }
  }

  void openKidsTab(int tabIndex, {String? studentSlug}) {
    changeTab(2, kidsTabIndex: tabIndex, studentSlug: studentSlug);
  }
}
