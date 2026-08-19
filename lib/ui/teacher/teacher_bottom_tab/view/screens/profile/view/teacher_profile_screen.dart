import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:unicorn/ui/teacher/teacher_bottom_tab/view/screens/profile/view/update_teacher_profile_screen.dart';
import 'package:unicorn/webpage/webview_screen.dart';

import '../../../../../../../core/Theme/ThemesController.dart';
import '../../../../../../../core/widget/profile_avatar.dart';
import '../../../../../../../service/session/session_helper.dart';
import '../../../../../../../translation/language_controller.dart';
import '../../../../../../auth/view/login_screen.dart';
import '../../../../../../common_screens/change_password/change_password_sceren.dart';
import '../controller/teacher_profile_controller.dart';
import 'my_leave/my_leave_list.dart';

class TeacherProfileScreen extends StatefulWidget {
  TeacherProfileScreen({super.key});

  @override
  State<TeacherProfileScreen> createState() => _TeacherProfileScreenState();
}

class _TeacherProfileScreenState extends State<TeacherProfileScreen> {
  final themeController = Get.find<ThemesController>();

  bool isLight(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light;
  final TeacherProfileController teacherProfileController =
      Get.put(TeacherProfileController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 0), () {
      teacherProfileController.teacherGetBySlug(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final light = isLight(context);

    return Scaffold(
      backgroundColor:
          light ? const Color(0xFFF4F6F8) : const Color(0xFF121212),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 16),
              _profileHeader(context),
              const SizedBox(height: 20),
              _accountSection(context),
              const SizedBox(height: 24),
              _moreSection(context),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // ================= PROFILE HEADER =================
  Widget _profileHeader(BuildContext context) {
    return Obx(() {
      // if (teacherProfileController.isLoading.value) {
      //   return const Center(
      //     child: CircularProgressIndicator(),
      //   );
      // }

      // final teacher = teacherProfileController.teacher.value;
      //
      // if (teacher == null) {
      //   return const SizedBox();
      // }
      if (teacherProfileController.isLoading.value) {
        return _profileHeaderShimmer();
      }

      final teacher = teacherProfileController.teacher.value;

      if (teacher == null) {
        return const SizedBox();
      }
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFF0D6E82),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            ProfileAvatar(
              radius: 26,
              imageUrl: teacher.profileLink,
              backgroundColor: const Color(0xFF0D6E82),
              iconColor: Colors.white,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    teacherProfileController.isLoading.value
                        ? "-"
                        : "${teacher.firstName ?? ""} ${teacher.lastName ?? ""}",
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    maxLines: 2,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    teacherProfileController.isLoading.value
                        ? "-"
                        : teacher.email ?? "",
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      );
    });
  }
  Widget _profileHeaderShimmer() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF0D6E82),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              height: 52,
              width: 52,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    height: 14,
                    width: double.infinity,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    height: 12,
                    width: 150,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  // ================= ACCOUNT SECTION =================
  Widget _accountSection(BuildContext context) {
    return _card(
      context,
      children: [
        _item(context,
            icon: Icons.person_outline,
            title: 'my_account'.tr,
            subtitle: 'my_account_desc'.tr, onTap: () {
          Get.to(EditTeacherProfileScreen(
            slug: teacherProfileController.teacher.value?.slug ?? '',
          ));
        }),
        _item(context,
            icon: Icons.lock_outline,
            title: 'change_password'.tr,
            subtitle: 'change_password_desc'.tr,
            onTap: () => Get.to(() => const ChangePasswordScreen())),
        _item(context,
            icon: Icons.description_outlined,
            title: 'my_leave'.tr,
            subtitle: 'my_leave_desc'.tr, onTap: () {
          Get.to(() => const MyLeaveList());
        }),
        _toggleItem(context),
        _item(context,
            icon: Icons.language_outlined,
            title: 'language'.tr,
            subtitle: 'language_desc'.tr,
            onTap: showLanguageBottomSheet),
        _item(context,
            icon: Icons.logout,
            title: 'logout'.tr,
            subtitle: 'logout_desc'.tr,
            onTap: () => _showLogoutConfirmation(context)),
      ],
    );
  }

  Future<void> clearFcmTokenFromChats(String userId) async {
    final firestore = FirebaseFirestore.instance;

    final chats = await firestore
        .collection('chats')
        .where('participants', arrayContains: userId)
        .get();

    for (var doc in chats.docs) {
      await doc.reference.update({
        "participantsTokens.$userId": "",
      });
    }
  }

  // ================= MORE SECTION =================
  Widget _moreSection(BuildContext context) {
    final light = isLight(context);

    return Obx(
      () {
        final teacher = teacherProfileController.teacher.value;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
              child: Text(
                'more'.tr,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: light ? Colors.black87 : Colors.white70,
                ),
              ),
            ),
            _card(
              context,
              children: [
                _item(
                  context,
                  icon: Icons.help_outline,
                  title: 'help_support'.tr,
                  onTap: () {
                    Get.to(
                      WebViewScreen(),
                      arguments: [
                        'help_support'.tr,
                        'https://admin.unicorn-class.com/help-and-support',
                      ],
                    );
                  },
                ),
                _item(
                  context,
                  icon: Icons.favorite_border,
                  title: 'about_us'.tr,
                  onTap: () {
                    Get.to(
                      WebViewScreen(),
                      arguments: [
                        'about_us'.tr,
                        'https://admin.unicorn-class.com/about-us',
                      ],
                    );
                  },
                ),
                _item(
                  context,
                  icon: Icons.privacy_tip_outlined,
                  title: 'privacy_policy'.tr,
                  onTap: () {
                    Get.to(
                      WebViewScreen(),
                      arguments: [
                        'privacy_policy'.tr,
                        teacher?.urls?.privacyPolicyUrl,
                      ],
                    );
                  },
                ),
                _item(
                  context,
                  icon: Icons.description_outlined,
                  title: 'terms_conditions'.tr,
                  onTap: () {
                    Get.to(
                      WebViewScreen(),
                      arguments: [
                        'terms_conditions'.tr,
                        teacher?.urls?.termsAndConditionsUrl,
                      ],
                    );
                  },
                ),
                // _item(context,
                //     icon: Icons.delete_outline,
                //     title: 'delete_account'.tr,
                //     danger: true),
              ],
            ),
          ],
        );
      },
    );
  }

  // ================= CARD =================
  Widget _card(BuildContext context, {required List<Widget> children}) {
    final light = isLight(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: light ? Colors.white : const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(children: children),
    );
  }

  // ================= ITEM =================
  Widget _item(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
    bool danger = false,
  }) {
    final light = isLight(context);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            _icon(context, icon, danger),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: danger
                          ? Colors.red
                          : light
                              ? Colors.black87
                              : Colors.white70,
                    ),
                  ),
                  if (subtitle != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: light ? Colors.grey : Colors.grey.shade400,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  // ================= TOGGLE =================
  Widget _toggleItem(BuildContext context) {
    final light = isLight(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          _icon(context, Icons.dark_mode_outlined, false),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              'light_dark_mode'.tr,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: light ? Colors.black87 : Colors.white70,
              ),
            ),
          ),
          Obx(
            () => CupertinoSwitch(
              value: themeController.theme.value == 'dark',
              onChanged: (v) => themeController.setTheme(v ? 'dark' : 'light'),
            ),
          ),
        ],
      ),
    );
  }

