import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unicorn/core/widget/my_regular_text.dart';
import 'package:unicorn/translation/language_bottom_sheet.dart';
import 'package:unicorn/translation/language_controller.dart';

import '../../../core/widget/my_form_field.dart';
import '../../../routes/app_routs.dart';
import '../../../widget/my_regular_button.dart';
import 'controller/login_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;

  bool isLight(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light;

  final LoginController controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    final bool light = isLight(context);
    final languageController = LanguageController.to;

    return Scaffold(
      backgroundColor: light ? Colors.white : const Color(0xFF121212),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),

                        Align(
                          alignment: AlignmentDirectional.topEnd,
                          child: Obx(
                            () => OutlinedButton.icon(
                              onPressed: showLanguageBottomSheet,
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 10,
                                ),
                                side: BorderSide(
                                  color: light
                                      ? Colors.grey.shade300
                                      : Colors.grey.shade700,
                                ),
                                foregroundColor:
                                    light ? Colors.black87 : Colors.white,
                                backgroundColor: light
                                    ? Colors.white
                                    : const Color(0xFF1E1E1E),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              icon:
                                  const Icon(Icons.language_outlined, size: 18),
                              label: Text(
                                languageController.locale.value.languageCode ==
                                        'ar'
                                    ? 'AR'
                                    : 'EN',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        /// LOGO + APP NAME
                        Row(
                          children: [
                            Image.asset(
                              'assets/png/login_logo.png',
                              height: 24,
                              width: 24,
                            ),
                            const SizedBox(width: 8),
                            MyRegularText(
                              label: 'app_name'.tr,
                              fontSize: 26,
                              fontWeight: FontWeight.w600,
                              color: light ? Colors.black : Colors.white,
                            ),
                          ],
                        ),

                        const SizedBox(height: 30),

                        /// TITLE
                        MyRegularText(
                          label: 'login_title'.tr,
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: light ? Colors.black : Colors.white,
                        ),

                        const SizedBox(height: 8),

                        /// SUBTITLE
                        MyRegularText(
                          label: 'login_subtitle'.tr,
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

                        /// EMAIL FIELD
                        MyFormField(
                          controller: controller.emailController,
                          hintText: 'email_hint_login'.tr,
                          textInputType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          borderRadius: 12,
                        ),

                        const SizedBox(height: 20),

                        /// PASSWORD LABEL
                        MyRegularText(
                          label: 'password_label'.tr,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: light
                              ? Colors.grey.shade600
                              : Colors.grey.shade400,
                        ),

                        const SizedBox(height: 8),

                        /// PASSWORD FIELD
                        MyFormField(
                          controller: controller.passwordController,
                          hintText: 'password_hint'.tr,
                          obscureText: _obscurePassword,
                          textInputAction: TextInputAction.done,
                          borderRadius: 12,
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

                        const SizedBox(height: 8),

                        /// FORGOT PASSWORD
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Get.toNamed(Routes.FORGOTPASSWORDSCREEN);
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: MyRegularText(
                              label: 'forgot_password'.tr,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF1E88E5),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        /// LOGIN BUTTON
                        Obx(
                          () => MyThemeButton(
                            title: 'login_button'.tr,
                            isLoading: controller.isLoading.value,
                            onPressed: () {
                              controller.login(context);
                            },
                          ),
                        ),

                        const Spacer(),

                        /// TERMS & CONDITIONS
                        // Center(
                        //   child: RichText(
                        //     textAlign: TextAlign.center,
                        //     text: TextSpan(
                        //       style: TextStyle(
                        //         fontSize: 11,
                        //         height: 1.5,
                        //         color:
                        //             light ? Colors.grey.shade600 : Colors.grey.shade400,
                        //       ),
                        //       children: [
                        //         TextSpan(text: 'terms_prefix'.tr),
                        //         TextSpan(
                        //           text: 'terms_service'.tr,
                        //           style: TextStyle(
                        //             fontWeight: FontWeight.w600,
                        //             color: light ? Colors.black87 : Colors.white,
                        //           ),
                        //         ),
                        //         TextSpan(text: 'terms_and'.tr),
                        //         TextSpan(
                        //           text: 'terms_data'.tr,
                        //           style: TextStyle(
                        //             fontWeight: FontWeight.w600,
                        //             color: light ? Colors.black87 : Colors.white,
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        //
                        // const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
