import 'package:video_player/video_player.dart';import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../../../../../core/widget/my_regular_text.dart';
import '../controller/add_story_controller.dart';
import '../video_preview_widget.dart';

class AddStoryScreenTeacher extends StatelessWidget {
  AddStoryScreenTeacher({super.key});

  final AddStoryController controller =
  Get.put(AddStoryController());

  bool isLight(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light;

  @override
  Widget build(BuildContext context) {
    final light = isLight(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        elevation: 0,
        title: MyRegularText(
          label: 'story_post'.tr,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
        actions: [
          Obx(() {
            if (controller.selectedFile.value == null) {
              return   TextButton(
                onPressed: () {
                  controller.clear();
                  Get.back();
                },
                child: MyRegularText(
                  label: 'cancel'.tr,
                  color: Colors.white,
                ),
              );
            }

            return controller.isUploading.value
                ? const Padding(
              padding: EdgeInsets.only(right: 16),
              child: Center(
                child: SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(),
                ),
              ),
            )
                : TextButton(
              onPressed: () =>
                  controller.uploadAndAddStory(context),
              child: MyRegularText(
                label: 'done'.tr,
                color: Colors.blueAccent,
                fontWeight: FontWeight.w600,
              ),
            );
          }),
        ],
      ),
      body: Obx(() {
        final file = controller.selectedFile.value;
        final type = controller.selectedMediaType.value;

        if (file == null) {
          return _cameraPlaceholder(context);
        }

        if (type == "VIDEO") {
          return VideoPreviewWidget(
            key: ValueKey(file.path), // VERY IMPORTANT
            file: file,
          );
        }

        return Center(
          child: Image.file(
            file,
            fit: BoxFit.contain,
          ),
        );
      }),
      bottomNavigationBar: _bottomBar(context),
    );
  }

  // ================= CAMERA PLACEHOLDER =================
  Widget _cameraPlaceholder(BuildContext context) {
    return Center(
      child: IconButton(
        iconSize: 72,
        onPressed: controller.openCamera,
        icon: const Icon(
          Icons.camera_alt,
          color: Colors.white,
        ),
      ),
    );
  }

  // ================= PREVIEW =================
  Widget _previewStory(File file) {
    if (controller.selectedMediaType.value == "VIDEO") {
      return VideoPreviewWidget(file: file); // create simple video widget
    }

    return Center(
      child: Image.file(
        file,
        fit: BoxFit.contain,
      ),
    );
  }

  // ================= BOTTOM BAR =================
  Widget _bottomBar(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton.icon(
            onPressed: controller.openGallery,
            icon: const Icon(Icons.photo, color: Colors.white),
            label: MyRegularText(
              label: 'library'.tr,
              color: Colors.white,
            ),
          ),
          TextButton.icon(
            onPressed: controller.openCamera,
            icon: const Icon(Icons.camera_alt, color: Colors.white),
            label: MyRegularText(
              label: 'photo'.tr,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
