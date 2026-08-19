import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemesController extends GetxController {
  final storage = GetStorage();

  final theme = 'light'.obs; // ✅ reactive

  @override
  void onInit() {
    super.onInit();
    theme.value = storage.read('Theme') ?? 'light';
    _applyTheme(theme.value);
  }

  void setTheme(String value) {
    theme.value = value;
    storage.write('Theme', value);
    _applyTheme(value);
  }

  void _applyTheme(String value) {
    if (value == 'system') Get.changeThemeMode(ThemeMode.system);
    if (value == 'light') Get.changeThemeMode(ThemeMode.light);
    if (value == 'dark') Get.changeThemeMode(ThemeMode.dark);
  }
}

