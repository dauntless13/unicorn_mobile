import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/ColorUtils.dart';
import '../../../../core/widget/my_regular_text.dart';
import '../../../../routes/app_routs.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  bool isLight(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light;

  Color pageBg(BuildContext context) =>
      isLight(context) ? const Color(0xFFF2F2F2) : const Color(0xFF0F0F0F);

  Color primaryText(BuildContext context) =>
      isLight(context) ? boldTextColor : Colors.white;

  Color secondaryText(BuildContext context) =>
      isLight(context) ? normalTextColor : Colors.grey.shade400;

  Color inactiveDot(BuildContext context) =>
      isLight(context) ? Colors.grey.shade400 : Colors.grey.shade600;

  void _onPageChanged(int index) {
    setState(() => _currentIndex = index);
  }

  void _nextPage() {
    if (_currentIndex < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Get.offAllNamed(Routes.LOGINSCREEN);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBg(context),
      body: SafeArea(
        child: Column(
          children: [
            /// PAGES
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                children: [
                  _OnboardPage(
                    image: 'assets/png/onboarding.png',
                    title: 'onboard_title_1'.tr,
                    subtitle: 'onboard_subtitle_1'.tr,
                  ),
                  _OnboardPage(
                    image: 'assets/png/onboarding.png',
                    title: 'onboard_title_2'.tr,
                    subtitle: 'onboard_subtitle_2'.tr,
                  ),
                  _OnboardPage(
                    image: 'assets/png/onboarding.png',
                    title: 'onboard_title_3'.tr,
                    subtitle: 'onboard_subtitle_3'.tr,
                  ),
                ],
              ),
            ),

            /// DOTS + BUTTON
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (index) {
                      final isActive = _currentIndex == index;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 8,
                        width: isActive ? 20 : 8,
                        decoration: BoxDecoration(
                          color: isActive
                              ? const Color(0xFF0A6C7D)
                              : inactiveDot(context),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    height: 42,
                    child: ElevatedButton(
                      onPressed: _nextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0A6C7D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        _currentIndex == 2 ? 'done'.tr : 'next'.tr,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardPage extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;

  const _OnboardPage({
    required this.image,
    required this.title,
    required this.subtitle,
  });

  bool isLight(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// IMAGE SECTION
        Container(
          height: MediaQuery.of(context).size.height * 0.6,
          width: double.infinity,
          decoration: BoxDecoration(
            color: isLight(context)
                ? const Color(0xFF8DBEC7)
                : const Color(0xFF1E3A40),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(image, fit: BoxFit.contain),
            ),
          ),
        ),

        SizedBox(height: MediaQuery.of(context).size.height * 0.03),

        /// TITLE
        MyRegularText(
          label: title,
          align: TextAlign.center,
          fontSize: 30,
          fontWeight: FontWeight.w700,
          color: isLight(context) ? boldTextColor : Colors.white,
        ),

        const SizedBox(height: 10),

        /// SUBTITLE
        MyRegularText(
          label: subtitle,
          align: TextAlign.center,
          fontSize: 16,
          maxlines: 2,
          color:
          isLight(context) ? normalTextColor : Colors.grey.shade400,
        ),
      ],
    );
  }
}
