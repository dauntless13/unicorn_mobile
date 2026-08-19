import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';

import '../../../../routes/app_routs.dart';
import '../../../../service/api_service/api_worker.dart';
import '../../../../service/session/session_helper.dart';
import '../../../../translation/language_controller.dart';
import '../../../../widget/common_toastification.dart';
import '../../../parent/main_tab_bar/controller/maintab_controller.dart';
import '../../../teacher/teacher_bottom_tab/controller/teacher_bottom_tab_controller.dart';
import '../model/login_request.dart';

class LoginController extends GetxController {
  final ApiWorker apiWorker = Get.put(ApiWorker());
  final RxBool isLoading = false.obs;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  /// -------------------------
  /// EMAIL VALIDATION
  /// -------------------------
  String? validateEmail(String value) {
    if (value.trim().isEmpty) {
      return "Email is required";
    }
    if (!GetUtils.isEmail(value.trim())) {
      return "Enter valid email address";
    }
    return null;
  }

  Future<String?> getFcmToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String? token = await messaging.getToken();
    return token;
  }

  Future<void> updateFcmTokenInChats(String userId, String newToken) async {
    final firestore = FirebaseFirestore.instance;

    final chats = await firestore
        .collection('chats')
        .where('participants', arrayContains: userId)
        .get();

    for (var doc in chats.docs) {
      await doc.reference.update({
        "participantsTokens.$userId": newToken,
      });
    }
  }

  /// -------------------------
  /// PASSWORD VALIDATION
  /// -------------------------
  String? validatePassword(String value) {
    if (value.trim().isEmpty) {
      return "Password is required";
    }
    if (value.trim().length < 6) {
      return "Password must be at least 6 characters";
    }
    return null;
  }

  /// -------------------------
  /// LOGIN FUNCTION
  /// -------------------------
  Future<void> login(BuildContext context) async {
    if (isLoading.value) return;
    try {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      /// Validate email
      final emailError = validateEmail(email);
      if (emailError != null) {
        showToast(
          context,
          "Error",
          emailError,
          type: ToastificationType.error,
        );
        return;
      }

      /// Validate password
      final passError = validatePassword(password);
      if (passError != null) {
        showToast(
          context,
          "Error",
          passError,
          type: ToastificationType.error,
        );
        return;
      }

      isLoading.value = true;
      final fcmToken = await getFcmToken();

      /// Create Request Model
      var request = LoginRequest(
        emailAddress: email,
        password: password,
        fcmToken: fcmToken, // Replace with real FCM later
        deviceId: "deviceId", // Replace with real device id later
        deviceType: "APP",
        lang: LanguageController.to.apiLanguage,
      );

      /// API CALL (ProgressBar handled inside ApiWorker)
      final response = await apiWorker.login(request, context);

      if (response != null) {
        /// Save session
        await SessionHelper().setLoginResponse(response);

        final role = response.data?.user?.role;
        String userId = response.data?.user?.id ?? "";
        await updateFcmTokenInChats(userId, fcmToken ?? "");

        /// Role Based Navigation
        if (role == "TEACHER") {
          if (Get.isRegistered<TeacherBottomTabController>()) {
            Get.find<TeacherBottomTabController>().resetToHome();
          }
          Get.offAllNamed(Routes.TEACHERBOTTOMTAB);
        } else if (role == "PARENT") {
          if (Get.isRegistered<MainTabController>()) {
            Get.find<MainTabController>().resetToHome();
          }
          Get.offAllNamed(Routes.MAINTABBAR);
        } else {
          isLoading.value = false;
          print("Unknown role");
          showToast(
            context,
            "Error",
            response.message ?? "Unknown role",
            type: ToastificationType.error,
          );
        }
      } else {
        isLoading.value = false;
      }
    } catch (e) {
      isLoading.value = false;
      print('Error ::: $e');
      showToast(
        context,
        "Error",
        "Login failed",
        type: ToastificationType.error,
      );
    }
  }

  /// Dispose Controllers Properly
  @override
  void onClose() {
    emailController.clear();
    passwordController.clear();
    super.onClose();
  }
}
