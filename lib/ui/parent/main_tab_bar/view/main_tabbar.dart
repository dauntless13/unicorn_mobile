import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unicorn/core/widget/glass_floating_nav_bar.dart';

import '../../../../controller/nursery_module_controller.dart';
import '../controller/maintab_controller.dart';

class MainTabScreen extends StatelessWidget {
  MainTabScreen({super.key});

  final MainTabController controller =
      Get.put(MainTabController(), permanent: true);

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
          extendBody: true,
          body: Stack(
            children: [
              Positioned.fill(child: _paddedScreen(context)),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: _buildBottomBar(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _paddedScreen(BuildContext context) {
    final media = MediaQuery.of(context);
    return MediaQuery(
      data: media.copyWith(
        padding: media.padding.copyWith(
          bottom: media.padding.bottom + kFloatingNavReserve,
        ),
        viewPadding: media.viewPadding.copyWith(
          bottom: media.viewPadding.bottom + kFloatingNavReserve,
        ),
      ),
      child: PageStorage(
        bucket: controller.bucket,
        child: controller.currentScreen.value,
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    final module = ensureNurseryModuleController();

    return Obx(
      () {
        final chatOn = module.chatEnabled.value;
        if (!chatOn && controller.selectedIndex.value == 3) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (controller.selectedIndex.value == 3) {
              controller.changeTab(4);
            }
          });
        }
        final tabIndexes = chatOn ? const [0, 1, 2, 3, 4] : const [0, 1, 2, 4];
        final visibleIndex = tabIndexes.indexOf(controller.selectedIndex.value);
        final items = [
          GlassNavItem(icon: 'assets/svg/home.svg', label: 'tab_home'.tr),
          GlassNavItem(icon: 'assets/svg/gallery.svg', label: 'tab_gallery'.tr),
          GlassNavItem(icon: 'assets/svg/kids.svg', label: 'tab_kids'.tr),
          if (chatOn)
            GlassNavItem(icon: 'assets/svg/chat.svg', label: 'tab_chat'.tr),
          GlassNavItem(icon: 'assets/svg/settings.svg', label: 'tab_profile'.tr),
        ];

        return GlassFloatingNavBar(
          items: items,
          currentIndex: visibleIndex < 0 ? 0 : visibleIndex,
          onTap: (index) => controller.changeTab(tabIndexes[index]),
        );
      },
    );
  }
}
