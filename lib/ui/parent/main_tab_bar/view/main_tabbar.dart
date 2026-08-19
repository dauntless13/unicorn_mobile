import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:unicorn/ui/parent/main_tab_bar/view/screeen/home/view/home_screen.dart';
import 'package:unicorn/ui/parent/main_tab_bar/view/screeen/kids/view/kids_screen.dart';
import 'package:unicorn/ui/parent/main_tab_bar/view/screeen/profile/view/profile_screen.dart';

import '../../../common_screens/chat/view/chats_screen.dart';
import '../controller/maintab_controller.dart';

class MainTabScreen extends StatelessWidget {
  MainTabScreen({super.key});

  final MainTabController controller =
      Get.put(MainTabController(), permanent: true);

  final List<Widget> _screens = [
    HomeScreen(),
    const KidsScreen(galleryOnly: true),
    KidsScreen(),
    ParentChatScreen(),
    ProfileScreen(),
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
                icon: 'assets/svg/gallery.svg',
                label: 'tab_gallery'.tr,
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
  //           padding: const EdgeInsets.only(bottom: 8.0),
  //           child: Container(
  //                   decoration: BoxDecoration(
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
  //                   ),
  //                   child: ClipRRect(
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
  //                   icon: 'assets/svg/gallery.svg',
  //                   label: 'tab_gallery'.tr,
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
  //                   ),
  //                 ),
  //         ),
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
