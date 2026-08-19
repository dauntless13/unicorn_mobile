import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unicorn/core/common_size/common_font_size.dart';
import 'package:video_player/video_player.dart';

import '../../../../../../../../../core/ColorUtils.dart';
import '../../../../../../../../../core/widget/back_button.dart';
import '../../../../../../../../../core/widget/my_form_field.dart';
import '../../../../../../../../../core/widget/my_regular_text.dart';
import '../../../../profile/model/get_all_class/get_all_class_response.dart';
import '../../../../profile/view/common_selection_bottomsheet.dart';
import '../controller/add_post_controller.dart';
import '../mode/list_student_by_class/list_student_by_class_response.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  String postType = 'announcements'.tr;
  String publishType = 'public'.tr;

  final AddPostController controller = Get.put(AddPostController());

  bool isLight(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light;

  @override
  Widget build(BuildContext context) {
    final light = isLight(context);

    return Scaffold(
      backgroundColor: light ? Colors.white : const Color(0xFF0F0F0F),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  appBackButton(context),
                  SizedBox(width: 6),
                  MyRegularText(
                    label: 'add_post'.tr,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: light ? Colors.black : Colors.white,
                  ),
                ],
              ),
              SizedBox(height: 10),

              /// TYPE
              _label('type'.tr),
              _dropdown(
                value: postType,
                items: [
                  'announcements'.tr,
                  'image'.tr,
                  'video'.tr,
                  'PDF',
                ],
                onChanged: (v) {
                  controller.clearMedia();
                  setState(() => postType = v);
                },
              ),

              const SizedBox(height: 14),

              /// CLASS (only for announcement)
              // if (postType == 'announcements'.tr) ...[
              _label('class'.tr),
              //   _dropdown(
              //     value: 'class_b'.tr,
              //     items: ['class_b'.tr],
              //     onChanged: (_) {},
              //   ),
              //   const SizedBox(height: 14),
              // ],
              Obx(() => _dropdownTile(
                    context,
                    light,
                    icon: Icons.class_outlined,
                    label: 'Select Classes'.tr,
                    value: controller.selectedClass.value?.name,
                    enabled: true,
                    isMultiline: true,
                    onTap: () async {
                      await controller.fetchClasses(context);
                      showSelectionBottomSheet<Class>(
                        context: context,
                        title: "Select Class".tr,
                        items: controller.classList,
                        itemLabel: (e) => e.name ?? "",
                        isMultiSelect: false,
                        selectedItems: controller.selectedClass.value != null
                            ? [controller.selectedClass.value!]
                            : [],
                        onSelect: controller.selectClass,
                      );
                    },
                  )),
              const SizedBox(height: 14),

              /// PUBLISH TYPE (only for photo)

              _label('publish_type'.tr),
              _dropdown(
                value: publishType,
                items: [
                  'public'.tr,
                  'private'.tr,
                ],
                onChanged: (v) => setState(() => publishType = v),
              ),
              const SizedBox(height: 14),

              /// STUDENTS (photo + private)
              // if (postType == 'photo'.tr && publishType == 'private'.tr) ...[
              //   _label('students'.tr),
              //   _dropdown(
              //     value: 'Alira',
              //     items: const ['Alira'],
              //     onChanged: (_) {},
              //     withAvatar: true,
              //   ),
              //   const SizedBox(height: 14),
              // ],
              if (publishType == 'private'.tr) ...[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label('students'.tr),
                    Obx(() => _dropdownTile(
                          context,
                          light,
                          icon: Icons.person_outline,
                          label: 'students'.tr,
                          value: controller.selectedStudents.isEmpty
                              ? null
                              : controller.selectedStudents
                                  .map((e) => "${e.firstName} ${e.lastName}")
                                  .join(", "),
                          isMultiline: true,
                          onTap: () async {
                            await controller.fetchStudentsByClass(context);

                            showSelectionBottomSheet<StudentData>(
                              context: context,
                              title: "Select Students",
                              items: controller.studentList,
                              itemLabel: (e) =>
                                  "${e.firstName ?? ""} ${e.lastName ?? ""}",
                              isMultiSelect: true,
                              selectedItems: controller.selectedStudents,
                              onSelect: controller.toggleStudent,
                            );
                          },
                        )),
                  ],
                ),
              ],
              const SizedBox(height: 14),

              /// MEDIA
              _label('media'.tr),
              // MediaUploadBox(),
              MediaUploadBox(postType: postType),
              const SizedBox(height: 14),

              /// DESCRIPTION
              _label('description'.tr),
              MyFormField(
                controller: controller.descriptionCtrl,
                hintText: 'description'.tr,
                maxLines: 4,
              ),

              const SizedBox(height: 30),

              /// SUBMIT BUTTON
              Obx(() {
                return SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () => controller.uploadMedia(
                              context,
                              publishType,
                              postType,
                            ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: controller.isLoading.value
                        ? const CircularProgressIndicator()
                        : MyRegularText(
                            label: 'Submit'.tr,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: CommonFontSize.largeFont(),
                          ),
                  ),
                );
              })
            ],
          ),
        ),
      ),
    );
  }

  // ================= LABEL =================
  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: MyRegularText(
        label: text,
        fontWeight: FontWeight.w500,
        align: TextAlign.start,
        color: secondaryText(context),
      ),
    );
  }

  static const _teal = Color(0xFF0D6E82);

  Widget _dropdownTile(
    BuildContext context,
    bool light, {
    required IconData icon,
    required String label,
    String? value,
    bool enabled = true,
    bool isMultiline = false,
    VoidCallback? onTap,
  }) {
    final hasValue = value != null && value.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        color: light ? Colors.white : const Color(0xFF1A1A1A),
      ),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// LABEL

                    /// VALUE
                    Text(
                      hasValue ? value! : 'Tap to select'.tr,
                      maxLines: isMultiline ? 2 : 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight:
                            hasValue ? FontWeight.w500 : FontWeight.w400,
                        color: hasValue
                            ? (light ? Colors.black87 : Colors.white)
                            : Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_drop_down,
                color: enabled ? Colors.grey : Colors.grey.shade300,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= DROPDOWN =================
  Widget _dropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String> onChanged,
    bool withAvatar = false,
  }) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          style: TextStyle(color: secondaryText(context)),
          value: value,
          isExpanded: true,
          items: items
              .map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Row(
                    children: [
                      if (withAvatar)
                        const CircleAvatar(
                          radius: 12,
                          child: Icon(Icons.person, size: 14),
                        ),
                      if (withAvatar) const SizedBox(width: 8),
                      Text(e),
                    ],
                  ),
                ),
              )
              .toList(),
          onChanged: (v) => onChanged(v!),
        ),
      ),
    );
  }
}

