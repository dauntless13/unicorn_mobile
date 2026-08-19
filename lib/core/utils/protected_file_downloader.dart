import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:unicorn/core/utils/gallery_save_helper.dart';
import 'package:unicorn/service/session/session_helper.dart';
import 'package:unicorn/widget/common_toastification.dart';

class ProtectedFileDownloader {
  static Future<bool> savePdf({
    String? url,
    Uint8List? bytes,
    required String fileName,
    bool authenticated = true,
    String acceptHeader = 'application/pdf',
    String successMessage = '',
    String failureMessage = '',
  }) {
    return saveToDownloads(
      url: url,
      bytes: bytes,
      fileName: _ensurePdfName(fileName),
      authenticated: authenticated,
      acceptHeader: acceptHeader,
      successMessage: successMessage,
      failureMessage: failureMessage,
    );
  }

  static Future<bool> saveToDownloads({
    String? url,
    Uint8List? bytes,
    required String fileName,
    bool authenticated = true,
    String acceptHeader = '*/*',
    String successMessage = '',
    String failureMessage = '',
  }) async {
    try {
      _showBusy();
      final data = bytes ??
          await fetchBytes(
            url: url,
            authenticated: authenticated,
            acceptHeader: acceptHeader,
          );
      if (data == null || data.isEmpty) {
        throw Exception('empty file');
      }

      final directory = await _resolveDownloadDirectory();
      await directory.create(recursive: true);
      final file = await _uniqueFile(directory, fileName);
      await file.writeAsBytes(data, flush: true);

      _hideBusy();
      showAppSnackbar(
        'Success'.tr,
        successMessage.isEmpty ? 'file_saved_to_downloads'.tr : successMessage,
      );
      return true;
    } catch (_) {
      _hideBusy();
      showAppSnackbar(
        'Error'.tr,
        failureMessage.isEmpty ? 'failed_to_download_file'.tr : failureMessage,
      );
      return false;
    }
  }

  static Future<bool> saveImage({
    String? url,
    Uint8List? bytes,
    required String fileName,
    bool authenticated = true,
  }) async {
    try {
      _showBusy();
      final data = bytes ??
          await fetchBytes(
            url: url,
            authenticated: authenticated,
            acceptHeader: 'image/*',
          );
      if (data == null || data.isEmpty) {
        throw Exception('empty image');
      }

      final saved = await GallerySaveHelper.saveImageBytes(
        data,
        name: fileName,
      );
      _hideBusy();
      if (!saved) {
        showAppSnackbar('Error'.tr, 'photo_permission_required'.tr);
        return false;
      }
      showAppSnackbar('Success'.tr, 'saved_to_gallery'.tr);
      return true;
    } catch (_) {
      _hideBusy();
      showAppSnackbar('Error'.tr, 'failed_to_save_gallery'.tr);
      return false;
    }
  }

  static Future<bool> saveVideo({
    required String url,
    required String fileName,
    bool authenticated = true,
  }) async {
    File? tempFile;
    try {
      _showBusy();
      final data = await fetchBytes(
        url: url,
        authenticated: authenticated,
        acceptHeader: 'video/*',
      );
      if (data == null || data.isEmpty) {
        throw Exception('empty video');
      }

      final tempDir = await getTemporaryDirectory();
      tempFile = File('${tempDir.path}${Platform.pathSeparator}$fileName');
      await tempFile.writeAsBytes(data, flush: true);

      final saved = await GallerySaveHelper.saveVideoFile(
        tempFile.path,
        name: fileName,
      );
      _hideBusy();
      if (!saved) {
        showAppSnackbar('Error'.tr, 'photo_permission_required'.tr);
        return false;
      }
      showAppSnackbar('Success'.tr, 'saved_to_gallery'.tr);
      return true;
    } catch (_) {
      _hideBusy();
      showAppSnackbar('Error'.tr, 'failed_to_save_gallery'.tr);
      return false;
    } finally {
      if (tempFile != null && await tempFile.exists()) {
        await tempFile.delete();
      }
    }
  }

  static Future<Uint8List?> fetchBytes({
    String? url,
    bool authenticated = true,
    String acceptHeader = '*/*',
  }) async {
    final trimmed = url?.trim() ?? '';
    if (trimmed.isEmpty) return null;

    final headers = <String, String>{'accept': acceptHeader};
    if (authenticated) {
      final token = (await SessionHelper().getLoginResponse())?.data?.token;
      if (token != null && token.isNotEmpty) {
        headers['authorization'] = 'Bearer $token';
      }
    }

    final response = await Dio().get<List<int>>(
      trimmed,
      options: Options(
        responseType: ResponseType.bytes,
        headers: headers,
        followRedirects: true,
        validateStatus: (status) => status != null && status < 400,
      ),
    );

    final data = response.data;
    if (data == null || data.isEmpty) return null;
    return Uint8List.fromList(data);
  }

  static Future<Directory> _resolveDownloadDirectory() async {
    if (Platform.isAndroid) {
      await _requestAndroidStoragePermission();
      final downloadDir = Directory('/storage/emulated/0/Download');
      if (await downloadDir.exists()) return downloadDir;
      final externalDir = await getExternalStorageDirectory();
      if (externalDir != null) return externalDir;
    }

    if (Platform.isIOS) {
      return getApplicationDocumentsDirectory();
    }

    return getTemporaryDirectory();
  }

  static Future<void> _requestAndroidStoragePermission() async {
    final storageStatus = await Permission.storage.request();
    if (storageStatus.isGranted) return;
    await Permission.photos.request();
  }

  static Future<File> _uniqueFile(Directory directory, String fileName) async {
    final extensionIndex = fileName.lastIndexOf('.');
    final hasExtension = extensionIndex > 0;
    final namePart =
        hasExtension ? fileName.substring(0, extensionIndex) : fileName;
    final extension = hasExtension ? fileName.substring(extensionIndex) : '';

    var candidate = File('${directory.path}${Platform.pathSeparator}$fileName');
    var counter = 1;
    while (await candidate.exists()) {
      candidate = File(
        '${directory.path}${Platform.pathSeparator}${namePart}_$counter$extension',
      );
      counter++;
    }
    return candidate;
  }

  static String _ensurePdfName(String fileName) {
    final sanitized = fileName.replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '_');
    if (sanitized.toLowerCase().endsWith('.pdf') && sanitized.isNotEmpty) {
      return sanitized;
    }
    return '${sanitized.isEmpty ? 'report' : sanitized}.pdf';
  }

  static void _showBusy() {
    if (Get.isDialogOpen ?? false) return;
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );
  }

  static void _hideBusy() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }
}
