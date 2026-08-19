import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unicorn/core/widget/my_regular_text.dart';
import '../../../core/widget/back_button.dart';
import '../../../core/widget/my_form_field.dart';
import '../../../widget/my_regular_button.dart';
import 'model/controller/change_password_controller.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  bool get isLight =>
      Theme.of(context).brightness == Brightness.light;
  final ChangePasswordController controller =
  Get.put(ChangePasswordController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
      isLight ? Colors.white : const Color(0xFF0F0F0F),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
            
                appBackButton(context),
            
                const SizedBox(height: 24),
            
                MyRegularText(
                  label: 'change_password_title'.tr,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: isLight ? Colors.black : Colors.white,
                ),
            
                const SizedBox(height: 24),
            
                /// CURRENT PASSWORD
                _label('password_label'.tr),
                const SizedBox(height: 8),
                _passwordField(
                  hint: 'password_hint'.tr,
                  obscure: _obscureCurrent,
                  controller: controller.currentPasswordController,
                  onToggle: () =>
                      setState(() => _obscureCurrent = !_obscureCurrent),
                ),
            
                const SizedBox(height: 16),
            
                /// NEW PASSWORD
                _label('new_password_label'.tr),
                const SizedBox(height: 8),
                _passwordField(
                  hint: 'new_password_hint'.tr,
                  obscure: _obscureNew,
                  controller: controller.newPasswordController,
                  onToggle: () =>
                      setState(() => _obscureNew = !_obscureNew),
                ),
            
                const SizedBox(height: 16),
            
                /// CONFIRM PASSWORD
                _label('confirm_password_label'.tr),
                const SizedBox(height: 8),
                _passwordField(
                  hint: 'confirm_password_hint'.tr,
                  obscure: _obscureConfirm,
                  controller: controller.confirmPasswordController,
                  onToggle: () =>
                      setState(() => _obscureConfirm = !_obscureConfirm),
                ),
            
                const SizedBox(height: 32),

                Obx(() => MyThemeButton(
                  title: 'change_password_button'.tr,
                  isLoading: controller.isLoading.value,
                  onPressed: () {
                    controller.changePassword(context);
                  },
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================= LABEL =================
  Widget _label(String text) {
    return MyRegularText(
      label: text,
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color:
      isLight ? Colors.grey[600] : Colors.grey[400],
    );
  }

  // ================= PASSWORD FIELD =================
  Widget _passwordField({
    required String hint,
    required bool obscure,
    required VoidCallback onToggle,
    required TextEditingController controller,
  }) {
    return MyFormField(
      controller: controller,
      hintText: hint,
      obscureText: obscure,
      borderRadius: 8,
      suffixIcon: IconButton(
        icon: Icon(
          obscure
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
        ),
        onPressed: onToggle,
      ),
    );
  }
}
