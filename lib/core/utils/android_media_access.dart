import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image_picker_android/image_picker_android.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

/// Google Play Photo and Video Permissions policy:
/// pick photos/videos with the system Photo Picker. Do not request
/// READ_MEDIA_IMAGES or READ_MEDIA_VIDEO.
class AndroidMediaAccess {
  static void enableSystemPhotoPicker() {
    if (kIsWeb) return;
    final implementation = ImagePickerPlatform.instance;
    if (implementation is ImagePickerAndroid) {
      implementation.useAndroidPhotoPicker = true;
    }
  }
}

class AppDownloadDirectory {
  static Future<Directory> resolve() async {
    if (Platform.isAndroid) {
      await _requestLegacyWritePermission();
      final publicDownloads = Directory('/storage/emulated/0/Download');
      if (await publicDownloads.exists()) {
        return publicDownloads;
      }
      final externalDir = await getExternalStorageDirectory();
      if (externalDir != null) {
        return externalDir;
      }
    }

    if (Platform.isIOS) {
      return getApplicationDocumentsDirectory();
    }

    return getTemporaryDirectory();
  }

  /// Android 13+ uses scoped storage. Never request photos/videos permissions.
  static Future<void> _requestLegacyWritePermission() async {
    if (!Platform.isAndroid) return;
    final status = await Permission.storage.status;
    if (status.isGranted || status.isLimited || status.isPermanentlyDenied) {
      return;
    }
    await Permission.storage.request();
  }
}
