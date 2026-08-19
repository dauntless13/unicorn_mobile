import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unicorn/core/widget/my_regular_text.dart';
import '../../../../core/widget/back_button.dart';
import '../../../../core/widget/my_form_field.dart';
import '../../../../widget/my_regular_button.dart';
import '../../../../routes/app_routs.dart';
import '../controller/forgot_password_controller.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  bool _obscurePassword = true;

  bool isLight(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light;
  final ForgotPasswordController controller = Get.put(ForgotPasswordController());
  @override
  Widget build(BuildContext context) {
    final bool light = isLight(context);

    return Scaffold(
      backgroundColor:
      light ? Colors.white : const Color(0xFF121212),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
            
                /// BACK BUTTON
                appBackButton(context),
            
                const SizedBox(height: 24),
            
                /// TITLE
                MyRegularText(
                  label: 'reset_password_title'.tr,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: light ? Colors.black : Colors.white,
                ),
            
                const SizedBox(height: 6),
            
                /// SUBTITLE
                MyRegularText(
                  label: 'reset_password_subtitle'.tr,
                  fontSize: 14,
                  color: light
                      ? Colors.grey.shade600
                      : Colors.grey.shade400,
                  align: TextAlign.start,
                ),
            
                const SizedBox(height: 32),
            
                /// NEW PASSWORD
                MyRegularText(
                  label: 'password_label'.tr,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: light
                      ? Colors.grey.shade600
                      : Colors.grey.shade400,
                ),
                const SizedBox(height: 8),
            
                MyFormField(
                  controller: controller.newPasswordController,
                  hintText: 'password_hint'.tr,
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.next,
                  borderRadius: 8,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: light
                          ? Colors.grey.shade600
                          : Colors.grey.shade400,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
            
                const SizedBox(height: 20),
            
                /// CONFIRM PASSWORD
                MyRegularText(
                  label: 'confirm_password_label'.tr,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: light
                      ? Colors.grey.shade600
                      : Colors.grey.shade400,
                ),
                const SizedBox(height: 8),
            
                MyFormField(
                  controller: controller.confirmPasswordController,
                  hintText: 'confirm_password_hint'.tr,
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.done,
                  borderRadius: 8,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: light
                          ? Colors.grey.shade600
                          : Colors.grey.shade400,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
            
                const SizedBox(height: 32),
            
                /// RESET BUTTON
                Obx(
                  () => MyThemeButton(
                    title: 'reset_password_button'.tr,
                    isLoading: controller.isLoading.value,
                    onPressed: () {
                      controller.changePassword(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