// Add this method to your _TeacherProfileScreenState class

  void _showLogoutConfirmation(BuildContext context) {
    final light = isLight(context);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: light ? Colors.white : const Color(0xFF1E1E1E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'logout_confirmation'.tr,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: light ? Colors.black87 : Colors.white,
            ),
          ),
          content: Text(
            'logout_confirmation_message'.tr,
            style: TextStyle(
              fontSize: 14,
              color: light ? Colors.black54 : Colors.white70,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'cancel'.tr,
                style: TextStyle(
                  color: light ? Colors.grey.shade700 : Colors.grey.shade400,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                final session = await SessionHelper().getLoginResponse();

                await SessionHelper().clearLoginSession();
                String userId = session?.data?.user?.id ?? "";
                await clearFcmTokenFromChats(userId);
                // if (Get.isRegistered<TeacherBottomTabController>()) {
                //   Get.find<TeacherBottomTabController>().resetToHome();
                // }
                Navigator.of(context).pop();
                Get.offAll(() => LoginScreen());
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.red.withOpacity(0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text(
                  'logout'.tr,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ================= ICON =================
  Widget _icon(BuildContext context, IconData icon, bool danger) {
    final light = isLight(context);

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: danger
            ? Colors.red.withOpacity(0.1)
            : light
                ? const Color(0xFFE8F3F6)
                : const Color(0xFF2A2A2A),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        size: 20,
        color: danger ? Colors.red : const Color(0xFF0D6E82),
      ),
    );
  }
}

void showLanguageBottomSheet() {
  Get.bottomSheet(
    Builder(
      builder: (context) {
        final isLight = Theme.of(context).brightness == Brightness.light;

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isLight ? Colors.white : const Color(0xFF1E1E1E),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _languageTile(
                context: context,
                title: 'English',
                locale: const Locale('en', 'US'),
              ),
              const SizedBox(height: 12),
              _languageTile(
                context: context,
                title: 'Arabic',
                locale: const Locale('ar', 'SA'),
              ),
            ],
          ),
        );
      },
    ),
    isScrollControlled: true,
  );
}

Widget _languageTile({
  required BuildContext context,
  required String title,
  required Locale locale,
}) {
  final controller = LanguageController.to;
  final isLight = Theme.of(context).brightness == Brightness.light;
  final TeacherProfileController teacherProfileController =
      Get.put(TeacherProfileController());
  final isSelected =
      controller.currentLocale.languageCode == locale.languageCode;

  final borderColor = isSelected
      ? Colors.teal
      : isLight
          ? Colors.grey.shade300
          : Colors.grey.shade700;

  final textColor = isSelected
      ? Colors.teal
      : isLight
          ? Colors.black87
          : Colors.white;

  return InkWell(
    borderRadius: BorderRadius.circular(12),
    onTap: () {
      controller.changeLanguage(locale);
      teacherProfileController.teacherGetBySlug(context).then(
        (value) {
          Get.back();
        },
      );
    },
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: borderColor,
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ),
          if (isSelected)
            const Icon(
              Icons.check_circle,
              color: Colors.teal,
            ),
        ],
      ),
    ),
  );
}
