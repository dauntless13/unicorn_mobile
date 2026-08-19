import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toastification/toastification.dart';

import '../../../../../../../../../service/api_service/api_worker.dart';
import '../../../../../../../../../translation/language_controller.dart';
import '../../../../../../../../../widget/common_toastification.dart';
import '../../../../profile/model/get_all_class/get_all_class_request.dart';
import '../../../../profile/model/get_all_class/get_all_class_response.dart';
import '../mode/add_post/add_post_request.dart';
import '../mode/list_student_by_class/list_student_by_class_request.dart';
import '../mode/list_student_by_class/list_student_by_class_response.dart';
import '../mode/upload_images/upload_images_request.dart';
import '../mode/upload_video/upload_video_request.dart';

class AddPostController extends GetxController {
  final ApiWorker apiWorker = Get.put(ApiWorker());

  final ImagePicker _picker = ImagePicker();

  RxList<File> selectedMedia = <File>[].obs;
  RxList<bool> mediaIsVideo = <bool>[].obs;
  RxString selectedMediaType = 'IMAGE'.obs;
  RxBool isVideo = false.obs;
  RxBool isLoading = false.obs;

  // ================= PICK IMAGE =================
  Future<void> pickImage() async {
    final List<XFile>? files = await _picker.pickMultiImage();

    if (files != null && files.isNotEmpty) {
      clearMedia();
      selectedMediaType.value = "IMAGE";
      for (var file in files) {
        selectedMedia.add(File(file.path));
        mediaIsVideo.add(false);
      }
    }
  }

  Future<void> captureImageFromCamera() async {
    final XFile? file = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );

