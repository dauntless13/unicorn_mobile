import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../../../model/story_model.dart';
import '../controller/home_controller.dart';

class AddStoryScreen extends StatefulWidget {
  const AddStoryScreen({super.key});

  @override
  State<AddStoryScreen> createState() => _AddStoryScreenState();
}

class _AddStoryScreenState extends State<AddStoryScreen> {
  File? _image;
  final TextEditingController _textController = TextEditingController();
  bool _showTextField = false;

  bool isLight(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light;

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source);

    if (picked != null) {
      setState(() => _image = File(picked.path));
    }
  }

  void _postStory() {
    if (_image == null) return;

    final controller = Get.find<HomeScreenController>();

    controller.addStory(
      StoryModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        username: 'your_story'.tr,
        avatarUrl: "https://i.ytimg.com/vi/zEr-mm8OSGo/sddefault.jpg",
        imageUrl: _image!.path,
        isMine: true,
        createdAt: DateTime.now(),
      ),
    );

    Get.back();
  }

  @override
  void dispose() {
    _textController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final light = isLight(context);

    return Scaffold(
      backgroundColor:
      light ? Colors.white : const Color(0xFF121212),
      body: _image == null
          ? _buildImagePickerUI(context)
          : _buildStoryEditorUI(context),
    );
  }

  // ================= IMAGE PICKER =================
  Widget _buildImagePickerUI(BuildContext context) {
    final light = isLight(context);

    return Container(
      decoration: BoxDecoration(
        gradient: light
            ? LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue.shade50,
            Colors.white,
            Colors.indigo.shade50
          ],
        )
            : const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1E1E1E),
            Color(0xFF121212),
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            /// TOP BAR
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(
                      Icons.close,
                      color: light ? Colors.grey[700] : Colors.white,
                      size: 28,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'create_story'.tr,
                    style: TextStyle(
                      color: light ? Colors.black87 : Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /// ICON
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: light
                            ? Colors.white
                            : const Color(0xFF1E1E1E),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.add_a_photo_outlined,
                        color: Colors.blue.shade600,
                        size: 50,
                      ),
                    ),

                    const SizedBox(height: 40),

                    Text(
                      'share_your_story'.tr,
                      style: TextStyle(
                        color: light ? Colors.black87 : Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      'story_subtitle'.tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color:
                        light ? Colors.grey[600] : Colors.grey[400],
                        fontSize: 15,
                        height: 1.6,
                      ),
                    ),

                    const SizedBox(height: 50),

                    _buildLargeButton(
                      icon: Icons.camera_alt,
                      label: 'take_photo'.tr,
                      gradient: LinearGradient(
                        colors: [
                          Colors.blue.shade600,
                          Colors.blue.shade700
                        ],
                      ),
                      onTap: () => _pickImage(ImageSource.camera),
                    ),

                    const SizedBox(height: 16),

                    _buildLargeButton(
                      icon: Icons.photo_library,
                      label: 'choose_gallery'.tr,
                      gradient: LinearGradient(
                        colors: [
                          Colors.indigo.shade600,
                          Colors.indigo.shade700
                        ],
                      ),
                      onTap: () => _pickImage(ImageSource.gallery),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= STORY EDITOR =================
  Widget _buildStoryEditorUI(BuildContext context) {
    final light = isLight(context);

    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            color: light ? Colors.grey[100] : Colors.black,
            child: Image.file(_image!, fit: BoxFit.contain),
          ),
        ),

        /// POST BUTTON
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton.icon(
                onPressed: _postStory,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.check, color: Colors.white),
                label: Text(
                  'post_story'.tr,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ================= BUTTON =================
  Widget _buildLargeButton({
    required IconData icon,
    required String label,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 28),
              const SizedBox(width: 16),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
