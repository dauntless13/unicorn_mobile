import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';

class LanguageController extends GetxController {
  static LanguageController get to => Get.find();

  final _box = GetStorage();
  final _localeKey = 'app_language';
  final Rx<Locale> locale = const Locale('en', 'US').obs;

  Locale get currentLocale {
    final lang = _box.read(_localeKey) ?? 'en';
    return lang == 'ar'
        ? const Locale('ar', 'SA')
        : const Locale('en', 'US');
  }

  String get apiLanguage {
    final lang = _box.read(_localeKey) ?? 'en';
    return lang == 'ar' ? "AR" : "EN";
  }

  @override
  void onInit() {
    super.onInit();
    locale.value = currentLocale;
    Get.updateLocale(currentLocale);
  }

  void changeLanguage(Locale locale) {
    _box.write(_localeKey, locale.languageCode);
    this.locale.value = locale;
    Get.updateLocale(locale);
  }
}
