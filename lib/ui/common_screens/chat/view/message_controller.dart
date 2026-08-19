import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../service/api_service/api_worker.dart';
import '../../../teacher/teacher_bottom_tab/view/screens/home/view/add_post/mode/upload_images/upload_images_request.dart';
import '../../../teacher/teacher_bottom_tab/view/screens/home/view/add_post/mode/upload_images/upload_images_response.dart';
import '../../../teacher/teacher_bottom_tab/view/screens/home/view/add_post/mode/upload_video/upload_video_request.dart';
import '../../../teacher/teacher_bottom_tab/view/screens/home/view/add_post/mode/upload_video/upload_video_response.dart';
import '../../../../widget/common_toastification.dart';
import '../model/parent_group_user_listing/parent_group_user_listing_response.dart';
import '../model/teacher_group_user_listing/teacher_group_user_listing_request.dart';
import '../model/teacher_group_user_listing/teacher_group_user_listing_response.dart' hide Pagination, Group;

// ────────────────────────────────────────────────────────────────────────────

/// Supported file extensions grouped by type.
class FileTypeHelper {
  static const List<String> imageExtensions = [
    'jpg', 'jpeg', 'png', 'gif', 'webp', 'svg'
  ];
  static const List<String> videoExtensions = [
    'mp4', 'mov', 'avi', 'mkv', 'webm'
  ];
  static const List<String> documentExtensions = [
    'pdf', 'txt', 'csv', 'xls', 'xlsx', 'doc', 'docx'
  ];
  static const List<String> allExtensions = [
    'jpg', 'jpeg', 'png', 'gif', 'webp', 'svg',
    'mp4', 'mov', 'avi', 'mkv', 'webm',
    'pdf', 'txt', 'csv', 'xls', 'xlsx', 'doc', 'docx',
  ];

  static String getMessageType(String filePath) {
    final ext = filePath.split('.').last.toLowerCase();
    if (imageExtensions.contains(ext)) return 'image';
    if (videoExtensions.contains(ext)) return 'video';
    if (documentExtensions.contains(ext)) return 'document';
    return 'document';
  }

  static IconData getDocumentIcon(String fileName) {
    final ext = fileName.split('.').last.toLowerCase();
    switch (ext) {
      case 'pdf':
        return Icons.picture_as_pdf_rounded;
      case 'doc':
      case 'docx':
        return Icons.description_rounded;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart_rounded;
      case 'csv':
        return Icons.grid_on_rounded;
      case 'txt':
        return Icons.text_snippet_rounded;
      default:
        return Icons.insert_drive_file_rounded;
    }
  }

  static Color getDocumentColor(String fileName) {
    final ext = fileName.split('.').last.toLowerCase();
    switch (ext) {
      case 'pdf':
        return Colors.red;
      case 'doc':
      case 'docx':
        return Colors.blue;
      case 'xls':
      case 'xlsx':
        return Colors.green.shade700;
      case 'csv':
        return Colors.teal;
      case 'txt':
        return Colors.orange;
      default:
        return Colors.blueGrey;
    }
  }

  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}

// ────────────────────────────────────────────────────────────────────────────

class ChatController extends GetxController {
  // ── Upload state ──────────────────────────────────────────────────────────
  final RxBool isUploading = false.obs;

  // ── Audio recording state ─────────────────────────────────────────────────
  final RxBool isRecording = false.obs;
  final RxBool isPlayingAudio = false.obs;
  final RxString recordingDuration = "0:00".obs;
  final RxString currentPlayingAudioId = "".obs;

  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  final FlutterSoundPlayer _player = FlutterSoundPlayer();

  bool _recorderInitialized = false;
  bool _playerInitialized = false;

  String? _recordingPath;
  Timer? _recordingTimer;
  int recordingSeconds = 0;

  // ── Image picker ──────────────────────────────────────────────────────────
  final ImagePicker _picker = ImagePicker();

