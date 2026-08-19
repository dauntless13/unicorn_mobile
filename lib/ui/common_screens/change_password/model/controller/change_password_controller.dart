import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';
import '../../../../../service/api_service/api_worker.dart';
import '../../../../../translation/language_controller.dart';
import '../../../../../widget/common_toastification.dart';
import '../model/change_password/change_password_request.dart';

class ChangePasswordController extends GetxController {
  final ApiWorker apiWorker = Get.put(ApiWorker());

  /// Text Controllers
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  RxBool isLoading = false.obs;

  Future<void> changePassword(BuildContext context) async {
    /// ✅ Validation
    if (newPasswordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      showToast(
        context,
        "Error",
        "Please enter password",
        type: ToastificationType.error,
      );
      return;
    }

    if (newPasswordController.text != confirmPasswordController.text) {
      showToast(
        context,
        "Error",
        "Password does not match",
        type: ToastificationType.error,
      );
      return;
    }
    try {
      isLoading.value = true;

      ChangePasswordRequest request = ChangePasswordRequest(
        password: currentPasswordController.text.trim(),
        newPassword: newPasswordController.text.trim(),
        confirmPassword: confirmPasswordController.text.trim(),
        lang: LanguageController.to.apiLanguage,
      );

      await apiWorker.changePasswordApi(request, context);

      Get.back();
      showToast(
        context,
        "Success",
        "Password changed successfully",
        type: ToastificationType.success,
      );
    } catch (e) {
      showToast(
        context,
        "Error",
        "Failed to change password",
        type: ToastificationType.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    currentPasswordController.clear();
    newPasswordController.clear();
    confirmPasswordController.clear();
    super.onClose();
  }
}
