import 'package:dio/dio.dart';
import 'package:toastification/toastification.dart';
import 'package:unicorn/service/api_service/api_constant.dart';
import 'package:unicorn/ui/teacher/teacher_bottom_tab/view/screens/home/model/reply_comment/reply_comment_request.dart';

import '../../translation/language_controller.dart';
import '../../ui/auth/forgot_password/model/forgot_password/forgot_password_request.dart';
import '../../ui/auth/forgot_password/model/forgot_password/forgot_password_response.dart';
import '../../ui/auth/forgot_password/model/verify_otp/verify_otp_request.dart';
import '../../ui/auth/forgot_password/model/verify_otp/verify_otp_response.dart';
import '../../ui/auth/view/model/login/login_response.dart';
import '../../ui/auth/view/model/login_request.dart';
import '../../ui/common_screens/change_password/model/model/change_password/change_password_request.dart';
import '../../ui/common_screens/change_password/model/model/change_password/change_password_response.dart';
import '../../ui/common_screens/change_password/model/model/reset_password/reset_password_request.dart';
import '../../ui/common_screens/change_password/model/model/reset_password/reset_password_response.dart';
import '../../ui/common_screens/chat/model/parent_group_user_listing/parent_group_user_listing_response.dart';
import '../../ui/common_screens/chat/model/teacher_group_user_listing/teacher_group_user_listing_request.dart';
import '../../ui/common_screens/chat/model/teacher_group_user_listing/teacher_group_user_listing_response.dart';
import '../../ui/common_screens/story_view/model/story_like/story_like_request.dart';
import '../../ui/common_screens/story_view/model/story_like/story_like_response.dart';
import '../../ui/common_screens/story_view/model/story_list_view/story_list_view_response.dart';
import '../../ui/common_screens/story_view/model/story_view/story_view_response.dart';
import '../../ui/parent/main_tab_bar/view/screeen/kids/view/model/fees_details/fees_details_request.dart';
import '../../ui/parent/main_tab_bar/view/screeen/kids/view/model/fees_details/fees_details_response.dart';
import '../../ui/parent/main_tab_bar/view/screeen/kids/view/model/gallery_details/gallery_details_response.dart';
import '../../ui/parent/main_tab_bar/view/screeen/kids/view/model/medical_reports/student_nurse_reports_request.dart';
import '../../ui/parent/main_tab_bar/view/screeen/kids/view/model/medical_reports/student_nurse_reports_response.dart';
import '../../ui/parent/main_tab_bar/view/screeen/kids/view/model/update_student_details/update_student_details_request.dart';
import '../../ui/parent/main_tab_bar/view/screeen/kids/view/model/update_student_details/update_student_details_response.dart';
import '../../ui/parent/main_tab_bar/view/screeen/profile/view/model/parent_data_by_slug/parent_data_by_slug_response.dart';
import '../../ui/parent/main_tab_bar/view/screeen/profile/view/student_leave/model/add_student_leave/student_leave_request.dart';
import '../../ui/parent/main_tab_bar/view/screeen/profile/view/student_leave/model/add_student_leave/student_leave_response.dart';
import '../../ui/parent/main_tab_bar/view/screeen/profile/view/student_leave/model/student_leave_listing/student_leave_listing_request.dart';
import '../../ui/parent/main_tab_bar/view/screeen/profile/view/student_leave/model/student_leave_listing/student_leave_listing_response.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/home/model/add_comment/add_comment_request.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/home/model/add_comment/add_comment_response.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/home/model/add_story/add_story_request.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/home/model/add_story/add_story_response.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/home/model/delete_comment/delete_comment_request.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/home/model/delete_comment/delete_comment_response.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/home/model/delete_post/delete_post_request.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/home/model/delete_post/delete_post_response.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/home/model/delete_story/delete_story_request.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/home/model/delete_story/delete_story_response.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/home/model/edit_comment/edit_comment_request.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/home/model/edit_comment/edit_comment_response.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/home/model/like_listing/like_listing_request.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/home/model/like_listing/like_listing_response.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/home/model/like_post/like_post_request.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/home/model/like_post/like_post_response.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/home/model/notification_list/notification_list_response.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/home/model/post_list/post_list_request.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/home/model/post_list/post_list_response.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/home/model/reply_comment/reply_comment_response.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/home/model/save_post/save_post_request.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/home/model/save_post/save_post_response.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/home/model/story_listing/story_listing_request.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/home/model/story_listing/story_listing_response.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/home/view/add_post/mode/add_post/add_post_request.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/home/view/add_post/mode/add_post/add_post_response.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/home/view/add_post/mode/list_student_by_class/list_student_by_class_request.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/home/view/add_post/mode/list_student_by_class/list_student_by_class_response.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/home/view/add_post/mode/upload_images/upload_images_request.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/home/view/add_post/mode/upload_images/upload_images_response.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/home/view/add_post/mode/upload_video/upload_video_request.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/home/view/add_post/mode/upload_video/upload_video_response.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/home/view/attendance/model/get_student_list_by_class/get_student_list_by_class_request.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/home/view/attendance/model/get_student_list_by_class/get_student_list_by_class_response.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/home/view/attendance/model/mark_attendance/mark_attendance_request.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/home/view/attendance/model/mark_attendance/mark_attendance_response.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/home/view/report/model/evaluation_area/evaluation_area_request.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/home/view/report/model/evaluation_area/evaluation_area_response.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/home/view/report/model/evaluation_forms_list/evaluation_forms_list_request.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/home/view/report/model/evaluation_forms_list/evaluation_forms_list_response.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/home/view/report/model/evaluation_question/evaluation_question_request.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/home/view/report/model/evaluation_question/evaluation_question_response.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/home/view/report/model/mood_update/mood_update_request.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/home/view/report/model/mood_update/mood_update_response.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/home/view/report/model/notes/add_notes/add_notes_request.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/home/view/report/model/notes/add_notes/add_notes_response.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/home/view/report/model/notes/notes_list/notes_list_request.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/home/view/report/model/notes/notes_list/notes_list_response.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/home/view/report/model/report_details_by_student_slug/report_details_by_student_slug_request.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/home/view/report/model/report_details_by_student_slug/report_details_by_student_slug_response.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/home/view/report/model/save_evaluation/save_evaluation_request.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/home/view/report/model/save_evaluation/save_evaluation_response.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/home/view/report/model/teacher_holiday_event_list/teacher_holiday_event_list_request.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/home/view/report/model/teacher_holiday_event_list/teacher_holiday_event_list_response.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/home/view/report/view/category_screens/activity/model/activity_listing/activity_listing_request.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/home/view/report/view/category_screens/activity/model/activity_listing/activity_listing_response.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/home/view/report/view/category_screens/activity/model/add_activity/add_activity_request.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/home/view/report/view/category_screens/activity/model/add_activity/add_activity_response.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/home/view/report/view/category_screens/hygiene/model/add_hygiene/add_hygiene_request.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/home/view/report/view/category_screens/hygiene/model/add_hygiene/add_hygiene_response.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/home/view/report/view/category_screens/hygiene/model/hygiene_list/hygiene_list_request.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/home/view/report/view/category_screens/hygiene/model/hygiene_list/hygiene_list_response.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/home/view/report/view/category_screens/meal_snack/model/add_meal_snack/add_meal_snack_request.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/home/view/report/view/category_screens/meal_snack/model/add_meal_snack/add_meal_snack_response.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/home/view/report/view/category_screens/meal_snack/model/meal_snack/meal_snack_request.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/home/view/report/view/category_screens/meal_snack/model/meal_snack/meal_snack_response.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/home/view/report/view/category_screens/nap/model/add_nap/add_nap_request.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/home/view/report/view/category_screens/nap/model/add_nap/add_nap_response.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/home/view/report/view/category_screens/nap/model/nap_list/nap_list_request.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/home/view/report/view/category_screens/nap/model/nap_list/nap_list_response.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/kids/model/student_by_slug/student_by_slug_request.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/kids/model/student_by_slug/student_by_slug_response.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/profile/model/city/city_request.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/profile/model/city/city_response.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/profile/model/country/country_request.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/profile/model/country/country_response.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/profile/model/get_all_class/get_all_class_request.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/profile/model/get_all_class/get_all_class_response.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/profile/model/state/state_request.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/profile/model/state/state_response.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/profile/model/teacher_profile_response.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/profile/model/update_parent_profile/update_parent_profile_request.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/profile/model/update_parent_profile/update_parent_profile_response.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/profile/model/update_teacher_profile/update_teacher_profile_request.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/profile/model/update_teacher_profile/update_teacher_profile_response.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/profile/view/my_leave/model/add_teacher_leave/add_teacher_leave_request.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/profile/view/my_leave/model/add_teacher_leave/add_teacher_leave_response.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/profile/view/my_leave/model/teacher_leave_list/teacher_leave_list_request.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/profile/view/my_leave/model/teacher_leave_list/teacher_leave_list_response.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/teacher_chat/model/create_chat/create_chat_request.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/teacher_chat/model/create_chat/create_chat_response.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/teacher_chat/model/parent_listing/parent_listing_request.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/teacher_chat/model/teacher_chat_parent_listing/teacher_chat_parent_listing_request.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/teacher_chat/model/teacher_chat_parent_listing/teacher_chat_parent_listing_response.dart';
import '../../ui/teacher/teacher_bottom_tab/view/screens/teacher_chat/model/techer_listing/teacher_listing_response.dart';
import '../../widget/common_toastification.dart';
import '../../widget/progressbar.dart';
import '../session/session_helper.dart';
import 'dio_client.dart';

