import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/nursery_module_controller.dart';
import '../../../routes/app_routs.dart';
import '../../../service/notification_service/FirebaseNotificationService.dart';
import '../../../service/session/session_helper.dart';
import '../../parent/main_tab_bar/controller/maintab_controller.dart';
import '../../teacher/teacher_bottom_tab/controller/teacher_bottom_tab_controller.dart';
import '../view/model/login/login_response.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isLight(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light;

  @override
  void initState() {
    super.initState();
    checkSession();
    // Future.delayed(const Duration(seconds: 3), () {
    //   Get.offNamed(Routes.ONBOARDING);
    // });
  }

  Future<void> checkSession() async {
    await Future.delayed(const Duration(seconds: 3));

    LoginResponse? loginResponse = await SessionHelper().getLoginResponse();
    String? role = loginResponse?.data?.user?.role;
    final module = ensureNurseryModuleController();
    await module.hydrateFromSession();
    if (role == "TEACHER" || role == "PARENT") {
      // Refresh flags so a nursery toggle applies without forcing re-login.
      // ignore: use_build_context_synchronously
      unawaited(module.load(context));
    }
    if (role == "TEACHER") {
      if (Get.isRegistered<TeacherBottomTabController>()) {
        Get.find<TeacherBottomTabController>().resetToHome();
      }
      print('Splash: Navigating to Teacher Bottom Tab');
      Get.offAllNamed(Routes.TEACHERBOTTOMTAB);
      await Future.delayed(const Duration(milliseconds: 1000));
      await FirebaseNotificationService.persistToken(context);
      await FirebaseNotificationService.markAppReadyForNotificationNavigation();
    } else if (role == "PARENT") {
      if (Get.isRegistered<MainTabController>()) {
        Get.find<MainTabController>().resetToHome();
      }
      print('Splash: Navigating to Parent Main Tab');
      Get.offAllNamed(Routes.MAINTABBAR);
      await Future.delayed(const Duration(milliseconds: 1000));
      await FirebaseNotificationService.persistToken(context);
      await FirebaseNotificationService.markAppReadyForNotificationNavigation();
    } else {
      Get.offNamed(Routes.ONBOARDING);
      await Future.delayed(const Duration(milliseconds: 1000));
      await FirebaseNotificationService.markAppReadyForNotificationNavigation();
    }
  }

  @override
  Widget build(BuildContext context) {
    final light = isLight(context);

    return Scaffold(
      backgroundColor: light ? Colors.white : const Color(0xFF121212),
      body: Center(
        child: Image.asset(
          'assets/png/splash_screen.png',
          width: 180,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
