import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';
import '../../../../../../../service/api_service/api_worker.dart';
import '../../../../../../../translation/language_controller.dart';
import '../../../../../../../widget/common_toastification.dart';
import '../../home/view/add_post/mode/list_student_by_class/list_student_by_class_request.dart';
import '../../home/view/add_post/mode/list_student_by_class/list_student_by_class_response.dart';
import '../../profile/model/get_all_class/get_all_class_request.dart';
import '../../profile/model/get_all_class/get_all_class_response.dart';
import '../model/student_by_slug/student_by_slug_request.dart';
import '../model/student_by_slug/student_by_slug_response.dart';

class TeacherKidsController extends GetxController {
  final ApiWorker apiWorker = Get.put(ApiWorker());

  void clearKidsScreenData() {
    selectedClass.value = null;
    classList.clear();
    studentList.clear();
    selectedStudents.clear();
    studentDetails.value = null;
    searchController.clear();
  }

  Rxn<Class> selectedClass = Rxn<Class>();

  RxBool isClassLoading = false.obs;
  RxList<Class> classList = <Class>[].obs;

  // ================= CLASS =================
  Future<void> fetchClasses(BuildContext context) async {
    try {
      isClassLoading.value = true;

      final response = await apiWorker.getAllClassApi(
        GetAllClassRequest(page: 1, limit: 100, lang: LanguageController.to.apiLanguage),
        context,
      );

      if (response?.success == true) {
        classList.assignAll(response?.data?.classes ?? []);
      }
    } finally {
      isClassLoading.value = false;
    }
  }

  void selectClass(Class item) {
    selectedClass.value = item;
  }

  RxBool isStudentLoading = false.obs;
  RxList<StudentData> studentList = <StudentData>[].obs;
  RxList<StudentData> selectedStudents = <StudentData>[].obs;
TextEditingController searchController = TextEditingController();
  Future<void> fetchStudentsByClass(BuildContext context) async {
    studentList.clear();
    if (selectedClass.value == null) {
      showToast(
        context,
        "Error",
        "Please select class first",
        type: ToastificationType.error,
      );
      return;
    }

    try {
      isStudentLoading.value = true;

      final response = await apiWorker.listStudentByClassApi(
        ListStudentByClassRequest(page: 1, limit: 100, lang: LanguageController.to.apiLanguage,search:searchController.text ),
        context,
        selectedClass.value!.slug ?? "",
      );

      if (response?.success == true) {
        studentList.assignAll(response?.data?.students ?? []);
      } else {
        print(response?.message);
      }
    } catch (e) {
      print(e);
    } finally {
      isStudentLoading.value = false;
    }
  }
  RxBool isStudentDetailsLoading = false.obs;
  Rxn<StudentDataGetBySlug> studentDetails = Rxn<StudentDataGetBySlug>();
  Future<void> fetchStudentsBySlug(BuildContext context, String slug) async {
    try {
      isStudentDetailsLoading.value = true;

      final response = await apiWorker.studentBySlug(
        StudentBySlugRequest(lang: LanguageController.to.apiLanguage),
        context,
        slug,
      );

      if (response?.success == true) {
        studentDetails.value = response?.data;
      } else {
        print(response?.message);
      }
    } catch (e) {
      print(e);
    } finally {
      isStudentDetailsLoading.value = false;
    }
  }

  @override
  void onClose() {
    searchController.clear();
    super.onClose();
  }
}
