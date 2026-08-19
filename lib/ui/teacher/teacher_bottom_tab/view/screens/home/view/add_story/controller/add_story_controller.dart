import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toastification/toastification.dart';

import '../../../../../../../../../service/api_service/api_worker.dart';
import '../../../../../../../../../translation/language_controller.dart';
import '../../../../../../../../../widget/common_toastification.dart';
import '../../../model/add_story/add_story_request.dart';
import '../../add_post/mode/upload_images/upload_images_request.dart';
import '../../add_post/mode/upload_video/upload_video_request.dart';

class AddStoryController extends GetxController {
  final ApiWorker apiWorker = Get.put(ApiWorker());
  final ImagePicker _picker = ImagePicker();
  Rx<File?> selectedFile = Rx<File?>(null);
  RxString selectedMediaType = "".obs; // IMAGE or VIDEO
  RxBool isUploading = false.obs;

  /// Pick from camera
  // Future<void> openCamera() async {
  //   final XFile? file = await _picker.pickMedia(
  //     imageQuality: 80,
  //   );
  //
  //   if (file != null) {
  //     selectedFile.value = File(file.path);
  //
  //     if (file.mimeType?.startsWith("video") == true) {
  //       selectedMediaType.value = "VIDEO";
  //     } else {
  //       selectedMediaType.value = "IMAGE";
  //     }
  //   }
  // }
  Future<void> openCamera() async {
    final themeContext = Get.context;
    final light = themeContext == null
        ? true
        : Theme.of(themeContext).brightness == Brightness.light;
    final sheetBg = light ? Colors.white : const Color(0xFF1E1E1E);
    final handleColor = light ? Colors.grey.shade300 : Colors.grey.shade700;
    final titleColor = light ? Colors.grey.shade900 : Colors.white;
    final cancelBg = light ? Colors.grey.shade100 : const Color(0xFF2A2A2A);
    final cancelText = light ? Colors.grey.shade700 : Colors.grey.shade300;

    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: sheetBg,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: handleColor,
                borderRadius: BorderRadius.circular(100),
              ),
            ),

            // Title
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Add Media".tr,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: titleColor,
                  letterSpacing: -0.3,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Take Photo
            _MediaOptionTile(
              icon: Icons.camera_alt_rounded,
              iconColor: const Color(0xFF2563EB),
              iconBg: const Color(0xFFEFF6FF),
              label: "Take Photo".tr,
              subtitle: "Use your camera".tr,
              onTap: () async {
                Get.back();
                final XFile? file = await _picker.pickImage(
                  source: ImageSource.camera,
                  imageQuality: 80,
                );
                if (file != null) {
                  selectedFile.value = File(file.path);
                  selectedMediaType.value = "IMAGE";
                }
              },
            ),

            const SizedBox(height: 10),

            // Record Video
            _MediaOptionTile(
              icon: Icons.videocam_rounded,
              iconColor: const Color(0xFF7C3AED),
              iconBg: const Color(0xFFF5F3FF),
              label: "Record Video".tr,
              subtitle: "Capture a video clip".tr,
              onTap: () async {
                Get.back();
                final XFile? file = await _picker.pickVideo(
                  source: ImageSource.camera,
                );
                if (file != null) {
                  selectedFile.value = File(file.path);
                  selectedMediaType.value = "VIDEO";
                }
              },
            ),

            const SizedBox(height: 16),

            // Cancel
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Get.back(),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: cancelBg,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  "Cancel".tr,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: cancelText,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }
  /// Pick from gallery
  // Future<void> openGallery() async {
  //   final XFile? file = await _picker.pickMedia();
  //
  //   if (file != null) {
  //     selectedFile.value = File(file.path);
  //
  //     if (file.mimeType?.startsWith("video") == true) {
  //       selectedMediaType.value = "VIDEO";
  //     } else {
  //       selectedMediaType.value = "IMAGE";
  //     }
  //   }
  // }
  Future<void> openGallery() async {
    final XFile? file = await _picker.pickMedia();

    if (file == null) return;

    selectedFile.value = File(file.path);

    if (file.path.toLowerCase().endsWith(".mp4") ||
        file.path.toLowerCase().endsWith(".mov") ||
        file.path.toLowerCase().endsWith(".mkv")) {
      selectedMediaType.value = "VIDEO";
    } else {
      selectedMediaType.value = "IMAGE";
    }
  }
  void clear() {
    selectedFile.value = null;
    selectedMediaType.value = "";
  }

  /// 🚀 MAIN FUNCTION → Upload + Add Story
  // Future<void> uploadAndAddStory(BuildContext context) async {
  //   try {
  //     if (selectedFile.value == null) return;
  //
  //     isUploading.value = true;
  //
  //     // 1️⃣ Upload Image First
  //     final uploadRequest = UploadImagesRequest(
  //       images: [selectedFile.value!],
  //       lang: "EN",
  //     );
  //
  //     final uploadResponse =
  //     await apiWorker.uploadFileApi(uploadRequest, context);
  //
  //     if (uploadResponse?.success != true ||
  //         uploadResponse?.data?.images?.isEmpty != false) {
  //       throw Exception("Image upload failed");
  //     }
  //
  //     final String imageUrl =
  //         uploadResponse!.data!.images!.first.imageUrl ?? "";
  //
  //     // 2️⃣ Call Add Story API
  //     final storyRequest = AddStoryRequest(
  //       lang: "EN",
  //       mediaUrl: imageUrl,
  //       mediaType: selectedMediaType.value, // ✅ dynamic
  //       text: "",
  //       ctaText: "",
  //     );
  //     final storyResponse =
  //     await apiWorker.addStoryApi(storyRequest, context);
  //
  //     if (storyResponse?.success == true) {
  //       showToast(
  //         context,
  //         "Success",
  //         "Story Added Successfully",
  //         type: ToastificationType.success,
  //       );
  //
  //       clear();
  //       Get.back();
  //     }
  //   } catch (e) {
  //     showToast(
  //       context,
  //       "Error",
  //       e.toString(),
  //       type: ToastificationType.error,
  //     );
  //   } finally {
  //     isUploading.value = false;
  //   }
  // }
  // Future<void> uploadAndAddStory(BuildContext context) async {
  //   try {
  //     if (selectedFile.value == null) return;
  //
  //     isUploading.value = true;
  //
  //     String mediaUrl = "";
  //
  //     /// IMAGE UPLOAD
  //     if (selectedMediaType.value == "IMAGE") {
  //       final uploadRequest = UploadImagesRequest(
  //         images: [selectedFile.value!],
  //         lang: LanguageController.to.apiLanguage,
  //       );
  //
  //       final uploadResponse =
  //       await apiWorker.uploadFileApi(uploadRequest, context);
  //
  //       if (uploadResponse?.success != true ||
  //           uploadResponse?.data?.images?.isEmpty == true) {
  //         throw Exception("Image upload failed");
  //       }
  //
  //       mediaUrl = uploadResponse!.data!.images!.first.imageUrl ?? "";
  //     }
  //
  //     /// VIDEO UPLOAD
  //     else if (selectedMediaType.value == "VIDEO") {
  //       final videoRequest = UploadVideoRequest(
  //         videos: [selectedFile.value!],
  //         lang:LanguageController.to.apiLanguage,
  //       );
  //
  //       final videoResponse =
  //       await apiWorker.videoUpload(videoRequest, context);
  //
  //       if (videoResponse?.success != true) {
  //         throw Exception("Video upload failed");
  //       }
  //
  //       mediaUrl = videoResponse?.data?.videos?.first.videoUrl ?? "";
  //     }
  //
  //     /// ADD STORY API
  //     final storyRequest = AddStoryRequest(
  //       lang: LanguageController.to.apiLanguage,
  //       mediaUrl: mediaUrl,
  //       mediaType: selectedMediaType.value,
  //       text: "",
  //       ctaText: "",
  //     );
  //
  //     final storyResponse =
  //     await apiWorker.addStoryApi(storyRequest, context);
  //
  //     if (storyResponse?.success == true) {
  //       showToast(
  //         context,
  //         "Success",
  //         "Story Added Successfully",
  //         type: ToastificationType.success,
  //       );
  //
  //       clear();
  //       Get.back();
  //     }
  //   } catch (e) {
  //     showToast(
  //       context,
  //       "Error",
  //       e.toString(),
  //       type: ToastificationType.error,
  //     );
  //   } finally {
  //     isUploading.value = false;
  //   }
  // }
  Future<void> uploadAndAddStory(BuildContext context) async {
    try {
      if (selectedFile.value == null) return;

      isUploading.value = true;

      String mediaUrl = "";

      if (selectedMediaType.value == "IMAGE") {
        final uploadRequest = UploadImagesRequest(
          images: [selectedFile.value!],
          lang: LanguageController.to.apiLanguage,
        );

        final response =
        await apiWorker.uploadFileApi(uploadRequest, context);

        if (response?.success != true ||
            response?.data?.images?.isEmpty == true) {
          throw Exception("Image upload failed");
        }

        mediaUrl = response!.data!.images!.first.imageUrl ?? "";
      }

      else if (selectedMediaType.value == "VIDEO") {
        final request = UploadVideoRequest(
          videos: [selectedFile.value!],
          lang: LanguageController.to.apiLanguage,
        );

        final response =
        await apiWorker.videoUpload(request, context);

        if (response?.success != true ||
            response?.data?.videos?.isEmpty == true) {
          throw Exception("Video upload failed");
        }

        mediaUrl = response!.data!.videos!.first.videoUrl ?? "";
      }

      final storyRequest = AddStoryRequest(
        lang: LanguageController.to.apiLanguage,
        mediaUrl: mediaUrl,
        mediaType: selectedMediaType.value,
        text: "",
        ctaText: "",
      );

      final storyResponse =
      await apiWorker.addStoryApi(storyRequest, context);

      if (storyResponse?.success == true) {
        showToast(
          context,
          "Success",
          "Story Added Successfully",
          type: ToastificationType.success,
        );

        clear();
        Get.back(result: true);
      }
    } catch (e) {
      showToast(
        context,
        "Error",
        e.toString(),
        type: ToastificationType.error,
      );
    } finally {
      isUploading.value = false;
    }
  }
}
class _MediaOptionTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  const _MediaOptionTile({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    return Material(
      color: isLight ? Colors.grey.shade50 : const Color(0xFF2A2A2A),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isLight ? const Color(0xFF111827) : Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color:
                          isLight ? Colors.grey.shade500 : Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Icon(Icons.chevron_right_rounded,
                  color:
                      isLight ? Colors.grey.shade400 : Colors.grey.shade500,
                  size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