  // ─────────────────────────────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    _initRecorder();
    _initPlayer();

  }

  @override
  void onClose() {
    _recorder.closeRecorder();
    _player.closePlayer();
    _recordingTimer?.cancel();
    super.onClose();
  }

  // ── Init ──────────────────────────────────────────────────────────────────
  Future<void> _initRecorder() async {
    await _recorder.openRecorder();
    _recorderInitialized = true;
  }

  Future<void> _initPlayer() async {
    await _player.openPlayer();
    _playerInitialized = true;
  }

  final _apiWorker = ApiWorker();

  // =========================================================================
  //  UPLOAD HELPERS
  // =========================================================================

  /// Upload image → returns URL string. Uses image API.
  Future<String> uploadImages(BuildContext context, String filePath) async {
    try {
      isUploading.value = true;
      final request = UploadImagesRequest(images: [File(filePath)]);
      final UploadImagesResponse? response =
      await _apiWorker.uploadFileApi(request, context);
      if (response?.data?.images?.isNotEmpty == true) {
        return response!.data!.images!.first.imageUrl ?? "";
      }
      return "";
    } catch (e) {
      debugPrint("Image upload error: $e");
      return "";
    } finally {
      isUploading.value = false;
    }
  }

  /// Upload video → returns URL string. Uses video API.
  Future<String> uploadVideo(BuildContext context, String filePath) async {
    try {
      isUploading.value = true;
      final request = UploadVideoRequest(videos: [File(filePath)]);
      final UploadVideoResponse? response =
      await _apiWorker.videoUpload(request, context);
      if (response?.data?.videos?.isNotEmpty == true) {
        return response!.data!.videos!.first.videoUrl ?? "";
      }
      return "";
    } catch (e) {
      debugPrint("Video upload error: $e");
      return "";
    } finally {
      isUploading.value = false;
    }
  }

  /// Upload audio → uses image API endpoint.
  Future<String> uploadAudio(BuildContext context, String filePath) async {
    try {
      isUploading.value = true;
      final request = UploadImagesRequest(images: [File(filePath)]);
      final UploadImagesResponse? response =
      await _apiWorker.uploadFileApi(request, context);
      if (response?.data?.images?.isNotEmpty == true) {
        return response!.data!.images!.first.imageUrl ?? "";
      }
      return "";
    } catch (e) {
      debugPrint("Audio upload error: $e");
      return "";
    } finally {
      isUploading.value = false;
    }
  }

  /// Upload any document (PDF, DOC, XLSX, etc.) → uses image API endpoint.
  Future<String> uploadDocument(BuildContext context, String filePath) async {
    try {
      isUploading.value = true;
      final request = UploadImagesRequest(images: [File(filePath)]);
      final UploadImagesResponse? response =
      await _apiWorker.uploadFileApi(request, context);
      if (response?.data?.images?.isNotEmpty == true) {
        return response!.data!.images!.first.imageUrl ?? "";
      }
      return "";
    } catch (e) {
      debugPrint("Document upload error: $e");
      return "";
    } finally {
      isUploading.value = false;
    }
  }

  // =========================================================================
  //  IMAGE PICKER
  // =========================================================================

  Future<File?> pickImageFromGallery() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 75,
    );
    if (picked == null) return null;
    return _normalizeImage(File(picked.path));
  }

  Future<File?> pickImageFromCamera() async {
    final picked = await _picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.rear,
      imageQuality: 75,
    );
    if (picked == null) return null;
    return _normalizeImage(File(picked.path));
  }

  Future<File> _normalizeImage(File file) async {
    try {
      final bytes = await file.readAsBytes();
      final original = img.decodeImage(bytes);
      if (original == null) return file;
      final fixed = img.bakeOrientation(original);
      final tempFile = File(
        '${Directory.systemTemp.path}/chat_img_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
      await tempFile.writeAsBytes(img.encodeJpg(fixed, quality: 85));
      return tempFile;
    } catch (_) {
      return file;
    }
  }

  // =========================================================================
  //  VIDEO PICKER
  // =========================================================================

  Future<File?> pickVideoFromGallery() async {
    final picked = await _picker.pickVideo(
      source: ImageSource.gallery,
      maxDuration: const Duration(minutes: 5),
    );
    return picked != null ? File(picked.path) : null;
  }

  Future<File?> pickVideoFromCamera() async {
    final picked = await _picker.pickVideo(
      source: ImageSource.camera,
      maxDuration: const Duration(minutes: 5),
    );
    return picked != null ? File(picked.path) : null;
  }

  // =========================================================================
  //  DOCUMENT PICKER
  // =========================================================================

  /// Picks a document of any allowed extension.
  /// Returns a [PickedFile] record with path, name, size.
  Future<({String path, String name, int sizeBytes, String ext})?> pickDocument() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: FileTypeHelper.documentExtensions,
        allowMultiple: false,
      );
      if (result == null || result.files.isEmpty) return null;
      final pf = result.files.single;
      if (pf.path == null) return null;
      return (
      path: pf.path!,
      name: pf.name,
      sizeBytes: pf.size,
      ext: pf.extension?.toLowerCase() ?? '',
      );
    } catch (e) {
      debugPrint("Document pick error: $e");
      return null;
    }
  }

  // =========================================================================
  //  AUDIO RECORDING
  // =========================================================================

  Future<bool> _requestMicPermission() async {
    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  Future<void> startRecording() async {
    if (!_recorderInitialized) await _initRecorder();
    final granted = await _requestMicPermission();
    if (!granted) {
      showAppSnackbar("Permission denied", "Microphone permission is required.");
      return;
    }
    final dir = await getTemporaryDirectory();
    _recordingPath =
    '${dir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.aac';
    await _recorder.startRecorder(toFile: _recordingPath, codec: Codec.aacADTS);
    isRecording.value = true;
    recordingSeconds = 0;
    recordingDuration.value = "0:00";
    _recordingTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      recordingSeconds++;
      final m = recordingSeconds ~/ 60;
      final s = (recordingSeconds % 60).toString().padLeft(2, '0');
      recordingDuration.value = "$m:$s";
    });
  }

  Future<String?> stopRecording({bool cancel = false}) async {
    _recordingTimer?.cancel();
    isRecording.value = false;
    recordingDuration.value = "0:00";
    await _recorder.stopRecorder();
    if (cancel) {
      if (_recordingPath != null) {
        final f = File(_recordingPath!);
        if (await f.exists()) await f.delete();
      }
      return null;
    }
    return _recordingPath;
  }

  // =========================================================================
  //  AUDIO PLAYBACK
  // =========================================================================

  Future<void> playAudio(String messageId, String url) async {
    if (!_playerInitialized) await _initPlayer();
    if (isPlayingAudio.value) {
      await _player.stopPlayer();
      final prev = currentPlayingAudioId.value;
      currentPlayingAudioId.value = "";
      isPlayingAudio.value = false;
      if (prev == messageId) return;
    }
    currentPlayingAudioId.value = messageId;
    isPlayingAudio.value = true;
    await _player.startPlayer(
      fromURI: url,
      codec: Codec.aacADTS,
      whenFinished: () {
        isPlayingAudio.value = false;
        currentPlayingAudioId.value = "";
      },
    );
  }

  Future<void> stopAudio() async {
    if (_playerInitialized) await _player.stopPlayer();
    isPlayingAudio.value = false;
    currentPlayingAudioId.value = "";
  }
  RxBool isLoading = false.obs;

  RxList<TeacherGroupUserListing> teacherList =
      <TeacherGroupUserListing>[].obs;

  Pagination? pagination;

  TeacherGroupUserListingResponse? response;
  Future<void> getTeacherGroupUsers() async {
    try {
      isLoading.value = true;

      TeacherGroupUserListingRequest request =
      TeacherGroupUserListingRequest(lang: "en");

      response = await ApiWorker().teacherGroupUserListing(request, Get.context);

      if (response != null &&
          response!.data != null &&
          response!.data!.data != null) {

        teacherList.assignAll(response!.data!.data!);
      }

    } catch (e) {
      print("TeacherGroup Error ::: $e");
    } finally {
      isLoading.value = false;
    }
  }
 RxBool  isParentLoading = false.obs;
 RxList<ParentGroupUserListing> parentList = <ParentGroupUserListing>[].obs;
 Pagination? parentPagination;
 Group?     parentGroup;

 Future<void> getParentGroupUsers() async {
   try {
     isParentLoading.value = true;
     final request = TeacherGroupUserListingRequest(lang: "en");
     final response = await ApiWorker().parentGroupUserListing(request, Get.context);
     if (response != null && response.data?.data != null) {
       parentList.assignAll(response.data!.data!);
       parentPagination = response.data!.pagination;
       parentGroup      = response.data!.group;
     }
   } catch (e) {
     debugPrint("ParentGroup Error ::: $e");
   } finally {
     isParentLoading.value = false;
   }
 }
}
