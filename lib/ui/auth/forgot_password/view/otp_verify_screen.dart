import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:toastification/toastification.dart';
import 'package:unicorn/core/widget/my_regular_text.dart';
import 'package:unicorn/service/api_service/api_worker.dart';
import '../../../../core/widget/back_button.dart';
import '../../../../widget/my_regular_button.dart';
import '../../../../routes/app_routs.dart';
import '../../../../widget/common_toastification.dart';
import '../controller/forgot_password_controller.dart';
import '../model/forgot_password/forgot_password_request.dart';

class OtpVerifyScreen extends StatefulWidget {
  const OtpVerifyScreen({super.key});

  @override
  State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  bool isLight(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light;
  final ForgotPasswordController controller = Get.put(ForgotPasswordController());
  final ApiWorker _apiWorker = ApiWorker();
  Timer? _timer;
  int _secondsRemaining = 60;
  bool _isResending = false;
  String? _email;

  @override
  void initState() {
    super.initState();
    _email = Get.arguments is String ? Get.arguments as String : null;
    if (controller.emailController.text.trim().isEmpty &&
        _email != null &&
        _email!.trim().isNotEmpty) {
      controller.emailController.text = _email!.trim();
    }
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() {
      _secondsRemaining = 60;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_secondsRemaining <= 1) {
        timer.cancel();
        setState(() {
          _secondsRemaining = 0;
        });
        return;
      }
      setState(() {
        _secondsRemaining -= 1;
      });
    });
  }

  String _formatTime(int seconds) {
    final int mins = seconds ~/ 60;
    final int secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  Future<void> _resendOtp(BuildContext context) async {
    if (_secondsRemaining > 0 || _isResending) return;

    final String email = controller.emailController.text.trim();
    if (email.isEmpty) {
      showToast(context, "Error", "Please enter email",
          type: ToastificationType.error);
      return;
    }

    try {
      setState(() {
        _isResending = true;
      });

      final request = ForgotPasswordRequest(email: email);
      final response = await _apiWorker.forgotPassword(request, context);

      if (!mounted) return;
      if (response != null) {
        showToast(context, "Success", response.message ?? "OTP Sent");
        _startTimer();
      }
    } catch (e) {
      if (!mounted) return;
      showToast(context, "Error", "Failed to resend OTP",
          type: ToastificationType.error);
    } finally {
      if (!mounted) return;
      setState(() {
        _isResending = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool light = isLight(context);

    final defaultPinTheme = PinTheme(
      width: 52,
      height: 52,
      textStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: light ? Colors.black : Colors.white,
      ),
      decoration: BoxDecoration(
        color: light ? Colors.white : const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: light
              ? Colors.grey.shade300
              : Colors.grey.shade700,
        ),
      ),
    );

    return Scaffold(
      backgroundColor:
      light ? Colors.white : const Color(0xFF121212),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              /// BACK BUTTON
              appBackButton(context),

              const SizedBox(height: 24),

              /// TITLE
              MyRegularText(
                label: 'otp_title'.tr,
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: light ? Colors.black : Colors.white,
              ),

              const SizedBox(height: 6),

              /// SUBTITLE
              MyRegularText(
                label: 'otp_subtitle'.tr,
                fontSize: 14,
                color: light
                    ? Colors.grey.shade600
                    : Colors.grey.shade400,
                align: TextAlign.start,
              ),

              const SizedBox(height: 32),

              /// OTP INPUT
              Center(
                child: Pinput(
                  length: 6,
                  controller: controller.otpController,
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: defaultPinTheme.copyWith(
                    decoration: defaultPinTheme.decoration!.copyWith(
                      border: Border.all(
                        color: const Color(0xFF008B8B),
                        width: 1.5,
                      ),
                    ),
                  ),
                  submittedPinTheme: defaultPinTheme,
                  showCursor: true,
                  cursor: Container(
                    width: 2,
                    height: 22,
                    color: const Color(0xFF008B8B),
                  ),
                  onCompleted: (pin) {
                    debugPrint('OTP Entered: $pin');
                  },
                ),
              ),

              const SizedBox(height: 32),

              /// VERIFY BUTTON
              Obx(
                () => MyThemeButton(
                  title: 'verify_code'.tr,
                  isLoading: controller.isLoading.value,
                  onPressed: () {
                    controller.verifyOtp(context);
                  },
                ),
              ),

              const SizedBox(height: 16),

              /// RESEND
              Center(
                child: GestureDetector(
                  onTap: _secondsRemaining == 0
                      ? () => _resendOtp(context)
                      : null,
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 13,
                        color: light
                            ? Colors.grey.shade600
                            : Colors.grey.shade400,
                      ),
                      children: [
                        TextSpan(text: 'otp_not_received'.tr),
                        TextSpan(
                          text: _secondsRemaining == 0
                              ? ' ${'otp_resend'.tr}'
                              : ' ${'otp_resend'.tr} (${_formatTime(_secondsRemaining)})',
                          style: TextStyle(
                            color: _secondsRemaining == 0
                                ? const Color(0xFF008B8B)
                                : (light
                                    ? Colors.grey.shade500
                                    : Colors.grey.shade500),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
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
