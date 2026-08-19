import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';
import '../../../../routes/app_routs.dart';
import '../../../../service/api_service/api_worker.dart';
import '../../../../translation/language_controller.dart';
import '../../../../widget/common_toastification.dart';
import '../../../common_screens/change_password/model/model/reset_password/reset_password_request.dart';
import '../model/forgot_password/forgot_password_request.dart';
import '../model/verify_otp/verify_otp_request.dart';

class ForgotPasswordController extends GetxController {

  final ApiWorker _apiWorker = ApiWorker();

  /// controllers
  final emailController = TextEditingController();
  final otpController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  RxBool isLoading = false.obs;

  /// EMAIL VALIDATION
  bool validateEmail(BuildContext context) {

    if (emailController.text.trim().isEmpty) {
      showToast(context,"Error","Please enter email",type: ToastificationType.error);
      return false;
    }

    if (!GetUtils.isEmail(emailController.text.trim())) {
      showToast(context,"Error","Enter valid email",type: ToastificationType.error);
      return false;
    }

    return true;
  }

  /// OTP VALIDATION
  bool validateOtp(BuildContext context) {

    if (otpController.text.trim().isEmpty) {
      showToast(context,"Error","Please enter OTP",type: ToastificationType.error);
      return false;
    }

    if (otpController.text.trim().length != 6) {
      showToast(context,"Error","OTP must be 6 digits",type: ToastificationType.error);
      return false;
    }

    return true;
  }

  /// PASSWORD VALIDATION
  bool validatePassword(BuildContext context) {

    if (newPasswordController.text.trim().isEmpty ||
        confirmPasswordController.text.trim().isEmpty) {
      showToast(context,"Error","Please enter password",type: ToastificationType.error);
      return false;
    }

    if (newPasswordController.text.length < 6) {
      showToast(context,"Error","Password must be at least 6 characters",type: ToastificationType.error);
      return false;
    }

    if (newPasswordController.text != confirmPasswordController.text) {
      showToast(context,"Error","Password does not match",type: ToastificationType.error);
      return false;
    }

    return true;
  }

  /// FORGOT PASSWORD API
  Future<void> forgotPassword(BuildContext context) async {

    if (!validateEmail(context)) return;

    try {

      isLoading.value = true;

      final request = ForgotPasswordRequest(
        email: emailController.text.trim(),
      );

      final response = await _apiWorker.forgotPassword(request, context);

      if (response != null) {

        showToast(context,"Success",response.message ?? "OTP Sent",
            type: ToastificationType.success);

        Get.toNamed(
          Routes.OTPVERIFYSCREEN,
          arguments: emailController.text.trim(),
        );
      }

    } catch (e) {

      showToast(context,"Error","Failed to send OTP",
          type: ToastificationType.error);

    } finally {

      isLoading.value = false;

    }
  }

  /// VERIFY OTP API
  Future<void> verifyOtp(BuildContext context) async {

    if (!validateOtp(context)) return;

    try {

      isLoading.value = true;

      final request = VerifyOtpRequest(
        email: emailController.text.trim(),
        otp: otpController.text.trim(),
      );

      final response = await _apiWorker.verifyOtpRequest(request, context);

      if (response != null) {

        showToast(context,"Success",response.message ?? "OTP Verified",
            type: ToastificationType.success);

        Get.toNamed(
          Routes.RESETPASSWORDSCREEN,
          arguments: emailController.text.trim(),
        );
      }

    } catch (e) {

      showToast(context,"Error","Invalid OTP",
          type: ToastificationType.error);

    } finally {

      isLoading.value = false;

    }
  }

  /// CHANGE PASSWORD
  Future<void> changePassword(BuildContext context) async {

    if (!validatePassword(context)) return;

    try {

      isLoading.value = true;

      ResetPasswordRequest request = ResetPasswordRequest(
        email: emailController.text.trim(),
        newPassword: newPasswordController.text.trim(),
        confirmPassword: confirmPasswordController.text.trim(),
        lang: LanguageController.to.apiLanguage,
      );

      await _apiWorker.resetPasswordApi(request, context);

      showToast(
        context,
        "Success",
        "Password changed successfully",
        type: ToastificationType.success,
      );

      Get.offAllNamed(Routes.LOGINSCREEN);

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
    emailController.clear();
    otpController.clear();
    newPasswordController.clear();
    confirmPasswordController.clear();
    super.onClose();
  }
}