class ApiWorker with ApiConstant {
  late DioClient dio;

  ApiWorker() {
    dio = DioClient();
  }

  Future<LoginResponse?> login(LoginRequest request, context) async {
    // ProgressBar.showProgressBarApi(context);

    try {
      final response = await dio.postbycustom(
        context,
        ApiConstant.loginUrl,
        data: request.toJson(),
      );

      return LoginResponse.fromJson(response.data);
    } on DioException catch (error) {
      throw DioExceptionHandler.fromDioError(error, context);
    } finally {
      // ProgressBar.hideProgressBar(context);
    }
  }

  Future<TeacherProfileResponse?> teacherGetBySlug(slug, context) async {
    // ProgressBar.showProgressBarApi(context);
    print('Language ::: ${LanguageController.to.apiLanguage}');
    try {
      print('Language ::: ${LanguageController.to.apiLanguage}');
      final response = await dio.postbycustom(
        context,
        '${ApiConstant.teacherBySlugUrl}$slug',
        data: {
          'lang': LanguageController.to.apiLanguage,
        },
      );
      // ProgressBar.hideProgressBar(context);
      return TeacherProfileResponse.fromJson(response.data);
    } on DioException catch (error) {
      // ProgressBar.hideProgressBar(context);
      throw DioExceptionHandler.fromDioError(error, context);
    } finally {
      // ProgressBar.hideProgressBar(context);
    }
  }

  Future<ParentDataBySlugResponse?> parentBySlug(slug, context) async {
    // ProgressBar.showProgressBarApi(context);

    try {
      final response = await dio.postbycustom(
        context,
        '${ApiConstant.parentBySlugUrl}$slug',
        data: {'lang': LanguageController.to.apiLanguage},
      );
      // ProgressBar.hideProgressBar(context);
      return ParentDataBySlugResponse.fromJson(response.data);
    } on DioException catch (error) {
      // ProgressBar.hideProgressBar(context);
      throw DioExceptionHandler.fromDioError(error, context);
    } finally {
      // ProgressBar.hideProgressBar(context);
    }
  }

  Future<UploadImagesResponse?> uploadFileApi(
    UploadImagesRequest request,
    context,
  ) async {
    try {
      // ProgressBar.showProgressBarApi(context);

      final loginResponse = await SessionHelper().getLoginResponse();

      /// ✅ EXTRACT TOKEN
      String? token = loginResponse?.data?.token;
      print('Token ::: $token');

      if (token == null || token.isEmpty) {
        throw Exception("Token not found. User not logged in.");
      }

      final formData = await request.toFormData();

      final response = await dio.postbycustom(
        context,
        ApiConstant.uploadImageUrl,
        data: formData,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "authorization": "Bearer $token",
          },
        ),
      );

