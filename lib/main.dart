import 'dart:io';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';
import 'package:unicorn/service/notification_service/FirebaseNotificationService.dart';
import 'package:unicorn/translation/app_translation.dart';
import 'package:unicorn/translation/language_controller.dart';

import 'routes/app_pages.dart';
import 'routes/app_routs.dart';
import 'core/Theme/Themes.dart';
import 'core/Theme/ThemesController.dart';
import 'core/common_size/common_hight_width.dart';
import 'core/widget/my_regular_text.dart';
import 'network_controller.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
var locale1 = "en";
var localeCountry1 = "US";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
  await FirebaseNotificationService.init();
  // Optional: Lock orientation
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(MyApp());
}

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ThemesController themeController = Get.put(ThemesController());
  final NetworkController networkController = Get.put(NetworkController());
  final LanguageController languageController =
  Get.put(LanguageController());
  bool dialogShowing = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      initTrackingTransparency();
    });
  }

  @override
  Widget build(BuildContext context) {
    /// ✅ CORRECT WAY TO USE SIZER
    return Sizer(
      builder: (context, orientation, deviceType) {
        return LayoutBuilder(
          builder: (context, constraints) {
            AppDimensions.createInstance(context, constraints);

            return
              GetMaterialApp(
                debugShowCheckedModeBanner: false,
                navigatorKey: navigatorKey,
                title: 'Unicorn',
                theme: Themes.lightTheme,
                darkTheme: Themes.darkTheme,
                themeMode: getThemeMode(themeController.theme.value),
                getPages: AppPages.pages,
                initialRoute: Routes.SPLASH,

                translations: AppTranslations(),
                locale: languageController.currentLocale,
                fallbackLocale: const Locale('en', 'US'),
                localeResolutionCallback: (deviceLocale, supportedLocales) {
                  return languageController.currentLocale;
                },

                /// ⭐ ADD THIS
                supportedLocales: const [
                  Locale('en', 'US'),
                  Locale('ar', 'SA'),
                ],

                localizationsDelegates: const [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
              );
          },
        );
      },
    );
  }

  ThemeMode getThemeMode(String type) {
    switch (type) {
      case "system":
        return ThemeMode.system;
      case "dark":
        return ThemeMode.dark;
      default:
        return ThemeMode.light;
    }
  }
  Future<void> initTrackingTransparency() async {
    try {
      final TrackingStatus status =
      await AppTrackingTransparency.trackingAuthorizationStatus;
      if (status == TrackingStatus.notDetermined) {
        await AppTrackingTransparency.requestTrackingAuthorization();
        requestNotificationPermissions();
      }
    } on PlatformException {}
  }

  Future<void> requestNotificationPermissions() async {
    var status = await Permission.notification.status;
    if (status.isDenied) {
      await Permission.notification.request();
    }
  }
}