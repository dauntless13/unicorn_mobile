import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_android/image_picker_android.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:path_provider/path_provider.dart';

export 'package:image_picker/image_picker.dart' show CameraDevice, ImageSource, XFile;

/// Google Play Photo and Video Permissions policy:
/// pick photos/videos with the system Photo Picker only.
/// Never request READ_MEDIA_IMAGES or READ_MEDIA_VIDEO.
class AndroidMediaAccess {
  static void enableSystemPhotoPicker() {
    if (kIsWeb) return;
    if (!Platform.isAndroid) return;
    final current = ImagePickerPlatform.instance;
    final implementation = current is ImagePickerAndroid
        ? current
        : ImagePickerAndroid();
    implementation.useAndroidPhotoPicker = true;
    ImagePickerPlatform.instance = implementation;
  }
}

/// Single gallery/camera entry point so a future screen cannot skip the
/// Android Photo Picker and trip Google Play's photo/video permission policy.
class AppMediaPicker {
  static final ImagePicker _picker = ImagePicker();

  static Future<XFile?> pickImage({
    required ImageSource source,
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
  }) {
    AndroidMediaAccess.enableSystemPhotoPicker();
    return _picker.pickImage(
      source: source,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      imageQuality: imageQuality,
      preferredCameraDevice: preferredCameraDevice,
    );
  }

  static Future<List<XFile>> pickImages({
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    int? limit,
  }) async {
    AndroidMediaAccess.enableSystemPhotoPicker();
    return _picker.pickMultiImage(
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      imageQuality: imageQuality,
      limit: limit,
    );
  }

  static Future<XFile?> pickVideo({
    required ImageSource source,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
    Duration? maxDuration,
  }) {
    AndroidMediaAccess.enableSystemPhotoPicker();
    return _picker.pickVideo(
      source: source,
      preferredCameraDevice: preferredCameraDevice,
      maxDuration: maxDuration,
    );
  }

  static Future<XFile?> pickMedia({
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
  }) {
    AndroidMediaAccess.enableSystemPhotoPicker();
    return _picker.pickMedia(
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      imageQuality: imageQuality,
    );
  }
}

class AppDownloadDirectory {
  static Future<Directory> resolve() async {
    if (Platform.isAndroid) {
      final externalDir = await getExternalStorageDirectory();
      if (externalDir != null) {
        final downloads = Directory('${externalDir.path}${Platform.pathSeparator}Download');
        return downloads;
      }
    }

    if (Platform.isIOS) {
      return getApplicationDocumentsDirectory();
    }

    return getTemporaryDirectory();
  }
}
