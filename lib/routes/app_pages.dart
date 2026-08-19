import 'package:get/get.dart';
import 'package:unicorn/ui/auth/splash/splash_screen.dart';
import 'package:unicorn/ui/teacher/teacher_bottom_tab/view/screens/home/view/report/view/category_screens/nap/nap_list.dart';
import '../ui/auth/forgot_password/view/reset_password_screen.dart';
import '../ui/auth/onboarding/view/onboarding_screen.dart';
import '../ui/auth/forgot_password/view/forgot_password_screen.dart';
import '../ui/auth/view/login_screen.dart';
import '../ui/auth/forgot_password/view/otp_verify_screen.dart';
import '../ui/parent/main_tab_bar/view/main_tabbar.dart';
import '../ui/teacher/teacher_bottom_tab/view/screens/home/view/add_post/view/add_post_screen.dart';
import '../ui/teacher/teacher_bottom_tab/view/screens/home/view/add_story/view/add_story_screen.dart';
import '../ui/teacher/teacher_bottom_tab/view/screens/home/view/attendance/attendance_screen.dart';
import '../ui/teacher/teacher_bottom_tab/view/screens/home/view/report/view/category_screens/activity/activity_list_screen.dart';
import '../ui/teacher/teacher_bottom_tab/view/screens/home/view/report/view/category_screens/hygiene/hygiene_list.dart';
import '../ui/teacher/teacher_bottom_tab/view/screens/home/view/report/view/category_screens/meal_snack/meal_snacks_list.dart';
import '../ui/teacher/teacher_bottom_tab/view/screens/home/view/report/view/notes_screen.dart';
import '../ui/teacher/teacher_bottom_tab/view/screens/home/view/report/view/report_details_screen.dart';
import '../ui/teacher/teacher_bottom_tab/view/screens/home/view/report/view/evolution_forms_list_screen.dart';
import '../ui/teacher/teacher_bottom_tab/view/screens/home/view/report/view/evolution_report_screen.dart';
import '../ui/teacher/teacher_bottom_tab/view/screens/home/view/report/view/quick_log_screen.dart';
import '../ui/teacher/teacher_bottom_tab/view/screens/home/view/report/view/bulk_evaluation_screen.dart';
import '../ui/teacher/teacher_bottom_tab/view/screens/home/view/report/view/teacher_notice_screen.dart';
import '../ui/teacher/teacher_bottom_tab/view/teacher_bottom_tab.dart';
import 'app_routs.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: Routes.SPLASH,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: Routes.ONBOARDING,
      page: () => const OnboardingScreen(),
    ),
    GetPage(
      name: Routes.LOGINSCREEN,
      page: () => const LoginScreen(),
    ),
    GetPage(
      name: Routes.FORGOTPASSWORDSCREEN,
      page: () => const ForgotPasswordScreen(),
    ),
    GetPage(
      name: Routes.RESETPASSWORDSCREEN,
      page: () => const ResetPasswordScreen(),
    ),
    GetPage(
      name: Routes.OTPVERIFYSCREEN,
      page: () => const OtpVerifyScreen(),
    ),
    GetPage(
      name: Routes.MAINTABBAR,
      page: () => MainTabScreen(),
    ),
    GetPage(
      name: Routes.TEACHERBOTTOMTAB,
      page: () => TeacherBottomTab(),
    ),
    GetPage(
      name: Routes.TEACHER_ATTENDANCE,
      page: () => AttendanceScreen(),
    ),
    GetPage(
      name: Routes.Add_POST_TEACHER,
      page: () => AddPostScreen(),
    ),
    GetPage(
      name: Routes.ADD_STORY_TEACHER,
      page: () => AddStoryScreenTeacher(),
    ),
    GetPage(
      name: Routes.TEACHER_NOTICE,
      page: () => TeacherNoticeScreen(),
    ),
    GetPage(
      name: Routes.REPORT_LIST,
      page: () => const QuickLogScreen(),
    ),
    GetPage(
      name: Routes.REPORT_DETAILS,
      page: () => ReportDetailsScreen(slug:''),
    ),
    GetPage(
      name: Routes.EVOLUTION_LIST,
      page: () => const BulkEvaluationScreen(),
    ),
    GetPage(
      name: Routes.EVOLUTION_FORMS_LIST,
      page: () {
        final args = Get.arguments as Map<String, dynamic>? ?? {};
        return EvolutionFormsListScreen(
          studentSlug: args['slug'] ?? '',
          classSlug: args['classSlug'] ?? '',
          studentName: args['studentName'],
          studentRoll: args['studentRoll'],
          studentClassName: args['studentClassName'],
          studentProfileLink: args['studentProfileLink'],
        );
      },
    ),
    GetPage(
      name: Routes.EVOLUTION_REPORT,
      page: () {
        final args = Get.arguments as Map<String, dynamic>? ?? {};
        return EvolutionReportScreen(
          slug: args['slug'] ?? '',
          studentName: args['studentName'],
          studentRoll: args['studentRoll'],
          studentClassName: args['studentClassName'],
          studentProfileLink: args['studentProfileLink'],
        );
      },
    ),
    GetPage(
      name: Routes.MEAL_SNACKS_LIST,
      page: () => MealSnacksList(),
    ),  GetPage(
      name: Routes.NAP_LIST,
      page: () => NapListScreen(),
    ),  GetPage(
      name: Routes.ACTIVITY_LIST,
      page: () => ActivityListScreen(),
    ),  GetPage(
      name: Routes.HYGIENE_LIST,
      page: () => HygieneListScreen(),
    ),      GetPage(
      name: Routes.NOTES_SCREEN,
      page: () => NotesScreen(),
    ),
    GetPage(
      name: Routes.QUICK_LOG,
      page: () => const QuickLogScreen(),
    ),
  ];
}