class MediaUploadBox extends StatefulWidget {
  final String postType;

  const MediaUploadBox({super.key, required this.postType});

  @override
  State<MediaUploadBox> createState() => _MediaUploadBoxState();
}

class _MediaUploadBoxState extends State<MediaUploadBox> {
  final AddPostController controller = Get.find();

  final Map<int, VideoPlayerController> _videoControllers = {};

  bool isLight(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light;

  @override
  void dispose() {
    for (var controller in _videoControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _initializeVideo(int index, File file) async {
    if (_videoControllers.containsKey(index)) return;

    final videoController = VideoPlayerController.file(file);
    await videoController.initialize();
    videoController.setLooping(true);

    _videoControllers[index] = videoController;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final light = isLight(context);

    return Obx(() {
      final files = controller.selectedMedia;

      return GestureDetector(
        onTap: () => _handleMediaTap(context),
        child: Container(
          height: 120,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
            color: light ? Colors.white : const Color(0xFF1A1A1A),
          ),
          child: files.isEmpty
              ? const Icon(Icons.upload_outlined, size: 32)
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: files.length,
                  itemBuilder: (context, index) {
                    final file = files[index];
                    final isVideo = controller.mediaIsVideo[index];
                    final isPdf = controller.selectedMediaType.value == "PDF";

                    if (isVideo && !_videoControllers.containsKey(index)) {
                      _initializeVideo(index, file);
                    }

                    return Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(6),
                          width: 100,
                          height: 100,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: isPdf
                                ? _buildPdfPreview(file, light)
                                : isVideo
                                    ? _videoControllers[index] != null &&
                                            _videoControllers[index]!
                                                .value
                                                .isInitialized
                                        ? Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              AspectRatio(
                                                aspectRatio:
                                                    _videoControllers[index]!
                                                        .value
                                                        .aspectRatio,
                                                child: VideoPlayer(
                                                  _videoControllers[index]!,
                                                ),
                                              ),
                                              const Icon(
                                                Icons.play_circle_fill,
                                                color: Colors.white,
                                                size: 30,
                                              ),
                                            ],
                                          )
                                        : const Center(
                                            child: CircularProgressIndicator(),
                                          )
                                    : Image.file(
                                        file,
                                        fit: BoxFit.cover,
                                      ),
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: () {
                              if (_videoControllers[index] != null) {
                                _videoControllers[index]!.dispose();
                                _videoControllers.remove(index);
                              }
                              controller.selectedMedia.removeAt(index);
                              controller.mediaIsVideo.removeAt(index);
                              setState(() {});
                            },
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
        ),
      );
    });
  }

  void _handleMediaTap(BuildContext context) {
    if (widget.postType == 'announcements'.tr) {
      _showPicker(context);
    } else if (widget.postType == 'image'.tr) {
      _showCameraGalleryPicker(context, isVideo: false);
    } else if (widget.postType == 'video'.tr) {
      _showCameraGalleryPicker(context, isVideo: true);
    } else if (widget.postType == 'PDF') {
      controller.pickPdf();
    }
  }

  void _showPicker(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.image),
              title: Text('Pick Image'.tr),
              onTap: () {
                Get.back();
                _showCameraGalleryPicker(context, isVideo: false);
              },
            ),
            ListTile(
              leading: const Icon(Icons.videocam),
              title: Text('Pick Video'.tr),
              onTap: () {
                Get.back();
                _showCameraGalleryPicker(context, isVideo: true);
              },
            ),
            ListTile(
              leading: const Icon(Icons.picture_as_pdf_rounded),
              title: Text('Pick PDF'),
              onTap: () {
                Get.back();
                controller.pickPdf();
              },
            ),
          ],
        ),
      ),
      backgroundColor: Theme.of(context).cardColor,
    );
  }

  void _showCameraGalleryPicker(BuildContext context, {required bool isVideo}) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Wrap(
          children: [
            /// 📸 CAMERA
            ListTile(
              leading: Icon(isVideo ? Icons.videocam : Icons.camera_alt),
              title: Text(isVideo ? 'Record Video'.tr : 'Capture Image'.tr),
              onTap: () {
                Get.back();
                if (isVideo) {
                  controller.captureVideoFromCamera();
                } else {
                  controller.captureImageFromCamera();
                }
              },
            ),

            /// 🖼️ GALLERY
            ListTile(
              leading: Icon(isVideo ? Icons.video_library : Icons.image),
              title: Text(isVideo ? 'Pick Video'.tr : 'Pick Image'.tr),
              onTap: () {
                Get.back();
                if (isVideo) {
                  controller.pickVideo();
                } else {
                  controller.pickImage();
                }
              },
            ),
          ],
        ),
      ),
      backgroundColor: Theme.of(context).cardColor,
    );
  }

  Widget _buildPdfPreview(File file, bool light) {
    return Container(
      width: 100,
      height: 100,
      color: light ? const Color(0xFFF5F5F5) : const Color(0xFF222222),
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.picture_as_pdf_rounded,
            color: Colors.red,
            size: 34,
          ),
          const SizedBox(height: 8),
          Text(
            file.path.split(Platform.pathSeparator).last,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: light ? Colors.black87 : Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
