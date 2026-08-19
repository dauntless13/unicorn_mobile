import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:unicorn/ui/teacher/teacher_bottom_tab/view/screens/calendar/view/teacher_calendar_screen.dart';
import 'package:unicorn/ui/teacher/teacher_bottom_tab/view/screens/home/view/teacher_home_screen.dart';
import 'package:unicorn/ui/teacher/teacher_bottom_tab/view/screens/kids/teacher_kids_screen.dart';
import 'package:unicorn/ui/teacher/teacher_bottom_tab/view/screens/profile/view/teacher_profile_screen.dart';
import 'package:unicorn/ui/teacher/teacher_bottom_tab/view/screens/teacher_chat/teacher_chat.dart';

import '../controller/teacher_bottom_tab_controller.dart';

class TeacherBottomTab extends StatelessWidget {
  TeacherBottomTab({super.key});

  final TeacherBottomTabController controller =
      Get.put(TeacherBottomTabController(), permanent: true);

  final List<Widget> _screens = [
    TeacherHomeScreen(),
    TeacherCalendarScreen(),
    TeacherKidsScreen(),
    TeacherChat(),
    TeacherProfileScreen(),
  ];

  bool isLight(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => WillPopScope(
        onWillPop: () async {
          if (controller.selectedIndex.value != 0) {
            controller.changeTab(0);
            return false;
          }
          return true;
        },
        child: Scaffold(
          backgroundColor: isLight(context)
              ? const Color(0xFFF5F5F5)
              : const Color(0xFF121212),
        
          // ✅ CHANGE HERE
          body: SafeArea(
            child: PageStorage(
              bucket: controller.bucket,
              child: controller.currentScreen.value,
            ),
          ),
        
          bottomNavigationBar: _buildBottomBar(context),
        ),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    final light = isLight(context);

    return Obx(
      () => Container(
        decoration: BoxDecoration(
          color: light ? Colors.white : const Color(0xFF1E1E1E),
          boxShadow: [
            if (light)
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
          ],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: controller.selectedIndex.value,
            onTap: controller.changeTab,
            backgroundColor: light ? Colors.white : const Color(0xFF1E1E1E),
            elevation: 0,
            selectedItemColor: const Color(0xFF008B8B),
            unselectedItemColor:
                light ? Colors.grey.shade400 : Colors.grey.shade500,
            selectedFontSize: 12,
            unselectedFontSize: 11,
            showUnselectedLabels: true,
            items: [
              _navItem(
                context,
                icon: 'assets/svg/home.svg',
                label: 'tab_home'.tr,
              ),
              _navItem(
                context,
                icon: 'assets/svg/calender.svg',
                label: 'tab_calendar'.tr,
              ),
              _navItem(
                context,
                icon: 'assets/svg/kids.svg',
                label: 'tab_kids'.tr,
              ),
              _navItem(
                context,
                icon: 'assets/svg/chat.svg',
                label: 'tab_chat'.tr,
              ),
              _navItem(
                context,
                icon: 'assets/svg/settings.svg',
                label: 'tab_profile'.tr,
              ),
            ],
          ),
        ),
      ),
    );
  }
  // Widget _buildBottomBar(BuildContext context) {
  //   final light = isLight(context);
  //
  //   return Obx(
  //         () => Padding(
  //       padding: const EdgeInsets.only(bottom: 8.0),
  //       child: Container(
  //         decoration: BoxDecoration(
  //           color: light ? Colors.white : const Color(0xFF1E1E1E),
  //           boxShadow: [
  //             if (light)
  //               BoxShadow(
  //                 color: Colors.black.withOpacity(0.05),
  //                 blurRadius: 10,
  //                 offset: const Offset(0, -2),
  //               ),
  //           ],
  //           borderRadius: const BorderRadius.only(
  //             topLeft: Radius.circular(16),
  //             topRight: Radius.circular(16),
  //           ),
  //         ),
  //         child: ClipRRect(
  //           borderRadius: const BorderRadius.only(
  //             topLeft: Radius.circular(16),
  //             topRight: Radius.circular(16),
  //           ),
  //           child: MediaQuery.removePadding(
  //             context: context,
  //             removeBottom: true,
  //             child: BottomNavigationBar(
  //               type: BottomNavigationBarType.fixed,
  //               currentIndex: controller.selectedIndex.value,
  //               onTap: controller.changeTab,
  //               backgroundColor:
  //               light ? Colors.white : const Color(0xFF1E1E1E),
  //               elevation: 0,
  //               selectedItemColor: const Color(0xFF008B8B),
  //               unselectedItemColor:
  //               light ? Colors.grey.shade400 : Colors.grey.shade500,
  //               selectedFontSize: 12,
  //               unselectedFontSize: 11,
  //               showUnselectedLabels: true,
  //               items: [
  //                 _navItem(
  //                   context,
  //                   icon: 'assets/svg/home.svg',
  //                   label: 'tab_home'.tr,
  //                 ),
  //                 _navItem(
  //                   context,
  //                   icon: 'assets/svg/calender.svg',
  //                   label: 'tab_calendar'.tr,
  //                 ),
  //                 _navItem(
  //                   context,
  //                   icon: 'assets/svg/kids.svg',
  //                   label: 'tab_kids'.tr,
  //                 ),
  //                 _navItem(
  //                   context,
  //                   icon: 'assets/svg/chat.svg',
  //                   label: 'tab_chat'.tr,
  //                 ),
  //                 _navItem(
  //                   context,
  //                   icon: 'assets/svg/settings.svg',
  //                   label: 'tab_profile'.tr,
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
  BottomNavigationBarItem _navItem(
    BuildContext context, {
    required String icon,
    required String label,
  }) {
    final light = isLight(context);

    return BottomNavigationBarItem(
      icon: SvgPicture.asset(
        icon,
        color: light ? Colors.grey.shade400 : Colors.grey.shade500,
        width: 22,
      ),
      activeIcon: SvgPicture.asset(
        icon,
        color: const Color(0xFF008B8B),
        width: 22,
      ),
      label: label,
    );
  }
}