    if (file != null) {
      clearMedia();
      selectedMediaType.value = "IMAGE";
      selectedMedia.add(File(file.path));
      mediaIsVideo.add(false);
    }
  }

  // ================= PICK VIDEO =================
  Future<void> pickVideo() async {
    final XFile? file = await _picker.pickVideo(source: ImageSource.gallery);

    if (file != null) {
      clearMedia();
      selectedMediaType.value = "VIDEO";
      selectedMedia.add(File(file.path));
      mediaIsVideo.add(true);
    }
  }

  Future<void> captureVideoFromCamera() async {
    final XFile? file = await _picker.pickVideo(
      source: ImageSource.camera,
    );

    if (file != null) {
      clearMedia();
      selectedMediaType.value = "VIDEO";
      selectedMedia.add(File(file.path));
      mediaIsVideo.add(true);
    }
  }

  Future<void> pickPdf() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['pdf'],
      allowMultiple: false,
    );

    if (result == null || result.files.isEmpty) return;

    final pickedFile = result.files.single;
    if (pickedFile.path == null || pickedFile.path!.isEmpty) return;

    clearMedia();
    selectedMediaType.value = "PDF";
    selectedMedia.add(File(pickedFile.path!));
    mediaIsVideo.add(false);
  }

  void clearMedia() {
    selectedMedia.clear();
    mediaIsVideo.clear();
    selectedMediaType.value = 'IMAGE';
  }

  String getPostType(String postTypeLabel) {
    if (postTypeLabel == 'announcements'.tr) return "ANNOUNCEMENT";
    if (postTypeLabel == 'video'.tr) return "VIDEO";
    if (postTypeLabel == 'PDF') return "PDF";

    switch (selectedMediaType.value) {
      case "VIDEO":
        return "VIDEO";
      case "PDF":
        return "PDF";
      default:
        return "PHOTO";
    }
  }

  String getPublishType(String publishTypeLabel) {
    return publishTypeIsPrivate(publishTypeLabel) ? "private" : "public";
  }

  bool publishTypeIsPrivate(String publishTypeLabel) {
    return publishTypeLabel == 'private'.tr;
  }

  final TextEditingController descriptionCtrl = TextEditingController();

  // ================= SUBMIT POST =================
  Future<void> uploadMedia(
    context,
    String publishTypeLabel,
    String postTypeLabel,
  ) async {
    if (selectedClass.value == null) {
      showToast(
        context,
        "Error",
        "Please select class",
        type: ToastificationType.error,
      );
      return;
    }

    /*if (selectedMedia.isEmpty) {
      showToast(
        context,
        "Error",
        "Please select media",
        type: ToastificationType.error,
      );
      return;
    }*/
    if (descriptionCtrl.text.isEmpty) {
      showToast(
        context,
        "Error",
        "Please enter description",
        type: ToastificationType.error,
      );
      return;
    }
    if (publishTypeIsPrivate(publishTypeLabel) && selectedStudents.isEmpty) {
      showToast(
        context,
        "Error",
        "Please select students",
        type: ToastificationType.error,
      );
      return;
    }

    try {
      isLoading.value = true;

      /// ================== STEP 1: Upload Media ==================
//       final uploadRequest = UploadImagesRequest(
//         images: selectedMedia,
//         lang: "EN",
//       );
// print(uploadRequest.images);
//       final uploadResponse =
//           await apiWorker.uploadFileApi(uploadRequest, Get.context);
//
//       if (uploadResponse?.success != true) {
//         showToast(
//           context,
//           "Error",
//           uploadResponse?.message ?? "Upload failed",
//           type: ToastificationType.error,
//         );
//         return;
//       }
//
//       /// Get uploaded media URL
//       final mediaUrls = uploadResponse?.data?.images
//               ?.map((e) => e.imageUrl ?? "")
//               .where((url) => url.isNotEmpty)
//               .toList() ??
//           [];
      /// ================== STEP 1: Upload Media ==================
      List<String> mediaUrls = [];

      if (selectedMedia.isNotEmpty) {
        if (selectedMediaType.value == "VIDEO") {
          // VIDEO UPLOAD
          final videoRequest = UploadVideoRequest(
            videos: selectedMedia,
            lang: LanguageController.to.apiLanguage,
          );

          final videoResponse =
              await apiWorker.videoUpload(videoRequest, context);

          if (videoResponse?.success != true) {
            showToast(
              context,
              "Error",
              videoResponse?.message ?? "Video upload failed",
              type: ToastificationType.error,
            );
            return;
          }

          mediaUrls = videoResponse?.data?.videos
                  ?.map((e) => e.videoUrl ?? "")
                  .where((url) => url.isNotEmpty)
                  .toList() ??
              [];
        } else {
          // IMAGE/PDF UPLOAD
          final uploadRequest = UploadImagesRequest(
            images: selectedMedia,
            lang: LanguageController.to.apiLanguage,
          );

          final uploadResponse =
              await apiWorker.uploadFileApi(uploadRequest, context);

          if (uploadResponse?.success != true) {
            showToast(
              context,
              "Error",
              uploadResponse?.message ?? "Upload failed",
              type: ToastificationType.error,
            );
            return;
          }

          mediaUrls = uploadResponse?.data?.images
                  ?.map((e) => e.imageUrl ?? "")
                  .where((url) => url.isNotEmpty)
                  .toList() ??
              [];
        }
      }

      /// ================== STEP 2: Create Post Request ==================
      final addPostRequest = AddPostRequest(
        lang: LanguageController.to.apiLanguage,
        type: getPostType(postTypeLabel),
        // PHOTO / VIDEO / ANNOUNCEMENT
        classSlug: selectedClass.value?.slug,
        publishType: getPublishType(publishTypeLabel),
        // public / private
        studentSlugs: selectedStudents
            .map((e) => e.slug ?? "")
            .where((slug) => slug.isNotEmpty)
            .toList(),
        mediaType: selectedMediaType.value,
        mediaUrls: mediaUrls,
        description:
            descriptionCtrl.text, // you can pass description from screen
      );

      /// ================== STEP 3: Call Add Post API ==================
      final response = await apiWorker.addPost(
        addPostRequest,
        Get.context,
        selectedClass.value?.slug ?? "",
      );
      if (response?.success == true) {
        showToast(
          context,
          "Success",
          "Post added successfully",
          type: ToastificationType.success,
        );

        clearMedia();
        selectedStudents.clear();
        Get.back(result: true);
      } else {
        showToast(
          context,
          "Error",
          response?.message ?? "Failed to add post",
          type: ToastificationType.error,
        );
      }
    } catch (e) {
      showToast(
        context,
        "Error",
        e.toString(),
        type: ToastificationType.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  RxBool isClassLoading = false.obs;
  RxList<Class> classList = <Class>[].obs;
  Rxn<Class> selectedClass = Rxn<Class>();

  // ================= CLASS =================
  Future<void> fetchClasses(BuildContext context) async {
    try {
      isClassLoading.value = true;

      final response = await apiWorker.getAllClassApi(
        GetAllClassRequest(
            page: 1, limit: 100, lang: LanguageController.to.apiLanguage),
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
    // If same class, do nothing
    if (selectedClass.value?.slug == item.slug) return;

    selectedClass.value = item;

    // 🔥 IMPORTANT: clear previous student selection
    selectedStudents.clear();
    studentList.clear(); // optional (recommended)
  }

  RxBool isStudentLoading = false.obs;
  RxList<StudentData> studentList = <StudentData>[].obs;
  RxList<StudentData> selectedStudents = <StudentData>[].obs;
  TextEditingController searchController = TextEditingController();
  Future<void> fetchStudentsByClass(BuildContext context) async {
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
        ListStudentByClassRequest(
            page: 1,
            limit: 100,
            lang: LanguageController.to.apiLanguage,
            search: searchController.text),
        context,
        selectedClass.value!.slug ?? "",
      );

      if (response?.success == true) {
        studentList.assignAll(response?.data?.students ?? []);
      } else {
        showToast(
          context,
          "Error",
          response?.message ?? "Failed to load students",
          type: ToastificationType.error,
        );
      }
    } catch (e) {
      showToast(
        context,
        "Error",
        e.toString(),
        type: ToastificationType.error,
      );
    } finally {
      isStudentLoading.value = false;
    }
  }

  // void toggleStudent(StudentData student) {
  //   if (selectedStudents.contains(student)) {
  //     selectedStudents.remove(student);
  //   } else {
  //     final alreadySelected =
  //         selectedStudents.any((s) => s.slug == student.slug);
  //     if (!alreadySelected) {
  //       selectedStudents.add(student);
  //     }
  //   }
  // }

  void toggleStudent(StudentData student) {
    final index = selectedStudents.indexWhere((s) => s.slug == student.slug);

    if (index != -1) {
      selectedStudents.removeAt(index); // remove
    } else {
      selectedStudents.add(student); // add
    }
  }

  @override
  void onClose() {
    descriptionCtrl.clear();
    searchController.clear();
    super.onClose();
  }
}