      return UploadImagesResponse.fromJson(response.data);
    } on DioException catch (error) {
      throw DioExceptionHandler.fromDioError(error, context);
    } finally {
      // ✅ Always hide progress bar (success or error)
      // ProgressBar.hideProgressBar(context);
    }
  }

  Future<UploadVideoResponse?> videoUpload(
    UploadVideoRequest request,
    context,
  ) async {
    try {
      // ProgressBar.showProgressBarApi(context);

      final loginResponse = await SessionHelper().getLoginResponse();

      /// ✅ EXTRACT TOKEN
      String? token = loginResponse?.data?.token;
      print('Token ::: $token');

      if (token == null || token.isEmpty) {
        throw Exception("Token not found. User not logged in.");
      }

      final formData = await request.toFormData();

      final response = await dio.postbycustom(
        context,
        ApiConstant.uploadVideoUrl,
        data: formData,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "authorization": "Bearer $token",
          },
        ),
      );

      return UploadVideoResponse.fromJson(response.data);
    } on DioException catch (error) {
      throw DioExceptionHandler.fromDioError(error, context);
    } finally {
      // ✅ Always hide progress bar (success or error)
      // ProgressBar.hideProgressBar(context);
    }
  }

  Future<UpdateTeacherProfileResponse?> updateTeacherProfile(
    UpdateTeacherProfileRequest request,
    context,
    String slug,
  ) async {
    try {
      // ProgressBar.showProgressBarApi(context);

      final loginResponse = await SessionHelper().getLoginResponse();
      String? token = loginResponse?.data?.token;
      print('Token ::: $token');
      if (token == null || token.isEmpty) {
        throw Exception("Token not found");
      }

      final response = await dio.postbycustom(
        context,
        '${ApiConstant.editTeacherProfileUrl}$slug',
        data: request.toJson(),
        options: Options(
          headers: {
            "authorization": "Bearer $token",
          },
        ),
      );

      return UpdateTeacherProfileResponse.fromJson(response.data);
    } on DioException catch (error) {
      throw DioExceptionHandler.fromDioError(error, context);
    } finally {
      // ✅ Always hide progress bar (success or error)
      // ProgressBar.hideProgressBar(context);
    }
  }

  Future<UpdateParentProfileResponse?> updateParentProfile(
    UpdateParentProfileRequest request,
    context,
    String slug,
  ) async {
    try {
      // ProgressBar.showProgressBarApi(context);

      final loginResponse = await SessionHelper().getLoginResponse();
      String? token = loginResponse?.data?.token;
      print('Token ::: $token');
      if (token == null || token.isEmpty) {
        throw Exception("Token not found");
      }

      final response = await dio.postbycustom(
        context,
        '${ApiConstant.editParentProfileUrl}$slug',
        data: request.toJson(),
        options: Options(
          headers: {
            "authorization": "Bearer $token",
          },
        ),
      );

      return UpdateParentProfileResponse.fromJson(response.data);
    } on DioException catch (error) {
      throw DioExceptionHandler.fromDioError(error, context);
    } finally {
      // ✅ Always hide progress bar (success or error)
      // ProgressBar.hideProgressBar(context);
    }
  }

  Future<CountryResponse?> countryListing(
    countryRequest request,
    context,
  ) async {
    try {
      // ProgressBar.showProgressBarApi(context);

      final loginResponse = await SessionHelper().getLoginResponse();
      String? token = loginResponse?.data?.token;
      print('Token ::: $token');
      if (token == null || token.isEmpty) {
        throw Exception("Token not found");
      }

      final response = await dio.postbycustom(
        context,
        ApiConstant.countryUrl,
        data: request.toJson(),
        options: Options(
          headers: {
            "authorization": "Bearer $token",
          },
        ),
      );

      return CountryResponse.fromJson(response.data);
    } on DioException catch (error) {
      throw DioExceptionHandler.fromDioError(error, context);
    } finally {
      // ✅ Always hide progress bar
      // ProgressBar.hideProgressBar(context);
    }
  }

  Future<StateResponse?> stateListing(
    StateRequest request,
    context,
  ) async {
    try {
      // ProgressBar.showProgressBarApi(context);

      final loginResponse = await SessionHelper().getLoginResponse();
      String? token = loginResponse?.data?.token;
      print('Token ::: $token');
      if (token == null || token.isEmpty) {
        throw Exception("Token not found");
      }

      final response = await dio.postbycustom(
        context,
        ApiConstant.stateUrl,
        data: request.toJson(),
        options: Options(
          headers: {
            "authorization": "Bearer $token",
          },
        ),
      );

      return StateResponse.fromJson(response.data);
    } on DioException catch (error) {
      throw DioExceptionHandler.fromDioError(error, context);
    } finally {
      // ✅ Always hide progress bar (success or error)
      // ProgressBar.hideProgressBar(context);
    }
  }

  Future<CityResponse?> cityListing(
    CityRequest request,
    context,
  ) async {
    try {
      // ProgressBar.showProgressBarApi(context);

      final loginResponse = await SessionHelper().getLoginResponse();
      String? token = loginResponse?.data?.token;
      print('Token ::: $token');
      if (token == null || token.isEmpty) {
        throw Exception("Token not found");
      }

      final response = await dio.postbycustom(
        context,
        ApiConstant.cityUrl,
        data: request.toJson(),
        options: Options(
          headers: {
            "authorization": "Bearer $token",
          },
        ),
      );

      return CityResponse.fromJson(response.data);
    } on DioException catch (error) {
      throw DioExceptionHandler.fromDioError(error, context);
    } finally {
      // ✅ Always hide progress bar (success or error)
      // ProgressBar.hideProgressBar(context);
    }
  }

  Future<GetAllClassResponse?> getAllClassApi(
    GetAllClassRequest request,
    context,
  ) async {
    try {
      // ProgressBar.showProgressBarApi(context);

      final loginResponse = await SessionHelper().getLoginResponse();
      String? token = loginResponse?.data?.token;
      print('Token ::: $token');
      if (token == null || token.isEmpty) {
        throw Exception("Token not found");
      }

      final response = await dio.postbycustom(
        context,
        ApiConstant.getAllClassUrl,
        data: request.toJson(),
        options: Options(
          headers: {
            "authorization": "Bearer $token",
          },
        ),
      );

      return GetAllClassResponse.fromJson(response.data);
    } on DioException catch (error) {
      throw DioExceptionHandler.fromDioError(error, context);
    } finally {
      // ✅ Always hide progress bar (success or error)
      // ProgressBar.hideProgressBar(context);
    }
  }

  Future<ListStudentByClassResponse?> listStudentByClassApi(
    ListStudentByClassRequest request,
    context,
    String slug,
  ) async {
    try {
      // ProgressBar.showProgressBarApi(context);

      final loginResponse = await SessionHelper().getLoginResponse();
      String? token = loginResponse?.data?.token;
      print('Token ::: $token');
      if (token == null || token.isEmpty) {
        throw Exception("Token not found");
      }

      final response = await dio.postbycustom(
        context,
        '${ApiConstant.listStudentByClassUrl}$slug',
        data: request.toJson(),
        options: Options(
          headers: {
            "authorization": "Bearer $token",
          },
        ),
      );

      return ListStudentByClassResponse.fromJson(response.data);
    } on DioException catch (error) {
      throw DioExceptionHandler.fromDioError(error, context);
    } finally {
      // ✅ Always hide progress bar (success or error)
      // ProgressBar.hideProgressBar(context);
    }
  }

  Future<AddPostResponse?> addPost(
    AddPostRequest request,
    context,
    String slug,
  ) async {
    try {
      // ProgressBar.showProgressBarApi(context);

      final loginResponse = await SessionHelper().getLoginResponse();
      String? token = loginResponse?.data?.token;
      print('Token ::: $token');
      if (token == null || token.isEmpty) {
        throw Exception("Token not found");
      }

      final response = await dio.postbycustom(
        context,
        ApiConstant.addPostUrl,
        data: request.toJson(),
        options: Options(
          headers: {
            "authorization": "Bearer $token",
          },
        ),
      );

      return AddPostResponse.fromJson(response.data);
    } on DioException catch (error) {
      throw DioExceptionHandler.fromDioError(error, context);
    } finally {
      // ✅ Always hide progress bar (success or error)
      // ProgressBar.hideProgressBar(context);
    }
  }

  Future<StudentBySlugResponse?> studentBySlug(
    StudentBySlugRequest request,
    context,
    String slug,
  ) async {
    try {
      // ProgressBar.showProgressBarApi(context);

      final loginResponse = await SessionHelper().getLoginResponse();
      String? token = loginResponse?.data?.token;
      print('Token ::: $token');
      if (token == null || token.isEmpty) {
        throw Exception("Token not found");
      }

      final response = await dio.postbycustom(
        context,
        '${ApiConstant.studentBySlugUrl}$slug',
        data: request.toJson(),
        options: Options(
          headers: {
            "authorization": "Bearer $token",
          },
        ),
      );

      return StudentBySlugResponse.fromJson(response.data);
    } on DioException catch (error) {
      throw DioExceptionHandler.fromDioError(error, context);
    } finally {
      // ✅ Always hide progress bar (success or error)
      // ProgressBar.hideProgressBar(context);
    }
  }

  Future<GetStudentListByClassResponse?> getStudentListByClass(
    GetStudentListByClassRequest request,
    context,
    String slug,
  ) async {
    print(request.toJson());

    try {
      // ProgressBar.showProgressBarApi(context);

      final loginResponse = await SessionHelper().getLoginResponse();
      String? token = loginResponse?.data?.token;
      print('Token ::: $token');
      if (token == null || token.isEmpty) {
        throw Exception("Token not found");
      }

      final response = await dio.postbycustom(
        context,
        ApiConstant.studentListByClassUrl,
        data: request.toJson(),
        options: Options(
          headers: {
            "authorization": "Bearer $token",
          },
        ),
      );

      return GetStudentListByClassResponse.fromJson(response.data);
    } on DioException catch (error) {
      throw DioExceptionHandler.fromDioError(error, context);
    } finally {
      // ✅ Always hide progress bar (success or error)
      // ProgressBar.hideProgressBar(context);
    }
  }

  Future<MarkAttendanceResponse?> markAttendanceApi(
    MarkAttendanceRequest request,
    context,
    String slug,
  ) async {
    try {
      // ProgressBar.showProgressBarApi(context);
      print(request.toJson());
      final loginResponse = await SessionHelper().getLoginResponse();
      String? token = loginResponse?.data?.token;
      print('Token ::: $token');
      if (token == null || token.isEmpty) {
        throw Exception("Token not found");
      }

      final response = await dio.postbycustom(
        context,
        ApiConstant.markAttendanceUrl,
        data: request.toJson(),
        options: Options(
          headers: {
            "authorization": "Bearer $token",
          },
        ),
      );

      return MarkAttendanceResponse.fromJson(response.data);
    } on DioException catch (error) {
      throw DioExceptionHandler.fromDioError(error, context);
    } finally {
      // ✅ Always hide progress bar (success or error)
      // ProgressBar.hideProgressBar(context);
    }
  }

  Future<ResetPasswordResponse?> resetPasswordApi(
    ResetPasswordRequest request,
    context,
  ) async {
    try {
      // ProgressBar.showProgressBarApi(context);

      final loginResponse = await SessionHelper().getLoginResponse();
      String? token = loginResponse?.data?.token;
      print('Token ::: $token');
      final response = await dio.postbycustom(
        context,
        ApiConstant.resetPasswordUrl,
        data: request.toJson(),
        options: Options(
          headers: {
            "authorization": "Bearer $token",
          },
        ),
      );

      return ResetPasswordResponse.fromJson(response.data);
    } on DioException catch (error) {
      throw DioExceptionHandler.fromDioError(error, context);
    } finally {
      // ✅ Always hide progress bar (success or error)
      // ProgressBar.hideProgressBar(context);
    }
  }

  Future<ChangePasswordResponse?> changePasswordApi(
    ChangePasswordRequest request,
    context,
  ) async {
    try {
      // ProgressBar.showProgressBarApi(context);

      final loginResponse = await SessionHelper().getLoginResponse();
      String? token = loginResponse?.data?.token;
      print('Token ::: $token');
      final response = await dio.postbycustom(
        context,
        ApiConstant.changePasswordApi,
        data: request.toJson(),
        options: Options(
          headers: {
            "authorization": "Bearer $token",
          },
        ),
      );

      return ChangePasswordResponse.fromJson(response.data);
    } on DioException catch (error) {
      throw DioExceptionHandler.fromDioError(error, context);
    } finally {
      // ✅ Always hide progress bar (success or error)
      // ProgressBar.hideProgressBar(context);
    }
  }

  Future<TeacherLeaveListResponse?> teacherLiveListingApi(
    TeacherLeaveListRequest request,
    context,
  ) async {
    try {
      // ProgressBar.showProgressBarApi(context);

      final loginResponse = await SessionHelper().getLoginResponse();
      String? token = loginResponse?.data?.token;
      print('Token ::: $token');
      if (token == null || token.isEmpty) {
        throw Exception("Token not found");
      }

      final response = await dio.postbycustom(
        context,
        ApiConstant.teacherLeaveUrl,
        data: request.toJson(),
        options: Options(
          headers: {
            "authorization": "Bearer $token",
          },
        ),
      );

      return TeacherLeaveListResponse.fromJson(response.data);
    } on DioException catch (error) {
      throw DioExceptionHandler.fromDioError(error, context);
    } finally {
      // ✅ Always hide progress bar (success or error)
      // ProgressBar.hideProgressBar(context);
    }
  }

  Future<AddTeacherLeaveResponse?> addTeacherLeave(
    AddTeacherLeaveRequest request,
    context,
  ) async {
    try {
      // ProgressBar.showProgressBarApi(context);

      final loginResponse = await SessionHelper().getLoginResponse();
      String? token = loginResponse?.data?.token;
      print('Token ::: $token');
      if (token == null || token.isEmpty) {
        throw Exception("Token not found");
      }

      final response = await dio.postbycustom(
        context,
        ApiConstant.addTeacherLeaveUrl,
        data: request.toJson(),
        options: Options(
          headers: {
            "authorization": "Bearer $token",
          },
        ),
      );

      return AddTeacherLeaveResponse.fromJson(response.data);
    } on DioException catch (error) {
      showToast(
        context,
        "Error",
        error.toString() ?? "Something went wrong",
        type: ToastificationType.error,
      );
      throw DioExceptionHandler.fromDioError(error, context);
    } finally {
      // ✅ Always hide progress bar (success or error)
      // ProgressBar.hideProgressBar(context);
    }
  }

  Future<TeacherHolidayEventListResponse?> holidayEventListResponse(
    TeacherHolidayEventListRequest request,
    context,
  ) async {
    try {
      // ProgressBar.showProgressBarApi(context);
      print('request : ${request.toJson()}');
      final loginResponse = await SessionHelper().getLoginResponse();
      String? token = loginResponse?.data?.token;
      print('Token ::: $token');
      if (token == null || token.isEmpty) {
        throw Exception("Token not found");
      }

      final response = await dio.postbycustom(
        context,
        ApiConstant.teacherHolidayEventListUrl,
        data: request.toJson(),
        options: Options(
          headers: {
            "authorization": "Bearer $token",
          },
        ),
      );

      return TeacherHolidayEventListResponse.fromJson(response.data);
    } on DioException catch (error) {
      throw DioExceptionHandler.fromDioError(error, context);
    } finally {
      // ✅ Always hide progress bar (success or error)
      // ProgressBar.hideProgressBar(context);
    }
  }

  Future<ReportDetailsByStudentSlugResponse?> reportStudentDetails(
      ReportDetailsByStudentSlugRequest request, context, String slug) async {
    try {
      // ProgressBar.showProgressBarApi(context);

      final loginResponse = await SessionHelper().getLoginResponse();
      String? token = loginResponse?.data?.token;
      print('Token ::: $token');
      if (token == null || token.isEmpty) {
        throw Exception("Token not found");
      }
      print('request ::: ${request.toJson()}');
      final response = await dio.postbycustom(
        context,
        '${ApiConstant.reportStudentDetailsUrl}$slug',
        data: request.toJson(),
        options: Options(
          headers: {
            "authorization": "Bearer $token",
          },
        ),
      );

      return ReportDetailsByStudentSlugResponse.fromJson(response.data);
    } on DioException catch (error) {
      throw DioExceptionHandler.fromDioError(error, context);
    } finally {
      // ✅ Always hide progress bar (success or error)
      // ProgressBar.hideProgressBar(context);
    }
  }

  Future<AddMealSnackResponse?> addMealSnacks(
      MealRequest request, context, String slug) async {
    try {
      // ProgressBar.showProgressBarApi(context);

      final loginResponse = await SessionHelper().getLoginResponse();
      String? token = loginResponse?.data?.token;
      print('Token ::: $token');
      print('request ::: ${request.toJson()}');
      if (token == null || token.isEmpty) {
        throw Exception("Token not found");
      }

      final response = await dio.postbycustom(
        context,
        '${ApiConstant.addMealSnackUrl}$slug',
        data: request.toJson(),
        options: Options(
          headers: {
            "authorization": "Bearer $token",
          },
        ),
      );

      return AddMealSnackResponse.fromJson(response.data);
    } on DioException catch (error) {
      throw DioExceptionHandler.fromDioError(error, context);
    } finally {
      // ✅ Always hide progress bar (success or error)
      // ProgressBar.hideProgressBar(context);
    }
  }

  Future<MealSnackResponse?> mealSnacksListing(
      MealSnackRequest request, context, String slug) async {
    try {
      // ProgressBar.showProgressBarApi(context);

      final loginResponse = await SessionHelper().getLoginResponse();
      String? token = loginResponse?.data?.token;
      print('Token ::: $token');
      if (token == null || token.isEmpty) {
        throw Exception("Token not found");
      }

      final response = await dio.postbycustom(
        context,
        '${ApiConstant.mealSnackListUrl}$slug',
        data: request.toJson(),
        options: Options(
          headers: {
            "authorization": "Bearer $token",
          },
        ),
      );

      return MealSnackResponse.fromJson(response.data);
    } on DioException catch (error) {
      throw DioExceptionHandler.fromDioError(error, context);
    } finally {
      // ✅ Always hide progress bar (success or error)
      // ProgressBar.hideProgressBar(context);
    }
  }

  Future<AddNapResponse?> addNapApi(
      AddNapRequest request, context, String slug) async {
    try {
      // ProgressBar.showProgressBarApi(context);

      final loginResponse = await SessionHelper().getLoginResponse();
      String? token = loginResponse?.data?.token;
      print('Token ::: $token');
      if (token == null || token.isEmpty) {
        throw Exception("Token not found");
      }
      print('request ::: ${request.toJson()}');
      final response = await dio.postbycustom(
        context,
        '${ApiConstant.addNapUrl}$slug',
        data: request.toJson(),
        options: Options(
          headers: {
            "authorization": "Bearer $token",
          },
        ),
      );

      return AddNapResponse.fromJson(response.data);
    } on DioException catch (error) {
      throw DioExceptionHandler.fromDioError(error, context);
    } finally {
      // ✅ Always hide progress bar (success or error)
      // ProgressBar.hideProgressBar(context);
    }
  }

  Future<NapListResponse?> napListingApi(
      NapListRequest request, context, String slug) async {
    try {
      // ProgressBar.showProgressBarApi(context);

      final loginResponse = await SessionHelper().getLoginResponse();
      String? token = loginResponse?.data?.token;
      print('Token ::: $token');
      if (token == null || token.isEmpty) {
        throw Exception("Token not found");
      }

      final response = await dio.postbycustom(
        context,
        '${ApiConstant.napListUrl}$slug',
        data: request.toJson(),
        options: Options(
          headers: {
            "authorization": "Bearer $token",
          },
        ),
      );

      return NapListResponse.fromJson(response.data);
    } on DioException catch (error) {
      throw DioExceptionHandler.fromDioError(error, context);
    } finally {
      // ✅ Always hide progress bar (success or error)
      // ProgressBar.hideProgressBar(context);
    }
  }

  Future<EvaluationAreaResponse?> evaluationAreaList(
    EvaluationAreaRequest request,
    context,
  ) async {
    try {
      final loginResponse = await SessionHelper().getLoginResponse();
      String? token = loginResponse?.data?.token;
      print('Token ::: $token');
      if (token == null || token.isEmpty) {
        throw Exception("Token not found");
      }

      final response = await dio.postbycustom(
        context,
        ApiConstant.evaluationAreaListUrl,
        data: request.toJson(),
        options: Options(
          headers: {
            "authorization": "Bearer $token",
          },
        ),
      );

      return EvaluationAreaResponse.fromJson(response.data);
    } on DioException catch (error) {
      throw DioExceptionHandler.fromDioError(error, context);
    } finally {}
  }

  Future<EvaluationQuestionResponse?> evaluationQuestionList(
    EvaluationQuestionRequest request,
    context,
  ) async {
    try {
      final loginResponse = await SessionHelper().getLoginResponse();
      String? token = loginResponse?.data?.token;
      print('Token ::: $token');
      if (token == null || token.isEmpty) {
        throw Exception("Token not found");
      }

      final response = await dio.postbycustom(
        context,
        ApiConstant.evaluationQuestionListUrl,
        data: request.toJson(),
        options: Options(
          headers: {
            "authorization": "Bearer $token",
          },
        ),
      );

      return EvaluationQuestionResponse.fromJson(response.data);
    } on DioException catch (error) {
      throw DioExceptionHandler.fromDioError(error, context);
    } finally {}
  }

  Future<({bool teachers, bool parents})?> getEvaluationModule(context) async {
    try {
      final loginResponse = await SessionHelper().getLoginResponse();
      final token = loginResponse?.data?.token;
      if (token == null || token.isEmpty) {
        throw Exception("Token not found");
      }

      final response = await dio.postbycustom(
        context,
        ApiConstant.evaluationModuleUrl,
        data: {'lang': LanguageController.to.apiLanguage},
        options: Options(
          headers: {
            "authorization": "Bearer $token",
          },
        ),
      );

      final data = response.data is Map ? response.data['data'] : null;
      if (data is! Map) return null;
      return (
        teachers: data['evaluationEnabledForTeachers'] != false,
        parents: data['evaluationEnabledForParents'] != false,
      );
    } on DioException catch (error) {
      throw DioExceptionHandler.fromDioError(error, context);
    }
  }

  Future<EvaluationFormsListResponse?> evaluationFormsList(
    EvaluationFormsListRequest request,
    context,
  ) async {
    try {
      print('request ::: ${request.toJson()}');
      final loginResponse = await SessionHelper().getLoginResponse();
      String? token = loginResponse?.data?.token;
      print('Token ::: $token');
      if (token == null || token.isEmpty) {
        throw Exception("Token not found");
      }

      final response = await dio.postbycustom(
        context,
        ApiConstant.evaluationFormsListUrl,
        data: request.toJson(),
        options: Options(
          headers: {
            "authorization": "Bearer $token",
          },
        ),
      );

      return EvaluationFormsListResponse.fromJson(response.data);
    } on DioException catch (error) {
      throw DioExceptionHandler.fromDioError(error, context);
    } finally {}
  }

  Future<StudentNurseReportsResponse?> studentNurseReportsList(
    StudentNurseReportsRequest request,
    context,
    String slug,
  ) async {
    try {
      print('request ::: ${request.toJson()}');
      final loginResponse = await SessionHelper().getLoginResponse();
      String? token = loginResponse?.data?.token;
      print('Token ::: $token');
      if (token == null || token.isEmpty) {
        throw Exception("Token not found");
      }

      final response = await dio.postbycustom(
        context,
        '${ApiConstant.studentNurseReportsUrl}$slug',
        data: request.toJson(),
        options: Options(
          headers: {
            "authorization": "Bearer $token",
          },
        ),
      );

      return StudentNurseReportsResponse.fromJson(response.data);
    } on DioException catch (error) {
      throw DioExceptionHandler.fromDioError(error, context);
    } finally {}
  }

  Future<SaveEvaluationResponse?> saveEvaluationForm(
    SaveEvaluationRequest request,
    context,
  ) async {
    try {
      final loginResponse = await SessionHelper().getLoginResponse();
      String? token = loginResponse?.data?.token;
      print('Token ::: $token');
      if (token == null || token.isEmpty) {
        throw Exception("Token not found");
      }

      final response = await dio.postbycustom(
        context,
        ApiConstant.saveEvaluationFormUrl,
        data: request.toJson(),
        options: Options(
          headers: {
            "authorization": "Bearer $token",
          },
        ),
      );

      return SaveEvaluationResponse.fromJson(response.data);
    } on DioException catch (error) {
      throw DioExceptionHandler.fromDioError(error, context);
    } finally {}
  }

  Future<SaveEvaluationResponse?> evaluationFormDetail(
    String evaluationId,
    context, {
    required String lang,
  }) async {
    try {
      final loginResponse = await SessionHelper().getLoginResponse();
      String? token = loginResponse?.data?.token;
      if (token == null || token.isEmpty) {
        throw Exception("Token not found");
      }

      final response = await dio.postbycustom(
        context,
        '${ApiConstant.evaluationFormDetailUrl}$evaluationId',
        data: {'lang': lang},
        options: Options(
          headers: {
            "authorization": "Bearer $token",
          },
        ),
      );

      return SaveEvaluationResponse.fromJson(response.data);
    } on DioException catch (error) {
      throw DioExceptionHandler.fromDioError(error, context);
    } finally {}
  }

  Future<AddActivityResponse?> createActivityApi(
      AddActivityRequest request, context, String slug) async {
    try {
      // ProgressBar.showProgressBarApi(context);

      final loginResponse = await SessionHelper().getLoginResponse();
      String? token = loginResponse?.data?.token;
      print('Token ::: $token');
      if (token == null || token.isEmpty) {
        throw Exception("Token not found");
      }
      print('request ::: ${request.toJson()}');
      final response = await dio.postbycustom(
        context,
        '${ApiConstant.addActivityUrl}$slug',
        data: request.toJson(),
        options: Options(
          headers: {
            "authorization": "Bearer $token",
          },
        ),
      );

      return AddActivityResponse.fromJson(response.data);
    } on DioException catch (error) {
      throw DioExceptionHandler.fromDioError(error, context);
    } finally {
      // ✅ Always hide progress bar (success or error)
      // ProgressBar.hideProgressBar(context);
    }
  }

  Future<ActivityListingResponse?> activityListingApi(
      ActivityListingRequest request, context, String slug) async {
    try {
      // ProgressBar.showProgressBarApi(context);

      final loginResponse = await SessionHelper().getLoginResponse();
      String? token = loginResponse?.data?.token;
      print('Token ::: $token');
      if (token == null || token.isEmpty) {
        throw Exception("Token not found");
      }

      final response = await dio.postbycustom(
        context,
        '${ApiConstant.activityListUrl}$slug',
        data: request.toJson(),
        options: Options(
          headers: {
            "authorization": "Bearer $token",
          },
        ),
      );

      return ActivityListingResponse.fromJson(response.data);
    } on DioException catch (error) {
      throw DioExceptionHandler.fromDioError(error, context);
    } finally {
      // ✅ Always hide progress bar (success or error)
      // ProgressBar.hideProgressBar(context);
    }
  }

  Future<AddHygieneResponse?> addHygieneApi(
      AddHygieneRequest request, context, String slug) async {
    try {
      // ProgressBar.showProgressBarApi(context);

      print('request : ${request.toJson()}');

      final loginResponse = await SessionHelper().getLoginResponse();
      String? token = loginResponse?.data?.token;
      print('Token ::: $token');
      if (token == null || token.isEmpty) {
        throw Exception("Token not found");
      }

      final response = await dio.postbycustom(
        context,
        '${ApiConstant.addHygieneUrl}$slug',
        data: request.toJson(),
        options: Options(
          headers: {
            "authorization": "Bearer $token",
          },
        ),
      );

      return AddHygieneResponse.fromJson(response.data);
    } on DioException catch (error) {
      throw DioExceptionHandler.fromDioError(error, context);
    } finally {
      // ✅ Always hide progress bar (success or error)
      // ProgressBar.hideProgressBar(context);
    }
  }

  Future<HygieneResponse?> hygieneListingApi(
      HygieneListRequest request, context, String slug) async {
    try {
      // ProgressBar.showProgressBarApi(context);

      final loginResponse = await SessionHelper().getLoginResponse();
      String? token = loginResponse?.data?.token;
      print('Token ::: $token');
      if (token == null || token.isEmpty) {
        throw Exception("Token not found");
      }

      final response = await dio.postbycustom(
        context,
        '${ApiConstant.hygieneListUrl}$slug',
        data: request.toJson(),
        options: Options(
          headers: {
            "authorization": "Bearer $token",
          },
        ),
      );

      return HygieneResponse.fromJson(response.data);
    } on DioException catch (error) {
      throw DioExceptionHandler.fromDioError(error, context);
    } finally {
      // ✅ Always hide progress bar (success or error)
      // ProgressBar.hideProgressBar(context);
    }
  }

  Future<AddNotesResponse?> addNotesApi(
      AddNotesRequest request, context, String slug) async {
    try {
      // ProgressBar.showProgressBarApi(context);

      final loginResponse = await SessionHelper().getLoginResponse();
      String? token = loginResponse?.data?.token;
      print('Token ::: $token');
      if (token == null || token.isEmpty) {
        throw Exception("Token not found");
      }

      final response = await dio.postbycustom(
        context,
        '${ApiConstant.addNoteUrl}$slug',
        data: request.toJson(),
        options: Options(
          headers: {
            "authorization": "Bearer $token",
          },
        ),
      );

      return AddNotesResponse.fromJson(response.data);
    } on DioException catch (error) {
      throw DioExceptionHandler.fromDioError(error, context);
    } finally {
      // ✅ Always hide progress bar (success or error)
      ProgressBar.hideProgressBar(context);
    }
  }

  Future<NotesListResponse?> notesListingApi(
      NotesListRequest request, context, String slug) async {
    try {
      // ProgressBar.showProgressBarApi(context);

      final loginResponse = await SessionHelper().getLoginResponse();
      String? token = loginResponse?.data?.token;
      print('Token ::: $token');
      if (token == null || token.isEmpty) {
        throw Exception("Token not found");
      }

      final response = await dio.postbycustom(
        context,
        '${ApiConstant.noteListUrl}$slug',
        data: request.toJson(),
        options: Options(
          headers: {
            "authorization": "Bearer $token",
          },
        ),
      );

      return NotesListResponse.fromJson(response.data);
    } on DioException catch (error) {
      throw DioExceptionHandler.fromDioError(error, context);
    } finally {
      // ✅ Always hide progress bar (success or error)
      // ProgressBar.hideProgressBar(context);
    }
  }

  Future<PostListResponse?> postListingApi(
    PostListRequest request,
    context,
  ) async {
    try {
      // ProgressBar.showProgressBarApi(context);

      final loginResponse = await SessionHelper().getLoginResponse();
      String? token = loginResponse?.data?.token;
      print('Token ::: $token');
      if (token == null || token.isEmpty) {
        throw Exception("Token not found");
      }

      final response = await dio.postbycustom(
        context,
        '${ApiConstant.postListUrl}',
        data: request.toJson(),
        options: Options(
          headers: {
            "authorization": "Bearer $token",
          },
        ),
      );

      return PostListResponse.fromJson(response.data);
    } on DioException catch (error) {
      throw DioExceptionHandler.fromDioError(error, context);
    } finally {
      // ✅ Always hide progress bar (success or error)
      // ProgressBar.hideProgressBar(context);
    }
  }

  Future<LikePostResponse?> likePostApi(
      LikeRequest request, context, String id) async {
    try {
      final loginResponse = await SessionHelper().getLoginResponse();
      String? token = loginResponse?.data?.token;
      print('Token ::: $token');
      if (token == null || token.isEmpty) {
        throw Exception("Token not found");
      }

      final response = await dio.postbycustom(
        context,
        '${ApiConstant.likePostUrl}$id',
        data: request.toJson(),
        options: Options(
          headers: {
            "authorization": "Bearer $token",
          },
        ),
      );

      return LikePostResponse.fromJson(response.data);
    } on DioException catch (error) {
      throw DioExceptionHandler.fromDioError(error, context);
    }
  }

  Future<SavePostResponse?> savePostApi(
      SaveRequest request, context, String id) async {
    try {
      final loginResponse = await SessionHelper().getLoginResponse();
      String? token = loginResponse?.data?.token;
      print('Token ::: $token');
      if (token == null || token.isEmpty) {
        throw Exception("Token not found");
      }

      final response = await dio.postbycustom(
        context,
        '${ApiConstant.savePostUrl}$id',
        data: request.toJson(),
        options: Options(
          headers: {
            "authorization": "Bearer $token",
          },
        ),
      );

      return SavePostResponse.fromJson(response.data);
    } on DioException catch (error) {
      throw DioExceptionHandler.fromDioError(error, context);
    }
  }

  Future<AddCommentResponse?> addCommentApi(
      AddCommentRequest request, context, String id) async {
    try {
      final loginResponse = await SessionHelper().getLoginResponse();
      String? token = loginResponse?.data?.token;
      print('Token ::: $token');
      if (token == null || token.isEmpty) {
        throw Exception("Token not found");
      }

      final response = await dio.postbycustom(
        context,
        '${ApiConstant.addCommentUrl}$id',
        data: request.toJson(),
        options: Options(
          headers: {
            "authorization": "Bearer $token",
          },
        ),
      );

      return AddCommentResponse.fromJson(response.data);
    } on DioException catch (error) {
      throw DioExceptionHandler.fromDioError(error, context);
    }
  }

  Future<EditCommentResponse?> editCommentApi(
      EditCommentRequest request, context, String id) async {
    try {
      final loginResponse = await SessionHelper().getLoginResponse();
      String? token = loginResponse?.data?.token;
      print('Token ::: $token');
      if (token == null || token.isEmpty) {
        throw Exception("Token not found");
      }

      final response = await dio.postbycustom(
        context,
        '${ApiConstant.updateCommentUrl}$id',
        data: request.toJson(),
        options: Options(
          headers: {
            "authorization": "Bearer $token",
          },
        ),
      );

      return EditCommentResponse.fromJson(response.data);
    } on DioException catch (error) {
      throw DioExceptionHandler.fromDioError(error, context);
    }
  }

  Future<DeleteCommentResponse?> deleteCommentApi(
      DeleteCommentRequest request, context, String id) async {
    try {
      final loginResponse = await SessionHelper().getLoginResponse();
      String? token = loginResponse?.data?.token;
      print('Token ::: $token');
      if (token == null || token.isEmpty) {
        throw Exception("Token not found");
      }

      final response = await dio.deletebycustom(
        context,
        '${ApiConstant.deleteCommentUrl}$id',
        data: request.toJson(),
        options: Options(
          headers: {
            "authorization": "Bearer $token",
          },
        ),
      );

      return DeleteCommentResponse.fromJson(response.data);
    } on DioException catch (error) {
      throw DioExceptionHandler.fromDioError(error, context);
    }
  }

  Future<StoryListingResponse?> storyListing(
    StoryListingRequest request,
    context,
  ) async {
    try {
      // ProgressBar.showProgressBarApi(context);

      final loginResponse = await SessionHelper().getLoginResponse();
      String? token = loginResponse?.data?.token;
      print('Token ::: $token');
      if (token == null || token.isEmpty) {
        throw Exception("Token not found");
      }

      final response = await dio.postbycustom(
        context,
        '${ApiConstant.storyListUrl}',
        data: request.toJson(),
        options: Options(
          headers: {
            "authorization": "Bearer $token",
          },
        ),
      );

      return StoryListingResponse.fromJson(response.data);
    } on DioException catch (error) {
      throw DioExceptionHandler.fromDioError(error, context);
    } finally {
      // ✅ Always hide progress bar (success or error)
      // ProgressBar.hideProgressBar(context);
    }
  }

  Future<AddStoryResponse?> addStoryApi(
    AddStoryRequest request,
    context,
  ) async {
    try {
      // ProgressBar.showProgressBarApi(context);

      final loginResponse = await SessionHelper().getLoginResponse();
      String? token = loginResponse?.data?.token;
      print('Token ::: $token');
      if (token == null || token.isEmpty) {
        throw Exception("Token not found");
      }

      final response = await dio.postbycustom(
        context,
        '${ApiConstant.addStoryUrl}',
        data: request.toJson(),
        options: Options(
          headers: {
            "authorization": "Bearer $token",
          },
        ),
      );

      return AddStoryResponse.fromJson(response.data);
    } on DioException catch (error) {
      throw DioExceptionHandler.fromDioError(error, context);
    } finally {
      // ✅ Always hide progress bar (success or error)
      // ProgressBar.hideProgressBar(context);
    }
  }

  Future<UpdateStudentDetailsResponse?> updateStudentDetails(
      UpdateStudentDetailsRequest request, context, String slug) async {
    try {
      // ProgressBar.showProgressBarApi(context);

      final loginResponse = await SessionHelper().getLoginResponse();
      String? token = loginResponse?.data?.token;
      print('Token ::: $token');
      if (token == null || token.isEmpty) {
        throw Exception("Token not found");
      }

      final response = await dio.postbycustom(
        context,
        '${ApiConstant.updateStudentUrl}$slug',
        data: request.toJson(),
        options: Options(
          headers: {
            "authorization": "Bearer $token",
          },
        ),
      );

      return UpdateStudentDetailsResponse.fromJson(response.data);
    } on DioException catch (error) {
      throw DioExceptionHandler.fromDioError(error, context);
    } finally {
      // ✅ Always hide progress bar (success or error)
      // ProgressBar.hideProgressBar(context);
    }
  }

  Future<FeesDetailsResponse?> feesDetails(
      FeesDetailsRequest request, context, String id) async {
    try {
      // ProgressBar.showProgressBarApi(context);

      final loginResponse = await SessionHelper().getLoginResponse();
      String? token = loginResponse?.data?.token;
      print('Token ::: $token');
      if (token == null || token.isEmpty) {
        throw Exception("Token not found");
      }

      final response = await dio.postbycustom(
        context,
        '${ApiConstant.feesDetailsUrl}$id',
        data: request.toJson(),
        options: Options(
          headers: {
            "authorization": "Bearer $token",
          },
        ),
      );

      return FeesDetailsResponse.fromJson(response.data);
    } on DioException catch (error) {
      throw DioExceptionHandler.fromDioError(error, context);
    } finally {
      // ✅ Always hide progress bar (success or error)
      // ProgressBar.hideProgressBar(context);
    }
  }

  Future<GalleryDetailsResponse?> galleryDetails(
      FeesDetailsRequest request, context, String id) async {
    try {
      // ProgressBar.showProgressBarApi(context);

      final loginResponse = await SessionHelper().getLoginResponse();
      String? token = loginResponse?.data?.token;
      print('Token ::: $token');
      if (token == null || token.isEmpty) {
        throw Exception("Token not found");
      }

      final response = await dio.postbycustom(
        context,
        '${ApiConstant.galleryListUrl}$id',
        data: request.toJson(),
        options: Options(
          headers: {
            "authorization": "Bearer $token",
          },
        ),
      );

      return GalleryDetailsResponse.fromJson(response.data);
    } on DioException catch (error) {
      throw DioExceptionHandler.fromDioError(error, context);
    } finally {
      // ✅ Always hide progress bar (success or error)
      // ProgressBar.hideProgressBar(context);
    }
  }

  // Future<ParentListingResponse?> parentListing(
  //     ParentListingRequest request,
  //     context,
  //     ) async {
  //   try {
  //     ProgressBar.showProgressBarApi(context);
  //
  //     final loginResponse = await SessionHelper().getLoginResponse();
  //     String? token = loginResponse?.data?.token;
  //     print('Token ::: $token');
  //     if (token == null || token.isEmpty) {
  //       throw Exception("Token not found");
  //     }
  //
  //     final response = await dio.postbycustom(
  //       context,
  //       '${ApiConstant.parentListUrl}',
  //       data: request.toJson(),
  //       options: Options(
  //         headers: {
  //           "authorization": "Bearer $token",
  //         },
  //       ),
  //     );
  //
  //     return ParentListingResponse.fromJson(response.data);
  //   } on DioException catch (error) {
  //     throw DioExceptionHandler.fromDioError(error, context);
  //   } finally {
  //     // ✅ Always hide progress bar (success or error)
  //     ProgressBar.hideProgressBar(context);
  //   }
  // }
  Future<TeacherListingResponse?> teacherListing(
    ParentListingRequest request,
    context,
  ) async {
    try {
      // ProgressBar.showProgressBarApi(context);

      final loginResponse = await SessionHelper().getLoginResponse();
      String? token = loginResponse?.data?.token;
      print('Token ::: $token');
      if (token == null || token.isEmpty) {
        throw Exception("Token not found");
      }

      final response = await dio.postbycustom(
        context,
        '${ApiConstant.teacherListUrl}',
        data: request.toJson(),
        options: Options(
          headers: {
            "authorization": "Bearer $token",
          },
        ),
      );

      return TeacherListingResponse.fromJson(response.data);
    } on DioException catch (error) {
      throw DioExceptionHandler.fromDioError(error, context);
    } finally {
      // ✅ Always hide progress bar (success or error)
      // ProgressBar.hideProgressBar(context);
    }
  }

  Future<ForgotPasswordResponse?> forgotPassword(
    ForgotPasswordRequest request,
    context,
  ) async {
    try {
      // ProgressBar.showProgressBarApi(context);

      final loginResponse = await SessionHelper().getLoginResponse();
      String? token = loginResponse?.data?.token;
      print('Token ::: $token');
      final response = await dio.postbycustom(
        context,
        '${ApiConstant.forgotPasswordUrl}',
        data: request.toJson(),
      );

      return ForgotPasswordResponse.fromJson(response.data);
    } on DioException catch (error) {
      throw DioExceptionHandler.fromDioError(error, context);
    } finally {
      // ✅ Always hide progress bar (success or error)
      // ProgressBar.hideProgressBar(context);
    }
  }

  Future<OtpVerifyResponse?> verifyOtpRequest(
    VerifyOtpRequest request,
    context,
  ) async {
    try {
      // ProgressBar.showProgressBarApi(context);

      final response = await dio.postbycustom(
        context,
        '${ApiConstant.verifyOtpUrl}',
        data: request.toJson(),
      );

      return OtpVerifyResponse.fromJson(response.data);
    } on DioException catch (error) {
      throw DioExceptionHandler.fromDioError(error, context);
    } finally {
      // ✅ Always hide progress bar (success or error)
      // ProgressBar.hideProgressBar(context);
    }
  }

  Future<MoodUpdateResponse?> moodUpdateApi(
      MoodUpdateRequest request, context, String id) async {
    try {
      // ProgressBar.showProgressBarApi(context);
      final loginResponse = await SessionHelper().getLoginResponse();
      String? token = loginResponse?.data?.token;
      print('Token ::: $token');
      print('request ::: ${request.toJson()}');
      final response = await dio.postbycustom(
        context,
        '${ApiConstant.moodUpdateUrl}$id',
        data: request.toJson(),
        options: Options(
          headers: {
            "authorization": "Bearer $token",
          },
        ),
      );

      return MoodUpdateResponse.fromJson(response.data);
    } on DioException catch (error) {
      throw DioExceptionHandler.fromDioError(error, context);
    } finally {
      // ✅ Always hide progress bar (success or error)
      // ProgressBar.hideProgressBar(context);
    }
  }

  Future<TeacherChatParentListingResponse?> parentListing(
    TeacherChatParentListingRequest request,
    context,
  ) async {
    try {
      // ProgressBar.showProgressBarApi(context);

      final loginResponse = await SessionHelper().getLoginResponse();
      String? token = loginResponse?.data?.token;
      print('Token ::: $token');
      if (token == null || token.isEmpty) {
        throw Exception("Token not found");
      }

      final response = await dio.postbycustom(
        context,
        '${ApiConstant.parentListingUrl}',
        data: request.toJson(),
        options: Options(
          headers: {
            "authorization": "Bearer $token",
          },
        ),
      );

      return TeacherChatParentListingResponse.fromJson(response.data);
    } on DioException catch (error) {
      throw DioExceptionHandler.fromDioError(error, context);
    } finally {
      // ✅ Always hide progress bar (success or error)
      // ProgressBar.hideProgressBar(context);
    }
  }

  Future<CreateChatResponse?> createChatApi(
    CreateChatRequest request,
    context,
  ) async {
    try {
      // ProgressBar.showProgressBarApi(context);

      final loginResponse = await SessionHelper().getLoginResponse();
      String? token = loginResponse?.data?.token;
      print('Token ::: $token');
      if (token == null || token.isEmpty) {
        throw Exception("Token not found");
      }

      final response = await dio.postbycustom(
        context,
        '${ApiConstant.createChatUrl}',
        data: request.toJson(),
        options: Options(
          headers: {
            "authorization": "Bearer $token",
          },
        ),
      );

      return CreateChatResponse.fromJson(response.data);
    } on DioException catch (error) {
      throw DioExceptionHandler.fromDioError(error, context);
    } finally {
      // ✅ Always hide progress bar (success or error)
      // ProgressBar.hideProgressBar(context);
    }
  }

  Future<TeacherGroupUserListingResponse?> teacherGroupUserListing(
    TeacherGroupUserListingRequest request,
    context,
  ) async {
    try {
      // ProgressBar.showProgressBarApi(context);

      final loginResponse = await SessionHelper().getLoginResponse();
      String? token = loginResponse?.data?.token;
      print('Token ::: $token');
      if (token == null || token.isEmpty) {
        throw Exception("Token not found");
      }

      final response = await dio.postbycustom(
        context,
        '${ApiConstant.teacherGroupUserList}',
        data: request.toJson(),
        options: Options(
          headers: {
            "authorization": "Bearer $token",
          },
        ),
      );

      return TeacherGroupUserListingResponse.fromJson(response.data);
    } on DioException catch (error) {
      throw DioExceptionHandler.fromDioError(error, context);
    } finally {
      // ✅ Always hide progress bar (success or error)
      // ProgressBar.hideProgressBar(context);
    }
  }

  Future<ParentGroupUserListingResponse?> parentGroupUserListing(
    TeacherGroupUserListingRequest request,
    context,
  ) async {
    try {
      // ProgressBar.showProgressBarApi(context);

      final loginResponse = await SessionHelper().getLoginResponse();
      String? token = loginResponse?.data?.token;
      print('Token ::: $token');
      if (token == null || token.isEmpty) {
        throw Exception("Token not found");
      }

      final response = await dio.postbycustom(
        context,
        '${ApiConstant.parentGroupUserList}',
        data: request.toJson(),
        options: Options(
          headers: {
            "authorization": "Bearer $token",
          },
        ),
      );

      return ParentGroupUserListingResponse.fromJson(response.data);
    } on DioException catch (error) {
      throw DioExceptionHandler.fromDioError(error, context);
    } finally {
      // ✅ Always hide progress bar (success or error)
      // ProgressBar.hideProgressBar(context);
    }
  }

  Future<StoryViewResponse?> storyView(context, storyId) async {
    try {
      // ProgressBar.showProgressBarApi(context);

      final loginResponse = await SessionHelper().getLoginResponse();
      String? token = loginResponse?.data?.token;
      print('Token ::: $token');
      if (token == null || token.isEmpty) {
        throw Exception("Token not found");
      }

      final response = await dio.postbycustom(
        context,
        '${ApiConstant.storyViewApi}$storyId',
        data: {
          'lang': LanguageController.to.apiLanguage,
        },
        options: Options(
          headers: {
            "authorization": "Bearer $token",
          },
        ),
      );

      return StoryViewResponse.fromJson(response.data);
    } on DioException catch (error) {
      throw DioExceptionHandler.fromDioError(error, context);
    } finally {
      // ✅ Always hide progress bar (success or error)
      // ProgressBar.hideProgressBar(context);
    }
  }

  Future<StoryListViewResponse?> storyUserListView(context, storyId) async {
    try {
      // ProgressBar.showProgressBarApi(context);

      final loginResponse = await SessionHelper().getLoginResponse();
      String? token = loginResponse?.data?.token;
      print('Token ::: $token');
      if (token == null || token.isEmpty) {
        throw Exception("Token not found");
      }

      final response = await dio.postbycustom(
        context,
        '${ApiConstant.storyViewListApi}$storyId',
        data: {
          'lang': LanguageController.to.apiLanguage,
        },
        options: Options(
          headers: {
            "authorization": "Bearer $token",
          },
        ),
      );

      return StoryListViewResponse.fromJson(response.data);
    } on DioException catch (error) {
      throw DioExceptionHandler.fromDioError(error, context);
    } finally {
      // ✅ Always hide progress bar (success or error)
      // ProgressBar.hideProgressBar(context);
    }
  }

  Future<StoryLikeResponse?> storyLike(
      context, storyId, StoryLikeRequest request) async {
    try {
      // ProgressBar.showProgressBarApi(context);

      final loginResponse = await SessionHelper().getLoginResponse();
      String? token = loginResponse?.data?.token;
      print('Token ::: $token');
      if (token == null || token.isEmpty) {
        throw Exception("Token not found");
      }

      final response = await dio.postbycustom(
        context,
        '${ApiConstant.storyLikeListApi}$storyId',
        data: request.toJson(),
        options: Options(
          headers: {
            "authorization": "Bearer $token",
          },
        ),
      );

      return StoryLikeResponse.fromJson(response.data);
    } on DioException catch (error) {
      throw DioExceptionHandler.fromDioError(error, context);
    } finally {
      // ✅ Always hide progress bar (success or error)
      // ProgressBar.hideProgressBar(context);
    }
  }

  Future<ReplyCommentResponse?> replyComment(
      context, commentId, ReplyCommentRequest request) async {
    try {
      // ProgressBar.showProgressBarApi(context);

      final loginResponse = await SessionHelper().getLoginResponse();
      String? token = loginResponse?.data?.token;
      print('Token ::: $token');
      if (token == null || token.isEmpty) {
        throw Exception("Token not found");
      }

      final response = await dio.postbycustom(
        context,
        '${ApiConstant.replyCommentApi}$commentId',
        data: request.toJson(),
        options: Options(
          headers: {
            "authorization": "Bearer $token",
          },
        ),
      );

      return ReplyCommentResponse.fromJson(response.data);
    } on DioException catch (error) {
      throw DioExceptionHandler.fromDioError(error, context);
    } finally {
      // ✅ Always hide progress bar (success or error)
      // ProgressBar.hideProgressBar(context);
    }
  }

  Future<NotificationListResponse?> notificationList(
    context, {
    int page = 1,
    int limit = 50,
  }) async {
    try {
      final loginResponse = await SessionHelper().getLoginResponse();
      String? token = loginResponse?.data?.token;
      print('Token ::: $token');
      if (token == null || token.isEmpty) {
        throw Exception("Token not found");
      }

      final response = await dio.postbycustom(
        context,
        '${ApiConstant.notificationListApi}',
        data: {
          "lang": LanguageController.to.apiLanguage,
          "page": page,
          "limit": limit,
        },
        options: Options(
          headers: {
            "authorization": "Bearer $token",
          },
        ),
      );

      return NotificationListResponse.fromJson(response.data);
    } on DioException catch (error) {
      throw DioExceptionHandler.fromDioError(error, context);
    }
  }

  Future<void> markNotificationRead(
    context, {
    required String id,
    required bool isRead,
  }) async {
    final loginResponse = await SessionHelper().getLoginResponse();
    final token = loginResponse?.data?.token;
    if (token == null || token.isEmpty) return;

    await dio.postbycustom(
      context,
      ApiConstant.notificationMarkAsReadApi,
      data: {
        "id": id,
        "isRead": isRead,
        "lang": LanguageController.to.apiLanguage,
      },
      options: Options(
        headers: {
          "authorization": "Bearer $token",
        },
      ),
    );
  }

  Future<void> markAllNotificationsRead(context) async {
    final loginResponse = await SessionHelper().getLoginResponse();
    final token = loginResponse?.data?.token;
    if (token == null || token.isEmpty) return;

    await dio.postbycustom(
      context,
      ApiConstant.notificationMarkAllReadApi,
      data: {
        "isRead": true,
        "lang": LanguageController.to.apiLanguage,
      },
      options: Options(
        headers: {
          "authorization": "Bearer $token",
        },
      ),
    );
  }

  Future<void> updateFcmToken(String fcmToken, context) async {
    try {
      final loginResponse = await SessionHelper().getLoginResponse();
      final token = loginResponse?.data?.token;
      if (token == null || token.isEmpty) return;

      await dio.postbycustom(
        context,
        ApiConstant.updateFcmTokenUrl,
        data: {
          "fcmToken": fcmToken,
          "lang": LanguageController.to.apiLanguage,
        },
        options: Options(
          headers: {
            "authorization": "Bearer $token",
          },
        ),
      );
    } catch (e) {
      print("Update FCM token error: $e");
    }
  }

  Future<LikeListingResponse?> likeListing(
    LikeListingRequest request,
    String postSlug,
    context,
  ) async {
    try {
      final loginResponse = await SessionHelper().getLoginResponse();
      String? token = loginResponse?.data?.token;
      print('Token ::: $token');
      if (token == null || token.isEmpty) {
        throw Exception("Token not found");
      }

      final response = await dio.postbycustom(
        context,
        '${ApiConstant.likeListApi}$postSlug',
        data: request.toJson(),
        options: Options(
          headers: {
            "authorization": "Bearer $token",
          },
        ),
      );

      return LikeListingResponse.fromJson(response.data);
    } on DioException catch (error) {
      throw DioExceptionHandler.fromDioError(error, context);
    } finally {
      // ✅ Always hide progress bar (success or error)
    }
  }

  Future<DeletePostResponse?> deletePostApi(
    DeletePostRequest request,
    context,
    String postSlug,
  ) async {
    try {
      final loginResponse = await SessionHelper().getLoginResponse();
      String? token = loginResponse?.data?.token;
      print('Token ::: $token');
      if (token == null || token.isEmpty) {
        throw Exception("Token not found");
      }

      final response = await dio.deletebycustom(
        context,
        '${ApiConstant.deletePostUrl}$postSlug',
        data: request.toJson(),
        options: Options(
          headers: {
            "authorization": "Bearer $token",
          },
        ),
      );

      return DeletePostResponse.fromJson(response.data);
    } on DioException catch (error) {
      throw DioExceptionHandler.fromDioError(error, context);
    } finally {
      // ✅ Always hide progress bar (success or error)
    }
  }

  Future<DeleteStoryResponse?> deleteStoryApi(
    DeleteStoryRequest request,
    context,
    String storyId,
  ) async {
    try {
      final loginResponse = await SessionHelper().getLoginResponse();
      String? token = loginResponse?.data?.token;
      print('Token ::: $token');
      if (token == null || token.isEmpty) {
        throw Exception("Token not found");
      }

      final response = await dio.deletebycustom(
        context,
        '${ApiConstant.deleteStoryUrl}$storyId',
        data: request.toJson(),
        options: Options(
          headers: {
            "authorization": "Bearer $token",
          },
        ),
      );

      return DeleteStoryResponse.fromJson(response.data);
    } on DioException catch (error) {
      throw DioExceptionHandler.fromDioError(error, context);
    } finally {
      // ✅ Always hide progress bar (success or error)
    }
  }

  Future<AddStudentLeaveResponse?> addStudentLeave(
    AddStudentLeaveRequest request,
    String postSlug,
    context,
  ) async {
    try {
      final loginResponse = await SessionHelper().getLoginResponse();
      String? token = loginResponse?.data?.token;
      print('Token ::: $token');
      if (token == null || token.isEmpty) {
        throw Exception("Token not found");
      }

      final response = await dio.postbycustom(
        context,
        ApiConstant.addStudentLeave,
        data: request.toJson(),
        options: Options(
          headers: {
            "authorization": "Bearer $token",
          },
        ),
      );

      return AddStudentLeaveResponse.fromJson(response.data);
    } on DioException catch (error) {
      throw DioExceptionHandler.fromDioError(error, context);
    } finally {
      // ✅ Always hide progress bar (success or error)
    }
  }

  Future<StudentLeaveListingResponse?> studentLeaveListing(
    StudentLeaveListingRequest request,
    String postSlug,
    context,
  ) async {
    try {
      final loginResponse = await SessionHelper().getLoginResponse();
      String? token = loginResponse?.data?.token;
      print('Token ::: $token');
      if (token == null || token.isEmpty) {
        throw Exception("Token not found");
      }

      final response = await dio.postbycustom(
        context,
        ApiConstant.studentLeaveList,
        data: request.toJson(),
        options: Options(
          headers: {
            "authorization": "Bearer $token",
          },
        ),
      );

      return StudentLeaveListingResponse.fromJson(response.data);
    } on DioException catch (error) {
      throw DioExceptionHandler.fromDioError(error, context);
    } finally {
      // ✅ Always hide progress bar (success or error)
    }
  }

  Future<bool> updateMealApi(
      MealRequest request, context, String mealId) async {
    return _postReportSuccess(
      context,
      '${ApiConstant.updateMealUrl}$mealId',
      request.toJson(),
    );
  }

  Future<bool> deleteMealApi(context, String mealId, {String? lang}) async {
    return _postReportSuccess(
      context,
      '${ApiConstant.deleteMealUrl}$mealId',
      {'lang': lang ?? LanguageController.to.apiLanguage},
    );
  }

  Future<bool> updateNapApi(
      AddNapRequest request, context, String napId) async {
    return _postReportSuccess(
      context,
      '${ApiConstant.updateNapUrl}$napId',
      request.toJson(),
    );
  }

  Future<bool> deleteNapApi(context, String napId, {String? lang}) async {
    return _postReportSuccess(
      context,
      '${ApiConstant.deleteNapUrl}$napId',
      {'lang': lang ?? LanguageController.to.apiLanguage},
    );
  }

  Future<bool> updateHygieneApi(
      AddHygieneRequest request, context, String hygieneId) async {
    return _postReportSuccess(
      context,
      '${ApiConstant.updateHygieneUrl}$hygieneId',
      request.toJson(),
    );
  }

  Future<bool> deleteHygieneApi(context, String hygieneId, {String? lang}) async {
    return _postReportSuccess(
      context,
      '${ApiConstant.deleteHygieneUrl}$hygieneId',
      {'lang': lang ?? LanguageController.to.apiLanguage},
    );
  }

  Future<bool> _postReportSuccess(
    context,
    String path,
    Map<String, dynamic> data,
  ) async {
    try {
      final loginResponse = await SessionHelper().getLoginResponse();
      final token = loginResponse?.data?.token;
      if (token == null || token.isEmpty) {
        throw Exception("Token not found");
      }

      final response = await dio.postbycustom(
        context,
        path,
        data: data,
        options: Options(
          headers: {
            "authorization": "Bearer $token",
          },
        ),
      );

      final body = response.data;
      return body is Map && body['success'] == true;
    } on DioException catch (error) {
      throw DioExceptionHandler.fromDioError(error, context);
    }
  }
}
