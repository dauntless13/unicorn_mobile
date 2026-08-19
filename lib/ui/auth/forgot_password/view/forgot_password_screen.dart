import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unicorn/core/widget/my_form_field.dart';
import 'package:unicorn/core/widget/my_regular_text.dart';
import '../../../../core/widget/back_button.dart';
import '../../../../widget/my_regular_button.dart';
import '../../../../routes/app_routs.dart';
import '../controller/forgot_password_controller.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// BACK BUTTON (VISIBLE IN DARK MODE)
              appBackButton(context),

              const SizedBox(height: 24),

              /// TITLE
              MyRegularText(
                label: 'forgot_password_title'.tr,
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: light ? Colors.black : Colors.white,
              ),

              const SizedBox(height: 8),

              /// SUBTITLE
              MyRegularText(
                label: 'forgot_password_subtitle'.tr,
                fontSize: 14,
                color: light
                    ? Colors.grey.shade600
                    : Colors.grey.shade400,
              ),

              const SizedBox(height: 32),

              /// EMAIL LABEL
              MyRegularText(
                label: 'email_label'.tr,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: light
                    ? Colors.grey.shade600
                    : Colors.grey.shade400,
              ),

              const SizedBox(height: 8),

              /// EMAIL FIELD (THEME AWARE)
              MyFormField(
                hintText: 'email_hint'.tr,
                controller: controller.emailController,
              ),

              const SizedBox(height: 32),

              /// BUTTON
              SizedBox(
                width: double.infinity,
                child: Obx(
                  () => MyThemeButton(
                    title: 'reset_password'.tr,
                    isLoading: controller.isLoading.value,
                    onPressed: () {
                      controller.forgotPassword(context);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
